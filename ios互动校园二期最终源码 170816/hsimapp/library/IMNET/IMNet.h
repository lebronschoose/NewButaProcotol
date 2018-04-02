// Package proto - IMProtocol
// 协议定义（主要用于JSON的编码与解码）：
// 1、命令参考《协议定义.docx》
// 2、所有的多字节的值，都采用的网络序，即大端序(Big Endian)；
// 3、BODY内容中的字符串均为UTF-8;
// 4、所有的请求与应答，都只需要一个包就完成。正常流程为：
//  4.1 当Body内容小于BODY_MAX时，就直接发送；
//  4.2 否则，将Body内容进行ZIP，如果ZIP后的内容小于BODY_MAX，就以ZIP形式发送；
//  4.3 否则，返回的Body中有一个url字段，告诉下载地址。
// 5、使用心跳包来同步服务器时间
// TCP 包格式定义如下：
// +------+--------+--------+--------+--------+------------+--------+------+
// |BTag  |Type    |SN      |CMD     |Size    |BODY        |CRC     |ETag  |
// +------+--------+--------+--------+--------+------------+--------+------+
// |FB(1B)|BYTE(1B)|WORD(2B)|WORD(2B)|WORD(2B)|JSON Body   |BYTE(1B)|FE(1B)|
// +------+--------+--------+--------+--------+------------+---------------+
// Begin Tag：包开始标识，为FB固定不变，1B
// Type：为功能扩展而保留，目前有：
//  0 －表示JSON字符串，以’\0’结尾；
//  1 －表示url方式下载的JSON字符串，以’\0’结尾；
//  2 －表示内容为ZIP压缩数据。
// SN：包序列号，由消息发起者设定，应答者对应给回此序列号(0~0xFFFF循环)
// CMD：为命令ID，标识BODY中的JSON具体命令类型。
// Size：包内容的字节长度，2B，用于快速解包定位，最大长度为BODY_MAX
// Body：包内容，格式为JSON，或者ZIP后的JSON内容
// CRC：包校验码，从BTag到Body结束的字节流的移位累加的结果(r*=2; r+=byte[i];)，1B
// End Tag：包结束标识，为FE固定不变，1B
//
// 6、用户ID/部门ID必须大于255，即[0~255]的ID为系统保留，0表示无效ID
// 7、单聊会话ID的生成规则：
//    {XXXXXXXX-0000-0000-0000-0000YYYYYYYY}
//    XXXXXXXX：为单聊参与人，ID较小的有的ID的十六进制数值
//    YYYYYYYY：为单聊参与人，ID较大的有的ID的十六进制数值
// 8、固定群(班级群)的会话ID生成规则：
//    {000000000-0000-0000-0000-0000DDDDDDDD}
//    DDDDDDDD：为班级ID
// 9、后台数据库用户密码加密方式：BASE64(AES(psw,'CBC-AES128',key));key=left(repeat(account),16)
// 10、离线消息推送：
// 10.1 当移动端和电脑端都不在线时，设置PUSH标识为1，需要进行离线推送
// 10.2 当移动端或电脑端有一端在线时，设置PUSH标识为0，不需要进行离线推送
// 10.3 当进行了离线推送时，设置PUSH标识为time
// 11、JSON格式约定：
// 11.1 所有的KEY都使用小写字母
// 11.2 如果有多个单词需要分隔，使用下划线 ‘_' 分隔
// 11.3 如果是数组，加后缀’s'
// 11.4 时间统一简写成一个字母't'
////////////////////////////////////////////////////////////////////////////////

#ifndef __IM_NET_HEADER_BY_YFGZ_20180314__
#define __IM_NET_HEADER_BY_YFGZ_20180314__

typedef unsigned char	UINT8;	// 无符号8bit整形
typedef unsigned short	UINT16;	// 无符号16bit整形
typedef const UINT8*	BODY;	// Body 

