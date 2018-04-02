//
//  HSCoreData.m
//  HSIMApp
//
//  Created by han on 14/1/14.
//  Copyright (c) 2014年 han. All rights reserved.
//

#import "HSCoreData.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "zlib.h"

@implementation HSCoreData
@synthesize m_notifyMessageList, m_publicIMessageList, m_privateIMessageList, m_sysNotify, m_publicGroup, m_configItems, m_serviceDataList, m_serviceWinTitle, m_allUserList;

static HSCoreData *sharedInstance;

+ (UIImage *)buildLogo:(UIImage *)image
{
    CGFloat x = (CGFloat)([HSAppData getChatImageSize]);
    if(x < 20) x = 360.0;
    CGSize newSize = CGSizeMake(x, x);
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *logoData = UIImageJPEGRepresentation(newImage, 0.85);
//    NSLog(@"the logo size: %lu", (unsigned long)[logoData length]);
    UIImage *img = [UIImage imageWithData:logoData];
    return img;
}

#pragma mark -- gzip

+(NSData *) compressData: (NSData*)uncompressedData
{
    /*
     Special thanks to Robbie Hanson of Deusty Designs for sharing sample code
     showing how deflateInit2() can be used to make zlib generate a compressed
     file with gzip headers:
     http://deusty.blogspot.com/2007/07/gzip-compressiondecompression.html
     */
    if (!uncompressedData || [uncompressedData length] == 0)
    {
//        NSLog(@"%s: Error: Can't compress an empty or null NSData object.", __func__);
        return nil;
    }
    /* Before we can begin compressing (aka "deflating") data using the zlib
     functions, we must initialize zlib. Normally this is done by calling the
     deflateInit() function; in this case, however, we'll use deflateInit2() so
     that the compressed data will have gzip headers. This will make it easy to
     decompress the data later using a tool like gunzip, WinZip, etc.
     deflateInit2() accepts many parameters, the first of which is a C struct of
     type "z_stream" defined in zlib.h. The properties of this struct are used to
     control how the compression algorithms work. z_stream is also used to
     maintain pointers to the "input" and "output" byte buffers (next_in/out) as
     well as information about how many bytes have been processed, how many are
     left to process, etc. */
    z_stream zlibStreamStruct;
    zlibStreamStruct.zalloc    = Z_NULL; // Set zalloc, zfree, and opaque to Z_NULL so
    zlibStreamStruct.zfree     = Z_NULL; // that when we call deflateInit2 they will be
    zlibStreamStruct.opaque    = Z_NULL; // updated to use default allocation functions.
    zlibStreamStruct.total_out = 0; // Total number of output bytes produced so far
    zlibStreamStruct.next_in   = (Bytef*)[uncompressedData bytes]; // Pointer to input bytes
    zlibStreamStruct.avail_in  = [uncompressedData length]; // Number of input bytes left to process
    /* Initialize the zlib deflation (i.e. compression) internals with deflateInit2().
     The parameters are as follows:
     z_streamp strm - Pointer to a zstream struct
     int level      - Compression level. Must be Z_DEFAULT_COMPRESSION, or between
     0 and 9: 1 gives best speed, 9 gives best compression, 0 gives
     no compression.
     int method     - Compression method. Only method supported is "Z_DEFLATED".
     int windowBits - Base two logarithm of the maximum window size (the size of
     the history buffer). It should be in the range 8..15. Add
     16 to windowBits to write a simple gzip header and trailer
     around the compressed data instead of a zlib wrapper. The
     gzip header will have no file name, no extra data, no comment,
     no modification time (set to zero), no header crc, and the
     operating system will be set to 255 (unknown).
     int memLevel   - Amount of memory allocated for internal compression state.
     1 uses minimum memory but is slow and reduces compression
     ratio; 9 uses maximum memory for optimal speed. Default value
     is 8.
     int strategy   - Used to tune the compression algorithm. Use the value
     Z_DEFAULT_STRATEGY for normal data, Z_FILTERED for data
     produced by a filter (or predictor), or Z_HUFFMAN_ONLY to
     force Huffman encoding only (no string match) */
    int initError = deflateInit2(&zlibStreamStruct, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY);
    if (initError != Z_OK)
    {
        NSString *errorMsg = nil;
        switch (initError)
        {
            case Z_STREAM_ERROR:
                errorMsg = @"Invalid parameter passed in to function.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Insufficient memory.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
//        NSLog(@"%s: deflateInit2() Error: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        return nil;
    }
    // Create output memory buffer for compressed data. The zlib documentation states that
    // destination buffer size must be at least 0.1% larger than avail_in plus 12 bytes.
    NSMutableData *compressedData = [NSMutableData dataWithLength:[uncompressedData length] * 1.01 + 12];
    int deflateStatus;
    do
    {
        // Store location where next byte should be put in next_out
        zlibStreamStruct.next_out = [compressedData mutableBytes] + zlibStreamStruct.total_out;
        // Calculate the amount of remaining free space in the output buffer
        // by subtracting the number of bytes that have been written so far
        // from the buffer's total capacity
        zlibStreamStruct.avail_out = [compressedData length] - zlibStreamStruct.total_out;
        /* deflate() compresses as much data as possible, and stops/returns when
         the input buffer becomes empty or the output buffer becomes full. If
         
         deflate() returns Z_OK, it means that there are more bytes left to
         
         compress in the input buffer but the output buffer is full; the output
         
         buffer should be expanded and deflate should be called again (i.e., the
         
         loop should continue to rune). If deflate() returns Z_STREAM_END, the
         
         end of the input stream was reached (i.e.g, all of the data has been
         
         compressed) and the loop should stop. */
        
        deflateStatus = deflate(&zlibStreamStruct, Z_FINISH);
        
        
        
    } while ( deflateStatus == Z_OK );
    
    
    
    // Check for zlib error and convert code to usable error message if appropriate
    
    if (deflateStatus != Z_STREAM_END)
        
    {
        
        NSString *errorMsg = nil;
        
        switch (deflateStatus)
        
        {
                
            case Z_ERRNO:
                
                errorMsg = @"Error occured while reading file.";
                
                break;
                
            case Z_STREAM_ERROR:
                
                errorMsg = @"The stream state was inconsistent (e.g., next_in or next_out was NULL).";
                
                break;
                
            case Z_DATA_ERROR:
                
                errorMsg = @"The deflate data was invalid or incomplete.";
                
                break;
                
            case Z_MEM_ERROR:
                
                errorMsg = @"Memory could not be allocated for processing.";
                
                break;
                
            case Z_BUF_ERROR:
                
                errorMsg = @"Ran out of output buffer for writing compressed bytes.";
                
                break;
                
            case Z_VERSION_ERROR:
                
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                
                break;
                
            default:
                
                errorMsg = @"Unknown error code.";
                
                break;
                
        }
        
//        NSLog(@"%s: zlib error while attempting compression: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        
        // Free data structures that were dynamically created for the stream.
        
        deflateEnd(&zlibStreamStruct);
        
        
        
        return nil;
        
    }
    
    
    
    // Free data structures that were dynamically created for the stream.
    
    deflateEnd(&zlibStreamStruct);
    
    
    
    [compressedData setLength: zlibStreamStruct.total_out];
    
    
    
    return compressedData;
    
}


+(NSData *)decompressData:(NSData *)compressedData
{
    
    z_stream zStream;
    
    zStream.zalloc = Z_NULL;
    
    zStream.zfree = Z_NULL;
    
    zStream.opaque = Z_NULL;
    
    zStream.avail_in = 0;
    
    zStream.next_in = 0;
    
    int status = inflateInit2(&zStream, (15+32));
    
    
    
    if (status != Z_OK) {
        
        return nil;
        
    }
    
    
    
    Bytef *bytes = (Bytef *)[compressedData bytes];
    
    NSUInteger length = [compressedData length];
    
    
    
    NSUInteger halfLength = length/2;
    
    NSMutableData *uncompressedData = [NSMutableData dataWithLength:length+halfLength];
    
    
    
    zStream.next_in = bytes;
    
    zStream.avail_in = (unsigned int)length;
    
    zStream.avail_out = 0;
    
    
    
    NSInteger bytesProcessedAlready = zStream.total_out;
    
    while (zStream.avail_in != 0) {
        
        
        
        if (zStream.total_out - bytesProcessedAlready >= [uncompressedData length]) {
            
            [uncompressedData increaseLengthBy:halfLength];
            
        }
        
        
        
        zStream.next_out = (Bytef*)[uncompressedData mutableBytes] + zStream.total_out-bytesProcessedAlready;
        
        zStream.avail_out = (unsigned int)([uncompressedData length] - (zStream.total_out-bytesProcessedAlready));
        
        
        
        status = inflate(&zStream, Z_NO_FLUSH);
        
        
        
        if (status == Z_STREAM_END) {
            
            break;
            
        } else if (status != Z_OK) {
            
            return nil;
            
        }
        
    }
    
    
    
    status = inflateEnd(&zStream);
    
    if (status != Z_OK) {
        
        return nil;
        
    }
    
    
    
    [uncompressedData setLength: zStream.total_out-bytesProcessedAlready];  // Set real length
    
    
    return uncompressedData;    
    
}


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
		
		sharedInstance = [[HSCoreData alloc] init];
	}
}

