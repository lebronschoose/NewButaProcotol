// IMNet.cpp : Defines the entry point for the console application.
//
#include "IMNet.h"
#include <errno.h>
#include <ctype.h>
#include <fcntl.h>
#include <pthread.h>
#include <cstring>
#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <stdlib.h>
#include <netdb.h>
#include <sys/select.h>
#include <unistd.h>

# ifndef  PASCAL
#  define PASCAL
# endif

#ifndef NULL
#ifdef __cplusplus
#define NULL    0
#else
#define NULL    ((void *)0)
#endif
#endif

# define SOCKET			int
# define THREAD_FUNC	void*

# define WSAGetLastError()  errno
# define CLOSE_SOCKET_(s)	do{ if(s > 0) { close(s); s = 0;} }while(0)
# define  CLOSE_HANDLE_(h)


const UINT8  BEGIN_TAG    = 0xFB;	// 包开始标识
const UINT8  END_TAG	  = 0xFE;	// 包结束标识
const UINT8  HEADER_SIZE  = 10;		// 包头部大小（不包括BODY）
const UINT16 PACKAGE_SIZE = 0xFFFF;	// 包最大字节数
const UINT16 BODY_MAX	  = PACKAGE_SIZE - HEADER_SIZE; // 包BODY大小
const int RCV_BUF_SIZE    = 10 * PACKAGE_SIZE;	// 接收缓冲最大字节数（20 * 64KB）
const int CONNECT_TIMEOUT = 3;		// 连接超时值(s)
const int RECV_TIMEOUT    = 5;		// 接收超时值(s)

// Package 包数据格式定义（包接收解析使用）
typedef struct tagPackage 
{
	UINT8	u8BTag;				// 包开始标识
	UINT8	u8Type;				// 包类型，参考 Type* 常量定义
	UINT16	u16SN;				// 包序列号，由消息发起者设定，应答者对应给回此序列号(0~0xFFFF循环)
	UINT16  u16CMD;				// 命令字，参考　IMP*　常量定义
	UINT16	u16Size;			// 包Body 字节数
	UINT8	au8Body[BODY_MAX];	// 包Body内容
	UINT8	u8CRC;				// CRC校验
	UINT8	u8ETag;				// 包结束标识
}S_Package, *PS_Package;

typedef struct tagIMNet
{
	SOCKET		  nSocket;		// 登录连接套接字
	bool		  bExit;		// 线程退出标识（true:为要求终止线程，hThread为NULL时退出成功）
	pthread_t	  hThread;		// 接收线程句柄
	PFN_OnRcvPack pfnOnRcv;		// 接收回调函数
	int		i32Pos;				// 接收缓冲的起始位置
	UINT8	aBuf[RCV_BUF_SIZE]; // 接收数据包BUF
}S_IMNet, *PS_IMNet;

// 睡眠
void uSleep(int lTime)
{
    struct timeval sTime;
    sTime.tv_sec    = 0;
    sTime.tv_usec   = lTime*1000;
    select(0, NULL, NULL, NULL, &sTime);
}

// CRC 计算CRC
int CRC(UINT8* pData, int nSize) 
{
	int nRet = 0;
	for(int i=0; i<nSize; i++)
	{
		nRet *= 2;
		nRet += pData[i];
	}

	return nRet;
}

int GetBeginPos(PS_IMNet pIMNet) 
{
	for (int i=0;i< pIMNet->i32Pos; i++ )
	{
		if (pIMNet->aBuf[i] == BEGIN_TAG ){
            return i; // 找到包的开始标识
		}
	}

    return -1;
}

