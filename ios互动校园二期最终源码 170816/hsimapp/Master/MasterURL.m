//
//  MasterURL.m
//  dyhAutoApp
//
//  Created by apple on 15/6/6.
//  Copyright (c) 2015年 dayihua. All rights reserved.
//

#import "MasterURL.h"

@implementation MasterURL

+ (NSString *)mainURL
{
    return @"http://www.bwxkj.com/entry.html";
}

+ (NSString *)urlOfUserLogo:(NSString *)account
{
    return [NSString stringWithFormat:@"%@/uploads/headpic/%@_s.jpg", [HSAppData getDomain], account];
}

+ (NSString *)urlOfUserHDLogo:(NSString *)account
{
    return [NSString stringWithFormat:@"%@/uploads/headpic/%@.jpg", [HSAppData getDomain], account];
}

+ (NSString *)urlOfGroupLogo:(NSNumber *)groupID
{
    return [NSString stringWithFormat:@"%@/uploads/grouplogo/%@_s.jpg", [HSAppData getDomain], groupID];
}

+ (NSString *)urlOfGroupHDLogo:(NSNumber *)groupID
{
    return [NSString stringWithFormat:@"%@/uploads/grouplogo/%@.jpg", [HSAppData getDomain], groupID];
}

+ (NSString *)urlOfItem:(NSInteger)index
{
    return @"";
}

