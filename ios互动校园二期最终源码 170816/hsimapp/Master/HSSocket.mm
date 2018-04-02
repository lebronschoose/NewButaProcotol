//
//  HSSocket.m
//  hsimapp
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "HSSocket.h"
#include "IMNet.h"

@implementation SocketCommand

@synthesize toServer, hasSent, data;


+(SocketCommand *)initWithCommand:(WORD)NETCMD andData:(NSData *)data ofServer:(int)toServer andTag:(long)tag
{
    SocketCommand *cmd = [[SocketCommand alloc] init];
    IMStop(nil);
    [cmd setTag:tag];
    [cmd setData:data];
    [cmd setCommand:NETCMD];
    [cmd setToServer:toServer];
    [cmd setHasSent:NO];
    return cmd;
}

-(id)init
{
    if ((self = [super init]))
    {
        hasSent = NO;
        toServer = 0;
        data = nil;
    }
    return self;
}

-(char *)p
{
    if(data == nil) return NULL;
    return (char *)([data bytes]);
}

@end



@implementation HSSocket

@synthesize m_sendCmdList;

/**
 * The runtime sends initialize to each class in a program exactly one time just before the class,
 * or any class that inherits from it, is sent its first message from within the program. (Thus the
 * method may never be invoked if the class is not used.) The runtime sends the initialize message to
 * classes in a thread-safe manner. Superclasses receive this message before their subclasses.
 *
 * This method may also be called directly (assumably by accident), hence the safety mechanism.
 **/
+(void)initialize
{
    static BOOL initialized = NO;
    if (!initialized)
    {
        initialized = YES;
    }
}

-(id)initWithDelegate:(id)d
{
    if ((self = [super init]))
    {
        delegate = d;
        m_pRcvBuffer = new char [DEF_MSGBUFFERSIZE];
        m_pSndBuffer = new char [DEF_MSGBUFFERSIZE];
        m_pSocket = [[AsyncSocket alloc] initWithDelegate:self];
        m_sendCmdList = [[NSMutableArray alloc] init];
        
        self.commandTag = 0;
        [self registKVO];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    }
    return self;
}

-(id)init
{
    if ((self = [super init]))
    {
        m_pRcvBuffer = new char [DEF_MSGBUFFERSIZE];
        m_pSndBuffer = new char [DEF_MSGBUFFERSIZE];
        m_pSocket = [[AsyncSocket alloc] initWithDelegate:self];
        m_sendCmdList = [[NSMutableArray alloc] init];
        
        nPacked = 0;
        nSended = 0;
        
        self.commandTag = 0;
        [self registKVO];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    }
    return self;
}

// on "dealloc" you need to release all your retained objects
-(void) dealloc
{
    // in case you have something to dealloc, do it in this method
    // in this particular example nothing needs to be released.
    // cocos2d will automatically release all the children (Label)
    [self unregistKVO];
    if(m_pRcvBuffer != NULL) delete []m_pRcvBuffer;
    m_pRcvBuffer = NULL;
    if(m_pSndBuffer != NULL) delete []m_pSndBuffer;
    m_pSndBuffer = NULL;
    
    [self closeSocket];
    m_pSocket.delegate = nil;
}

// 注册KVO
-(void)registKVO
{
    [self addObserver:self forKeyPath:@"commandTag" options:NSKeyValueObservingOptionNew context:nil];
}

// 移除KVO
-(void)unregistKVO
{
    [self removeObserver:self forKeyPath:@"commandTag"];
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath  isEqualToString: @"commandTag"])
    {
        if([change[@"new"] intValue] == 2)
        {
        }
        else
        {
        }
        if([m_pSocket isConnected]) [self CheckSendAction];
        else [self ReconnectServer];
    }
}

- (IBAction)timerFired:(id)sender
{
}

#pragma mark ------------- Private Interface -------------

-(void)iSendCommand:(WORD)NETCMD to:(int)toServer ofData:(char *)pData ofLength:(int)length
{
    char cKey = arc4random() % 0xff;
    int    i;
    DWORD dwSize = length;
    
    m_pSndBuffer[0] = cKey;
    
    m_pSndBuffer[1] = (byte)((dwSize + 3) & 0xff);
    m_pSndBuffer[2] = (byte)(((dwSize + 3) >> 8) & 0xff);
    
    memcpy((char *)(m_pSndBuffer + 3), pData, dwSize);
    if(cKey != 0x00)
    {
        for (i = 0; i < (int)dwSize; i++)
        {
            m_pSndBuffer[3+i] -= ((dwSize - i) ^ cKey);
            m_pSndBuffer[3+i] = (char)(m_pSndBuffer[3+i] ^ (cKey ^ i));
        }
    }
    
    [self pushCommand:NETCMD to:toServer ofData:m_pSndBuffer andLength:(int)(dwSize + 3)];
}