int ParsePackage(PS_IMNet pIMNet)
{
	if ( pIMNet->i32Pos < HEADER_SIZE )
		return ErrIncomplete;

	int i32Pos = GetBeginPos(pIMNet);
	if ( i32Pos < 0 )
	{	// 是无效数据
		pIMNet->i32Pos = 0;
		memset(pIMNet->aBuf, 0, i32Pos);
		return ErrIncomplete;
	}

	S_Package sPack;
	memset(&sPack, 0, sizeof(S_Package));

	sPack.u8BTag = pIMNet->aBuf[i32Pos++];
	sPack.u8Type = pIMNet->aBuf[i32Pos++];
	
	sPack.u16SN	 = ntohs(*(UINT16*)&pIMNet->aBuf[i32Pos]);
	i32Pos+=2;
	
	sPack.u16CMD = ntohs(*(UINT16*)&pIMNet->aBuf[i32Pos]);
	i32Pos+=2;

	sPack.u16Size = ntohs(*(UINT16*)&pIMNet->aBuf[i32Pos]);
	i32Pos+=2;

	memcpy(sPack.au8Body, &pIMNet->aBuf[i32Pos], sPack.u16Size);
	i32Pos+=sPack.u16Size;

	UINT8 u8CRC = CRC(pIMNet->aBuf, i32Pos);
	sPack.u8CRC  = pIMNet->aBuf[i32Pos++];
	sPack.u8ETag = pIMNet->aBuf[i32Pos++];

	if ( i32Pos > pIMNet->i32Pos )
	{	// 包不完整
		return ErrIncomplete;
	}
	else if ( i32Pos == pIMNet->i32Pos )
	{	// 是一个完整的包，没有多余数据
		pIMNet->i32Pos = 0;
		memset(pIMNet->aBuf, 0, i32Pos);
	}
	else
	{	// 有粘包
		int nLeave = pIMNet->i32Pos - i32Pos;
		memmove(pIMNet->aBuf, &pIMNet->aBuf[i32Pos], nLeave);	// 向前移动到缓冲头
		memset(&pIMNet->aBuf[nLeave], 0, i32Pos);				// 清零原来的遗留数据
		pIMNet->i32Pos = nLeave; // 调整缓冲开始位置指针
	}

	if ( u8CRC != sPack.u8CRC )
		return ErrCRC;

	// 通知调用者
	if (!pIMNet->pfnOnRcv(pIMNet, E_Type(sPack.u8Type), sPack.u16SN, E_CMD(sPack.u16CMD), sPack.au8Body, sPack.u16Size))
		return ErrAbort;

	return ErrOK;
}

int RecvPackage(PS_IMNet pIMNet, int i32Timeout)
{
	int nCount = 0;
	i32Timeout*= 10;

	while(1)
	{
		int nRcvLen = recv(pIMNet->nSocket, (char*)&pIMNet->aBuf[pIMNet->i32Pos], RCV_BUF_SIZE - pIMNet->i32Pos, 0);
		if( nRcvLen < 0)
		{	//由于是非阻塞的模式,所以当errno为EAGAIN时,表示当前缓冲区已无数据可读,在这里就当作是该次事件已处理
			if (WSAGetLastError() == EWOULDBLOCK || WSAGetLastError() == EINTR)
			{
				if (nCount++ >= i32Timeout)
					return ErrRecvTimeout;

				uSleep(100);
				continue;
			}

			return ErrRecv;
		}
		else if(nRcvLen == 0)  //表示对端的socket已正常关闭.
			return ErrSocketClose;

		pIMNet->i32Pos += nRcvLen;
		return ParsePackage(pIMNet);	// 包解析
	}

	return ErrOK;
}

THREAD_FUNC RecvThread(void *pParam)
{
	PS_IMNet pIMNet = (PS_IMNet)pParam;
	int		nRet = 0;
	fd_set  sSet;
    struct timeval sTimeout;

	pthread_detach(pthread_self());
	try{
		while(!pIMNet->bExit)
		{
			sTimeout.tv_sec  = 1;
			sTimeout.tv_usec = 0;
			FD_ZERO(&sSet);
			FD_SET(pIMNet->nSocket, &sSet);
			nRet = select(pIMNet->nSocket+1, &sSet, NULL, NULL, &sTimeout);
			if (nRet == 0)
				continue;
			else if (nRet < 0)
				break;

			nRet = RecvPackage(pIMNet, RECV_TIMEOUT);
			if ( nRet == ErrOK ||			// 接收成功
				 nRet == ErrRecvTimeout ||	// 接收超时
				 nRet == ErrIncomplete )	// 接收不完整
				continue;
			
			break;
		}
	}
	catch(...)
	{
	}
	
	pIMNet->pfnOnRcv(NULL, eTypeJSON, 0, ImpNone, NULL, 0); // 通知客户端，连接已经断开
    CLOSE_SOCKET_(pIMNet->nSocket);
    CLOSE_HANDLE_(pIMNet->hThread);
	free(pIMNet);
	return 0;
}