+(HSCoreData *)sharedInstance
{
	return sharedInstance;
}

+(NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

+(NSString *)stringByDate:(NSDate *)date withYear:(BOOL)bWithYear
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    if(bWithYear) return destDateString;
    else return [HSCoreData dateNoYear:destDateString];
}

+(NSString *)stringOfMinuteByDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+(void)genRandCode:(char *)szCode ofLength:(int)len
{
    char szModule[17] = "0123456789ABCDEF";
    for(int i = 0; i < len; i++)
    {
        int x = arc4random() % 16;
        szCode[i] = szModule[x];
    }
    szCode[len] = 0x00;
}

+(NSString *)dateNoYear:(NSString *)strDate
{
    if(isNullData(strDate)) return @"";
    
    NSRange range = [strDate rangeOfString:@" "];
    NSString *b = [strDate substringFromIndex:range.location + range.length];//开始截取
    return b;
}

-(id)init
{
	if (sharedInstance != nil)
	{
		return nil;
	}
	
	if ((self = [super init]))
	{
        m_sysNotify = [[NSMutableArray alloc] initWithCapacity:8];
        m_publicGroup = [[NSMutableArray alloc] initWithCapacity:8];
        m_configItems= [[NSMutableArray alloc] initWithCapacity:8];
        m_notifyMessageList = [[NSMutableArray alloc] initWithCapacity:32];
        m_publicIMessageList = [[NSMutableArray alloc] initWithCapacity:32];
        m_privateIMessageList = [[NSMutableArray alloc] initWithCapacity:32];
        m_serviceDataList = [[NSMutableDictionary alloc] initWithCapacity:8];
        m_serviceWinTitle = [[NSMutableDictionary alloc] initWithCapacity:8];
        m_allUserList = [[NSMutableDictionary alloc] initWithCapacity:32];
	}
	return self;
}

-(void)clearData
{
    if(m_sysNotify != nil) [m_sysNotify removeAllObjects];
    if(m_publicGroup != nil) [m_publicGroup removeAllObjects];
    if(m_configItems != nil) [m_configItems removeAllObjects];
    if(m_serviceDataList != nil) [m_serviceDataList removeAllObjects];
    if(m_serviceWinTitle != nil) [m_serviceWinTitle removeAllObjects];
    if(m_notifyMessageList != nil) [m_notifyMessageList removeAllObjects];
    if(m_publicIMessageList != nil) [m_publicIMessageList removeAllObjects];
    if(m_privateIMessageList != nil) [m_privateIMessageList removeAllObjects];
    if(m_allUserList != nil) [m_allUserList removeAllObjects];
}

+(BOOL)bIsValidUserID:(NSString *)userID
{
    int ilen = [userID length];
    if(ilen <= 0) return NO;
    for(int i = 0; i < ilen; i++)
    {
        char c = [userID characterAtIndex:i];
        if(
           c == '-' ||
           c == '_' ||
           c == '.' ||
           c == '@' ||
           (c >= 'a' && c <= 'z') ||
           (c >= 'A' && c <= 'Z') ||
           (c >= '0' && c <= '9')
           )
        {
            
        }
        else return FALSE;
    }
    return TRUE;
}

#pragma mark ***** Account Table
//信息类 数据库
-(BOOL)dumpAccount
{
#ifdef closeDump
    return YES;
#endif
    FMDatabase *db = [FMDatabase databaseWithPath:ACCOUNTDATABASE_PATH];
//    NSLog(@"ACCOUNTDATABASE_PATH is %@",ACCOUNTDATABASE_PATH);
    if(![db open])
    {
//        NSLog(@"数据库打开失败");
        return NO;
    }
    if([self checkAccountTable:db] == NO) return NO;
    
//    NSLog(@"========== DUMP Account Table ========");
    FMResultSet *rs = [db executeQuery:@"select * from _tbIMAccount"];
    while([rs next])
    {
        HSUserObject *aUser = [HSUserObject userFromDataSet:rs];
        [aUser dump];
    }
//    NSLog(@"=============================");
    [rs close];
    return YES;
}

-(BOOL)checkAccountTable:(FMDatabase *)db
{
    NSString *createStr = @"CREATE  TABLE  IF NOT EXISTS _tbIMAccount ('oldData' INTEGER, userType INTEGER, DDNumber VARCHAR, 'realname' VARCHAR, 'nickName' VARCHAR, 'EmailAddr' VARCHAR, 'MobileNo' VARCHAR, 'signText' VARCHAR, 'bindText' VARCHAR, 'dataFlag' INTEGER)";
    BOOL worked = [db executeUpdate:createStr];
    FMDBQuickCheck(worked);
    return worked;
}

-(void)pushNewAccount:(HSUserObject *)aUser
{
    FMDatabase *db = [FMDatabase databaseWithPath:ACCOUNTDATABASE_PATH];
    if(![db open])
    {
//        NSLog(@"数据库打开失败");
        return;
    }
    if([self checkAccountTable:db] == NO) return;
    
    BOOL bExist = NO, worked;
    FMResultSet *rs = [db executeQuery:@"select * from _tbIMAccount where DDNumber=?", [aUser DDNumber]];
    while([rs next])
    {
        bExist = YES;
    }
    [rs close];
    
    if(bExist)
    {
        worked = [db executeUpdate:@"update _tbIMAccount set oldData=0, userType=?, dataFlag=?, nickName=?, realName=?, MobileNo=?, signText=?, bindText=? where DDNumber=?",
                  aUser.userType,
                  aUser.dataFlag,
                  aUser.nickName,
                  aUser.realName,
                  aUser.mobileNo,
                  aUser.signText,
                  aUser.bindText,
                  aUser.DDNumber];
    }
    else
    {
//        NSLog(@"push new ACCOUNT:%@ , new flag: %d, old data: 1", aUser.DDNumber, 0);
        worked = [db executeUpdate:@"INSERT INTO _tbIMAccount (oldData, userType, 'DDNumber', 'nickName', 'EmailAddr', 'MobileNo', 'signText', 'bindText', 'dataFlag') values(0,?,?,?,?,?,?,?,?)", aUser.userType, aUser.DDNumber, aUser.nickName, aUser.emailAddr, aUser.mobileNo, aUser.signText,aUser.bindText, aUser.dataFlag];
    }
}

-(HSUserObject *)userForAccount:(NSString *)account
{
    FMDatabase *db = [FMDatabase databaseWithPath:ACCOUNTDATABASE_PATH];
    if(![db open])
    {
//        NSLog(@"数据库打开失败");
        return nil;
    }
    if([self checkAccountTable:db] == NO) return nil;
    
    FMResultSet *rs = [db executeQuery:@"select * from _tbIMAccount where DDNumber=?", account];
    while([rs next])
    {
        HSUserObject *aUser = [HSUserObject userFromDataSet:rs];
        [rs close];
        [db close];
        return aUser;
    }
    [rs close];
    [db close];
    return nil;
}