// 命令字定义
typedef enum tagCMD
{
	ImpNone	   = 0, // 未知命令

	// 协议模式类型定义
	ImpReq     = 0x1000, // 请求
	ImpRsp     = 0x2000, // 响应
	ImpNotice  = 0x4000, // 通知
	ImpAck     = 0x8000, // 应答

	// 请求 <==> 响应
	ImpHeartbeatReq        = ImpReq + 0x00, // 心跳请求
	ImpHeartbeatRsp        = ImpRsp + 0x00, // 心跳响应
	ImpAccessReq           = ImpReq + 0x01, // 接入请求
	ImpAccessRsp           = ImpRsp + 0x01, // 接入响应
	ImpLoginReq            = ImpReq + 0x02, // 登录请求
	ImpLoginRsp            = ImpRsp + 0x02, // 登录响应
	ImpLogoutReq           = ImpReq + 0x03, // 登出请求
	ImpLogoutRsp           = ImpRsp + 0x03, // 登出响应
	ImpSendMsgReq          = ImpReq + 0x04, // 发送消息请求
	ImpSendMsgRsp          = ImpRsp + 0x04, // 发送消息响应
	ImpUpdateUserInfoReq   = ImpReq + 0x07, // 更新用户信息请求
	ImpUpdateUserInfoRsp   = ImpRsp + 0x07, // 更新用户信息响应
	ImpGetUserInfoReq      = ImpReq + 0x08, // 获取用户信息请求
	ImpGetUserInfoRsp      = ImpRsp + 0x08, // 获取用户信息响应
	ImpGetSessionMemberReq = ImpReq + 0x09, // 获取会话成员请求
	ImpGetSessionMemberRsp = ImpRsp + 0x09, // 获取会话成员响应
	ImpGetDeptListReq      = ImpReq + 0x0a, // 获取部门(班级/年级)列表请求
	ImpGetDeptListRsp      = ImpRsp + 0x0a, // 获取部门（班级/年级）列表响应
	ImpGetOfflineMsgReq    = ImpReq + 0x0b, // 获取离线消息请求
	ImpGetOfflineMsgRsp    = ImpRsp + 0x0b, // 获取离线消息应答
	ImpGetSessionListReq   = ImpReq + 0x0d, // 获取会话列表请求
	ImpGetSessionListRsp   = ImpRsp + 0x0d, // 获取会话列表响应

	// 通知 <==> 应答
	ImpMsgNotice        = ImpNotice + 0x00, // 消息通知
	ImpMsgNoticeAck     = ImpAck + 0x00,    // 消息通知应答
	ImpContactNotice    = ImpNotice + 0x02, // 通讯录状态更新通知
	ImpContactNoticeAck = ImpAck + 0x02,    // 通讯录状态更新通知应答
	ImpFriendNotice     = ImpNotice + 0x05, // 添加/删除朋友通知
	ImpFriendNoticeAck  = ImpAck + 0x05,   	// 添加/删除朋友通知应答

}E_CMD, *PE_CMD;