+ (NSString *)APIFor:(NSString *)type with:(id)p, ...
{
    NSMutableArray *argsArray = [[NSMutableArray alloc] init];
    va_list params;
    va_start(params, p);
    if(p)
    {
        id arg;
        id prev = p;
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
    
    if ([type isEqualToString:@"fileUpload"])
    {
        return [NSString stringWithFormat:@"%@/index.php?s=/Home/Appupload/upload", [HSAppData getDomain]];
    }
    else if ([type isEqualToString:@"chatHDImage"])
    {
        NSString *old = [argsArray objectAtIndex:0];
        if(old == nil)
        {
            return nil;
        }
        NSRange range = NSMakeRange(old.length - 4, 4);
        NSString *ext = [old substringWithRange:range];
        if([ext isEqualToString:@".jpg"] || [ext isEqualToString:@".JPG"])
        {
            NSString *newString = [old stringByReplacingOccurrencesOfString:@"_s.jpg" withString:@".jpg"];
            return [NSString stringWithFormat:@"%@/%@", [HSAppData getDomain], newString];
        }
        return nil;
    }
    else if ([type isEqualToString:@"notice"])
    {
        return [NSString stringWithFormat:@"%@/Notice/view/checkcode/%@/id/%@.html", [HSAppData getDomain], [HSAppData getCheckCode], p];
    }
    
    
    
    
    
    else if ([type isEqualToString:@"aboutUS"])
    {
        return [NSString stringWithFormat:@"%@/index.php?m=Home&c=Appapi&a=Articledetail&id=4", [HSAppData getDomain]];
    }
    else if ([type isEqualToString:@"help"])
    {
        return [NSString stringWithFormat:@"%@/help.html", [HSAppData getDomain]];
    }
    else if ([type isEqualToString:@"chatImage"])
    {
        return [NSString stringWithFormat:@"%@/%@", [HSAppData getDomain], [argsArray objectAtIndex:0]];
    }
    else if([type isEqualToString:@"zoneList"])
    {
        return [NSString stringWithFormat:@"%@/index.php?m=Home&c=Appapi&a=zone&sid=12", [HSAppData getDomain]];
    }
    else if([type isEqualToString:@"maderList"])
    {
        return [NSString stringWithFormat:@"%@/index.php?m=Home&c=Appapi&a=carMader&sid=12&id=0", [HSAppData getDomain]];
    }
    else if([type isEqualToString:@"seriesList"])
    {
        return [NSString stringWithFormat:@"%@/index.php?m=Home&c=Appapi&a=carSeries&sid=12&id=%@", [HSAppData getDomain], [argsArray objectAtIndex:0]];
    }
    else if([type isEqualToString:@"homepage"])
    {
        return [NSString stringWithFormat:@"%@/index.php?s=/Home/Index/index/stype/13.html", [HSAppData getDomain]];
    }
    else if([type isEqualToString:@"keepList"])
    {
        return [NSString stringWithFormat:@"%@/index.php?m=Home&c=Appapi&a=getuserkeep&account=%@", [HSAppData getDomain], p];
    }
    else if([type isEqualToString:@"baoyangjilu"])
    {
        return [NSString stringWithFormat:@"%@/index.php?s=/Home/Account/appkeepinfo/id/%@.html", [HSAppData getDomain], p];
    }
    else if([type isEqualToString:@"woyaotiyanweb"])
    {
        return [NSString stringWithFormat:@"%@/index.php?s=/Home/Feedback/wantty/stype/13.html", [HSAppData getDomain]];
    }
    else if([type isEqualToString:@"yewudaiban"])
    {
        return [NSString stringWithFormat:@"%@/index.php?s=/Home/Article/lists/category/Businessagent/stype/13.html", [HSAppData getDomain]];
    }
    else if([type isEqualToString:@"register"])
    {
        return [NSString stringWithFormat:@"%@/index.php?s=/Home/Account/register/stype/13.html", [HSAppData getDomain]];
    }
    else if([type isEqualToString:@"iforget"])
    {
        return [NSString stringWithFormat:@"%@/index.php?s=/Home/Account/forgetpsw/stype/13.html", [HSAppData getDomain]];
    }
    else if([type isEqualToString:@"adImageList"])
    {
        return [NSString stringWithFormat:@"%@/index.php?m=Home&c=Appapi&a=indexfoucs&sid=12&id=", [HSAppData getDomain]];
    }
    else if([type isEqualToString:@"xcdt"])
    {
        return [NSString stringWithFormat:@"%@/index.php?m=Home&c=Appapi&a=Article&catid=43&p=%@", [HSAppData getDomain], p];
    }
    else if([type isEqualToString:@"gczn"])
    {
        return [NSString stringWithFormat:@"%@/index.php?m=Home&c=Appapi&a=Article&catid=39&p=%@", [HSAppData getDomain], p];
    }
    else if([type isEqualToString:@"ycjq"])
    {
        return [NSString stringWithFormat:@"%@/index.php?m=Home&c=Appapi&a=Article&catid=2&p=%@", [HSAppData getDomain], p];
    }
    else if([type isEqualToString:@"yccs"])
    {
        return [NSString stringWithFormat:@"%@/index.php?m=Home&c=Appapi&a=Article&catid=1&p=%@", [HSAppData getDomain], p];
    }
    else if([type isEqualToString:@"article"])
    {
        return [NSString stringWithFormat:@"%@/index.php?s=/Home/Article/detail/id/%@/stype/13.html", [HSAppData getDomain], p];
    }
    else if([type isEqualToString:@"provinceList"])
    {
        return [NSString stringWithFormat:@"%@/index.php?m=Home&c=Appapi&a=getProvince", [HSAppData getDomain]];
    }
    else if([type isEqualToString:@"cityList"])
    {
        return [NSString stringWithFormat:@"%@/index.php?m=Home&c=Appapi&a=getCity&pid=%@", [HSAppData getDomain], p];
    }
    else if([type isEqualToString:@"districtList"])
    {
        return [NSString stringWithFormat:@"%@/index.php?m=Home&c=Appapi&a=getDistrict&cid=%@", [HSAppData getDomain], p];
    }
    else if([type isEqualToString:@"regCode"])
    {
        return [NSString stringWithFormat:@"%@/index.php?m=Home&c=Account&a=getregsmscode&account=%@", [HSAppData getDomain], p];
    }
    else if([type isEqualToString:@"forgetCode"])
    {
        return [NSString stringWithFormat:@"%@/index.php?m=Home&c=Account&a=getforgetsmscode&account=%@", [HSAppData getDomain], p];
    }
    else if([type isEqualToString:@"doregister"])
    {
        return [NSString stringWithFormat:@"%@/index.php?m=Home&c=Account&a=doregister&account=%@&password=%@&verify=%@", [HSAppData getDomain], [p objectForKey:@"account"], [p objectForKey:@"password"], [p objectForKey:@"smscode"]];
    }
    else if([type isEqualToString:@"doforget"])
    {
        return [NSString stringWithFormat:@"%@/index.php?m=Home&c=Account&a=doforget&account=%@&password=%@&verify=%@", [HSAppData getDomain], [p objectForKey:@"account"], [p objectForKey:@"password"], [p objectForKey:@"smscode"]];
    }
    return @"";
}

+ (NSString *)bindCheckcode:(NSString *)url
{
    if(url.length <= 5) return url;
    
    return [NSString stringWithFormat:@"%@/checkcode/%@%@", [url substringToIndex:url.length - 5],
            [HSAppData getCheckCode],
            [url substringFromIndex:url.length - 5]];
}

@end