-(NSString *)webURLForAccount:(NSString *)account
{
    FMDatabase *db = [FMDatabase databaseWithPath:ACCOUNTDATABASE_PATH];
    if(![db open])
    {
//        NSLog(@"数据库打开失败");
        return nil;
    }
    if([self checkAccountTable:db] == NO) return nil;
    
    FMResultSet *rs = [db executeQuery:@"select * from _tbIMAccount where DDNumber=?", account];
    while([rs next])
    {
        NSString *webURL = [rs objectForColumnName:@"webURL"];
        [rs close];
        [db close];
        return webURL;
    }
    [rs close];
    [db close];
    return nil;
}

-(BOOL)checkTableCreatedInDb:(FMDatabase *)db
{
    //NSLog(@"******* db path: %@", DATABASE_PATH);
    return [self checkUserTableCreatedInDb:db] && [self checkGroupTableCreatedInDb:db] && [self checkMessageTableCreatedInDb:db];
}

#pragma mark ******************* public mapping chatid

- (void)dumpChatID
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
//        NSLog(@"数据库打开失败");
        return;
    }
    
    if(![self checkGroupChatIDTableCreatedInDb:db]) return;
    
//    NSLog(@"====================Dump _tbChatID2MainGroup Table==============");
    FMResultSet *rs = [db executeQuery:@"select * from '_tbChatID2MainGroup'"];
    while([rs next])
    {
//        NSLog(@"chatID:%@ groupFlag:%@ newChatID:%@", [rs objectForColumnName:@"chatID"], [rs stringForColumn:@"groupFlag"], [rs objectForColumnName:@"newChatID"]);
    }
    [rs close];
//    NSLog(@"=================================================");
}

-(BOOL)checkGroupChatIDTableCreatedInDb:(FMDatabase *)db
{
    NSString *createStr = @"CREATE  TABLE  IF NOT EXISTS '_tbChatID2MainGroup' ('chatID' INTEGER, 'groupFlag' VARCHAR, 'newChatID' INTEGER)";
    BOOL worked = [db executeUpdate:createStr];
    FMDBQuickCheck(worked);
    return worked;
}

-(NSNumber *)getChatIDForPublicGroup:(NSNumber *)chatID andFlag:(NSString *)groupFlag
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
//        NSLog(@"数据库打开失败");
        return chatID;
    }
    
    if(![self checkGroupChatIDTableCreatedInDb:db]) return chatID;
    
    BOOL bExist = NO;
    NSNumber *retChatID = nil;
    FMResultSet *rs = [db executeQuery:@"select * from '_tbChatID2MainGroup' where chatID=? and groupFlag=?", chatID, groupFlag];
    while([rs next])
    {
        retChatID = [rs objectForColumnName:@"newChatID"];
        bExist = YES;
    }
    [rs close];
    if(bExist) return retChatID;
    return chatID;
}

-(NSNumber *)genChatIDForPublicGroup:(NSNumber *)chatID andFlag:(NSString *)groupFlag
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
//        NSLog(@"数据库打开失败");
        return [NSNumber numberWithInt:0];
    }
    
    if(![self checkGroupChatIDTableCreatedInDb:db]) return [NSNumber numberWithInt:0];
    
    BOOL bExist = NO;
    NSNumber *retChatID = nil;
    FMResultSet *rs = [db executeQuery:@"select * from '_tbChatID2MainGroup' where chatID=? and groupFlag=?", chatID, groupFlag];
    while([rs next])
    {
        retChatID = [rs objectForColumnName:@"newChatID"];
        bExist = YES;
    }
    [rs close];
    
    if(!bExist)
    {
        rs = [db executeQuery:@"select * from '_tbChatID2MainGroup' order by newChatID ASC LIMIT 1"];
        while([rs next])
        {
            retChatID = [NSNumber numberWithInt:([[rs objectForColumnName:@"newChatID"] intValue] - 1)];
        }
        [rs close];
        if(retChatID == nil) retChatID = [NSNumber numberWithInt: -1];
        if(NO == [db executeUpdate:@"INSERT INTO '_tbChatID2MainGroup' VALUES(?,?,?)", chatID, groupFlag, retChatID])
        {
            [db close];
            return [NSNumber numberWithInt:0];
        }
    }
    [db close];
    return retChatID;
}

-(NSNumber *)chatIDForChatID:(NSNumber *)chatID
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
//        NSLog(@"数据库打开失败");
        return chatID;
    }
    
    if(![self checkGroupChatIDTableCreatedInDb:db]) return chatID;
    
    BOOL bExist = NO;
    NSNumber *retChatID = nil;
    FMResultSet *rs = [db executeQuery:@"select * from '_tbChatID2MainGroup' where newChatID=?", chatID];
    while([rs next])
    {
        retChatID = [rs objectForColumnName:@"ChatID"];
        bExist = YES;
    }
    [rs close];
    [db close];
    
    if(!bExist) return chatID;
    return retChatID;
}

-(NSString *)flagForChatID:(NSNumber *)chatID
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
//        NSLog(@"数据库打开失败");
        return @"";
    }
    
    if(![self checkGroupChatIDTableCreatedInDb:db]) return @"";
    
    BOOL bExist = NO;
    NSString *retFlag = nil;
    FMResultSet *rs = [db executeQuery:@"select * from '_tbChatID2MainGroup' where newChatID=?", chatID];
    while([rs next])
    {
        retFlag = [rs stringForColumn:@"groupFlag"];
        bExist = YES;
    }
    [rs close];
    [db close];
    
    if(!bExist) return @"";
    return retFlag;
}

#pragma mark ******************* Public Group Handler

-(BOOL)checkGroupTableCreatedInDb:(FMDatabase *)db
{
    NSString *createStr = @"CREATE  TABLE  IF NOT EXISTS '_tbMainGroup' ('delFlag' INTEGER, 'showInIM' INTEGER, 'chatID' INTEGER, 'groupName' VARCHAR, 'descText' VARCHAR, 'addData' VARCHAR)";
    BOOL worked = [db executeUpdate:createStr];
    FMDBQuickCheck(worked);
    return worked;
}

-(void)showGroupInIM:(BOOL)bShow ofChatID:(NSNumber *)chatID
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
//        NSLog(@"数据库打开失败");
        return;
    }
    
    if(![self checkTableCreatedInDb:db]) return;
    
    if(bShow)
    {
        BOOL worked = [db executeUpdate:@"UPDATE '_tbMainGroup' set showInIM = 1 where chatID = ?", chatID];
        FMDBQuickCheck(worked);
    }
    else
    {
        BOOL worked = [db executeUpdate:@"UPDATE '_tbMainGroup' set showInIM = 0 where chatID = ?", chatID];
        FMDBQuickCheck(worked);
        [self signMessageReadByChatID:chatID];
        PostMessage(hsNotificationReloadFList, [NSNumber numberWithInt:0]);
    }
}

-(HSPublicGroupObject *)groupFromDB:(NSNumber *)chatID
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
//        NSLog(@"数据库打开失败");
        return nil;
    }
    if(![self checkTableCreatedInDb:db]) return nil;
    
    FMResultSet *rs = [db executeQuery:@"select * from '_tbMainGroup' where chatID=?", chatID];
    while([rs next])
    {
        HSPublicGroupObject *aGroup = [HSPublicGroupObject groupFromDataset:rs];
        [rs close];
        [db close];
        return aGroup;
        break;
    }
    [rs close];
    [db close];
    return nil;
}

-(BOOL)pushGroupListIntoDB:(char *)pData
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
//        NSLog(@"数据库打开失败");
        return NO;
    }
    if(![self checkTableCreatedInDb:db]) return NO;
    
    BOOL worked;
    worked = [db executeUpdate:@"update _tbMainGroup set delFlag=1"];
    if(!worked)
    {
        [db close];
        return NO;
    }
    cpNew;
    int nCount = *cp; cp++;
    for(int i = 0; i < nCount; i++)
    {
        HSPublicGroupObject *aGroup = [HSPublicGroupObject groupFromCP:&cp];
//        NSLog(@"new group: %@ [%@ - %@] [%@]", aGroup.chatID, aGroup.groupName, aGroup.descText, aGroup.addData);
        [_HSCore addNewGroupItem:aGroup];
    }
    worked = [db executeUpdate:@"delete from _tbMainGroup where delFlag=1"];
    if(!worked)
    {
        [db close];
        return NO;
    }
    [_HSCore reloadGroup];
    // send nil object to make the msg effect
    PostMessage(hsNotificationReloadGList, nil);
    return YES;
}

