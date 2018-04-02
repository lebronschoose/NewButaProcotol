//
//  HDWebViewController.m
//  hsimapp
//
//  Created by dingding on 2018/3/10.
//  Copyright © 2018年 dayihua .inc. All rights reserved.
//

#import "HDWebViewController.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "RSADataSigner.h"

@interface HDWebViewController ()<UIWebViewDelegate>
{
    UIWebView * WebView;
}

@end

@implementation HDWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    WebView.delegate = self;
    WebView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:WebView];
    WebView.scrollView.bounces = NO;
    WebView.scrollView.showsHorizontalScrollIndicator = NO;
    WebView.scrollView.showsVerticalScrollIndicator = NO;
    [WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.UrlString]]];
    self.tabBarController.tabBar.hidden = YES;
    // Do any additional setup after loading the view.
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url=[NSString stringWithFormat:@"%@",request.URL];
    NSLog(@"Url is %@",url);
    
    if ([url rangeOfString:@"appWeChatPay"].location != NSNotFound)
    {
        NSLog(@"调起支付渠道");
        NSArray * arr = [url componentsSeparatedByString:@"@"];
        NSString * a1;NSString * a2;NSString * a3;NSString * a4;NSString * a5;NSString * a6;NSString * a7;
        a1 = arr[0]; // 固定头
        a2 = arr[1]; // 使用urldecode后为本次支付的标题，提交给微信支付或支付宝支付的一个参数，会显示在微信或支付宝支付里面
        a3 = arr[2]; // 本次支付的金额，单位是分 5000
        a4 = arr[3]; // 本次支付的订单号，a7接口中需要提供这个订单号2017050989181
        a5 = arr[4]; // 本次支付的类别，     wx - 代表微信支付，   alipay - 代表支付宝支付
        a6 = arr[5]; //  用来提交给微信支付的notfiy_url参数
        a7 = arr[6]; // 支付完成后，用来查询支付结果的后台接口，需要参数orderid.所以调用方式为  http://www.butaschool.com/mall/mobile/querywxpay.php?orderid=2017050989181
        //支付结果延时性，暂时这样不去取结果，直接使用微信支付宝的回调结果
        if (a5 && [a5 isEqualToString:@"alipay"]) {
            [self doAlipayPay:[NSString stringWithFormat:@"%.f", [a3 floatValue] / 100] :a4];
        }else if (a5 && [a5 isEqualToString:@"wx"])
        {
            [MXWechatPayHandler jumpToWxPayBy:a3 ByCode:a4 ByNotifyUrl:a6];
        }
        return NO;
    }
    
    return YES;
}


#pragma mark -
#pragma mark   ==============点击订单模拟支付行为==============
//
//选中商品调用支付宝极简支付
//
- (void)doAlipayPay:(NSString *)amountstring :(NSString *)codeNumebr;
{
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"2017050207087695";
    
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = @"MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDIV5rfMdHUW7XIfnQmBsjAszFeNgt3Gtyo1d6TfunLNU3iQpYR99MDHghWcW8Iakz2XwcKYQkMRbPdgKnqKEhhSrOq+gKm2RJb8Xscwe43EcYgD3iiQJaZb+Gc2NkaSZuE9tZrAlQALtLVoW/p/O3pK7r46CIMzGkv2NU6ySE7Mf2vhg+DlPrBFJ+YpHaGX7Eau83PzKkCoHP8xWUTXMG0Zf9h93PjCU0dKH4uZ8fzOBSiQZvBORXineyrwcvxp5Ux525T/ScS3em28mg/+QikGMbXZmvPeHrvEYzp9+CdoBFTH0lw4gw4LI+54JgNRVUHLzxpTdNfHugUkq/BYMoxAgMBAAECggEALOAyuLwYHFFOrtJkggATB9cbv9arSsqhktAVQ0SyaepOv9fadbvlcFVR2Msf6+qjwqwWj6ScujsCxyMC7IiJbgGlrS7DWUxWaHH2+cIW8g7xKk1M4EtHcKc3CkMonlLOm0IPVXj4B/J1F5VJ1EfrosdA4nBc8DD5ftY7LSfQYcmzYnTaSqHfK2ZEG+GAPHwp/RYYYRVusewwTrYaYe9ogzQ4+589emITpl0kvDPux+Hpce2cCjNpifgdftjzqI3wo95TJ4DnFnIL6zjYSmQat5IkbjOSC0R8F2spv2FZXtpbv2tgTcP0vVd44c+8Ar/D0ndc0cTpxXy4TXSwwGDQYQKBgQDo4LfWZ0JsmIIo9x4EM0iyCDALHVl4HesGapfIF0dhgki24RC9tYBR4r9qBCkv73UkLFRJVaq4FcW77brfiiXA7bf4MSKrSEtsDh+tUAlPl2zy+sfmGR3tZqr362SG/gHZEHxk6uUriBoWvT61q2yDSvYDgdgMrU3/xqS9JSw4pwKBgQDcO+XbXoRUK4vqPzZvkcrZzTVPDtfrtTmk591gTCF4bMPskccpzY9u37cmatNmAPWO4GOpVn/uhGkCuORrwBFdF/qaubtlwpm0QV0P+0yvxxxXjYRuBBYQmozJi5DTaWxemCvBoEfj37YCPel9nO7i/tqB/MZZ1dX35DvTRYrpZwKBgQDj7nbhCmZQRiE3mU+uysc/QZZMeqiEUbwkppXyyR4biVpEbRtmo0x6WVYCnRn3Cgf8pMrGkGutC9piqzd57gwvvjyPVwBY50Sy+Uv15V2Hom2HkP+w7iqFnzR9vc7B9cG3RFSMrgAqUGdAlG/ZfnSSOP97xU3CcqniS/oYC1cyBwKBgQDTaNBCn92Jau/5okqgGSTPpRR6WrZc9u9p5IX2zb4Heuksq9eywjfg5/JJd5yMu3j9eVtSD83o6cRgL5pd8Nb6NW2En6xLh93CUkiCcepwhkMnrJqmfVetAp8JTedtejLkL1E5oqHAFl0Ck+oSgdYzow+gXkUNsZ6fQsFHEufBGwKBgE1XGDrmuC9shLN/oAE3liTTbUU2jOyKvU6vQIv5NFxM58+W3laDQfqY5Ongsnsejfz35P5zJIC6/ZRb21ui7V9fautMPun6ybC+Nm/m8MJ1MdfqRoJTwsM+Qe4esC9/ekewa1lJGG9iN69KhLLsPhf5gL2iRwm1yp6u0z/+4gMl";
    NSString *rsaPrivateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = @"我是测试数据";
    order.biz_content.subject = codeNumebr;
    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", [amountstring floatValue]]; //商品价格
    //    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01];
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"hsimapp";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}


-(void)viewWillDisappear:(BOOL)animated
{
    StopWaiting;
}

-(IBAction)waitingEnd:(id)sender
{
    if([self.waitingTag isEqualToString:@"waitingloadweb"])
    {
        StopWaiting;
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad ok is %@.", webView.request.URL);
    
    StopWaiting;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"response code2: %@", response.description);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    NSLog(@"response code3: %@", error.description);
}


@end
