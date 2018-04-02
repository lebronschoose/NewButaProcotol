//
//  QuetionDetailViewController.m
//  hsimapp
//
//  Created by dingding on 2018/1/19.
//  Copyright © 2018年 dayihua .inc. All rights reserved.
//

#import "QuetionDetailViewController.h"
#import "QuestionDetailTableViewCell.h"
#import "MHYouKuInputPanelView.h"
#import "QustionDmodel.h"

@interface QuetionDetailViewController ()<UITableViewDelegate,UITableViewDataSource,MHYouKuInputPanelViewDelegate>
@property (nonatomic,strong) UITableView * QuestionTableView;
@property (nonatomic,strong) UIButton * ConfrimBtn;
@property (nonatomic,strong) QustionDmodel * model;
@property (nonatomic,strong) NSMutableArray * modelArr;
@end

@implementation QuetionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _modelArr =[NSMutableArray array];
    // Do any additional setup after loading the view.
    [self GetData];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

-(void)GetData
{
    NSMutableDictionary * postdic = [NSMutableDictionary dictionary];
    [postdic setValue:_Passid  forKey:@"opid"];
    [[Master sharedInstance] SubmitTo:@"getOpinionInfoById" andParams:postdic success:^(NSDictionary * dict) {
        NSLog(@"postdic is %@",dict);
        NSArray * listArr = dict[@"lists"];
        for (NSDictionary * dic in listArr) {
            NSLog(@"getQAListdict is %@",dict);
            QustionDmodel * model = [QustionDmodel mj_objectWithKeyValues:dic];
            [_modelArr addObject:model];
        }
        self.QuestionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, listArr.count * 100) style:UITableViewStylePlain];
        self.QuestionTableView.delegate = self;
        self.QuestionTableView.dataSource = self;
        [self.view addSubview:self.QuestionTableView];
        //    self.QuestionTableView.backgroundColor = [UIColor clearColor];
        [self.QuestionTableView registerClass:[QuestionDetailTableViewCell class] forCellReuseIdentifier:@"DetailCell"];
       
        _ConfrimBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.QuestionTableView.frame)+10, ScreenWidth - 20, 30)];
        if (listArr.count%2 ==0 ) {
            _ConfrimBtn.hidden = NO;
        }else
        {
            _ConfrimBtn.hidden = YES;
        }
        _ConfrimBtn.layer.cornerRadius = 2;
        [self.view addSubview:_ConfrimBtn];
        [_ConfrimBtn setTitle:@"继续咨询" forState:UIControlStateNormal];
        [_ConfrimBtn setBackgroundColor:[UIColor colorFromHexString:@"#00bb54"]];
        _ConfrimBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_ConfrimBtn addTarget:self action:@selector(TouchAction) forControlEvents:UIControlEventTouchUpInside];
        [_ConfrimBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
//        NSLog(@"_datearr.count is %ld",_DateArr.count);
    } failed:^{
        
    }];
}

-(void)TouchAction
{
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
//    NSDictionary * dic =_DateArr[PassIndex.row];
    [postdic setValue:[HSAppData getCheckCode]  forKey:@"checkcode"];
    [postdic setValue:_Passid forKey:@"id"];
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
#pragma mark - Table View Data Source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 10;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArr.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
    
    
    
    //    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[NewQATableViewCell class] contentViewWidth:[self cellContentViewWith]];
    //    return  200;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    QuestionDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
    
//    cell.delegate = self;
    QustionDmodel * model = [_modelArr objectAtIndex:indexPath.row];
//
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