-(BOOL)addNewGroupItem:(HSPublicGroupObject *)aGroup
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
//        NSLog(@"数据库打开失败");
        return NO;
    }
    
    if(![self checkTableCreatedInDb:db]) return NO;
    
    bool worked;
    BOOL bExist = NO;
    FMResultSet *rs = [db executeQuery:@"select * from '_tbMainGroup' where chatID=?", aGroup.chatID];
    while([rs next])
    {
        bExist = YES;
    }
    [rs close];
    
    if(bExist)
    {
        worked = [db executeUpdate:@"update '_tbMainGroup' set delFlag=0, groupName=?, descText=?, addData=? where chatID=?", aGroup.groupName, aGroup.descText, aGroup.addData, aGroup.chatID];
    }
    else
    {
        worked = [db executeUpdate:@"INSERT INTO '_tbMainGroup' VALUES(0,0,?,?,?,?)", aGroup.chatID, aGroup.groupName, aGroup.descText, aGroup.addData];
    }
    [db close];
    return worked;
}

-(BOOL)reloadGroup
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
//        NSLog(@"数据库打开失败");
        return NO;
    }
    if(![self checkTableCreatedInDb:db]) return NO;
    
    [m_sysNotify removeAllObjects];
    [m_publicGroup removeAllObjects];
    [m_configItems removeAllObjects];
    
    FMResultSet *rs = [db executeQuery:@"select * from '_tbMainGroup'"];
    while([rs next])
    {
        HSPublicGroupObject *aGroup = [HSPublicGroupObject groupFromDataset:rs];
        if([Master isSysNotify:[aGroup.chatID intValue]])
        {
            [m_sysNotify addObject:aGroup];
        }
        else if([Master isPublicGroup:[aGroup.chatID intValue]] || [Master isHyperLink:[aGroup.chatID intValue]])
        {
            [m_publicGroup addObject:aGroup];
            [self reloadFriendList:aGroup.chatID];
        }
        else if([Master isConfigItem:[aGroup.chatID intValue]])
        {
            [m_configItems addObject:aGroup];
        }
    }
    [rs close];
    [db close];
    return YES;
}

#pragma mark dump table

#define closeDump

-(BOOL)dumpGroup
{
#ifdef closeDump
    //return YES;
#endif
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
//        NSLog(@"数据库打开失败");
        return NO;
    }
    if(![self checkTableCreatedInDb:db]) return NO;
    
//    NSLog(@"====================Dump Group Table==============");
    NSString *queryString = @"select * from '_tbMainGroup'";
    FMResultSet *rs = [db executeQuery:queryString];
    while([rs next])
    {
//        NSLog(@"show:%d chatID:%d name:%@ desc:%@",
//              [[rs objectForColumnName:@"showInIM"] intValue],
//              [[rs objectForColumnName:@"chatID"] intValue],
//              [rs stringForColumn:@"groupName"],
//              [rs stringForColumn:@"descText"]);
    }
    [rs close];
    [db close];
//    NSLog(@"=================================================");
    return YES;
}

-(BOOL)dumpFriend
{
#ifdef closeDump
    //return YES;
#endif
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
//        NSLog(@"数据库打开失败");
        return NO;
    }
    if(![self checkTableCreatedInDb:db]) return NO;
    
//    NSLog(@"====================Dump _tbIMFriendList Table==============");
    NSString *queryString = @"select * from '_tbIMFriendList'";
    FMResultSet *rs = [db executeQuery:queryString];
    while([rs next])
    {
        HSUserObject *aUser = [HSUserObject userFromDataSet:rs];
        [aUser dump];
    }
    [rs close];
    [db close];
//    NSLog(@"=================================================");
    return YES;
}

-(BOOL)dumpMessage
{
#ifdef closeDump
    //return YES;
#endif
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
//        NSLog(@"数据库打开失败");
        return NO;
    }
    if(![self checkTableCreatedInDb:db]) return NO;
    
//    NSLog(@"====================Dump _tbHSMessage Table==============");
    NSString *queryString = @"select * from '_tbHSMessage'";
    FMResultSet *rs = [db executeQuery:queryString];
    while([rs next])
    {
//        NSLog(@"hasRead:%d chatID:%d hasOperate:%d state:%d type:%d from:%@ to:%@ flag:%d msg:%@",
//              [[rs objectForColumnName:@"hasRead"] intValue],
//              [[rs objectForColumnName:@"messageChatID"] intValue],
//              [[rs objectForColumnName:@"hasOperate"] intValue],
//              [[rs objectForColumnName:@"messageState"] intValue],
//              [[rs objectForColumnName:@"messageType"] intValue],
//              [rs stringForColumn:@"messageFrom"],
//              [rs stringForColumn:@"messageTo"],
//              [[rs objectForColumnName:@"messageTimeFlag"] intValue],
//              [rs stringForColumn:@"messageContent"]);
    }
    [rs close];
    [db close];
//    NSLog(@"=================================================");
    return YES;
}

-(BOOL)dumpSetting
{
#ifdef closeDump
    return YES;
#endif
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
//        NSLog(@"数据库打开失败");
        return NO;
    }
    if(![self checkTableCreatedInDb:db]) return NO;
    
//    NSLog(@"====================Dump _tbHSGroupSetting Table==============");
    NSString *queryString = @"select * from '_tbHSGroupSetting'";
    FMResultSet *rs = [db executeQuery:queryString];
    while([rs next])
    {
        NSLog(@"chatID:%d isPrompt:%d isShowNick:%d",
              [[rs objectForColumnName:@"chatID"] intValue],
              [[rs objectForColumnName:@"isPrompt"] intValue],
              [[rs objectForColumnName:@"isShowNick"] intValue]);
    }
    [rs close];
    [db close];
//    NSLog(@"=================================================");
    return YES;
}

-(BOOL)dumpUnSend
{
#ifdef closeDump
    return YES;
#endif
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
//        NSLog(@"数据库打开失败");
        return NO;
    }
    if(![self checkTableCreatedInDb:db]) return NO;
    
//    NSLog(@"====================Dump _tbHSSendingMessage Table==============");
    NSString *queryString = @"select * from '_tbHSSendingMessage'";
    FMResultSet *rs = [db executeQuery:queryString];
    while([rs next])
    {
        NSLog(@"chatID:%@ timeFlag:%@ date:%@",
              [rs objectForKeyedSubscript:@"messageChatID"],
              [rs objectForKeyedSubscript:@"messageTimeFlag"],
              [rs objectForKeyedSubscript:@"sendDate"]);
    }
    [rs close];
    [db close];
    NSLog(@"=================================================");
    return YES;
}

#pragma mark ******************* IM Chat Message Handler

-(BOOL)reloadIMessage
{
    return ([self reloadNotifyIM] && [self reloadPublicIM] && [self reloadPrivateIM]);
}

-(BOOL)reloadNotifyIM
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
        NSLog(@"数据库打开失败");
        return NO;
    }
    if(![self checkTableCreatedInDb:db]) return NO;
    
    [m_notifyMessageList removeAllObjects];
    
    NSString *queryString = @"select * from '_tbMainGroup' where showInIM = 1";
    FMResultSet *rs = [db executeQuery:queryString];
    while([rs next])
    {
        if([Master isSysNotify:[[rs objectForColumnName:@"chatID"] intValue]])
        {
            HSPublicGroupObject *aGroup = [HSPublicGroupObject groupFromDataset:rs];
            FMResultSet *rs2 = [db executeQuery:@"select * from '_tbHSMessage' where messageChatID=? order by messageDate desc LIMIT 0,1", aGroup.chatID];
            while([rs2 next])
            {
                HSMessageObject *aMessage = [HSMessageObject messageFromDataSet:rs2];
                HSIMessageObject *aIMessage = [HSIMessageObject iMessageFrom:aMessage andUser:nil orGroup:aGroup];
                [m_notifyMessageList addObject:aIMessage];
                break;
            }
            [rs2 close];
        }
    }
    [rs close];
    [db close];
    return YES;
}

