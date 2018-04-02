 
//
//  ViewControllerNotice.m
//  hsimapp
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerNotice.h"
#import "CellArticle.h"

@interface ViewControllerNotice ()<PullTableViewDelegate,CellArticleDelegate,UIAlertViewDelegate>
{
//    NSString * maxnid;
    NSString * maxnid;
    NSString * minnid;
    NSString * load;
    NSString * deletenid;

    NSMutableArray *noticeList;
}
@end

@implementation ViewControllerNotice

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    maxnid = @"0";
    minnid = @"0";
    load = @"0";
    noticeList = [[NSMutableArray alloc] init];
    
    [self.tableView setPullMode:0];
    [self.tableView EnableRefresh:YES];
    [self.tableView EnableLoadMore:YES];
    [self setExTril:self.tableView];
    
    [self.btNewNotice setHidden:!([_Master isClassMaster] || [_Master isSchoolMaster])];
    [self loadNoticeList];
    CareMsg(msgDataNeedRefresh);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)loadNoticeList
{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[HSAppData getCheckCode] forKey:@"checkcode"];
    [dic setValue:maxnid forKey:@"maxnid"];
    [dic setValue:minnid forKey:@"minnid"];
    [dic setValue:load forKey:@"load"];
    [_Master SubmitTo:@"getNoticeList" andParams:dic success:^(NSDictionary * dict) {
        NSLog(@"getNoticeListDic is %@",dict);
        if ([load isEqualToString:@"1"]) {
            NSLog(@"上拉");
            NSLog(@"PushListdict is %@",dict);
            NSMutableArray *array1 = [NSMutableArray array];
            NSArray *list = [dict objectForKey:@"noticelist"];
            for (NSDictionary * dic in list) {
                NSLog(@"getQAListdict is %@",dict);
//                QAModel * model = [QAModel mj_objectWithKeyValues:dic];
                [array1 addObject:dic];
            }
            [noticeList insertObjects:array1 atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [array1 count])]];
            NSDictionary * FirstModel = noticeList.firstObject;
            maxnid = FirstModel[@"nid"];
            
            
        }else if([load isEqualToString:@"2"])
        {
            NSLog(@"下拉");
            NSLog(@"PushListdict is %@",dict);
            NSNumber * more = dict[@"more"];
            if ([more integerValue]==0) {
                [self showMessage:@"没有更多数据了"];
                return;
            }
            NSArray *list = [dict objectForKey:@"noticelist"];
            [noticeList addObjectsFromArray:list];
            NSDictionary * lastDict = noticeList.lastObject;
            minnid = lastDict[@"nid"];
            
        }else
        {
            NSArray *list = [dict objectForKey:@"noticelist"];
            [noticeList addObjectsFromArray:list];
            NSDictionary * Lastmodel = noticeList.lastObject;
            NSDictionary * FirstModel = noticeList.firstObject;
            minnid = Lastmodel[@"nid"];
            maxnid = FirstModel[@"nid"];
        }
        [self.tableView reloadData];
  
        
    } failed:^{
        
    }];
}

- (void)onNotifyMsg:(NSNotification *)notification
{
    NSString *msg = [NSString stringWithString:notification.name];
    if([msg isEqualToString:msgDataNeedRefresh])
    {
        maxnid = @"0";
        noticeList = [[NSMutableArray alloc] init];

        [self loadNoticeList];
    }
}

#pragma mark - PullTableViewDelegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.5f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.5f];
}

- (void) refreshTable
{
    /*
     Code to actually refresh goes here.  刷新代码放在这
     */
    self.tableView.pullLastRefreshDate = [NSDate date];
    self.tableView.pullTableIsRefreshing = NO;
    if(self.tableView.pullRefreshEnabled == NO) return;
//    [noticeList removeAllObjects];
    load = @"1";
    [self loadNoticeList];
//
//        [self.tableView reloadData];
}

- (void) loadMoreDataToTable
{
    /*
     Code to actually load more data goes here.  加载更多实现代码放在在这
     */
    self.tableView.pullTableIsLoadingMore = NO;
    if(self.tableView.pullLoadMoreEnabled == NO) return;
    
    load = @"2";
    
    [self loadNoticeList];
    

    
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return noticeList.count;
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
    NSLog(@"======= %ld -  req cell ", indexPath.row);
    
    static NSString *cellId = @"idCellArticle";
    CellArticle *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.delegate = self;
    if (cell == nil)
    {
        cell = [[CellArticle alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if(indexPath.row % 2)
    {
        [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }
    
    NSDictionary *dict = [noticeList objectAtIndex:indexPath.row];
    cell.NowNid = dict[@"nid"];
    if ([dict[@"username"] isEqualToString:_Master.mySelf.DDNumber]) {
        cell.deletebtn.hidden = NO;
    }else
    {
        cell.deletebtn.hidden = YES;
    }
    [cell.labelTitle setText:[dict objectForKey:@"title"]];
    [cell.labelText setText:[dict objectForKey:@"content"]];
    
    // Label加载富文本数据
//    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[[dict objectForKey:@"content"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//    //    UILabel * myLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
//    //    myLabel;
//    cell.labelText.attributedText = attrStr;
    [cell.labelTime setText:[dict objectForKey:@"datetime"]];
    [cell.imgIcon setImage:[UIImage imageNamed:@"icon_gonggao"]];
    return cell;
}

-(void)DeleteActionByCell:(NSString *)indexNid
{
    NSLog(@"index.row is %@",indexNid);
    deletenid = indexNid;
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否确定删除此公告" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"确定");
                NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                [dic setValue:[HSAppData getCheckCode] forKey:@"checkcode"];
                [dic setValue:deletenid forKey:@"nid"];
                [_Master SubmitTo:@"deleteNotice" andParams:dic success:^(NSDictionary * dict) {
                    NSLog(@"dict is %@",dict);
                    if ([dict[@"ret"] integerValue] == 0) {
                        NSLog(@"删除成功");
                        maxnid = @"0";
                        minnid = @"0";
                        load = @"0";
                        noticeList = [[NSMutableArray alloc] init];
                        [self loadNoticeList];
                    }else
                    {
                        [self showMessage:dict[@"str"]];
                    }
                    
                } failed:^{
                    
                }];

        }
            break;
        case 1:
        {
            NSLog(@"取消");
        }
            break;

        default:
            break;
    }
}


-(void)setExTril:(UITableView *)tableview
{
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableview setTableFooterView:view];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self showSegueWithObject:@{@"title": @"校园公告", @"url": [MasterURL APIFor:@"notice" with:[[noticeList objectAtIndex:indexPath.row] objectForKey:@"nid"], nil]} Identifier:@"showNoticeWeb"];
    
}

@end