-(void)CheckSendAction
{
    NSLog(@"Socket: Check send action");
    for(SocketCommand *cmd in m_sendCmdList)
    {
        if(cmd.hasSent == YES) continue;
        
        if([m_pSocket writeData:cmd.data withTimeout:-1 tag:cmd.tag])
        {
            nSended++;
            cmd.hasSent = YES;
            NSLog(@" -- Package Sended : %04X (%d/%d of all:%lu)", cmd.command, nSended, nPacked, (unsigned long)m_sendCmdList.count);
        }
    }
}

#pragma mark ------------- Public Interface -------------
-(void)clearPackageQueue
{
    [m_sendCmdList removeAllObjects];
}

#pragma mark ------------- Command Interface -------------

-(void)SendCommand:(WORD)NETCMD with:(id)p0, ...
{
    int toServer = glState.destServer;
    // 如果企图发送一个数据包到im服务器，并且im服务器没有连接，而且这个数据包本身不是登录im的指令
    // 此时，自动提交生成一个im登录指令
    // 相应的，在登录im返回失败后，清除指令队列里所有内容
//    NSLog(@"[glState mainState] is %d toserver is %d netcom is %d",[glState mainState],toServer,NETCMD);
    if(toServer == IM && NETCMD != NETMSG_REQLOGINIM && ([glState mainState] != emStateHasEnterIM))
    {
        if(delegate && [delegate respondsToSelector:@selector(needLoginIMFirst)])
        {
            [delegate needLoginIMFirst];
        }
    }
    
    NSMutableArray *argsArray = [[NSMutableArray alloc] init];
    va_list params;
    va_start(params, p0);
    if(p0)
    {
        id arg;
        id prev = p0;
        [argsArray addObject:prev];
        while((arg = va_arg(params,id)))
        {
            if(arg)
            {
                [argsArray addObject:arg];
            }
        }
    }
    va_end(params);
    
    char *cp, szData[MAX_BUFF_SIZE];
    cp = szData;
    cpFromWORD(NETCMD);
    nPacked++;
    NSLog(@" -- Package Command: %04X (%d/%d of all:%lu)", NETCMD, nSended, nPacked, (unsigned long)m_sendCmdList.count);
    
    for(id obj in argsArray)
    {
        if([obj isKindOfClass:[NSString class]])
        {
            NSLog(@" -- Package String : %@", (NSString *)obj);
            cpFromString((const char *)([obj cStringUsingEncoding:En2CHN]));
        }
        else if([obj isKindOfClass:[NSNumber class]])
        {
            NSLog(@" -- Package Integer: %d", [obj intValue]);
            cpFromInt([obj intValue]);
        }
        else if([obj isKindOfClass:[NSByte class]])
        {
            NSLog(@" -- Package char: %d", [obj byteValue]);
            *cp = (char)[obj byteValue];
            cp++;
        }
        else if([obj isKindOfClass:[NSWord class]])
        {
            NSLog(@" -- Package WORD: %d", [obj wordValue]);
            cpFromWORD([obj wordValue]);
        }
        else if([obj isKindOfClass:[NSData class]])
        {
            NSLog(@" -- Package data with length: %lu", (unsigned long)[obj length]);
            cpFromData(obj);
        }
    }
    [self iSendCommand:NETCMD to:toServer ofData:szData ofLength:(int)(cp - szData)];
}

-(void)removeCommandFromList:(WORD)command
{
    NSMutableIndexSet *indexSets = [[NSMutableIndexSet alloc] init];
    for(int i = 0; i < m_sendCmdList.count; i++)
    {
        SocketCommand *cmd = [m_sendCmdList objectAtIndex:i];
        if(cmd.command == command)
        {
            [indexSets addIndex:i];
        }
    }
    [m_sendCmdList removeObjectsAtIndexes:indexSets];
}

-(void)pushCommand:(WORD)NETCMD to:(int)toServer ofData:(const char *)szData andLength:(int)length
{
    @synchronized(m_sendCmdList)
    {
        [m_sendCmdList addObject:[SocketCommand initWithCommand:NETCMD andData:[NSData dataWithBytes:szData length:length] ofServer:toServer andTag:self.commandTag]];
        self.commandTag++;
    };
}

-(void)MsgProcess
{
    DWORD dwSize = 0;
    char *pData = [self deCodeData:&dwSize];
    if(pData == NULL) return;
    
    if(delegate && [delegate respondsToSelector:@selector(socket:didReceiveCommand:ofLength:)])
    {
        [delegate socket:self didReceiveCommand:pData ofLength:dwSize];
    }
}

#pragma mark ------------- Socket Methods -------------

-(BOOL)connect:(int)toServer
{
    if(toServer != LOGIN && toServer != IM) return NO;
    
    NSString *ip = (toServer == LOGIN) ? [HSAppData getLoginServerIP] : [HSAppData getIMServerIP];
    UInt16 port = (toServer == LOGIN) ? [HSAppData getLoginServerPort] : [HSAppData getIMServerPort];
    
    NSLog(@"Socket: Try to connect to server: %@:%d", ip, port);
    if(ip == nil || port == 0)
    {
        NSLog(@"Socket: No server indicated to connect.");
        return NO;
    }
    
    NSError *err = nil;
    if(![m_pSocket connectToHost:ip onPort:port error:&err])
    {
        NSLog(@"Socket: Error: %@", err);
        return NO;
    }
    return YES;
}