-(BOOL)reloadPublicIM
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
        NSLog(@"数据库打开失败");
        return NO;
    }
    if(![self checkTableCreatedInDb:db]) return NO;
    
    [m_privateIMessageList removeAllObjects];
    [m_publicIMessageList removeAllObjects];
    BOOL bLoad = TRUE;
    if(bLoad)
    {
        
        FMResultSet *rs2 = [db executeQuery:@"select * from '_tbHSMessage' where messageType=10 or messageType=11 or messageType=12 or messageType=13 order by messageDate desc LIMIT 0,1"];
        while([rs2 next])
        {
            HSMessageObject *aMessage = [HSMessageObject messageFromDataSet:rs2];
            HSIMessageObject *aIMessage = [HSIMessageObject iMessageFrom:aMessage andUser:nil orGroup:nil];
            [m_privateIMessageList addObject:aIMessage];
            [m_publicIMessageList addObject:aIMessage];
            break;
        }
        [rs2 close];
    }
    
    NSString *queryString = @"select * from '_tbMainGroup' where showInIM = 1";
    FMResultSet *rs = [db executeQuery:queryString];
    while([rs next])
    {
        if([Master isPublicGroup:[[rs objectForColumnName:@"chatID"] intValue]])
        {
            FMResultSet *rs2 = [db executeQuery:@"select * from '_tbHSMessage' where messageChatID=? order by messageDate desc LIMIT 0,1", [rs objectForColumnName:@"chatID"]];
            while([rs2 next])
            {
                HSPublicGroupObject *aGroup = [HSPublicGroupObject groupFromDataset:rs];
                HSMessageObject *aMessage = [HSMessageObject messageFromDataSet:rs2];
                HSIMessageObject *aIMessage = [HSIMessageObject iMessageFrom:aMessage andUser:nil orGroup:aGroup];
                [m_privateIMessageList addObject:aIMessage];
                [m_publicIMessageList addObject:aIMessage];
                break;
            }
            [rs2 close];
        }
    }
    [rs close];
    [db close];
    return YES;
}

-(BOOL)reloadPrivateIM
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
        NSLog(@"数据库打开失败");
        return NO;
    }
    if(![self checkTableCreatedInDb:db]) return NO;
    
//    [m_privateIMessageList removeAllObjects];
    
    BOOL bLoad = YES;
    if(bLoad)
    {
        // 之所以要加载这些是因为这些消息来的时候这个好友还不存在，所以，下面的方式加载不到
        FMResultSet *rs2 = [db executeQuery:@"select * from '_tbHSMessage' where (messageType=14 or messageType=15 or messageType=16 or messageType=17) order by messageDate desc"];// LIMIT 0,1"];
        while([rs2 next])
        {
            HSMessageObject *aMessage = [HSMessageObject messageFromDataSet:rs2];
            HSIMessageObject *aIMessage = [HSIMessageObject iMessageFrom:aMessage andUser:nil orGroup:nil];
            [m_privateIMessageList addObject:aIMessage];
        }
        [rs2 close];
    }
    
    NSString *queryString = @"select * from '_tbIMFriendList' where showInIM = 1";
    FMResultSet *rs = [db executeQuery:queryString];
    while([rs next])
    {
        
        FMResultSet *rs2 = [db executeQuery:@"select * from '_tbHSMessage' where messageType<10 and messageFrom=? and messageChatID=0 order by messageDate desc LIMIT 0,1", [rs stringForColumn:@"DDNumber"]];
        while([rs2 next])
        {
            HSUserObject *aUser = [HSUserObject userFromDataSet:rs];
            HSMessageObject *aMessage = [HSMessageObject messageFromDataSet:rs2];
            HSIMessageObject *aIMessage = [HSIMessageObject iMessageFrom:aMessage andUser:aUser orGroup:nil];
            [m_privateIMessageList addObject:aIMessage];
            break;
        }
        [rs2 close];
    }
    [rs close];
    [db close];
    return YES;
}

#pragma mark ******************* Friend List Handler

-(BOOL)checkUserTableCreatedInDb:(FMDatabase *)db
{
    NSString *createStr = @"CREATE  TABLE  IF NOT EXISTS '_tbIMFriendList' ('delFlag' INTEGER, 'oldData' INTEGER, 'showInIM' INTEGER, 'chatID' INTEGER, 'DDNumber' VARCHAR, 'userType' INTEGER, 'nickName' VARCHAR, 'realName' VARCHAR, 'EmailAddr' VARCHAR, 'MobileNo' VARCHAR, 'signText' VARCHAR, 'bindText' VARCHAR, 'dataFlag' INTEGER)";
    BOOL worked = [db executeUpdate:createStr];
    FMDBQuickCheck(worked);
    return worked;
}

-(NSMutableArray *)userListForChatID:(NSNumber *)chatID
{
    NSString *strChatID = [NSString stringWithFormat:@"%@", chatID];
    return [m_allUserList objectForKey:strChatID];
}

-(BOOL)reloadFriendList:(NSNumber *)chatID
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
        NSLog(@"数据库打开失败");
        return NO;
    }
    if(![self checkTableCreatedInDb:db]) return NO;
    
    NSMutableArray *nsList = [self userListForChatID:chatID];
    if(nsList == nil)
    {
        nsList = [[NSMutableArray alloc] initWithCapacity:128];
        [m_allUserList setObject:nsList forKey:[NSString stringWithFormat:@"%@", chatID]];
    }
    
    [nsList removeAllObjects];
    NSString *queryStr= [NSString stringWithFormat:@"select * from '_tbIMFriendList' where chatID=?"];
    FMResultSet *rs = [db executeQuery:queryStr, chatID];
    while([rs next])
    {
        HSUserObject *aUser = [HSUserObject userFromDataSet:rs];
//        if(aUser.dataNeedUpdate)
//        {
//            NSLog(@"need update: %@", aUser.DDNumber);
//        }
        [nsList addObject:aUser];
    }
    [rs close];
    [db close];
    return YES;
}

-(BOOL)removeFriend:(NSString *)userID
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
        NSLog(@"数据库打开失败");
        return NO;
    }
    if(![self checkTableCreatedInDb:db]) return NO;
    
    return [db executeUpdate:@"delete from '_tbIMFriendList' where DDNumber=? and chatID=0", userID];
}

-(HSUserObject *)userFromDB:(NSString *)userID ofChatID:(NSNumber *)chatID
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
        NSLog(@"数据库打开失败");
        return nil;
    }
    if(![self checkTableCreatedInDb:db]) return nil;
    
    NSString *queryStr= [NSString stringWithFormat:@"select * from '_tbIMFriendList' where DDNumber=? and chatID=?"];
    FMResultSet *rs = [db executeQuery:queryStr, userID, chatID];
    while([rs next])
    {
        HSUserObject *aUser = [HSUserObject userFromDataSet:rs];
        [rs close];
        [db close];
        return aUser;
    }
    [rs close];
    [db close];
    return nil;
}

-(void)showFriendInIM:(BOOL)bShow ofWho:(NSString *)DDNumber
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
        NSLog(@"数据库打开失败");
        return;
    }
    
    if(![self checkTableCreatedInDb:db]) return;
    if(bShow)
    {
        BOOL worked = [db executeUpdate:@"UPDATE '_tbIMFriendList' set showInIM = 1 where DDNumber = ? and chatID = 0", DDNumber];
        FMDBQuickCheck(worked);
    }
    else
    {
        BOOL worked = [db executeUpdate:@"UPDATE '_tbIMFriendList' set showInIM = 0 where DDNumber = ? and chatID = 0", DDNumber];
        FMDBQuickCheck(worked);
        [self signMessageReadByUserID:DDNumber];
        PostMessage(hsNotificationReloadFList, [NSNumber numberWithInt:0]);
    }
}

