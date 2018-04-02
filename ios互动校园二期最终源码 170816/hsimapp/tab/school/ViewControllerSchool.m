//
//  ViewControllerSchool.m
//  hsimapp
//
//  Created by apple on 16/6/26.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerSchool.h"
#import "CellArticle.h"
#import "FMDBHelper.h"
@interface ViewControllerSchool ()<HSImageScrollViewDelegate, HSGridViewDelegate>
{
    NSArray *adImages;
    NSArray *gridTitles;
    NSArray *arrayIcon;
    NSArray *listRecent;
    NSString * titleString;
    BOOL firstShow;
    FMDBHelper *dbHelper;
//    NSMutableArray *_dataArray;
    NSArray * unreadArr;
    NSArray * showArr;
}
@end

@implementation ViewControllerSchool

#pragma mark --- json request ---
- (void)reqHomeInfo
{
    [self runAPI:@"GetHomeInfo" andParams:@{@"checkcode": [HSAppData getCheckCode]} success:^(NSDictionary * dict) {
        NSLog(@"GetHomeInfodict is %@",dict);
        
        if ([NSString isBlankString:[dict objectForKey:@"title"]]) {
            self.navigationItem.title = @"互动校园";
            titleString = @"互动校园";
        }else
        {
            self.navigationItem.title = [dict objectForKey:@"title"];
            titleString = [dict objectForKey:@"title"];
        }
        if ([[dict objectForKey:@"help"] isKindOfClass:[NSDictionary class]]) {
            [HSAppData setHelpDic:[dict objectForKey:@"help"]];
            NSLog(@"name is %@",[[dict objectForKey:@"help"] objectForKey:@"name"]);
        }
        adImages = [dict objectForKey:@"indexfoucs"];
        [_HSData putObject:adImages withId:@"indexfoucs"];
        [self reloadImageScrollView];
        listRecent = [dict objectForKey:@"recentlist"];
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = [HSAppData getschname];
//    self.scrollView.backgroundColor = [UIColor redColor];
    if([_Master isTeacher])
    {
        gridTitles = @[@"学校公告", @"家庭作业", @"行为记录", @"考试成绩", @"学生课程", @"学校咨询", @"学生考勤"];
        arrayIcon = @[@"icon_gonggao", @"icon_zuoye", @"icon_xingweijilu", @"icon_chengji", @"icon_kecheng", @"icon_zixun", @"icon_kaoqin"];
    }
    else
    {
        gridTitles = @[@"学校公告", @"家庭作业", @"行为记录", @"考试成绩", @"学生课程", @"学校咨询", @"★请假★"];
        arrayIcon = @[@"icon_gonggao", @"icon_zuoye", @"icon_xingweijilu", @"icon_chengji", @"icon_kecheng", @"icon_zixun", @"icon_qingjia"];
    }
    
    firstShow = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //解决tableView分割线左边不到边的情况
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    // 不显示多余的分割线
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    listRecent = @[];
    adImages = [_HSData getObjectById:@"indexfoucs"];
    CareMsg(msgTest);
    CareMsg(msgBack2Login);
    CareMsg(hsNotificationMsgBadge);
    CareMsg(hsNotificationSelfDataReceived);
    CareMsg(hsNotificationUnread);
    
    [self SetTabBadge];

}

- (void)viewDidAppear:(BOOL)animated
{
    if(firstShow == NO) return;
    firstShow = NO;
    /// adjust sub views
    {
        CGRect rt = self.hsImageScrollView.frame;
        rt = self.scrollView.frame;
        NSArray* constrains = self.hsImageScrollView.constraints;
        for (NSLayoutConstraint* constraint in constrains)
        {
            if (constraint.firstAttribute == NSLayoutAttributeHeight)
            {
                // 调整hsImageScrollView的高度，否则width不是320到时候会变形
                constraint.constant = self.hsImageScrollView.frame.size.height * [[UIScreen mainScreen] bounds].size.width / 320.0;
                CGRect frame = self.hsImageScrollView.frame;
                frame.size.height = constraint.constant;
                [self.hsImageScrollView setFrame:frame];
//                [self.hsImageScrollView setNeedsDisplay];
                break;
            }
        }
        [self reloadImageScrollView];
        
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        ////
        [self reloadGridView];
    }
    
    //    adImages = [[JsonObject jsonForAPI:@"getMainInfo"] objectForKey:@"indexfoucs"];
    //    listRecent = [[JsonObject jsonForAPI:@"getMainInfo"] objectForKey:@"recentlist"];
    [self reloadImageScrollView];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    showArr = [NSArray array];
    [self reqHomeInfo];
     [self reqUnreadInfo];

}


-(void)reqUnreadInfo
{
    NSLog(@"[HSAppData getCheckCode] is %@",[HSAppData getCheckCode]);
    [_Master SubmitTo:@"getCornerNum" andParams:@{@"checkcode" : [HSAppData getCheckCode]} success:^(NSDictionary * dict) {
        NSLog(@"getCornerNumsdict is %@",dict);
        unreadArr = dict[@"count"];
        dbHelper = [FMDBHelper getInstance:dbFullPath];
        [self CreatTableUnread];
        NSArray * dateArr = [dbHelper queryFromTable:Unread_TABLE_NAME items:@[Unread_User_ID,UNread_School,UNread_HomeWork,UNread_Action,UNread_Score,UNread_Table,UNread_Query,UNread_Abend,Unread_checkCode] where:[NSString stringWithFormat:@"where %@ = '%@';",Unread_checkCode,[HSAppData getCheckCode]]];
        if (dateArr.count>1) {
            NSLog(@"不允许存在两条插入数据,防止崩溃");
            return;
        }
        ZUser *user = dateArr.firstObject;
        if (user.TheCheckCode.length == 0) {
            [self InitInsertFB];
        }else
        {
            NSArray * arr = [self ChangeWithZuser:user];
            showArr = [self FromSelectedArr:unreadArr ByOtherArr:arr];
        }
        for(int i = 0; i < 7; i++)
        {
            if(i >= showArr.count)
            {
                [self.hsGridView setBadgeCount:0 forItem:i];
                continue;
            }
            [self.hsGridView setBadgeCount:[[showArr objectAtIndex:i] intValue] forItem:i];
        }
    } failed:^{
        
        
    }];
}

-(NSArray *)FromSelectedArr:(NSArray *)array1 ByOtherArr:(NSArray *)arr2
{
    NSMutableArray * returnArr = [NSMutableArray array];
    for (int i = 0; i<array1.count; i++) {
        NSNumber * num =  array1[i];
        NSNumber * num2 = arr2[i];
        NSLog(@"num is %@ num2 is %@",num,num2);
        NSNumber * num3 = [num integerValue]>[num2 integerValue]?[NSNumber numberWithInteger:[num integerValue] - [num2 integerValue]]:[NSNumber numberWithInteger:[num2 integerValue] - [num integerValue]];
        [returnArr addObject:num3];
    }
    return [returnArr copy];
}

-(void)CreatTableUnread
{
    if ([dbHelper createTable:Unread_TABLE_NAME items:@[Unread_User_ID,UNread_School,UNread_HomeWork,UNread_Action,UNread_Score,UNread_Table,UNread_Query,UNread_Abend,Unread_checkCode] itemsAttr:@[TableItemAttrTypeIntegerAndPrimaryKey,TableItemAttrTypeInteger,TableItemAttrTypeInteger,TableItemAttrTypeInteger,TableItemAttrTypeInteger,TableItemAttrTypeInteger,TableItemAttrTypeInteger,TableItemAttrTypeInteger,TableItemAttrTypeText]]) {
        NSLog(@"建表成功");
    }else{
        NSLog(@"建表失败");
    }

}

-(void)reloadGridView
{
    CGFloat gridHeight = [self.hsGridView initWithCount:7 delegate:self autoHeight:YES];
    CGFloat imageHeight = self.hsImageScrollView.frame.size.height;
    CGFloat tableH = self.tableView.frame.size.height;
    CGFloat newHeight = imageHeight + 8 + gridHeight  + tableH +44 + 15;
    CGSize contentSize = self.scrollView.contentSize;
    if(contentSize.height != newHeight)
    {
        contentSize.height = newHeight;
        [self.scrollView setContentSize:contentSize];
    }
}

-(void)reloadImageScrollView
{
    [self.hsImageScrollView initWithCount:adImages.count delegate:self];
    self.hsImageScrollView.scrollInterval = 3.0f;
    
    // adjust pageControl position
    self.hsImageScrollView.pageControlPosition = ICPageControlPosition_BottomCenter;
    
    // hide pageControl or not
    self.hsImageScrollView.hidePageControl = NO;
    [self.hsImageScrollView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onNotifyMsg:(NSNotification *)notification
{
    NSString *msg = [NSString stringWithString:notification.name];
    if([msg isEqualToString:hsNotificationSelfDataReceived])
    {
        if([_Master isTeacher])
        {
            //隐藏学生食谱 icon_shipu
            gridTitles = @[@"学校公告", @"家庭作业", @"行为记录", @"考试成绩", @"学生课程", @"学校咨询",  @"学生考勤"];
            arrayIcon = @[@"icon_gonggao", @"icon_zuoye", @"icon_xingweijilu", @"icon_chengji", @"icon_kecheng", @"icon_zixun", @"icon_kaoqin"];
        }
        else
        {
            gridTitles = @[@"学校公告", @"家庭作业", @"行为记录", @"考试成绩", @"学生课程", @"学校咨询", @"★请假★"];
            arrayIcon = @[@"icon_gonggao", @"icon_zuoye", @"icon_xingweijilu", @"icon_chengji", @"icon_kecheng", @"icon_zixun", @"icon_qingjia"];
        }
        [self reloadGridView];
    }
    else if([msg isEqualToString:msgBack2Login])
    {
        NSLog(@"msgBack2Login arrival... %@", self);
        
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            NSLog(@"back 2 login view");
        }];
    }
    else if([msg isEqualToString:msgTest])
    {
        NSLog(@"msgTest arrival... %@", self);
    }
    else if([msg isEqualToString:hsNotificationMsgBadge])
    {
        NSLog(@"msgTest arrival... %@", self);
        [self SetTabBadge];
    } else if([msg isEqualToString:hsNotificationUnread])
    {
        [self reqUnreadInfo];
    }
    
}

- (void)SetTabBadge
{
    int nNotifyCount = [_HSCore badgeCountOfNotify];
    int nMessageCount = [_HSCore badgeCountOfChat];
    UIViewController *tController = [self.tabBarController.viewControllers objectAtIndex:2];
    //int     badgeValue = [tController.tabBarItem.badgeValue intValue];
    if(nNotifyCount + nMessageCount > 0)
    {
        tController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", nNotifyCount + nMessageCount];
    }
    else tController.tabBarItem.badgeValue = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - HSImageScrollViewDelegate
- (NSString *)hsImageScrollView:(HSImageScrollView *)hsImageScrollView imageForItemAtIndex:(NSInteger)index
{
    NSString *strImage = [[adImages objectAtIndex:index] objectForKey:@"image"];
    NSString *strURL = [NSString stringWithFormat:@"%@%@", [HSAppData getDomain], strImage];
    return  strURL;
}

- (void)hsImageScrollView:(HSImageScrollView *)hsImageScrollView didTapAtIndex:(NSInteger)index
{
    NSLog(@"did tap index = %d", (int)index);
    if(adImages != nil)
    {
        [self showSegueWithObject:@{@"title":[[adImages objectAtIndex:index] objectForKey:@"title"], @"url":[[adImages objectAtIndex:index] objectForKey:@"link"],@"schooltitle": titleString} Identifier:@"showAdWeb"];

//        [self showSegueWithObject:@{@"title":[[adImages objectAtIndex:index] objectForKey:@"title"], @"url":[NSString stringWithFormat:@"http://www.butaschool.com/Actives/index/checkcode/%@.html",[HSAppData getCheckCode]]} Identifier:@"showAdWeb"];
    }
}

#pragma mark - HSGridViewDelegate

-(NSInteger)numberOfColumnsOfHSGridView:(HSGridView *)hsGridView
{
    return 4;
}

-(UIEdgeInsets)edgeInsets:(HSGridView *)hsGridView
{
    return  UIEdgeInsetsMake(10, 20, 8, 20);
    return  UIEdgeInsetsMake(10, 32, 40, 32);
}

-(CGFloat)horizonalGap:(HSGridView *)hsGridView
{
    CGFloat w = self.view.frame.size.width / 320.0 * 42.0;
    return  w;
}

-(CGFloat)verticalGap:(HSGridView *)hsGridView
{
    return 36.0;
}

-(void)hsGridView:(HSGridView *)hsGridView loadTitleForItem:(UILabel *)labelTitle index:(NSInteger)index
{
    labelTitle.text = [gridTitles objectAtIndex:index];
}

-(void)hsGridView:(HSGridView *)hsGridView loadImageForItem:(UIImageView *)imageView index:(NSInteger)index
{
    imageView.image = [UIImage imageNamed:[arrayIcon objectAtIndex:index]];
}

- (void)onHideTip
{
    [super onHideTip];
    NSLog(@"sldkfj");
}

-(void)hsGridView:(HSGridView *)hsGridView didTapAtIndex:(NSInteger)index
{
    NSLog(@"did tap index = %d", (int)index);
    
//    [self showTipText:[gridTitles objectAtIndex:index] title:@"open" size:56 align:NSTextAlignmentCenter color:[UIColor blackColor]];
    
    self.tabBarController.tabBar.hidden = YES;
    switch (index)
    {
        case 0:
            [dbHelper updateDataToTable:Unread_TABLE_NAME items:@[UNread_School] values:@[unreadArr[0]] where:[NSString stringWithFormat:@"where %@ = '%@';",Unread_checkCode,[HSAppData getCheckCode]]];
            [self showSegueWithObject:nil Identifier:@"showNotice"];
            [_HSCore dumpFriend];
            break;
        case 1:
            [self showSegueWithObject:nil Identifier:@"showHomework"];
            [dbHelper updateDataToTable:Unread_TABLE_NAME items:@[UNread_HomeWork] values:@[unreadArr[1]] where:[NSString stringWithFormat:@"where %@ = '%@';",Unread_checkCode,[HSAppData getCheckCode]]];
            break;
        case 2:
            [self showSegueWithObject:nil Identifier:@"showAction"];
            [dbHelper updateDataToTable:Unread_TABLE_NAME items:@[UNread_Action] values:@[unreadArr[2]] where:[NSString stringWithFormat:@"where %@ = '%@';",Unread_checkCode,[HSAppData getCheckCode]]];
            break;
        case 3:
            if([_Master isTeacher])
            {
                [self showSegueWithObject:nil Identifier:@"showScoreTeacher"];
            }
            else
            {
                [self showSegueWithObject:nil Identifier:@"showScoreParent"];
            }
            [dbHelper updateDataToTable:Unread_TABLE_NAME items:@[UNread_Score] values:@[unreadArr[3]] where:[NSString stringWithFormat:@"where %@ = '%@';",Unread_checkCode,[HSAppData getCheckCode]]];
            break;
        case 4:
            [self showSegueWithObject:nil Identifier:@"showCourse"];
            [dbHelper updateDataToTable:Unread_TABLE_NAME items:@[UNread_Table] values:@[unreadArr[4]] where:[NSString stringWithFormat:@"where %@ = '%@';",Unread_checkCode,[HSAppData getCheckCode]]];
            break;
        case 5:
            [self showSegueWithObject:nil Identifier:@"showQA"];
//            [dbHelper updateDataToTable:Unread_TABLE_NAME items:@[UNread_Query] values:@[unreadArr[5]] where:[NSString stringWithFormat:@"where %@ = '%@';",Unread_checkCode,[HSAppData getCheckCode]]];
            break;
//        case 6:
//            [self showSegueWithObject:nil Identifier:@"showRecipe"];
//            break;
        case 6:
            if([_Master isTeacher])
            {
                [self showSegueWithObject:nil Identifier:@"showAttendance"];
                
            }
            else
            {
                [self showSegueWithObject:nil Identifier:@"showAbsent"];
            }
            [dbHelper updateDataToTable:Unread_TABLE_NAME items:@[UNread_Abend] values:@[unreadArr[6]] where:[NSString stringWithFormat:@"where %@ = '%@';",Unread_checkCode,[HSAppData getCheckCode]]];
            break;
            
        default:
            break;
    }
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listRecent.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"idCellArticle";
    CellArticle *cell = (CellArticle *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[CellArticle alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSDictionary *dict = [listRecent objectAtIndex:indexPath.row];
    [cell.imgIcon setImage:[UIImage imageNamed:[arrayIcon objectAtIndex:[[dict objectForKey:@"type"] intValue] - 1]]];
    [cell.labelTitle setText:[dict objectForKey:@"title"]];
    [cell.labelText setText:[dict objectForKey:@"desc"]];
    [cell.labelTime setText:[dict objectForKey:@"time"]];
    
    [cell.labelBadge setHidden:YES];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = [listRecent objectAtIndex:indexPath.row];
    NSNumber *type = [dict objectForKey:@"type"];
    if(type.intValue == 1)
    {
        [self showSegueWithObject:@{@"title": @"校园公告", @"url": [MasterURL APIFor:@"notice" with:[dict objectForKey:@"nid"], nil]} Identifier:@"showNoticeWeb"];
    }
    else if(type.intValue == 2) // 作业
    {
        self.tabBarController.tabBar.hidden = YES;
        [self showSegueWithObject:@{@"classid": NN(8), @"date": dict[@"date"]} Identifier:@"showHomework"];
    }
    else if(type.intValue == 6)
    {
        [self showSegueWithObject:nil Identifier:@"showQA"];
    }
}

- (IBAction)onRefresh:(id)sender
{
    [self reqHomeInfo];
}

-(void)InitInsertFB
{
    if ([NSString isBlankString:[HSAppData getCheckCode]]) {
        NSLog(@"checkcode is nil");
        return;
    }
    
    [dbHelper insertDataToTable:Unread_TABLE_NAME items:@[UNread_School,UNread_HomeWork,UNread_Action,UNread_Score,UNread_Table,UNread_Query,UNread_Abend,Unread_checkCode] values:@[[NSNumber numberWithInteger:0],[NSNumber numberWithInteger:0],[NSNumber numberWithInteger:0],[NSNumber numberWithInteger:0],[NSNumber numberWithInteger:0],[NSNumber numberWithInteger:0],[NSNumber numberWithInteger:0],[HSAppData getCheckCode]]];
    showArr = @[[NSNumber numberWithInteger:0],[NSNumber numberWithInteger:0],[NSNumber numberWithInteger:0],[NSNumber numberWithInteger:0],[NSNumber numberWithInteger:0],[NSNumber numberWithInteger:0],[NSNumber numberWithInteger:0]];
}

-(NSArray * )ChangeWithZuser:(ZUser *)user
{
    NSArray * arr = [NSArray array];
    arr =  @[[NSNumber numberWithInteger:user.SchoolUnread],[NSNumber numberWithInteger:user.HomeWorkUnread],[NSNumber numberWithInteger:user.ActionUnread],[NSNumber numberWithInteger:user.ScoreUnread],[NSNumber numberWithInteger:user.TableUnread],[NSNumber numberWithInteger:user.QueryUnread],[NSNumber numberWithInteger:user.AbendUnread]];
    return arr;
}


@end