// 错误码定义(满足Windows 的HRESULT)，负数是出错
// 客户端定义的错误码 +200（200以内是服务器所定义）
typedef enum tagResult
{
	// 结果类型
	ErrInfo  = 0x20000000,	// 为信息
	ErrError = 0xA0000000,	// 错误(最高位为1)
	ErrClient= 0x100,		// 客户端定义错误码的起始值

	// 结果分类(Family)
	ErrCommon = ErrError + 0x00010000, // 通用错误
	ErrIM     = ErrError + 0x00020000, // IM相关的结果
	ErrDB     = ErrError + 0x00030000, // Database相关的结果
	ErrNet    = ErrError + 0x00040000, // 网络错误
    ErrDevice = ErrError + 0x00040000, // 设备错误
	
	// 通用错误码 ===================================================
	ErrOK		 	 = 0,				// 成功
	ErrUnknown   	 = ErrCommon+1,		// 未知错误
	ErrNULL      	 = ErrCommon+2,		// <null>
	ErrSendError 	 = ErrCommon+3,		// 发送数据出错
	ErrOverload  	 = ErrCommon+4,		// 超过负荷，稍后重试
	ErrAccount   	 = ErrCommon+5,		// 无效账号
	ErrPassword  	 = ErrCommon+6,		// 密码错误
	ErrToken     	 = ErrCommon+7,		// Token无效
	ErrKicked    	 = ErrCommon+8,		// 被踢
	ErrForbidden 	 = ErrCommon+9,		// 账号被禁用
	ErrNoSession 	 = ErrCommon+10,	// 会话不存在
	ErrUserID    	 = ErrCommon+11,	// 用户ID无效
	ErrNoUserInfo    = ErrCommon+12, 	// 没有用户信息"
	ErrModifyFlag    = ErrCommon+13, 	// 没有设置用户更新标识
	ErrModifyFailed  = ErrCommon+14, 	// 更新用户信息失败
	ErrNoReceiver    = ErrCommon+15, 	// P2P会话没有接收者
	ErrSessionMember = ErrCommon+16, 	// 没有会话成员

	 // 客户端通用错误码起始值...
	ErrCommonClient  = ErrCommon + ErrClient,

	// 数据库错误码 =================================================
	ErrNotOpen	 = ErrDB+1,				// 数据库未打开

	// 客户端定义数据库错误码起始值...
	ErrDbClient = ErrDB + ErrClient,	

	// 网络错误码 ===================================================
	ErrPackage    	= ErrNet+1,			// 数据包错误
	ErrIncomplete 	= ErrNet+2,			// 数据包未接收完整，继续接收
	ErrCRC        	= ErrNet+3,			// CRC校验失败
	ErrPack       	= ErrNet+4,			// 数据打包出错
	ErrNotConnPush 	= ErrNet+5, 		// "没有连接到推送服务器")
	ErrBadRequest  	= ErrNet+6, 		// "无效请求")

	// 客户端定义网络错误码起始值...
	ErrNetClient  = ErrNet+ErrClient,
	ErrSocketFD	  = ErrNetClient+0,		// Socket 初始化错误（客户端没有初始化网络环境）
	ErrGetHostName= ErrNetClient+1,		// 获取Host Name 失败
	ErrConnTimeout= ErrNetClient+2,		// 连接超时
	ErrRecvTimeout= ErrNetClient+3,		// 接收超时
	ErrGetOption  = ErrNetClient+4,		// 获取Socket Option 失败
	ErrSocketClose= ErrNetClient+5,		// 套接字已经关闭
	ErrRecv       = ErrNetClient+6,		// 接收错误
	ErrAbort	  = ErrNetClient+7,		// 回调函数中止
	ErrSendTimeout= ErrNetClient+8,		// 发送超时
	ErrSendFailed = ErrNetClient+9,		// 发送失败

	// 设备错误 =================================================================
	ErrNoRegDevice = ErrDevice+1,		// 设备没有注册，服务器断开非法连接")
	ErrNoRegCard   = ErrDevice+2,		// 学生卡没有注册")
	ErrNoHandle    = ErrDevice+3,		// 命令未处理")
	ErrNoGuardian  = ErrDevice+4,		// 没有找到监护人")


}E_Result, *PE_Result;

// Body类型
typedef enum tagType
{
	eTypeJSON = 0,		// JSON Body
	eTypeURL  = 1,		// URL Body
	eTypeZIP  = 2,		// ZIP Body
}E_Type,*PE_Type;

// 客户端升级类型
typedef enum tagUpgrade 
{
	eUpgradeNone   = 0, // 无升级
	eUpgradeForce  = 1, // 强制升级
	eUpgradeUpdate = 2, // 可选升级
}E_Upgrade, *PE_Upgrade;

// 登录终端类型
typedef enum tagTerm
{
	eTermiOS     = 1,	// iOS
	eTermAndroid = 2,	// Android
	eTermMac     = 3,	// Mac
	eTermWin     = 4,	// Windows
}E_TERM, *PE_TERM;