-(BOOL)addNewFriendIntoDB:(HSUserObject *)aUser ofChatID:(NSNumber *)chatID isFullData:(BOOL)fullData isReload:(BOOL)reload
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
        NSLog(@"数据库打开失败");
        return NO;
    }
    if(![self checkTableCreatedInDb:db]) return NO;
    
    BOOL worked;
    BOOL bExist = NO;
    FMResultSet *rs;
    NSNumber *oldDataFlag;
    rs = [db executeQuery:@"select DDNumber, dataFlag from '_tbIMFriendList' where DDNumber=? and chatID=?", aUser.DDNumber, chatID];
    while([rs next])
    {
        NSLog(@"existed FRIEND:%@ ", aUser.DDNumber);
        oldDataFlag = [rs objectForColumnName:@"dataFlag"];
        bExist = YES;
        break;
    }
    [rs close];
    
    NSNumber *oldData;
    if(fullData)
    {
        oldData = [NSNumber numberWithInt:0];
    }
    else
    {
        oldData = [NSNumber numberWithInt:1];
    }
    if(bExist == YES)
    {
        NSNumber *oldData;
        if([aUser.dataFlag intValue] == 0) oldData = [NSNumber numberWithInt:1];
        else
        {
            if([aUser.dataFlag isEqualToNumber:oldDataFlag])
            {
                oldData = [NSNumber numberWithInt:0];
            }
            else
            {
                oldData = [NSNumber numberWithInt:1];
            }
        }
        if(fullData)
        {
            worked = [db executeUpdate:@"update _tbIMFriendList set delFlag=0, oldData=?, dataFlag=?, nickName=?, realName=?, signText=?, bindText=?, emailAddr=?, mobileNo=? where DDNumber=?",
                      oldData,
                      aUser.dataFlag,
                      aUser.nickName,
                      aUser.realName,
                      aUser.signText,
                      aUser.bindText,
                      aUser.emailAddr,
                      aUser.mobileNo,
                      aUser.DDNumber];
        }
        else
        {
            worked = [db executeUpdate:@"UPDATE _tbIMFriendList set 'delFlag'=0, 'oldData'=?, 'dataFlag'=? where DDNumber=?", oldData,  aUser.dataFlag, aUser.DDNumber];
        }
        if(worked == NO) NSLog(@"update friend %@ failed.", aUser.DDNumber);
    }
    else
    {
        NSLog(@"push new FRIEND:%@ , new flag: %d, old data: 1", aUser.DDNumber, 0);
        worked = [db executeUpdate:@"INSERT INTO _tbIMFriendList ('delFlag', 'oldData', 'showInIM', 'chatID', 'DDNumber', 'nickName', 'realName', 'EmailAddr', 'MobileNo', 'signText', 'bindText', 'dataFlag') values(0,?,0,?,?,?,?,?,?,?,?,?)", oldData, chatID, aUser.DDNumber, aUser.nickName, aUser.realName, aUser.emailAddr, aUser.mobileNo, aUser.signText,aUser.bindText, aUser.dataFlag];
    }
    
    [db close];
    if(reload) [self reloadFriendList:chatID];
    return YES;
}

-(BOOL)pushFriendListIntoDB:(char *)pData
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
        NSLog(@"数据库打开失败");
        return NO;
    }
    if(![self checkTableCreatedInDb:db]) return NO;
    
    cpNew;
    cp2NewInt(iChatID);
    cp2NewString(szGroupFlag, LEN_ACCOUNT);
    cp2NewInt(nCount);
    NSNumber *chatID = [self getChatIDForPublicGroup:[NSNumber numberWithInt:iChatID] andFlag:[NSString stringWithCString:szGroupFlag encoding:NSASCIIStringEncoding]];
    BOOL worked;
    worked = [db executeUpdate:@"update _tbIMFriendList set delFlag = 1 where chatID=?", chatID];
    if(!worked)
    {
        [db close];
        return NO;
    }
    for(int i = 0; i < nCount; i++)
    {
        cp2NewString(szDDNumber, LEN_ACCOUNT);
        cp2NewInt(dataFlag);
        
        HSUserObject *aUser = [HSUserObject userWithDDNumber:[[NSString alloc] initWithCString:szDDNumber encoding:En2CHN] andDataFlag:[NSNumber numberWithInt:dataFlag]];
        if([aUser.DDNumber isEqualToString:_Master.mySelf.DDNumber] == YES) continue;
        if([Master isP2PChat:iChatID] == NO)
        {
            HSUserObject *aUser0 = [_HSCore userFromDB:aUser.DDNumber ofChatID:chatID];
            if(aUser0 != nil)
            {
                [self addNewFriendIntoDB:aUser0 ofChatID:chatID isFullData:YES isReload:NO];
            }
            else
            {
                [self addNewFriendIntoDB:aUser ofChatID:chatID isFullData:NO isReload:NO];
            }
        }
        else [self addNewFriendIntoDB:aUser ofChatID:chatID isFullData:NO isReload:NO];
    }
    worked = [db executeUpdate:@"delete from  _tbIMFriendList where delFlag = 1 and chatID=?", chatID];
    [db close];
    [self reloadFriendList:chatID];
    return YES;
}

-(void)updateUserFullData:(HSUserObject *)aUser ofChatID:(NSNumber *)chatID
{
    [self addNewFriendIntoDB:aUser ofChatID:chatID isFullData:YES isReload:YES];
}

-(BOOL)isMyFriend:(NSString *)userID
{
    HSUserObject *aUser = [self userFromDB:userID ofChatID:[NSNumber numberWithInt:0]];
    if(aUser == nil) return NO;
    return YES;
}

#pragma mark ******************* Group Settting DB

// use chatID = -1 FOR system setting config
-(BOOL)checkGroupSettingTableCreatedInDB:(FMDatabase *)db
{
    NSString *createStr = @"CREATE  TABLE  IF NOT EXISTS '_tbHSGroupSetting' ('chatID' INTEGER ,'isPrompt' INTEGER, 'isShowNick' INTEGER)";
    
    BOOL worked = [db executeUpdate:createStr];
    FMDBQuickCheck(worked);
    return worked;
}

-(void)setPromptMsgOfChatID:(NSNumber *)chatID ofPrompt:(BOOL)bPrompt
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
        NSLog(@"数据打开失败");
        return;
    }
    if(![self checkGroupSettingTableCreatedInDB:db]) return;
    
    FMResultSet *rs;
    rs = [db executeQuery:@"select * from _tbHSGroupSetting where chatID=?", chatID];
    BOOL bExist = NO;
    while([rs next])
    {
        bExist = YES;
        break;
    }
    [rs close];
    if(bExist == NO)
    {
        BOOL bOK = [db executeUpdate:@"INSERT INTO _tbHSGroupSetting VALUES(?,?,?)", chatID, [NSNumber numberWithInt:1], [NSNumber numberWithInt:0]];
        FMDBQuickCheck(bOK);
    }
    
    NSNumber *bIsPrompt;
    bIsPrompt = [NSNumber numberWithInt:bPrompt ? 1 : 0];
    BOOL worked = [db executeUpdate:@"UPDATE _tbHSGroupSetting set isPrompt=? where chatID=?", bIsPrompt, chatID];
    [db close];
    FMDBQuickCheck(worked);
    if(worked)
    {
        if([chatID intValue] == notPubChat)
        {
            [_Master setBPlaySound:bPrompt];
        }
    }
}

-(BOOL)isPromptMsgOfChatID:(NSNumber *)chatID
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
        NSLog(@"数据库打开失败");
        return NO;
    }
    if(![self checkGroupSettingTableCreatedInDB:db]) return NO;
    
    FMResultSet *rs;
    NSNumber *bIsPrompt = [NSNumber numberWithInt:1];
    rs = [db executeQuery:@"select * from _tbHSGroupSetting where chatID=?", chatID];
    while([rs next])
    {
        bIsPrompt = [rs objectForColumnName:@"isPrompt"];
        break;
    }
    [rs close];
    if([bIsPrompt intValue] == 0) return NO;
    return YES;
}

-(void)setShowNickOfChatID:(NSNumber *)chatID ofShow:(BOOL)bShow
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
        NSLog(@"数据打开失败");
        return;
    }
    if(![self checkGroupSettingTableCreatedInDB:db]) return;
    
    FMResultSet *rs;
    rs = [db executeQuery:@"select * from _tbHSGroupSetting where chatID=?", chatID];
    BOOL bExist = NO;
    while([rs next])
    {
        
        bExist = YES;
        break;
    }
    [rs close];
    if(bExist == NO)
    {
        BOOL bOK = [db executeUpdate:@"INSERT INTO _tbHSGroupSetting VALUES(?,?,?)", chatID, [NSNumber numberWithInt:1], [NSNumber numberWithInt:0]];
        FMDBQuickCheck(bOK);
    }
    
    NSNumber *bIsShow;
    bIsShow = [NSNumber numberWithInt:bShow ? 1 : 0];
    BOOL worked = [db executeUpdate:@"UPDATE _tbHSGroupSetting set isShowNick=? where chatID=?", bIsShow, chatID];
    [db close];
    FMDBQuickCheck(worked);
    if(worked)
    {
    }
}

