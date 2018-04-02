//
//  HDServiceViewController.m
//  hsimapp
//
//  Created by dingding on 2018/2/1.
//  Copyright © 2018年 dayihua .inc. All rights reserved.
//

#import "HDServiceViewController.h"
#import "FuncTionCell.h"
#import "ServiceModel.h"
#import "UIImageView+WebCache.h"
#import "HDWebViewController.h"
#import "AlertUtil.h"
#import "KeyCenter.h"
#import <AgoraSignalKit/AgoraSignalKit.h>
#import "DialViewController.h"
@interface HDServiceViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
     UICollectionView *_mainView;
    NSMutableArray * _dataArr;
    AgoraAPI *signalEngine;
}

@end

@implementation HDServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"辅助应用";
    self.view.backgroundColor = [UIColor whiteColor];
    [self getData];
   
    // Do any additional setup after loading the view.
}

-(void)getData
{
    
    _dataArr = [NSMutableArray array];
    NSMutableDictionary * postdic = [NSMutableDictionary dictionary];
    [postdic setObject:@"2" forKey:@"extra_id"];
    [postdic setObject:[HSAppData getCheckCode] forKey:@"checkcode"];
    [_Master SubmitTo:@"getExtraFunctionInfo" andParams:postdic success:^(NSDictionary * postdic ) {
        NSLog(@"dict is %@",postdic);
        NSArray * listarr = postdic[@"lists"];
        for (NSDictionary * adic in listarr) {
            ServiceModel * model = [ServiceModel mj_objectWithKeyValues:adic];
            [_dataArr addObject:model];
        }
        [self addCollectionVie];

    } failed:^{
        
    }];

    
}

-(void)addCollectionVie{
    
    // 1.创建UICollectionViewFlowLayout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    // 1.1设置每个Item的大小
    CGSize size = [UIScreen mainScreen].bounds.size;
    flowLayout.itemSize = CGSizeMake(size.width/3-1,  96);
    
    //    // 1.2 设置每列最小间距
    flowLayout.minimumInteritemSpacing = 1;
    //
    //    // 1.3设置每行最小间距
    flowLayout.minimumLineSpacing = 1;
    //    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    // 1.4设置滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 1.5设置header区域大小
    flowLayout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 30);
    
    // 1.6设置footer区域大小
    //    flowLayout.footerReferenceSize = CGSizeMake(self.view.bounds.size.width, 0);
    
    // 2.创建UICollectionView
    _mainView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-74) collectionViewLayout:flowLayout];
    // 3.设置数据源代理、collection代理
    _mainView.dataSource = self;
    _mainView.delegate = self;
    _mainView.showsVerticalScrollIndicator = FALSE;
    _mainView.showsHorizontalScrollIndicator = FALSE;
    
    
    [self.view addSubview:_mainView];
    
    _mainView.backgroundColor = RGBColor(241, 245, 250);
    
    // 4.注册cell的类型和重用标示符
    [_mainView registerNib:[UINib nibWithNibName:@"FuncTionCell" bundle:nil] forCellWithReuseIdentifier:@"FuncCellOnly"];
    // 5.注册footer和header类型的重用标识符
    [_mainView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    NSArray *arr = _dataArr[section];
    ServiceModel * model = _dataArr[section];
    NSArray * childarr = model.child;
    return childarr.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.去重用队列中查找
    FuncTionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FuncCellOnly" forIndexPath:indexPath];
    ServiceModel * model = _dataArr[indexPath.section];
    NSArray * childarr = model.child;
    NSDictionary * dic = childarr[indexPath.row];
//    ServiceModel * model = arr[indexPath.row];
    NSString * UrlString  = [NSString stringWithFormat:@"%@%@",[HSAppData getDomain],dic[@"info_img"]];
    [cell.ImageView   sd_setImageWithURL:[NSURL URLWithString:UrlString]];
    cell.TitleLabel.text = dic[@"info_name"];
        cell.ImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return cell;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
    reusableView.backgroundColor = RGBColor(241, 245, 250);
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, ScreenWidth, 25)];
    headerLabel.backgroundColor = RGBColor(241, 245, 250);
    headerLabel.textColor = [UIColor lightGrayColor];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    ServiceModel * model  = _dataArr[indexPath.section];
//    if (indexPath.section==0) {
        headerLabel.text = model.info_name;
//    }else if (indexPath.section==1){
//        headerLabel.text = @"  第三方服务";
//    }
    headerLabel.font = [UIFont systemFontOfSize:14];
    [reusableView addSubview:headerLabel];
    
    //    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, KScreenWidth, 1)];
    //    backView.backgroundColor = kTCColor(154, 154, 154);
    //    [reusableView addSubview:backView];
    
    return reusableView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"");
    ServiceModel * model = _dataArr[indexPath.section];
    NSArray * childarr = model.child;
    NSDictionary * dic = childarr[indexPath.row];
    NSString * urlstring  = dic[@"info_url"];
    if (urlstring.length == 0) {
        NSLog(@"无url 连接 不做跳转");
        if ([dic[@"info_name"] isEqualToString:@"视频通话"]) {
             signalEngine = [AgoraAPI getInstanceWithoutMedia:[KeyCenter appId]];
            [signalEngine login:[KeyCenter appId]
                        account:@"3"
                          token:[KeyCenter generateSignalToken:@"3" expiredTime:3600]
                            uid:0
                       deviceID:nil];
            __weak typeof(self) weakSelf = self;
            signalEngine.onLoginSuccess = ^(uint32_t uid, int fd) {
                NSLog(@"Login successfully, uid: %u", uid);
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf performSegueWithIdentifier:@"ShowDialView" sender:@(uid)];
                    UIStoryboard * sb =
                    [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    DialViewController * lvc =
                    [sb instantiateViewControllerWithIdentifier:@"DialViewController"];
                    lvc.localUID = 0;
                    lvc.localAccount = @"3";
                    
                    [weakSelf.navigationController pushViewController:lvc animated:YES];
                });
            };
            
            signalEngine.onLoginFailed = ^(AgoraEcode ecode) {
                NSLog(@"Login failed, error: %lu", (unsigned long)ecode);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [AlertUtil showAlert:@"Login failed"];
                });
            };

        
//            DialViewController *dialVC = segue.destinationViewController;
//            [self performSegueWithIdentifier:@"ShowDialView" sender:@(uid)];
//            dialVC.localUID = [sender unsignedIntValue];
//            dialVC.localAccount = self.accountTextField.text;

        }else
        {
            [self showMessage:@"功能正在开发中，敬请期待"];
//            kAlert(@"功能正在开发中");
        }
    }else
    {
//        [self showSegueWithObject:@{@"title":@"123", @"url":urlstring,@"schooltitle": @"234"} Identifier:@"showAdWeb"];
        HDWebViewController * Web = [[HDWebViewController alloc]init];
        Web.UrlString = urlstring;
        [self.navigationController pushViewController:Web animated:YES];
    }
//    if (indexPath.section==0) {
//        NSLog(@"第一队列点击");
//    }else if (indexPath.section==2){
//        NSLog(@"第三队列点击");
//
//    }else if (indexPath.section==1){
//        NSLog(@"第二队列点击");
//    }
    
}


@end
