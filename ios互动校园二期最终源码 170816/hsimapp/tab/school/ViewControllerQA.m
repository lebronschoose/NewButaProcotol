//
//  ViewControllerQA.m
//  hsimapp
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 dayihua .inc. All rights reserved.
//

#import "ViewControllerQA.h"
#import "CellQA.h"
#import "WantQAViewController.h"
#import "QAModel.h"
//#import "InputBarView.h"
#import "NewQATableViewCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "MHYouKuInputPanelView.h"
#define kTimeLineTableViewCellId @"QANameCell"
@interface ViewControllerQA ()<PullTableViewDelegate,NewCellQADelegate,UITextFieldDelegate,MHYouKuInputPanelViewDelegate>
{
    NSMutableArray *listQA;
    NSString * maxcid;
    NSString * mincid;
    NSString * load;
//    InputBarView * inputView;
    NSIndexPath * PassIndex;
}
@end

@implementation ViewControllerQA

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    listQA = [[NSMutableArray alloc] init];
    maxcid  = @"0";
    mincid = @"0";
    load = @"0";

    if ([_Master isTeacher]) {
        
    }else
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 70, 34);
        btn.titleLabel.textAlignment = NSTextAlignmentRight;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:@"我要咨询" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];


    }
    
    [self.tableView setPullMode:0];
    [self.tableView EnableRefresh:YES];
    [self.tableView EnableLoadMore:YES];
    [self.tableView registerClass:[NewQATableViewCell class] forCellReuseIdentifier:kTimeLineTableViewCellId];
    
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi) name:@"tongzhi" object:nil];
//    inputView = [[NSBundle mainBundle]loadNibNamed:@"InputBarView" owner:self options:nil].lastObject;
//    inputView.InputTF.delegate = self;
//    inputView.frame = CGRectMake(0, ScreenHeight + inputView.frame.size.height, inputView.frame.size.width, inputView.frame.size.height);
//    [self.view addSubview:inputView];
    listQA = [[NSMutableArray alloc] init];
    [self loadQAList];
    CareMsg(msgDataNeedRefresh);
}

-(void)tongzhi
{
    [listQA  removeAllObjects];
    load = 0;
    maxcid = 0;
    mincid = 0;
    [self loadQAList];
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


-(void)loadQAList
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[HSAppData getCheckCode] forKey:@"checkcode"];
    [dic setValue:mincid forKey:@"mincid"];
    [dic setValue:maxcid forKey:@"maxcid"];
    [dic setValue:load forKey:@"load"];
    [_Master SubmitTo:@"getQAList" andParams:dic success:^(NSDictionary * dict) {
        
        
        if ([load isEqualToString:@"1"]) {
            NSLog(@"下拉");
            NSLog(@"PushListdict is %@",dict);
            NSMutableArray *array1 = [NSMutableArray array];
            
            NSArray *list = [dict objectForKey:@"qalist"];
            for (NSDictionary * dic in list) {
                NSLog(@"getQAListdict is %@",dict);
                QAModel * model = [QAModel mj_objectWithKeyValues:dic];
                [array1 addObject:model];
            }

            [listQA insertObjects:array1 atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [array1 count])]];


        }else if([load isEqualToString:@"2"])
        {
            NSLog(@"上拉");
            NSLog(@"PushListdict is %@",dict);
            NSNumber * more = dict[@"more"];
            if ([more integerValue]==0) {
                 [self showMessage:@"没有更多数据了"];
                return;
            }
            NSArray *list = [dict objectForKey:@"qalist"];
            for (NSDictionary * dic in list) {
                QAModel * model = [QAModel mj_objectWithKeyValues:dic];
                [listQA addObject:model];
            }
            QAModel * model = listQA.lastObject;
            mincid = model.cid;
            
        }else
        {
            NSLog(@"ALLListdict is %@",dict);

            NSArray *list = [dict objectForKey:@"qalist"];
            for (NSDictionary * dic in list) {
                QAModel * model = [QAModel mj_objectWithKeyValues:dic];
                [listQA addObject:model];
                
            }
            QAModel * Lastmodel = listQA.lastObject;
            QAModel * FirstModel = listQA.firstObject;
            mincid = Lastmodel.cid;
            maxcid = FirstModel.cid;
        }        
            [self.tableView reloadData];

//        }

    } failed:^{
        
    }];
}