-(BOOL)isShowNickOfChatID:(NSNumber *)chatID
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
        NSLog(@"数据库打开失败");
        return NO;
    }
    if(![self checkGroupSettingTableCreatedInDB:db]) return NO;
    
    FMResultSet *rs;
    NSNumber *bIsShow = [NSNumber numberWithInt:0];
    rs = [db executeQuery:@"select * from _tbHSGroupSetting where chatID=?", chatID];
    while([rs next])
    {
        bIsShow = [rs objectForColumnName:@"isShowNick"];
        break;
    }
    [rs close];
    if([bIsShow intValue] == 0) return NO;
    return YES;
}

#pragma mark ******************* Chat Message Send Comfirm

-(BOOL)checkMessageSendTableCreatedInDb:(FMDatabase *)db
{
    NSString *createStr = @"CREATE  TABLE  IF NOT EXISTS '_tbHSSendingMessage' ('messageTimeFlag' INTEGER, 'sendDate' VARCHAR, 'messageChatID' INTEGER)";
    
    BOOL worked = [db executeUpdate:createStr];
    FMDBQuickCheck(worked);
    return worked;
}

-(void)removeUnSendMsg:(NSNumber *)timeFlag
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open])
    {
        NSLog(@"数据打开失败");
        return;
    }
    if(![self checkMessageSendTableCreatedInDb:db]) return;
    NSLog(@"REMOVE sending msg : %@", timeFlag);
    [db executeUpdate:@"delete from _tbHSSendingMessage where messageTimeFlag=?", timeFlag];
    [db close];
}

-(void)checkMessageSendTimeout:(NSNumber *)chatID
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open])
    {
        NSLog(@"数据打开失败");
        return;
    }
    if(![self checkMessageSendTableCreatedInDb:db]) return;
    
    BOOL bNeedUpdate = NO;
    FMResultSet *rs;
    rs = [db executeQuery:@"select * from _tbHSSendingMessage where messageChatID=?", chatID];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //this is the sqlite's format
   // NSDate *date = [formatter dateFromString:score.datetime];
    
    while([rs next])
    {
        NSNumber *timeFlag = [rs objectForColumnName:@"messageTimeFlag"];
        NSDate *sendDate = [HSCoreData dateFromString:[rs objectForColumnName:@"sendDate"]];
        NSTimeInterval timeSinceLastUpdate = [sendDate timeIntervalSinceNow];
        timeSinceLastUpdate *= -1;
        if(timeSinceLastUpdate > 6)
        {
            bNeedUpdate = YES;
            // sign send failed.
            [db executeUpdate:@"UPDATE _tbHSMessage set hasSuccess=? where messageTimeFlag=?", [NSNumber numberWithInt:2], timeFlag];
            [db executeUpdate:@"delete from _tbHSSendingMessage where messageTimeFlag=?", timeFlag];
        }
    }
    if(bNeedUpdate == YES)
    {
        PostMessage(hsNotificationMsgUpdateChatList, nil);
    }
    
    [rs close];
    [db close];
    return;
}

-(BOOL)pushUnSendMsg:(NSNumber *)timeFlag ofChatID:(NSNumber *)chatID
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
        NSLog(@"数据库打开失败");
        return NO;
    }
    if(![self checkMessageSendTableCreatedInDb:db]) return NO;
    
    NSDate *date = [NSDate date];
    NSLog(@"ADDING sending msg : %@ %@", timeFlag, chatID);
    BOOL worked = [db executeUpdate:@"INSERT INTO '_tbHSSendingMessage' ('messageTimeFlag', 'sendDate', 'messageChatID') VALUES (?,?,?)",
                   timeFlag,
                   [HSCoreData stringByDate:date withYear:YES],
                   chatID];
    FMDBQuickCheck(worked);
    [db close];
    return worked;
}

#pragma mark ******************* Chat Message Handler

-(BOOL)checkMessageTableCreatedInDb:(FMDatabase *)db
{
    NSString *createStr = @"CREATE  TABLE  IF NOT EXISTS '_tbHSMessage' ('messageId' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL  UNIQUE ,'messageState' INTEGER, 'messageFrom' VARCHAR, 'messageTo' VARCHAR, 'messageContent' VARCHAR, 'messageDate' DATETIME,'messageType' INTEGER, 'messageChatID' INTEGER, 'messageTimeFlag' INTEGER, 'hasRead' INTEGER, 'hasOperate' INTEGER, bindImagePath VARCHAR, uploadUUID VARCHAR)";
    
    BOOL worked = [db executeUpdate:createStr];
    FMDBQuickCheck(worked);
    return worked;
}

-(void)removeMessageFromDB:(HSMessageObject *)aMessage
{
    if(aMessage == nil) return;
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
        NSLog(@"数据打开失败");
        return;
    }
    BOOL worked = [db executeUpdate:@"delete from _tbHSMessage where messageTimeFlag=? and messageFrom=? and messageTo=? and messageDate=?",
                   aMessage.messageTimeFlag,
                   aMessage.messageFrom,
                   aMessage.messageTo,
                   aMessage.messageDate];
    [db close];
    FMDBQuickCheck(worked);
}

-(void)disableMessageOperation:(HSMessageObject *)aMessage
{
    if(aMessage == nil) return;
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
        NSLog(@"数据打开失败");
        return;
    }
    BOOL worked = [db executeUpdate:@"UPDATE _tbHSMessage set hasOperate=1 where messageTimeFlag=? and messageChatID=?", aMessage.messageTimeFlag, aMessage.messageChatID];
    [db close];
    FMDBQuickCheck(worked);
    if(worked)
    {
        [self reloadIMessage];
        //PostMessage(hsNotificationNewMsg, aMessage);
    }
}

-(void)signNotifyP2PMessageRead:(HSMessageObject *)aMessage
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
        NSLog(@"数据打开失败");
        return;
    }
    BOOL worked = [db executeUpdate:@"UPDATE _tbHSMessage set hasRead=1 where messageFrom=? and messageChatID=? and messageType=?",
                   aMessage.messageFrom,
                   aMessage.messageChatID,
                   aMessage.messageType];
    [db close];
    FMDBQuickCheck(worked);
}

-(void)signMessageReadByUserID:(NSString *)userID
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
        NSLog(@"数据打开失败");
        return;
    }
    BOOL worked = [db executeUpdate:@"UPDATE _tbHSMessage set hasRead=1 where messageFrom=? and messageChatID=0", userID];
    [db close];
    FMDBQuickCheck(worked);
}

-(void)signMessageReadByChatID:(NSNumber *)chatID
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
        NSLog(@"数据打开失败");
        return;
    }
    BOOL worked = [db executeUpdate:@"UPDATE _tbHSMessage set hasRead=1 where messageChatID=?", chatID];
    [db close];
    FMDBQuickCheck(worked);
}

-(void)signMessageState:(int)timeFlag ofState:(int)state
{
    NSLog(@"message %d has done.", timeFlag);
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
        NSLog(@"数据打开失败");
        return;
    }
    BOOL worked = [db executeUpdate:@"UPDATE _tbHSMessage set messageState=? where messageTimeFlag=?", [NSNumber numberWithInt:state], [NSNumber numberWithInt:timeFlag]];
    [db close];
    FMDBQuickCheck(worked);
    if(worked)
    {
        PostMessage(hsNotificationMsgUpdateChatList, nil);
    }
}

-(BOOL)mergeSameMessage:(HSMessageObject *)aMessage
{
    int msgType = [aMessage.messageType intValue];
    switch (msgType)
    {
        case kWCMessageTypeP2PAuthration:
            break;
        default:
            return NO;
    }
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
        NSLog(@"数据库打开失败");
        return NO;
    }
    if(![self checkTableCreatedInDb:db]) return NO;
    
    NSString *insertStr = @"delete from _tbHSMessage where messageFrom = ? and messageChatID = ? and messageType = ?";
    BOOL worked = [db executeUpdate:insertStr, aMessage.messageFrom, aMessage.messageChatID, aMessage.messageType];
    FMDBQuickCheck(worked);
    [db close];
    return YES;
}