// 设置套接字为非阻塞方式
bool SetNoBlock( SOCKET& nSocket )
{
	int iRet = 0;
	if ( nSocket == 0 )
		return false;

	iRet= fcntl( nSocket, F_GETFL, 0 );
	if ( iRet < 0 )
		return false;

	iRet |= O_NONBLOCK;
	fcntl( nSocket, F_SETFL, iRet );

	return true;
}

// 以非阻塞方式建立网络连接
int Connect(const char* pAddr, UINT16 uPort, int nTimeout, SOCKET* pSocket)
{
	SOCKET nSocket = socket(AF_INET, SOCK_STREAM, 0);
	if (nSocket < 0)
		return ErrSocketFD;

	char szIP[30]="";
    if (isalpha(pAddr[0]))
	{
		if (struct hostent* pHost = gethostbyname(pAddr))
			strcpy(szIP, inet_ntoa(*((struct in_addr*)pHost->h_addr)));
		else
			return ErrGetHostName;
	}
	else
		strcpy(szIP, pAddr);

	struct sockaddr_in sSrvAddr;
	struct linger   sLin;

	memset(&sSrvAddr, 0, sizeof(sockaddr_in));
	sSrvAddr.sin_family = AF_INET;
	sSrvAddr.sin_port   = htons(uPort);

	sLin.l_onoff	= 1;        
	sLin.l_linger   = 0;

	inet_aton(szIP, &sSrvAddr.sin_addr);
	setsockopt(nSocket, SOL_SOCKET, SO_LINGER, &sLin, sizeof(sLin));

	int nRecvBuf = RCV_BUF_SIZE;
	int nSendBuf = PACKAGE_SIZE;
	setsockopt(nSocket, SOL_SOCKET, SO_RCVBUF, (const char*)&nRecvBuf, sizeof(int));
	setsockopt(nSocket, SOL_SOCKET, SO_SNDBUF, (const char*)&nSendBuf, sizeof(int));
	
	SetNoBlock(nSocket);
	int nRet = connect(nSocket, (struct sockaddr*)&sSrvAddr, sizeof(sSrvAddr));
	if (nRet != 0)
	{
		 fd_set	sSet;
	    struct timeval  sTimeout;

		sTimeout.tv_sec  = nTimeout;
		sTimeout.tv_usec = 0;
		FD_ZERO(&sSet);
		FD_SET(nSocket, &sSet);

		nRet = select(nSocket+1, NULL, &sSet, NULL, &sTimeout);
		if(nRet <=0 )
		{
			CLOSE_SOCKET_(nSocket);
			return ErrConnTimeout;
		}

		int nError = -1;
		int nErrorLen = sizeof(int);
		getsockopt(nSocket, SOL_SOCKET, SO_ERROR, (char*)&nError, (socklen_t*)&nErrorLen); 
		if (nError != 0)
		{
			CLOSE_SOCKET_(nSocket);
			return ErrGetOption;
		}
	}

	*pSocket = nSocket;
	return ErrOK;
}

// 接入请求(同步调用)
int IMAccess(BODY pAccReq, UINT16 uSize, const char* pszAddr, UINT16 uPort, PFN_OnRcvPack pfnOnRcv)
{
	if ( pAccReq == NULL || pszAddr == NULL || pfnOnRcv == NULL )
		return ErrNULL;

	S_IMNet sIMNet;

	memset(&sIMNet, 0 ,sizeof(S_IMNet));
	sIMNet.pfnOnRcv = pfnOnRcv;
	
	// 建立连接
	int nRet = Connect(pszAddr, uPort, CONNECT_TIMEOUT, &sIMNet.nSocket);
	if ( nRet != ErrOK )
		return nRet;

	// 发送接入请求
	nRet = IMSendPackage((void*)&sIMNet, eTypeJSON, 0, ImpAccessReq, pAccReq, uSize);
	if ( nRet != ErrOK )
	{
		CLOSE_SOCKET_(sIMNet.nSocket);
		return nRet;
	}

	// 接收应答
	nRet = RecvPackage(&sIMNet, RECV_TIMEOUT);
	CLOSE_SOCKET_(sIMNet.nSocket);
	return nRet;
}