- (void)onNotifyMsg:(NSNotification *)notification
{
    NSString *msg = [NSString stringWithString:notification.name];
    if([msg isEqualToString:msgDataNeedRefresh])
    {
        [self refreshTable];
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
   
    load = @"1";
    [self loadQAList];
}

- (void) loadMoreDataToTable
{
    /*
     Code to actually load more data goes here.  加载更多实现代码放在在这
     */
    self.tableView.pullTableIsLoadingMore = NO;
    if(self.tableView.pullLoadMoreEnabled == NO) return;
  
    load = @"2";
   
    [self loadQAList];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return listQA.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    QAModel * model = [listQA objectAtIndex:indexPath.section];
//    NSString *a = model.answer;
//    if([NSString isBlankString:a])
//    {
//        return  196;
//    }else
//    {
//        return 296;
//    }
    id model = listQA[indexPath.section];
    NSLog(@"heitht is %lf",[self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[NewQATableViewCell class] contentViewWidth:[self cellContentViewWith]]);
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[NewQATableViewCell class] contentViewWidth:[self cellContentViewWith]];
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NewQATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineTableViewCellId];

//    cell.delegate = self;
    QAModel * model = [listQA objectAtIndex:indexPath.section];
    cell.model = model;
    cell.indexPath = indexPath;
    
    __weak typeof(self) weakSelf = self;
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            QAModel *model = listQA[indexPath.section];
            model.isOpening = !model.isOpening;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
                
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)rightBtnClick
{
    NSLog(@"我要咨询");
    WantQAViewController * want = [[WantQAViewController alloc]init];
    [self.navigationController pushViewController:want animated:YES];
    
}

//- (void)keyBoardWillShow:(NSNotification *)note
//{
//    NSLog(@"3frame of last view: %f,%f %f,%f", self.view.frame.origin.x, self.view.frame.origin.y,
//          self.view.frame.size.width, self.view.frame.size.height);
//    
//    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat ty =  rect.size.height;
//    NSLog(@"ty is %f",ty);
//    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
////        [self.mediaView setHidden:YES];
//        inputView.frame = CGRectMake(0, ScreenHeight - ty- inputView.frame.size.height - 64, ScreenWidth, inputView.frame.size.height);
////        [self adjustTableView];
//    }];
//}
//
//#pragma mark 键盘即将退出
//- (void)keyBoardWillHide:(NSNotification *)note
//{
//    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//        inputView.frame = CGRectMake(0, ScreenHeight + inputView.frame.size.height, inputView.frame.size.width, inputView.frame.size.height);
////        [self adjustTableView];
//    }];
//}

-(void)ComfrimActionBySelectedIndex:(UITableViewCell *)cell
{
    PassIndex = [self.tableView indexPathForCell:cell];

    MHYouKuInputPanelView *inputPanelView = [MHYouKuInputPanelView inputPanelView];
    inputPanelView.wordlength  = 300;
//    inputPanelView.commentReply = [[MHCommentReply alloc]init];
    QAModel * model =  listQA[PassIndex.section];
    inputPanelView.model = model;
    inputPanelView.delegate = self;
    [inputPanelView show];

    
}


-(void)SendMethodsByCommitBy:(NSString *)String
{
    QAModel * model = listQA[PassIndex.section];
    NSMutableDictionary * postdic = [NSMutableDictionary dictionary];
    [postdic setValue:[HSAppData getCheckCode] forKey:@"checkcode"];
    [postdic setValue:@"1" forKey:@"who"];
    [postdic setValue:String forKey:@"answer"];
    [postdic setValue:model.cid forKey:@"cid"];
    [_Master SubmitTo:@"postQA" andParams:postdic success:^(NSDictionary *dict) {
        NSLog(@"postQADic is %@",dict);
//        [inputView.InputTF resignFirstResponder];
        NSNumber * num = dict[@"ret"];
        NSString * str = dict[@"str"];
        if ([num integerValue] == 0) {
            QAModel *model = listQA[PassIndex.section];
//            NSString * aserString = [NSString copy];
            model.answer = String;
            model.aname = _Master.mySelf.nickName;
            [self.tableView reloadRowsAtIndexPaths:@[PassIndex] withRowAnimation:UITableViewRowAnimationNone];
        }else
        {
            [self showMessage:str];
        }

    } failed:^{
        
    }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"yes");
    if (textField.text.length == 0) {
        return NO;
    }
    return YES;
}

-(void)inputPanelView:(MHYouKuInputPanelView *)inputPanelView attributedText:(NSString *)attributedText
{
    NSLog(@"attributedtext is %@",attributedText);
    [self SendMethodsByCommitBy:attributedText];

}
@end