//增删改查
-(BOOL)saveMessage2DB:(HSMessageObject *)aMessage ofRead:(BOOL)isRead isReloadIM:(BOOL)bReloadIM
{
    [self mergeSameMessage:aMessage];
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
        NSLog(@"数据库打开失败");
        return NO;
    }
    if(![self checkTableCreatedInDb:db]) return NO;
    
    NSString *insertStr = @"INSERT INTO '_tbHSMessage' ('messageState', 'messageFrom','messageTo','messageContent','messageDate','messageType', 'messageChatID', 'messageTimeFlag', 'hasRead', 'hasOperate', bindImagePath, uploadUUID) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
    NSNumber *bIsRead = [NSNumber numberWithInt:isRead ? 1 : 0];
    BOOL worked = [db executeUpdate:insertStr,aMessage.messageState, aMessage.messageFrom,aMessage.messageTo,aMessage.messageContent,aMessage.messageDate,aMessage.messageType, aMessage.messageChatID, aMessage.messageTimeFlag, bIsRead, [NSNumber numberWithInt:0], aMessage.bindImagePath, aMessage.uploadUUID];
    FMDBQuickCheck(worked);
    [db close];
    
    if([Master isPublicGroup:[aMessage.messageChatID intValue]] || [Master isSysNotify:[aMessage.messageChatID intValue]])
    {
        [self showGroupInIM:YES ofChatID:aMessage.messageChatID];
    }
    else 
    {
        [self showFriendInIM:YES ofWho:aMessage.messageFrom];
    }
    if(!bReloadIM) return worked;
    
    [self reloadIMessage];
    //发送全局通知
    PostMessage(hsNotificationNewMsg, aMessage);
    if(isRead == NO)
    {
        [self constructBadge];
    }
    return worked;
}

-(void)updateMessageContentForMessageOfTimeFlag:(NSNumber *)timeFlag and:(NSString *)content
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if(![db open])
    {
        NSLog(@"数据打开失败");
        return;
    }
    BOOL worked = [db executeUpdate:@"UPDATE _tbHSMessage set messageContent=? where messageTimeFlag=?", content, timeFlag];
    [db close];
    FMDBQuickCheck(worked);
}

-(void)clearAllChatMsg:(NSNumber *)chatID fromWho:(NSString *)messageFrom myName:(NSString *)selfName
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open])
    {
        NSLog(@"数据打开失败");
        return;
    }
    if([chatID intValue] == -1)
    {
        [db executeUpdate:@"delete from _tbHSMessage"];
    }
    else
    {
        if(messageFrom == nil)
        {
            [db executeUpdate:@"delete from _tbHSMessage where messageChatID=?", chatID];
        }
        else
        {
            [db executeUpdate:@"delete from _tbHSMessage where messageChatID=0 and messageFrom=? and messageTo=?", messageFrom, selfName];
            [db executeUpdate:@"delete from _tbHSMessage where messageChatID=0 and messageFrom=? and messageTo=?", selfName, messageFrom];
        }
    }
    PostMessage(hsNotificationMsgUpdateChatList, nil);
}

//获取某联系人聊天记录
-(NSMutableArray*)fetchMessageListWithUser:(NSString *)userId byPages:(int)pageCount ofChatID:(NSNumber *)chatID
{
    NSMutableArray *messageList=[[NSMutableArray alloc]init];
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open])
    {
        NSLog(@"数据打开失败");
        return messageList;
    }
    NSString *queryString;
    FMResultSet *rs;
    int iChatID = [chatID intValue];
    NSNumber *countPerPage = [NSNumber numberWithInt:10 * pageCount];
    NSNumber *start = [NSNumber numberWithInt:0];//(pageIndex - 1) * [countPerPage intValue]];
    if([Master isP2PChat:iChatID])
    {
        queryString = @"select * from _tbHSMessage where messageChatID=0 and (messageFrom=? or messageTo=?) order by messageID desc LIMIT ?,?";
        rs = [db executeQuery:queryString,userId,userId,start,countPerPage];
    }
    else if([Master isPublicGroup:iChatID] || [Master isSysNotify:iChatID] || [Master isGroup:iChatID])
    {
        queryString = @"select * from _tbHSMessage where messageChatID=? order by messageID desc LIMIT ?,?";
        rs = [db executeQuery:queryString,chatID,start,countPerPage];
    }
    else
    {
        [db close];
        return nil;
    }
    if([Master isSysNotify:iChatID])
    {
        while([rs next])
        {
            HSMessageObject *aMessage = [HSMessageObject messageFromDataSet:rs];
            HSPublicGroupObject *aGroup = [self groupFromDB:chatID];
            HSIMessageObject *aIMessage = [HSIMessageObject iMessageFrom:aMessage andUser:nil orGroup:aGroup];
            [messageList addObject:aIMessage];
        }
    }
    else
    {
        while([rs next])
        {
            HSMessageObject *aMessage = [HSMessageObject messageFromDataSet:rs];
            NSLog(@"aMessageFrom is %@",aMessage.messageFrom);
            if([aMessage.messageFrom isEqualToString:_Master.mySelf.DDNumber])
            {
                HSIMessageObject *aIMessage = [HSIMessageObject iMessageFrom:aMessage andUser:_Master.mySelf orGroup:nil];
                [messageList addObject:aIMessage];
            }
            else
            {
                HSUserObject *aUser = [self userFromDB:aMessage.messageFrom ofChatID:chatID];
                HSIMessageObject *aIMessage = [HSIMessageObject iMessageFrom:aMessage andUser:aUser orGroup:nil];
                [messageList addObject:aIMessage];
            }
        }
    }
    
    [rs close];
    [db close];
    return  messageList;
}

-(void)constructBadge
{
    PostMessage(hsNotificationMsgBadge, nil);
}

-(int)badgeCountOfNotify
{
    int nCount = 0;
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open])
    {
        NSLog(@"数据打开失败");
        return nCount;
    }
    FMResultSet *rs;
    rs = [db executeQuery:@"select * from _tbHSMessage where hasRead=0"];
    while([rs next])
    {
        int iChatID = [[rs objectForColumnName:@"messageChatID"] intValue];
        if([Master isSysNotify:iChatID]) nCount++;
    }
    [rs close];
    [db close];
    if(nCount > 99) nCount = 99;
    return  nCount;
}

-(int)badgeCountOfChat
{
    int nCount = 0;
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open])
    {
        NSLog(@"数据打开失败");
        return nCount;
    }
    FMResultSet *rs;
    rs = [db executeQuery:@"select * from _tbHSMessage where hasRead=0"];
    while([rs next])
    {
        int iChatID = [[rs objectForColumnName:@"messageChatID"] intValue];
        if([Master isP2PChat:iChatID]) nCount++;
        else if([Master isPublicGroup:iChatID]) nCount++;
        else if([Master isGroup:iChatID]) nCount++;
    }
    [rs close];
    [db close];
    if(nCount > 99) nCount = 99;
    return  nCount;
}

-(int)badgeCountByChatID:(NSNumber *)chatID
{
    int nCount = 0;
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open])
    {
        NSLog(@"数据打开失败");
        return nCount;
    }
    FMResultSet *rs;
    rs = [db executeQuery:@"select * from _tbHSMessage where hasRead=0 and messageChatID=?", chatID];
    while([rs next])
    {
        nCount++;
    }
    [rs close];
    [db close];
    if(nCount > 99) nCount = 99;
    return  nCount;
}

-(int)badgeCountByUserID:(NSString *)userID andChatType:(NSNumber *)chatType
{
    int nCount = 0;
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open])
    {
        NSLog(@"数据打开失败");
        return nCount;
    }
    FMResultSet *rs;
    rs = [db executeQuery:@"select * from _tbHSMessage where hasRead=0 and messageFrom=? and messageChatID=0 and messageType=?", userID, chatType];
    while([rs next])
    {
        nCount++;
    }
    [rs close];
    [db close];
    if(nCount > 99) nCount = 99;
    return  nCount;
}

@end