// 用户在线状态
typedef enum tagStatus
{
	eStatusKicked  = -1, // Kicked
	eStatusExit    = 0,  // Logout
	eStatusLeave   = 1,  // Leave
	eStatusOnline  = 2,  // Online
}E_Status, *PE_Status;

// 消息子类型定义
typedef enum tagMsgType
{
	eMsgText     = 0,	// 文本消息
	eMsgEmot     = 1,	// 标准表情消息，IM内置
	eMsgEmotUser = 2,	// 用户表情消息，以图片方式发送
	eMsgAnnex    = 3,	// 附件消息
	eMsgImage    = 4,	// 图片消息
	eMsgVoice    = 5,	// 语音消息
	eMsgVideo    = 6,	// 小视频消息

	MsgCheckin = 100, // 考勤通知
}E_MsgType, *PE_MsgType;

// 会话类型定义
typedef enum tagSessionType
{
	// 点对点会话
	eSessionP2P = 0,		// 点对点会话

	// 多人会话
	eSessionFix  = 30,		// 后台创建固定群会话（后台创建的:如教师群，年级群）
	eSessionClass= 31,		// 班级群会话（自动创建：不能修改）
	eSessionDisc = 32,		// 临时组会话（客户端创建的临时讨论组？）

	// 公告(广播)
	eBulletin       = 50,	// 公告
	eSchoolBulletin = 50,	// 全校公告
	eClassBulletin  = 51,	// 班级公告
	eGradeBulletin  = 52,	// 年级公告
	eBulletinTo     = 53,	// 定向公告（选择公告的接收者）？

	// 通知
	eSystemNotice = 100,	// 系统通知？
	eWebAppNotice = 110,	// 轻应用通知
	WebAppNotice  = 110, // 轻应用通知
}E_SessionType, *PE_SessionType;

void uSleep(int lTime);

// 包接收通知的回调函数，当pvIMNet==NULL && cmd == ImpNone 时，表示连接已经断开，pvIMNet已经无效了。
typedef bool (*PFN_OnRcvPack)(	// 返回 false时，终止流程，pvIMNet 就无效了。
	void*	pvIMNet,			// IMStart所返回的连接对象指针（接入服务的为NULL）
	E_Type	type,				// 包类型
	UINT16	sn,					// 发送序号（用于诊错），由发送端生成
	E_CMD	cmd,				// 命令ID
	BODY	pBody,				// 消息体
	UINT16	uSize);				// 消息体长度（字节数）

// 接入请求
int IMAccess(
	BODY		  pAccReq,	// 接入请求消息体
	UINT16		  uSize,	// 接入请求消息体长度（字节数）
	const char*	  pszAddr,	// 接入服务器地址（IP或域名）
	UINT16		  u16Port,	// 接入服务器端口
	PFN_OnRcvPack pfnOnRcv);// 接收到消息的回调函数指针

// 开始网络活动，建立IM网络连接（接入请求返回的服务器信息）
void* IMStart(	// 返回连接对象指针
	const char*	  pszAddr,	// 登录服务器地址（IP或域名）
	UINT16		  u16Port,	// 登录服务器端口
	PFN_OnRcvPack pfnOnRcv);// 接收到消息的回调函数指针

// 发送一个包，成功时返回0
int IMSendPackage(	// 返回错误号
	void*	pvIMNet,			// IMStart所返回的连接对象指针
	E_Type	type,				// 包类型(客户端发送只会有TypeJSON)
	UINT16	sn,					// 发送序号（用于诊错），由发送端生成
	E_CMD	cmd,				// 命令ID
	BODY	pBody,				// 消息体
	UINT16	uSize);				// 消息体长度（字节数）

// 结束网络活动
bool IMStop(
	void*	pvIMNet);			// IMStart所返回的连接对象指针


#endif //__IM_NET_HEADER_BY_YFGZ_20180314__