// 开始网络活动，建立IM网络连接（接入请求返回的服务器信息）
void* IMStart(const char* pszAddr, UINT16 uPort, PFN_OnRcvPack pfnOnRcv)
{
	if ( pszAddr == NULL || pfnOnRcv == NULL )
		return NULL;	// 参数无效

	PS_IMNet psIMNet = (PS_IMNet)malloc(sizeof(S_IMNet));
	if ( psIMNet == NULL )
		return NULL;	// 申请内存失败

	// 建立连接
	memset(psIMNet, 0, sizeof(S_IMNet));
	psIMNet->pfnOnRcv = pfnOnRcv;
	int nRet = Connect(pszAddr, uPort, CONNECT_TIMEOUT, &psIMNet->nSocket);
	if ( nRet != ErrOK )
	{	// 连接失败
		free(psIMNet);
		return NULL;
	}

    pthread_create(&psIMNet->hThread, NULL, RecvThread, psIMNet);
	if ( !psIMNet->hThread )
	{	// 启动接收线程失败
		free(psIMNet);
		return NULL;
	}

	return psIMNet;
}

// 发送一个包，成功时返回ErrOK
int IMSendPackage(void* pvIMNet, E_Type	type, UINT16 sn, E_CMD cmd, BODY pBody, UINT16 uSize)	
{
	if ( pvIMNet == NULL )
		return ErrNULL;

	int nPos   = 0;
	UINT8 aData[PACKAGE_SIZE];

	memset(aData, 0, sizeof(aData));

	aData[nPos++] = BEGIN_TAG;				// BeginTag
	aData[nPos++] = type;					// Type

	*(UINT16*)&aData[nPos] = htons(sn);		// SN
	nPos+=2;

	*(UINT16*)&aData[nPos] = htons(cmd);	// CMD
	nPos+=2;

	*(UINT16*)&aData[nPos] = htons(uSize);	// Body Size
	nPos+=2;

	memcpy(&aData[nPos], pBody, uSize);		// Body
	nPos+=uSize;
	
	aData[nPos] = CRC((UINT8*)&aData, nPos);// CRC
	nPos++;

	aData[nPos] = END_TAG;					// End Tag
	nPos++;

	int nRet   = 0;
	int nRetry = 0;
	int nTotal = uSize + HEADER_SIZE;
	int nSend  = 0;
	PS_IMNet psIMNet = (PS_IMNet)(pvIMNet);
	const char* pSendBuf = (const char*)aData;
	while(1)
	{
		nSend = send(psIMNet->nSocket, pSendBuf, nTotal, 0);
		if (nSend < 0)
		{	// 超时重传
			nRetry++;
			if (WSAGetLastError() == EWOULDBLOCK || WSAGetLastError() == EINTR)
			{
				if (nRetry > 30)
					return ErrSendTimeout;

				uSleep(100);
				continue;
			}
			
			return ErrSendFailed;
		}

		if (nSend == nTotal)
			return ErrOK;

		nTotal  -= nSend;
		pSendBuf+= nSend;
		nRet    += nSend;
	}

	return ErrOK;
}

// 结束网络活动 (资源由接收线程释放)
bool IMStop(void* pvIMNet)
{	
	if ( pvIMNet == NULL )
		return false; // 参数无效

	PS_IMNet psIMNet = (PS_IMNet)(pvIMNet);
	psIMNet->bExit = true;			// 标记为退出
	CLOSE_SOCKET_(psIMNet->nSocket);// 关闭套接字，才能让接收的Socket立即出错并退出线程

	return true;
}
