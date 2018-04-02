//
//  Master.m
//  HSEduApp
//
//  Created by han on 14/1/6.
//  Copyright (c) 2014年 han. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import "Master.h"
#import "HSPublicGroupObject.h"
#import "zlib.h"
#import "AppDelegate.h"
#import "ViewControllerLogin.h"

@implementation Master
@synthesize currentChatUser, m_nTick;

static Master *sharedInstance;

/**
 * The runtime sends initialize to each class in a program exactly one time just before the class,
 * or any class that inherits from it, is sent its first message from within the program. (Thus the
 * method may never be invoked if the class is not used.) The runtime sends the initialize message to
 * classes in a thread-safe manner. Superclasses receive this message before their subclasses.
 *
 * This method may also be called directly (assumably by accident), hence the safety mechanism.
 **/
+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;
		
		sharedInstance = [[Master alloc] init];
	}
}

+ (Master *)sharedInstance
{
	return sharedInstance;
}

+ (long long)fileSizeAtPath:(NSString*)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath])
    {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+(void)messageBox:(NSString *)pMsg withTitle:(NSString *)pTitle withOkText:(NSString *)okText
{
    UIAlertView * messageBox = [[UIAlertView alloc] initWithTitle: NSLocalizedString(pTitle, @"")
                                                          message: NSLocalizedString(pMsg, @"")
                                                         delegate: nil
                                                cancelButtonTitle: NSLocalizedString(okText, @"")
                                                otherButtonTitles: nil];
    [messageBox show];
}

-(CGSize)getScrSize
{
    return m_scrSize;
}

-(void)setScrSize:(CGSize)size
{
    m_scrSize = size;
}

- (BOOL)isTeacher
{
    return (self.mySelf.userType.intValue >= 3 || self.mySelf.userType.intValue == 0);
}

- (BOOL)isClassMaster
{
    return (self.mySelf.userType.intValue == 4 || self.mySelf.userType.intValue == 0);
}

- (BOOL)isSchoolMaster
{
    return (self.mySelf.userType.intValue == 5 || self.mySelf.userType.intValue == 0);
}

-(id)init
{
	if (sharedInstance != nil)
	{
		return nil;
	}
	
	if ((self = [super init]))
    {
        self.lastRequestTime = [[NSMutableDictionary alloc] init];
//        tcpMaster = [[HSSocket alloc] initWithDelegate:self];
        
//        m_bSlientMsg = NO;
//        m_bSingleChatMsg = YES;
//        m_nTick = 0;
//        m_pZipBatchData = NULL;
//        [self setBNetwokOKing:YES];
//        [self setBNeedForce2Update:NO];
//        [self setBPlaySound:[_HSCore isPromptMsgOfChatID:[NSNumber numberWithInt:notPubChat]]];
//        [self startSocketTimer];
//        [glState setMainState:emStateNone];
//        [glState setLastActiveTime:[NSDate dateWithTimeIntervalSinceNow:-999.0f]];
	}
	return self;
}

+(BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|77|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark --- json request ---

- (void)reqJsonFor:(NSString *)api andParams:(NSDictionary *)params success:(void(^)(NSDictionary *))blockSuccess failed:(void(^)())blockFailed
{
    NSLog(@"[HSAppData getDomain] is %@",[HSAppData getDomain]);
    NSString *domain = [HSAppData getDomain];
//    NSString * domain = @"http://192.168.5.107"; 调试Url
    NSString *url = domain;
    //http://www.butaschool.com/Appapi/getclasslist/checkcode/1233456.html
    if([api isEqualToString:@"getClassList"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/getClassList/checkcode/%@.html", domain, [params objectForKey:@"checkcode"]];
    }
    //http://www.butaschool.com/Appapi/SendRegSms/phone/13684887266.html
    else if([api isEqualToString:@"SendRegSms"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/SendRegSms/phone/%@.html", domain, [params objectForKey:@"phone"]];
    }
    //http://www.butaschool.com/Appapi/Verifyregsms/phone/13684887266/sms/326080.html
    else if([api isEqualToString:@"Verifyregsms"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/Verifyregsms/phone/%@/sms/%@.html", domain, [params objectForKey:@"phone"], [params objectForKey:@"sms"]];
    }
    //http://www.butaschool.com/Appapi/sendbindsms/phone/13684887266/bindphone/13684887266.html
    else if([api isEqualToString:@"sendbindsms"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/sendbindsms/phone/%@/bindphone/%@.html", domain, [params objectForKey:@"phone"], [params objectForKey:@"bindphone"]];
    }
    //http://www.butaschool.com/Appapi/doregister/phone/15012345678/password/mima/bindphone/18800000001/bindsms/123456.html
    else if([api isEqualToString:@"doregister"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/doregister/phone/%@/password/%@/bindphone/%@/bindsms/%@.html", domain, [params objectForKey:@"phone"], [params objectForKey:@"password"], [params objectForKey:@"bindphone"], [params objectForKey:@"bindsms"]];
    }
    //http://www.butaschool.com/Appapi/getForgetSmsCode/phone/13684887266.html
    else if([api isEqualToString:@"getForgetSmsCode"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/getForgetSmsCode/phone/%@.html", domain, [params objectForKey:@"phone"]];
    }
    //http://www.butaschool.com/Appapi/getMainInfo/checkcode/abcdefg.html
    else if([api isEqualToString:@"GetHomeInfo"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/getMainInfo/checkcode/%@.html", domain, [params objectForKey:@"checkcode"]];
    }
    //http://www.butaschool.com/Appapi/getNoticeList/checkcode/abcdefg/pageno/2.html
    else if([api isEqualToString:@"getNoticeList"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/getNoticeList/checkcode/%@/maxnid/%@.html", domain, [params objectForKey:@"checkcode"], [params objectForKey:@"maxnid"]];
    }
    //http://www.butaschool.com/Appapi/getHomeworkByClass/checkcode/13000000004/date/2016-07-28/myclassid/1.html
    else if([api isEqualToString:@"getHomeworkByClass"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/getHomeworkByClass/checkcode/%@/date/%@/myclassid/%@.html", domain, [params objectForKey:@"checkcode"], [params objectForKey:@"date"], [params objectForKey:@"classid"]];
    }
    //http://www.butaschool.com/Appapi/getCourseList/checkcode/1233456.html
    else if([api isEqualToString:@"getCourseList"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/getCourseList/checkcode/%@.html", domain, [params objectForKey:@"checkcode"]];
    }
    //http://www.butaschool.com/Appapi/getExamByClass/checkcode/abcdefg/myclassid/1.html
    else if([api isEqualToString:@"getExamByClass"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/getExamByClass/checkcode/%@/myclassid/%@.html", domain, [params objectForKey:@"checkcode"], [params objectForKey:@"classid"]];
    }
    //http://www.butaschool.com/Appapi/getCourseTable/checkcode/abcdefg/date/2016-07-06/myclassid/1.html
    else if([api isEqualToString:@"getCourseTable"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/getCourseTable/checkcode/%@/date/%@/myclassid/%@.html", domain, [params objectForKey:@"checkcode"], [params objectForKey:@"date"], [params objectForKey:@"classid"]];
    }
    //http://www.butaschool.com/Appapi/getQAList/checkcode/abcdefg/pageno/2.html
    else if([api isEqualToString:@"getQAList"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/getQAList/checkcode/%@/pageno/%@.html", domain, [params objectForKey:@"checkcode"], [params objectForKey:@"pageno"]];
    }
    //http://www.butaschool.com/Appapi/getRecipe/checkcode/abcdefg/date/2016-07-05.html
    else if([api isEqualToString:@"getRecipe"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/getRecipe/checkcode/%@/date/%@.html", domain, [params objectForKey:@"checkcode"], [params objectForKey:@"date"]];
    }
    //http://www.butaschool.com/Appapi/getAttendance/checkcode/C94BD013BEE08D483C2BF8581C6CA9/date/2016-08-14.html
    else if([api isEqualToString:@"getAttendance"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/getAttendance/checkcode/%@/date/%@.html", domain, [params objectForKey:@"checkcode"], [params objectForKey:@"date"]];
    }
    else if([api isEqualToString:@"getAbsentList"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/getAbsentList/classid/%@/checkcode/%@/date/%@.html", domain, [params objectForKey:@"classid"], [params objectForKey:@"checkcode"], [params objectForKey:@"date"]];
    }
    //http://www.butaschool.com/Appapi/getScoreByExamAndClass/checkcode/4AD3FEBB33BE2ECE5A3DA41BFA2F06/examid/10/classid/9.html
    else if([api isEqualToString:@"getScoreByExamAndClass"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/getScoreByExamAndClass/checkcode/%@/examid/%@/classid/%@.html", domain, [params objectForKey:@"checkcode"], [params objectForKey:@"examid"], [params objectForKey:@"classid"]];
    }
    //http://www.butaschool.com/Appapi/getScoreByExamAndStudent/checkcode/abcdefg/examid/2/myid/12.html
    else if([api isEqualToString:@"getScoreByExamAndStudent"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/getScoreByExamAndStudent/checkcode/%@/examid/%@/myid/%@.html", domain, [params objectForKey:@"checkcode"], [params objectForKey:@"examid"], [params objectForKey:@"uid"]];
    }
    else if([api isEqualToString:@"getBindStudent"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/getBindStudent/checkcode/%@.html", domain, [params objectForKey:@"checkcode"]];
    }
    else if([api isEqualToString:@"switchBindStudent"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/switchBindStudent/checkcode/%@/id/%@.html", domain, [params objectForKey:@"checkcode"], [params objectForKey:@"id"]];
    }
//    NSLog(@"getUrl is %@",url);
    [self getJsonFrom:url success:blockSuccess failed:blockFailed];
}

- (void)getJsonFrom:(NSString *)url success:(void(^)(NSDictionary *))blockSuccess failed:(void(^)())blockFailed
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // Get请求
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        // 这里可以获取到目前的数据请求的进度
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         //NSLog(@"%@", responseObject);
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
         NSLog(@"%@", dict);
         
         if(dict != nil)
         {
             blockSuccess(dict);
         }
         else
         {
             blockFailed();
         }
     }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"%@", [error localizedDescription]);
         blockFailed();
     }];
}

- (void)SubmitTo:(NSString *)api andParams:(NSDictionary *)params success:(void(^)(NSDictionary *))blockSuccess failed:(void(^)())blockFailed
{
    //登陆URL
    NSString *domain = [HSAppData getDomain];
    //调试Url
//    NSString * domain = @"http://192.168.5.107";
    NSString *url = domain;
    //http://www.butaschool.com/Appapi/postNotice/checkcode/1233456/type/1/pto/0/title/test/content/test/rdate/2016-07-19.html
    if([api isEqualToString:@"postNotice"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/postNotice.html", domain];
    }
    //http://www.butaschool.com/Appapi/SendRegSms/phone/13684887266.html
    else if([api isEqualToString:@"SendRegSms"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/SendRegSms/phone/%@.html", domain, [params objectForKey:@"phone"]];
    }
    
//    checkcode：用户识别code
//classid:班级id
//courseid: 课程id
//content: 公告内容
//    
    //http://www.butaschool.com/Appapi/postHomework/checkcode/1233456/classid/1/courseid/3/title/test/content/test/dotime/2016-07-19.html
    else if([api isEqualToString:@"postHomework"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/postHomework.html", domain];
    }
    //    checkcode：用户识别code
    //fromtime:请假开始时间  格式：2016-07-19 09:00
    //totime:请假结束时间  格式：2016-07-20 09:00
    //content: 咨询内容
    //
    //http://www.butaschool.com/Appapi/postAskleave.html
    else if([api isEqualToString:@"postAskleave"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/postAskleave.html", domain];
    }
    else if([api isEqualToString:@"doForget"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/doForget.html", domain];
    }
    else if([api isEqualToString:@"getActionByClass"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/getActionByClass.html", domain];
    }
    else if([api isEqualToString:@"getActionByClass2"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/getActionByClass2.html", domain];
    }
    else if([api isEqualToString:@"getStudentAction"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/getStudentAction.html", domain];
    }
    else if([api isEqualToString:@"getActionByStudent"])
    {
        url = [NSString stringWithFormat:@"%@/Appapi/getActionByStudent.html", domain];
    }else if([api isEqualToString:@"postOpinionForm"])
    {
        url = [NSString stringWithFormat:@"%@/appapi/%@.html", domain, api];
    }
    else
    {
        url = [NSString stringWithFormat:@"%@/Appapi/%@.html", domain, api];
    }

    [self PostTo:url andParams:params success:blockSuccess failed:blockFailed];
}

- (void)PostTo:(NSString *)url andParams:(NSDictionary *)params success:(void(^)(NSDictionary *))blockSuccess failed:(void(^)())blockFailed
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject :%@", responseObject);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        if(dict != nil)
        {
            blockSuccess(dict);
        }
        else
        {
            blockFailed();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"mainerror %@", [error localizedDescription]);
        blockFailed();
    }];
}

-(UIImage *)buildImage:(UIImage*)image forSize:(CGFloat)size
{
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    
    if(w <= size && h <= size) return image;
    
    CGFloat nw, nh;
    if(w > h)
    {
        nw = size;
        nh = h / w * size;
    }
    else
    {
        nh = size;
        nw = w / h * size;
    }
    
    CGSize newSize = CGSizeMake(nw, nh);
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(NSString *)image2File:(UIImage *)image ofType:(NSNumber *)type
{
    UIImage *newImage = image; //[self buildImage:image forSize:960.0];
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取document路径,括号中属性为当前应用程序独享
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    //定义记录文件全名以及路径的字符串filePath
    NSString *imagePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"temp%@_%@.jpg", type, [NSNumber numberWithInt:arc4random()]]];
    //查找文件，如果不存在，就创建一个文件
    if(![fileManager fileExistsAtPath:imagePath])
    {
        [fileManager createFileAtPath:imagePath contents:nil attributes:nil];
    }
    [UIImageJPEGRepresentation(newImage, 1.0) writeToFile:imagePath atomically:YES];
    return imagePath;
}

/*
- (void)postImageToSever
{
    //获取地址
    NSString *path = @"http://10.0.178.12/iOS_PHP/upload.php"; //下载管理类的对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager]; //默认传输的数据类型是二进制
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //第三个参数：进行上传数据的保存操作
    
    [manager POST:path parameters:nil constructingBodyWithBlock:^(idformData) {
        
        //找到要上传的图片
        
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"menu_bg_01-hd.jpg" ofType:nil];
        
 
         
         第一个参数：将要上传的数据的原始路径
         
         第二个参数：要上传的路径的key
         
         第三个参数：上传后文件的别名
         
         第四个参数：原始图片的格式
 
 
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:imagePath] name:@"file" fileName:@"2345.png" mimeType:@"image.jpg" error:nil];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",str);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error.description);
        
    }];
    
}*/


- (void)uploadFile:(UIImage *)image withUUID:(NSString *)uploadUUID andType:(int)type andP:(id)p start:(void(^)(NSDictionary *dict))blockStart progress:(void(^)(NSDictionary *dict))blockProgress finish:(void(^)(NSDictionary *dict))blockFinish error:(void(^)(NSDictionary *dict))blockError
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    [manager setUserInfo:@{@"image": image, @"uploadUUID":uploadUUID, @"type": NN(type), @"p": p}];
     NSString *url = @"http://www.butaschool.com/index.php?s=/Home/Appupload/upload";
//    NSString *url = @"http://192.168.5.107/index.php?s=/Home/Appupload/upload&XDEBUG_SESSION_START=18158";
    
    UIImage *newImage = [HSCoreData buildLogo:image];
    NSString *filePath = [self image2File:newImage ofType:NN(type)];
    NSDictionary *params = @{@"Filename" : filePath, @"type": NN(type), @"p": p};
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         NSData *imageData = UIImageJPEGRepresentation(newImage, 1);
         //上传的参数(上传图片，以文件流的格式)
         [formData appendPartWithFileData:imageData
                                     name:@"Filename"
                                 fileName:filePath
                                 mimeType:@"image/jpeg"];
         // 主线程执行：
         dispatch_async(dispatch_get_main_queue(), ^{
             blockStart(@{@"userInfo": manager.userInfo});
         });
     } progress:^(NSProgress * _Nonnull uploadProgress) {
         //打印下上传进度
         NSLog(@"flag - %@ 总大小：%lld,当前大小:%lld", [manager.userInfo objectForKey:@"uploadUUID"], uploadProgress.totalUnitCount, uploadProgress.completedUnitCount);
         // 主线程执行：
         dispatch_async(dispatch_get_main_queue(), ^{
             blockProgress(@{@"userInfo": manager.userInfo, @"progress": uploadProgress});
         });
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         //上传成功
         NSLog(@"上传成功flag - %@ ", [manager.userInfo objectForKey:@"uploadUUID"]);
         NSDictionary *dict = (NSDictionary *)responseObject;
         
         if(dict != nil)
         {
             // 主线程执行：
             dispatch_async(dispatch_get_main_queue(), ^{
                 blockFinish(@{@"userInfo": manager.userInfo, @"response": dict});
             });
         }
         else
         {
             // 主线程执行：
             dispatch_async(dispatch_get_main_queue(), ^{
                 blockError(@{@"userInfo": manager.userInfo});
             });
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         //上传失败
         NSLog(@"上传失败flag - %@ ", [manager.userInfo objectForKey:@"uploadUUID"]);
         // 主线程执行：
         dispatch_async(dispatch_get_main_queue(), ^{
             blockError(@{@"userInfo": manager.userInfo});
         });
     }];
}
/*
- (void)uploadFile:(UIImage *)image withUUID:(NSString *)uploadUUID andType:(int)type andP:(id)p
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    [manager setUserInfo:@{@"image": image, @"uploadUUID":uploadUUID, @"type": NN(type), @"p": p}];
    NSString *url = @"http://www.butaschool.com/index.php?s=/Home/Appupload/upload";
    
    UIImage *newImage = [HSCoreData buildLogo:image];
    NSString *filePath = [self image2File:newImage ofType:NN(type)];
    NSDictionary *params = @{@"Filename" : filePath, @"type": NN(type), @"p": p};
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         NSData *imageData = UIImageJPEGRepresentation(newImage, 1);
         //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"Filename"
                                fileName:filePath
                                mimeType:@"image/jpeg"];
         // 主线程执行：
         dispatch_async(dispatch_get_main_queue(), ^{
             PostMessage(msgUploadImageStart, (@{@"userInfo": manager.userInfo}));
         });
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
        NSLog(@"flag - %@ 总大小：%lld,当前大小:%lld", [manager.userInfo objectForKey:@"uploadUUID"], uploadProgress.totalUnitCount, uploadProgress.completedUnitCount);
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            PostMessage(msgUploadImageProgress, (@{@"userInfo": manager.userInfo, @"progress": uploadProgress}));
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //上传成功
        NSLog(@"上传成功flag - %@ ", [manager.userInfo objectForKey:@"uploadUUID"]);
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        if(dict != nil)
        {
            // 主线程执行：
            dispatch_async(dispatch_get_main_queue(), ^{
                PostMessage(msgUploadImageFinish, (@{@"userInfo": manager.userInfo, @"response": dict}));
            });
        }
        else
        {
            // 主线程执行：
            dispatch_async(dispatch_get_main_queue(), ^{
                PostMessage(msgUploadImageError, (@{@"userInfo": manager.userInfo}));
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //上传失败
        NSLog(@"上传失败flag - %@ ", [manager.userInfo objectForKey:@"uploadUUID"]);
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            PostMessage(msgUploadImageFailed, (@{@"userInfo": manager.userInfo, @"reason": error}));
        });
    }];
}*/

+(void)removeLogoFor:(id)who
{
    if(who == nil)
    {
        [EGOImageView removeCacheForURL:[NSURL URLWithString:[MasterURL urlOfUserLogo:_Master.mySelf.DDNumber]]];
        [EGOImageView removeCacheForURL:[NSURL URLWithString:[MasterURL urlOfUserHDLogo:_Master.mySelf.DDNumber]]];
    }
    else
    {
        if([who isKindOfClass:[NSString class]])
        {
            [EGOImageView removeCacheForURL:[NSURL URLWithString:[MasterURL urlOfUserLogo:who]]];
            [EGOImageView removeCacheForURL:[NSURL URLWithString:[MasterURL urlOfUserHDLogo:who]]];
        }
    }
}

- (void)getServerInfo
{
    [self getJsonFrom:MAIN_ENTRY success:^(NSDictionary * dict) {
        NSLog(@"dic is %@",dict);
        NSString *domain = [dict objectForKey:@"domain"];
//        NSString *ip = @"192.168.5.108";
        NSString *ip = [dict objectForKey:@"ip"];
        NSNumber *port = [dict objectForKey:@"port"];
        NSNumber *size = [dict objectForKey:@"chatImageSize"];
        
        [HSAppData setDomain:domain];
        [HSAppData setLoginServerIP:ip];
        [HSAppData setLoginServerPort:port.intValue];
        [HSAppData setChatImageSize:size.intValue];
    } failed:^{
        NSLog(@"faile.d");
    }];
}

-(void)startSocketTimer
{
    m_bTimerDone = NO;
    m_waitingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}

- (IBAction)onTimer:(id)sender
{
    if(m_pZipBatchData != NULL)
    {
        m_bSlientMsg = NO;
        m_bSingleChatMsg = NO;
        char *cp = m_pZipBatchData;
        cp2NewInt(nCount);
        while(nCount)
        {
            cp2NewChar(cKey);
            cp2NewWORD(wLen);
            if(!m_bSlientMsg)
            {
                [_Master makeASound:emSoundRecvMsg];
                m_bSlientMsg = YES;
            }
            [self processCommand:cp ofLen:wLen];
            cp += wLen - 3;
            nCount--;
            NSLog(@"process msg %d", nCount);
        }
        [_HSCore constructBadge];
        
        m_bSlientMsg = NO;
        m_bSingleChatMsg = YES;
        PostMessage(hsNotificationNewMsg, nil);
        delete []m_pZipBatchData;
        m_pZipBatchData = NULL;
    }
    //if(self.bNetwokOKing == NO) return;
    if([glState mainState] >= emStateHasLogin)
    {
        NSTimeInterval timeSince = [glState.lastActiveTime timeIntervalSinceNow];
        timeSince *= -1;
//        NSLog(@"PING CHECK %f", timeSince);
        if(timeSince > 25 && timeSince < 27)
        {
            NSLog(@"25s timeout, disconn.");
            [self disconnectIMServer];
        }
        else if(timeSince >= 8)
        {
            [self socket_Ping];
        }
    }
}

-(void)disconnectIMServer
{
//    [glState setMainState:emStateHasLogin];
    [tcpMaster disconnect];
}

// on "dealloc" you need to release all your retained objects
-(void) dealloc
{
}

-(void)makeASound:(enum EMSOUNDTYPE)type
{
    if(self.bPlaySound == NO) return;
    
    NSString *path = nil;
    switch (type)
    {
        case emSoundSendMsg:
            path = [NSString stringWithFormat: @"%@/%@", [[NSBundle mainBundle] resourcePath], @"sendmsg.caf"];
            break;
        case emSoundRecvMsg:
            path = [NSString stringWithFormat: @"%@/%@", [[NSBundle mainBundle] resourcePath], @"MSG.WAV"];
            break;
            
        default:
            break;
    }
    
    NSURL* filePath = [NSURL fileURLWithPath: path isDirectory: NO];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

+(char *)createBuffer:(int)length
{
    char *pBuffer = NULL;
    pBuffer = (char *)malloc(length + 1);
    memset(pBuffer, 0x00, length + 1);
    return pBuffer;
}

-(BOOL)isChattingUser:(NSString *)userID
{
    if(currentChatUser == nil) return NO;
    if([currentChatUser.DDNumber isEqualToString:userID]) return YES;
    return NO;
}

+(BOOL)isP2PChat:(int)iChatID
{
	return (iChatID == 0);
}

+(BOOL)isPublicGroup:(int)iChatID
{
    if(iChatID < 0 && iChatID > -9999) return YES;
	return (iChatID >= 100 && iChatID < 200);
}

+(BOOL)isHyperLink:(int)iChatID
{
	return (iChatID >= 200 && iChatID < 1000);
}

+(BOOL)isSysNotify:(int)iChatID
{
    // details for it in item config table
	return (iChatID >= 1000 && iChatID < 1200);
}

+(BOOL)isConfigItem:(int)iChatID
{
	return (iChatID >= 1200 && iChatID < 1400);
}

+(BOOL)isGroup:(int)iChatID
{
	return (iChatID >= 10000);
}

-(void)changeChatTarget:(HSUserObject *)aUser
{
    if(aUser != nil)
    {
        if(aUser.specialChatID == nil)
        {
            aUser.specialChatID = [NSNumber numberWithInt:0];
        }
    }
    [self setCurrentChatUser:aUser];
}

-(void)lookUpBadge
{
    if(self.currentChatUser == nil) return;
    // do some badge things
    if([self.currentChatUser.specialChatID intValue] == 0) // p2p
    {
        [_HSCore signMessageReadByUserID:self.currentChatUser.DDNumber];
    }
    else
    {
        [_HSCore signMessageReadByChatID:self.currentChatUser.specialChatID];
    }
    [_HSCore constructBadge];
}

-(void)back2Login
{
    [glState setMainState:emStateNone];
    [glState setDestServer:IM];
    [glState setIsFirstTimeLoginIMServer:YES];
    [_HSCore clearData];
    [HSAppData clearUserInfo];
    m_nTick = 0;
    
    if([glState withLoginView])
    {
        NSLog(@"with login view, back to it!");
        PostMessage(msgBack2Login, nil);
    }
    else
    {
        NSLog(@"no login view, load it!");
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        ViewControllerLogin *vcLogin = [app.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLogin"];
        app.window.rootViewController = vcLogin;
    }
}

#pragma mark ------------- Socket Delegate -------------
-(void)needLoginIMFirst
{
    NSLog(@"need login IM first.");
    [self reqLoginIM];
}

-(void)socket:(HSSocket *)socket didReceiveCommand:(char *)pData ofLength:(unsigned long)length
{
    [self processCommand:pData ofLen:length];
}

#pragma mark ----------------网络数据处理--------------

-(void)resZipBatchMsg:(char *)pData ofLen:(DWORD)dwSize
{
    char *cp = pData;
    cp2NewInt(nLen);
    
    if(m_pZipBatchData != NULL)
    {
        delete []m_pZipBatchData;
        m_pZipBatchData = NULL;
    }
    m_pZipBatchData = new char[MAX_BUFF_SIZE];
    long n = MAX_BUFF_SIZE;
    uncompress((unsigned char *)m_pZipBatchData, (unsigned long *)&n, (unsigned char *)pData + sizeof(int), dwSize - sizeof(int));
    
    [tcpMaster SendCommand:NETMSG_REQRESBATCHCHATMSG with:nil];
}

-(void)processCommand:(char *)pData ofLen:(DWORD)dwSize
{
    char *cp = pData;
    cp2NewWORD(wCommand);
    
    if(wCommand == NETMSG_RESLOGINIM || wCommand == NETMSG_RESLOGINLOGIN)
    {
    }
    else
    {
        [glState setLastActiveTime:[NSDate date]];
    }
//    NSLog(@"wcommand is %d",wCommand);
    switch (wCommand)
    {
        case NETMSG_RESCLEARBADGENUMBER:
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            break;
        case NETMSG_RESPUSHDETAIL:
            cp2NewChar(cPushDetail);
            [glState setPushDetail:(BOOL)(cPushDetail != 0x00)];
            break;
        case NETMSG_RESLOGINOUT:
            NSLog(@"********login out res.");
            PostMessage(hsNotificationLogoutRes, nil);
            break;
            break;
        case NETMSG_RESDELETEFRIEND:
            [self resDeleteFriend:pData];
            break;
        case NETMSG_RESFORABSENT:
            [self resForAbsent:pData];
            break;
        case NETMSG_ZIPBATCHMSG:
            [self resZipBatchMsg:pData + WMSG_SIZE ofLen:dwSize - WMSG_SIZE];
            break;
        case NETMSG_NOTIFYMSG:
            [self notifyMsg:pData];
            break;
        case NETMSG_RESUPDATEUSERTEXT:
            [self resUpdateUserText:pData];
            break;
        case NETMSG_RESUSERDATA:
            [self resUserData:pData];
            break;
        case NETMSG_S2C_FRIENDLIST:
            [self rcvFriendList:pData];
            break;
        case NETMSG_RESADDFRIEND:
            PostMessage(hsNotificationAddFriendRet, nil);
            break;
        case NETMSG_RESCHATSEND:
            [self resChatSend:pData];
            break;
        case NETMSG_CHATMSG:
            [self resChatMsg:pData];
            break;
        case NETMSG_S2C_PUBLICGROUP:
            [self resPublicGroup:pData];
            break;
        case NETMSG_DROPCLIENT:
            NSLog(@"be dropped from server.");
            //[self closeSocket];
            break;
        case NETMSG_RESLOGINIM:
            [self resLoginIM:pData];
            break;
        case NETMSG_RESLOGINLOGIN:
            [self resLoginLogin:pData];
            break;
        case NETMSG_RESBROADCASTNOTIFY:
            PostMessage(hsNotificationUnread, nil);
            break;
        case NETMSG_RENOTIFY:
            NSLog(@"推送刷新1");
            break;
            
        default:
            break;
    }
}

-(void)resDeleteFriend:(char *)pData
{
    cpNew;
    cp2NewString(userID, LEN_ACCOUNT);
    if([_HSCore removeFriend:[NSString stringWithFormat:@"%s", userID]])
    {
        [_HSCore reloadFriendList:[NSNumber numberWithInt:0]];
        PostMessage(hsNotificationReloadFList, [NSNumber numberWithInt:0]);
    }
    [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"删除成功." description:@"" type:TWMessageBarMessageTypeSuccess];
}

-(void)resForAbsent:(char *)pData
{
    cpNew;
    cp2NewInt(dRet);
    PostMessage(hsAbsentResponse, [NSNumber numberWithInt:dRet]);
}

-(void)notifyMsg:(char *)pData
{
    cpNew;
    cp2NewInt(iNotify);
    switch (iNotify)
    {
        case 1:
            PostMessage(hsNotificationAppInitOK, nil);
            break;
        case 2:
            m_bSlientMsg = YES;
            break;
        case 3:
            [_Master makeASound:emSoundRecvMsg];
            m_bSlientMsg = NO;
            break;
        case 4: // change im server
        {
            cp2NewString(szNewIP, 256);
            cp2NewInt(iNewPort);
            [HSAppData setIMServerIP:[NSString stringWithFormat:@"%s", szNewIP]];
            [HSAppData setIMServerPort:iNewPort];
            [self getSelfData];
            break;
        }
        case 5:
        {
            PostMessage(hsNotificationLogoutRes, nil);
            break;
        }
        default:
            break;
    }
}

-(void)getSelfData
{
    [self reqUserData:[HSAppData getAccount] ofType:0 oldFlag:0 ofChatID:0];
}

-(void)resUpdateUserText:(char *)pData
{
    cpNew;
    cp2NewInt(iDataFlag);
    PostMessage(hsNotificationUserUpdateOK, nil);
    [self getSelfData];
}

-(void)userDataReceived:(char)reqType ofUser:(HSUserObject *)aUser ofChatID:(NSNumber *)chatID
{
    // 0: get my profile,
    // 1: search friend,
    // 2: view identify get detail,
    // 3: get group user,
    // 4: get user in friendlist
    switch (reqType)
    {
        case 0:
            NSLog(@"recved my data. (%@) type:%@", aUser.DDNumber, aUser.userType);
            [self setMySelf:aUser];
            [_HSCore pushNewAccount:aUser];
            PostMessage(hsNotificationSelfDataReceived, aUser);
            break;
        case 1:
        case 2:
            if([aUser.userType intValue] == -1)
            {
                PostMessage(hsNotificationSearchFriendRet, nil);
                return;
            }
            else PostMessage(hsNotificationSearchFriendRet, aUser);
            break;
        case 3:
            if([aUser.userType intValue] == -2)
            {
                // no change of the user
                break;
            }
            [_HSCore updateUserFullData:aUser ofChatID:chatID];
            [_HSCore reloadFriendList:chatID];
            PostMessage(hsNotificationUpdateGListUser, aUser);
            PostMessage(hsNotificationUserReceived, aUser);
            break;
        case 4:
            if([aUser.userType intValue] == -2)
            {
                // no change of the user
                break;
            }
            [_HSCore updateUserFullData:aUser ofChatID:chatID];
            [_HSCore reloadFriendList:chatID];
            PostMessage(hsNotificationUpdateFListUser, aUser);
            PostMessage(hsNotificationUserReceived, aUser);
            break;
            
        default:
            break;
    }
}

-(void)resUserData:(char *)pData
{
    cpNew;
    cp2NewChar(reqType);
    cp2NewInt(iChatID);
    NSNumber *chatID = [NSNumber numberWithInt:iChatID];
    HSUserObject *aUser = [HSUserObject userFromCP:cp];
    NSLog(@"recv user %@ - %@", aUser.DDNumber, aUser.realName);
    [self userDataReceived:reqType ofUser:aUser ofChatID:chatID];
}

-(void)rcvFriendList:(char *)pData
{
    cpNew;
    cp2NewInt(iChatID);
    cp2NewString(szGroupFlag, LEN_ACCOUNT);
    [_HSCore pushFriendListIntoDB:pData];
    PostMessage(hsNotificationReloadFList, [_HSCore getChatIDForPublicGroup:[NSNumber numberWithInt:iChatID] andFlag:[NSString stringWithCString:szGroupFlag encoding:NSASCIIStringEncoding]]);
}

-(void)resChatMsg:(char *)pData
{
    cpNew;
    cp2NewInt(timeFlag);
    cp2NewInt(theChatID);
    cp2NewChar(chatType);
    cp2NewString(szFrom, LEN_ACCOUNT);
    cp2NewString(szTo, LEN_ACCOUNT);
    cp2NewString(szDate, LEN_DATE);
    cp2NewString(szMsg, MAX_CHAT_SIZE);
    cp2NewString(szGroupFlag, LEN_ACCOUNT);
    if(m_bSingleChatMsg) [self reqResChatMsg:timeFlag andChatID:theChatID andFlag:szGroupFlag];
    NSLog(@"[NSString stringWithFormat is %@",[NSString stringWithFormat:@"%s", szFrom]);
    if([[HSAppData getAccount] isEqualToString:[NSString stringWithCString:szFrom encoding:En2CHN]]) return;
    
    NSNumber *chatID = [_HSCore getChatIDForPublicGroup:[NSNumber numberWithInt:theChatID] andFlag:[NSString stringWithCString:szGroupFlag encoding:NSASCIIStringEncoding]];
    int iChatID = [chatID intValue];
    if(strlen(szGroupFlag) > 0 && iChatID == theChatID && [Master isPublicGroup:theChatID])
    {
        return;
    }
    if(m_bSlientMsg == NO)
    {
        BOOL bPrompt = YES;
        if([Master isGroup:iChatID] == YES || [Master isPublicGroup:iChatID] == YES)
        {
            if([_HSCore isPromptMsgOfChatID:[NSNumber numberWithInt:iChatID]] == NO)
            {
                bPrompt = NO;
            }
        }
        if(bPrompt == YES) [_Master makeASound:emSoundRecvMsg];
    }
    
    HSMessageObject *aMessage = [[HSMessageObject alloc] init];
    [aMessage setMessageState:[NSNumber numberWithInt:kWCMessageTextSuccess]];
    [aMessage setMessageChatID:[NSNumber numberWithInt:iChatID]];
    [aMessage setMessageType:[NSNumber numberWithInt:chatType]];
    [aMessage setMessageFrom:[NSString stringWithCString:szFrom encoding:En2CHN]];
    [aMessage setMessageTo:[NSString stringWithCString:szTo encoding:En2CHN]];
    [aMessage setMessageDate:[HSCoreData dateFromString:[NSString stringWithCString:szDate encoding:NSASCIIStringEncoding]]];
    [aMessage setMessageContent:[NSString stringWithCString:szMsg encoding:En2CHN]];
    [aMessage setMessageTimeFlag:[NSNumber numberWithInt:arc4random()]];
    [_HSCore saveMessage2DB:aMessage ofRead:NO isReloadIM:m_bSingleChatMsg];
    NSLog(@"New msg recv: %@", aMessage.messageContent);
    
    if([Master isSysNotify:iChatID]) return;
    
    int msgType = [aMessage.messageType intValue];
    switch (msgType)
    {
        case kWCMessageTypeP2PAuthration:
            break;
        case kWCMessageTypeP2PAuthrationOK:
            [_HSCore addNewFriendIntoDB:[HSUserObject userWithDDNumber:aMessage.messageFrom andDataFlag:[NSNumber numberWithInt:0]] ofChatID:aMessage.messageChatID isFullData:NO isReload:YES];
            PostMessage(hsNotificationReloadFList, [NSNumber numberWithInt:0]);
            break;
        case kWCMessageTypeP2PAuthrationReject:
            break;
        case kWCMessageTypeP2PDelete:
            break;
        default:
            break;
    }
}

-(void)resChatSend:(char *)pData
{
    cpNew;
    cp2NewInt(timeFlag);
    [_HSCore signMessageState:timeFlag ofState:kWCMessageTextSuccess];
    [_HSCore removeUnSendMsg:[NSNumber numberWithInt:timeFlag]];
    [_Master makeASound:emSoundSendMsg];
}

-(void)resPublicGroup:(char *)pData
{
    [_HSCore pushGroupListIntoDB:pData];
}

#pragma mark ----------------网络数据请求--------------

-(void)reqLogin:(NSString *)account andPassword:(NSString *)password
{
    [glState setDestServer:LOGIN];
    [_HSCore pushNewAccount:[HSUserObject userWithDDNumber:account andDataFlag:NN(0)]];
    [_HSCore dumpAccount];
    [glState setIsFirstTimeLoginIMServer:YES];
    [HSAppData setAccount:account];
    [tcpMaster SendCommand:NETMSG_REQLOGINLOGIN with:NT(1), NT(iOS1), account, password, nil];
}

-(void)reqLoginIM
{
    NSLog(@"Try to long into IM server with checkcode:%@", [HSAppData getCheckCode]);
    [tcpMaster removeCommandFromList:NETMSG_REQLOGINIM];
    NSLog(@"Try to long into IM server with checkcode2:%@", [HSAppData getCheckCode]);
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *stringWithoutQuotation = [version
                                        stringByReplacingOccurrencesOfString:@"." withString:@""];
//    float vf = [version floatValue];
  int iVersion =  [stringWithoutQuotation intValue];
    NSLog(@"iVersionValue is %zi",iVersion);
    [tcpMaster SendCommand:NETMSG_REQLOGINIM with:NT(glState.isFirstTimeLoginIMServer), NT(iOS1), NW(iVersion), [HSAppData getCheckCode], nil];
}

//-(int)getversionBy:(char *)szString
//{
//        char cVersion[16];
//    //    ZeroMemory(cVersion, sizeof(cVersion));
//        for(int x = 0; x < (int)strlen(szString); x++)
//        {
//            if(szString[x] >= '0' && szString[x] <= '9')
//            {
//                cVersion[strlen(cVersion)] = szString[x];
//            }
//        }
//        return atoi(cVersion);
//
//}

//int getVersion(char *szString)
//{
//    char cVersion[16];
////    ZeroMemory(cVersion, sizeof(cVersion));
//    for(int x = 0; x < (int)strlen(szString); x++)
//    {
//        if(szString[x] >= '0' && szString[x] <= '9')
//        {
//            cVersion[strlen(cVersion)] = szString[x];
//        }
//    }
//    return atoi(cVersion);
//}
-(BOOL)reqUserData:(NSString *)userID ofType:(int)reqType oldFlag:(int)flag ofChatID:(int)chatID
{
    if(userID == nil) return NO;
    if([userID length] == 0) return NO;
    NSLog(@"req user:%@ data ofType: %d of chatID: %d oldFlag: %d", userID, reqType, chatID, flag);
    if([userID isEqualToString:self.mySelf.DDNumber])
    {
        if(reqType != 0)
        {
            NSLog(@"req self data not use reqType = 0, denied.");
            return NO;
        }
    }
    
    [tcpMaster SendCommand:NETMSG_REQUSERDATA with:NT(reqType), NN(flag), NN(chatID), userID, nil];
    return YES;
}

#pragma mark ------------------------------

#pragma mark ----------------网络数据回应--------------

-(void)resLoginLogin:(char *)pData
{
    cpNew;
    cp2NewInt(iRet);
    NSLog(@"login response. %d", iRet);
    
    if(iRet == D_OK)
    {
        cp2NewNSString(sCheckCode, LEN_NORMAL);
        cp2NewNSString(sIMServerIP, LEN_NORMAL);
        cp2NewInt(iIMPort);
        cp2NewInt(classID);
        [HSAppData setIMServerIP:sIMServerIP];
        [HSAppData setIMServerPort:iIMPort];
        [HSAppData setCheckCode:sCheckCode];
        [HSAppData setClassid:classID];
        [tcpMaster disconnect];
        [self reloadOffline];
        [glState setDestServer:IM];
        [glState setMainState:emStateHasLogin];
        [self reqLoginIM];
    }
    else
    {
        [tcpMaster clearPackageQueue];
    }
    PostMessage(msgLoginStatus, NN(iRet));
}

-(void)resLoginIM:(char *)pData
{
    cpNew;
    cp2NewInt(iRet);
    NSLog(@"iret is %d",iRet);
    switch (iRet)
    {
        case D_VERSIONUPDATE:
            [self setBNeedForce2Update:YES];
            break;
        case D_OK:
        case D_VERSIONCANUSE:
        {
            NSLog(@"req Login OK.==================");
            cp2NewInt(iDataFlag);
            cp2NewInt(iUserType);
            cp2NewString(szUserID, LEN_ACCOUNT);
            cp2NewChar(cPushDetail);
            
            [self setMySelf:[_HSCore userForAccount:[NSString stringWithFormat:@"%s", szUserID]]];
            [self.mySelf setUserType:NN(iUserType)];
            [glState setPushDetail:(BOOL)(cPushDetail != 0)];
            [glState setMainState:emStateHasEnterIM];
            
            if(glState.isFirstTimeLoginIMServer == YES)
            {
                [glState setIsFirstTimeLoginIMServer:NO];
                if(self.mySelf == nil || (iDataFlag != 0 && [self.mySelf.dataFlag intValue] != iDataFlag))
                {
                    [self getSelfData];
                }
                else
                {
                    PostMessage(hsNotificationSelfDataReceived, self.mySelf);
                }
                PostMessage(hsNotificationNewURL, nil);
                [self reqUploadDeviceToken];
            }
            if([UIApplication sharedApplication].applicationIconBadgeNumber != 0)
            {
                [self reqResetBadgeOnServer];
                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            }
            if(iRet == D_VERSIONCANUSE)
            {
                [Master messageBox:@"当前版本还可以继续使用.\n但建议您更新至最新版本以获得更好的使用体验." withTitle:@"发现程序新版本." withOkText:@"确定"];
            }
            return;
            break;
        }
        default:
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"登录凭证已过期." description:@"请重新输入您的帐号密码进行登录." type:TWMessageBarMessageTypeInfo];
            break;
    }
    [self back2Login];
    
    PostMessage(msgLoginIMStatus, NN(iRet));
}

#pragma mark ------------------------------

-(void)reqSendChatMsg:(HSMessageObject *)msg
{
    if(msg == nil) return;
    NSLog(@"socketmsgfrom is %@ socketmsgto is %@",msg.messageFrom,msg.messageTo);
    [tcpMaster SendCommand:NETMSG_CHATMSG with:msg.messageTimeFlag, [_HSCore chatIDForChatID:msg.messageChatID], NT(msg.messageType.intValue), msg.messageTo, msg.messageContent, [_HSCore flagForChatID:msg.messageChatID], nil];
}

-(BOOL)reqAddFriend:(NSString *)userID ofMsg:(NSString *)msg
{
    if(userID == nil) return NO;
    [tcpMaster SendCommand:NETMSG_REQADDFRIEND with:userID, msg, nil];
    return YES;
}

-(void)reqReplyAddFriend:(BOOL)bAgree ofUser:(NSString *)account
{
    [tcpMaster SendCommand:NETMSG_REPLYADDFRIEND with:account, NT((bAgree ? 1 : 0)), nil];
    if(bAgree == NO) return;
    [_HSCore addNewFriendIntoDB:[HSUserObject userWithDDNumber:account andDataFlag:[NSNumber numberWithInt:0]] ofChatID:[NSNumber numberWithInt:0] isFullData:NO isReload:YES];
    PostMessage(hsNotificationReloadFList, [NSNumber numberWithInt:0]);
}

-(void)reqUpdateUserText:(NSString *)newStr ofType:(int)type
{
    if(newStr == nil) return;
    NSLog(@"req update user TEXT:%@ ofType:%d", newStr, type);
    [tcpMaster SendCommand:NETMSG_REQUPDATEUSERTEXT with:NT(type), NN(arc4random()), newStr, nil];
}

-(void)reqGroupUserList:(NSNumber *)groupID
{
    if(groupID == nil) return;
    NSLog(@"req group list:%d", [groupID intValue]);
    [tcpMaster SendCommand:NETMSG_REQGROUPUSERLIST with:[_HSCore chatIDForChatID:groupID], [_HSCore flagForChatID:groupID], nil];
}

-(void)reqUploadDeviceToken
{
    if(glState.deviceToken == nil) return;
    if([glState mainState] != emStateHasEnterIM) return;
    
    NSLog(@"Token: upload device token string to server.");
    [tcpMaster SendCommand:NETMSG_REQSENDDEVICETOKEN with:glState.deviceToken, nil];
}

-(void)reqResetBadgeOnServer
{
    m_nTick = 0;
    
    NSLog(@"req RESET badge number.==================");
    [tcpMaster SendCommand:NETMSG_REQCLEARBADGENUMBER with:nil];
}

-(void)reqLoginOut
{
    [tcpMaster SendCommand:NETMSG_REQLOGINOUT with:nil];
}

-(void)reqFriendList
{
    [tcpMaster SendCommand:NETMSG_REQFRIENDLIST with:nil];
}

-(BOOL)reqAbsentFrom:(NSDate *)sDate toDate:(NSDate *)eDate ofMsg:(NSString *)absentMsg
{
    [tcpMaster SendCommand: NETMSG_REQFORABSENT with: [HSCoreData stringByDate:sDate withYear:YES], [HSCoreData stringByDate:eDate withYear:YES], absentMsg, nil];
    return YES;
}

-(void)reqDeleteFriend:(NSString *)userID
{
    [tcpMaster SendCommand:NETMSG_REQDELETEFRIEND with:userID, nil];
}

-(void)socket_Ping
{
    NSLog(@"ping server....");
    
    [tcpMaster removeCommandFromList:NETMSG_REQPING];
    [tcpMaster SendCommand:NETMSG_REQPING with:nil];
}

-(void)reqResChatMsg:(int)timeFlag andChatID:(int)chatID andFlag:(char *)szGroupFlag
{
    [tcpMaster SendCommand:NETMSG_REQRESCHATMSG with:NN(timeFlag), NN(chatID), [NSString stringWithFormat:@"%s", szGroupFlag], nil];
}

-(void)reloadOffline
{
    [self setMySelf:[_HSCore userForAccount:[HSAppData getAccount]]];
    [_HSCore reloadFriendList:[NSNumber numberWithInt:0]];
    [_HSCore reloadGroup];
}

-(void)reqSwitPushDetail:(BOOL)isOn
{
    [tcpMaster SendCommand:NETMSG_REQPUSHDETAIL with:NT((isOn ? 1 : 0)), nil];
}

@end
