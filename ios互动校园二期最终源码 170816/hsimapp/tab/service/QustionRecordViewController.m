//
//  QustionRecordViewController.m
//  hsimapp
//
//  Created by dingding on 2018/1/17.
//  Copyright © 2018年 dayihua .inc. All rights reserved.
//

#import "QustionRecordViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "QuestionTableViewCell.h"
#import "MHYouKuInputPanelView.h"
#import "QuetionDetailViewController.h"

@interface QustionRecordViewController ()<UITableViewDelegate,UITableViewDataSource,QuestionTableViewCellDelegate,MHYouKuInputPanelViewDelegate>
{
     NSIndexPath * PassIndex;
}
@property (nonatomic,strong) UITableView * QuestionTableView;
@property (nonatomic,strong) NSMutableArray * DateArr;
@end

@implementation QustionRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的反馈";
    _DateArr = [NSMutableArray array];
    [self GetData];
    // Do any additional setup after loading the view.

}

-(void)GetData
{
    NSMutableDictionary * postdic = [NSMutableDictionary dictionary];
    [postdic setValue:[HSAppData getCheckCode]  forKey:@"checkcode"];
    [[Master sharedInstance] SubmitTo:@"getOpinionLists" andParams:postdic success:^(NSDictionary * dict) {
        NSLog(@"postdic is %@",dict);
        NSArray * listArr = dict[@"lists"];
        for (NSDictionary * dic  in listArr) {
            [_DateArr addObject:dic];
        }
        self.QuestionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-66) style:UITableViewStylePlain];
        [self setExTril:_QuestionTableView];

        self.QuestionTableView.delegate = self;
        self.QuestionTableView.dataSource = self;
        [self.view addSubview:self.QuestionTableView];
        //    self.QuestionTableView.backgroundColor = [UIColor clearColor];
        [self.QuestionTableView registerClass:[QuestionTableViewCell class] forCellReuseIdentifier:@"QustionCell"];

        NSLog(@"_datearr.count is %ld",_DateArr.count);
    } failed:^{
        
    }];
}

-(void)setExTril:(UITableView *)tableview
{
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableview setTableFooterView:view];
}

#pragma mark - Table View Data Source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 10;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _DateArr.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize textLabelSize;
    CGSize textLabelSize1;
        NSDictionary * dic = [_DateArr objectAtIndex:indexPath.row];
        NSArray * contentArr = dic[@"detailed"];
    if (contentArr.count == 1) {
        NSDictionary * dic = contentArr[0];
        NSString  * labelstring = dic[@"content"];
         textLabelSize = [labelstring boundingRectWithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} context:nil].size;
        return 60+ textLabelSize.height;
    }else
    {
        NSDictionary * dict = [NSDictionary dictionary];
        NSDictionary * dict1 = [NSDictionary dictionary];
        dict = contentArr[0];
        dict1 = contentArr[1];
        textLabelSize = [dict[@"content"] boundingRectWithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} context:nil].size;
        textLabelSize1 = [dict1[@"content"] boundingRectWithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} context:nil].size;

        
        
        return 80+ textLabelSize.height +textLabelSize1.height;
    }

    return 0;
    
    

//    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[NewQATableViewCell class] contentViewWidth:[self cellContentViewWith]];
//    return  200;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QustionCell"];
    
        cell.delegate = self;
    NSDictionary * dic = [_DateArr objectAtIndex:indexPath.row];
    
    cell.postdic = dic;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)ComfrimActionBySelectedIndex:(UITableViewCell *)cell
{
    PassIndex = [self.QuestionTableView indexPathForCell:cell];
//
    MHYouKuInputPanelView *inputPanelView = [MHYouKuInputPanelView inputPanelView];
    inputPanelView.wordlength = 40;
//        inputPanelView.commentReply = [[MHCommentReply alloc]init];
//    QAModel * model =  listQA[PassIndex.section];
//    inputPanelView.model = model;
    inputPanelView.delegate = self;
    [inputPanelView show];
    
    
}

-(void)inputPanelView:(MHYouKuInputPanelView *)inputPanelView attributedText:(NSString *)attributedText
{
    NSLog(@"attributedtext is %@",attributedText);
//    [self SendMethodsByCommitBy:attributedText];
    [self SendSchoolMethodsBy:attributedText];
}

-(void)SendSchoolMethodsBy:(NSString *)string
{
    NSMutableDictionary * postdic = [NSMutableDictionary dictionary];
    NSDictionary * dic =_DateArr[PassIndex.row];
    [postdic setValue:[HSAppData getCheckCode]  forKey:@"checkcode"];
    [postdic setValue:dic[@"id"] forKey:@"id"];
    [postdic setValue:@"2" forKey:@"time"];
    [postdic setValue:string forKey:@"content"];
    [self PostAPI:@"postOpinionForm" andParams:postdic success:^(NSDictionary * dict) {
        NSLog(@"postdic is %@",dict);
        NSLog(@"str is %@",dict[@"str"]);
        NSNumber * ret = dict[@"str"];
        NSString * errorString = dict[@"ret"];
        if ([ret integerValue] == 0) {
            [self.navigationController popViewControllerAnimated:YES];
            
        }else
        {
            if ([NSString isBlankString:errorString]) {
                [self showMessage:@"提交失败"];
            }else
            {
                [self showMessage:errorString];
            }
        }
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * dic = [_DateArr objectAtIndex:indexPath.row];
    QuetionDetailViewController * contller = [[QuetionDetailViewController alloc]init];
    contller.Passid = dic[@"id"];
    [self.navigationController pushViewController:contller animated:YES];
}
@end
