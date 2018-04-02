//
//  HSSocket.h
//  hsimapp
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "NetMessage.h"

#define PACKAGE_HEADER          3
#define DEF_MSGBUFFERSIZE       65536

#define MAX_BUFF_SIZE           32768

#define LEN_NORMAL              64

#define cpFromText(t,code)  do\
{\
NSString *strText = t.text;\
if(strText == nil)\
{\
cpFromString("");\
}\
else\
{\
cpFromString(([strText cStringUsingEncoding:code]));\
}\
}while(0)
#define cp2NewNSString(ns, n) cp2NewString(__##ns##__, n); NSString *ns = [NSString stringWithCString:__##ns##__ encoding:En2CHN]

/// Marco deine:::

#define cpFromData(x)   cpFromWORD(((WORD)[x length])); memcpy(cp, [x bytes], [x length]); cp += [x length]

#define cp2NewString(sz, n) char sz[n+1]; memset(sz, 0x00, n+1); cp2String(sz, n)
#define cp2String(sz, n) do\
{\
memset(sz, 0x00, n);\
cp2NewWORD(len);\
if(len > 0 && len < n) memcpy(sz, cp, len);\
else if(len != 0) memcpy(sz, cp, n);\
cp += len;\
}while(0)

#define cpFromString(sz)	do\
{\
if(sz != NULL)\
{\
int szLen = (int)strlen(sz);\
if(szLen >= 0xffff) szLen = 0xffff;\
cpFromWORD(szLen);\
memcpy(cp, sz, szLen); cp += szLen;\
}\
else\
{\
cpFromWORD(0);\
}\
}while(0)


#define cpNew					char *cp = pData + WMSG_SIZE

#define cp2NewInt(x)			int x; cp2Int(x)
#define cp2Int(x)				x = ((byte)(cp[3]) << 24) | ((byte)(cp[2]) << 16) | ((byte)(cp[1]) << 8) | (byte)(cp[0]); cp += 4
#define cpFromInt(x)			cp[0] = (byte)((x >> 0) & 0xff);\
cp[1] = (byte)((x >> 8) & 0xff);\
cp[2] = (byte)((x >> 16) & 0xff);\
cp[3] = (byte)((x >> 24) & 0xff);\
cp += 4



#define cp2NewSzChar(sz, n)		char sz[n+1];\
memset(sz, 0x00, n+1);\
memcpy(sz, cp, n);\
cp += n
#define cp2SzChar(sz, n)		memset(sz, 0x00, n);\
memcpy(sz, cp, n - 1);\
cp += n
#define cpFromSzChar(x,n)		memcpy(cp, x, n); cp += n


#define cp2NewSzChar(sz, n)		char sz[n+1];\
memset(sz, 0x00, n+1);\
memcpy(sz, cp, n);\
cp += n
#define cp2SzChar(sz, n)		memset(sz, 0x00, n);\
memcpy(sz, cp, n - 1);\
cp += n
#define cpFromSzChar(x,n)		memcpy(cp, x, n); cp += n


#define cp2NewChar(x)			char x; cp2Char(x)
#define cp2Char(x)				x = (byte)(cp[0] & 0xff); cp++

#define cp2NewWORD(x)			WORD x; cp2WORD(x)
#define cp2WORD(x)				x = ((byte)(cp[1]) << 8) | (byte)(cp[0]); cp += 2
#define cpFromWORD(x)			cp[0] = (byte)((x >> 0) & 0xff);\
cp[1] = (byte)((x >> 8) & 0xff);\
cp += 2

#define NN(x)       [NSNumber numberWithInt:x]
#define NB(x)       NN(((x==YES)?1:0))
#define NT(x)       [NSByte byteWithInt:x]
#define NW(x)       [NSWord wordWithInt:x]

#define LOGIN       1
#define IM          2


@interface SocketCommand : NSObject

@property (nonatomic, assign) BOOL hasSent;
@property (nonatomic, assign) int toServer; // 0 : none, 1 : login, 2 : im
@property (nonatomic, assign) long tag; // write package tag
@property (nonatomic, assign) WORD command; // save command to spy
@property (nonatomic, retain) NSData *data;

+(SocketCommand *)initWithCommand:(WORD)NETCMD andData:(NSData *)data ofServer:(int)toServer andTag:(long)tag;

@end


@class HSSocket;
@protocol HSSocketDelegate <NSObject>

@optional

@required
- (void)needLoginIMFirst;
- (void)socket:(HSSocket *)socket didReceiveCommand:(char *)pData ofLength:(unsigned long)length;

@end

/*
 这一层使用AsyncSocket连接服务器，并进行断线重连的管理与操作。
 接收到数据后发给MasterNetIO层，在那里进行组包和解析。
 app不需要对这个类进行任何改动即可无限复用。只需要在MasterNetIO重新定义自己的封包和指令。
 */
@interface HSSocket : NSObject
{
    //连接服务器成功后一定要先调用一次
    //[sock readDataWithTimeout:-1 tag:0];
    //否则接收不到数据
    AsyncSocket *m_pSocket;
    // The delegate - will be notified of various changes in state via the ASIHTTPRequestDelegate protocol
    id <HSSocketDelegate> delegate;
    
    char *m_pRcvBuffer; // 用来协助m_recvDataPool做数据内存池交换
    char *m_pSndBuffer;
    NSMutableData *m_recvDataPool;
    
    int nPacked;
    int nSended;
}

@property(nonatomic, assign) long commandTag;
@property(nonatomic, retain) NSMutableArray *m_sendCmdList;

- (id)initWithDelegate:(id)d;
- (void)disconnect;
- (void)CheckSendAction;
- (void)clearPackageQueue;
- (void)removeCommandFromList:(WORD)command;
- (void)SendCommand:(WORD)NETCMD with:(id)p0, ...;

@end