-(void)disconnect
{
    NSLog(@"Socket: Disconnect Socket.");
    [m_pSocket disconnect];
}

-(void)ReconnectServer
{
    NSLog(@"Socket: Need reconnect to server.");
    SocketCommand *cmd = [m_sendCmdList lastObject];
    if(cmd == nil) return;
    
    [self connect:cmd.toServer];
}

-(void)closeSocket
{
    if([m_pSocket isConnected] == YES)
    {
        [m_pSocket disconnect];
    }
}


-(char *)deCodeData:(DWORD *)pLen
{
    WORD * wp;
    DWORD  dwSize;
    int i;
    char cKey, *cBuffer;
    if([self getCurPackageLen] <= 0) return NULL;
    cBuffer = (char *)[m_recvDataPool mutableBytes];
    
    cKey = cBuffer[0];
    
    wp = (WORD *)(cBuffer + 1);
    dwSize    = cBuffer[2] & 0xff;
    dwSize <<= 8;
    dwSize |= (cBuffer[1] & 0xff);
    dwSize -= 3;
    
    if (dwSize > DEF_MSGBUFFERSIZE) dwSize = DEF_MSGBUFFERSIZE;
    
    // v.14 : cBuffer +3
    if(cKey != 0x00)
    {
        for (i = 0; i < (int)dwSize; i++)
        {
            cBuffer[3+i] = (char)(cBuffer[3+i] ^ (cKey ^ i));
            cBuffer[3+i] += ((dwSize - i) ^ cKey);
        }
    }
    if(pLen) *pLen = dwSize;
    return cBuffer + 3;
}

-(int)getCurPackageLen
{
    if([m_recvDataPool length] < PACKAGE_HEADER) return 0;
    char *cp = (char *)([m_recvDataPool mutableBytes]) + 1;
    cp2NewWORD(wLen);
    return (int)(wLen);
}

-(void)clearRecvPool
{
    [m_recvDataPool setLength:0];
}

-(void)processRecvData
{
    if([m_recvDataPool length] < PACKAGE_HEADER) return;
    
    int nCurPackageLen = 0;
    while(1)
    {
        nCurPackageLen = [self getCurPackageLen];
        if(nCurPackageLen > DEF_MSGBUFFERSIZE)
        {
            [self clearRecvPool];
            [self closeSocket];
            return;
        }
        if(nCurPackageLen <= [m_recvDataPool length])
        {
            [self MsgProcess];
            if(nCurPackageLen < [m_recvDataPool length])
            {
                unsigned long nLeftBytes = [m_recvDataPool length] - nCurPackageLen;
                if(nLeftBytes > DEF_MSGBUFFERSIZE)
                {
                    [self clearRecvPool];
                    [self closeSocket];
                    return;
                }
                memcpy(m_pRcvBuffer, ((char *)([m_recvDataPool mutableBytes])) + nCurPackageLen, nLeftBytes);
                [self clearRecvPool];
                [m_recvDataPool appendBytes:m_pRcvBuffer length:nLeftBytes];
            }
            else
            {
                [self clearRecvPool];
                break;
            }
        }
        else break;
    }
}

#pragma mark -------------- AsyncSocket Event -----------
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
//    NSLog(@"Socket: onSocket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    [sock readDataWithTimeout:-1 tag:0];
    
    [self CheckSendAction];
}

-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSMutableIndexSet *indexSets = [[NSMutableIndexSet alloc] init];
    for(int i = 0; i < m_sendCmdList.count; i++)
    {
        SocketCommand *cmd = [m_sendCmdList objectAtIndex:i];
        if(cmd.tag == tag && cmd.hasSent == YES)
        {
            [indexSets addIndex:i];
//            NSLog(@"Socket: package has sent of %ld bytes with tag:%ld", (unsigned long)[cmd.data length], cmd.tag);
        }
    }
    [m_sendCmdList removeObjectsAtIndexes:indexSets];
    
//    NSLog(@"Socket: write data ok %ld", tag);
}

-(void) onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if([data length] > 0)
    {
        if(m_recvDataPool == nil)
        {
            m_recvDataPool = [[NSMutableData alloc] init];
        }
        [m_recvDataPool appendData:data];
        [self processRecvData];
    }
    
    [sock readDataWithTimeout:-1 tag:0];
}

-(void)onSocket:(AsyncSocket *)sock didSecure:(BOOL)flag
{
    NSLog(@"Socket: onSocket:%p didSecure:YES", sock);
}

-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"Socket: onSocket:%p willDisconnectWithError:%@", sock, err);
}

-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    //断开连接了
    if(glState.destServer == IM)
    {
        [glState setMainState:emStateHasLogin];
    }
    [self closeSocket];
    NSLog(@"Socket: onSocketDidDisconnect:%p", sock);
}

@end





