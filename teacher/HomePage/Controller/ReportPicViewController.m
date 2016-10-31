//
//  ReportPicViewController.m
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define KPATA @"ReportCell"
#import "ReportCell.h"
#import "ReportPicViewController.h"
#import "MBProgressHUD.h"
#import "XXEHomeReportListApi.h"
#import "XXEReportModel.h"
#import "XXEReportSubmitMessageApi.h"
@interface ReportPicViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *idArray;
    NSMutableArray *seletedIdArray;
    UIAlertView *_alert;
    MBProgressHUD *HUD;
    NSMutableString * report_name_idStr;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@property (nonatomic, strong)UITableView *reportTableView;

/**举报表的数据 */
@property (nonatomic, strong)NSMutableArray *reportLiatDatasource;

/** 保存举报类型的id */
@property (nonatomic, strong)NSMutableArray *datasourceReportId;

@end

@implementation ReportPicViewController

- (NSMutableArray *)datasourceReportId
{
    if (!_datasourceReportId) {
        _datasourceReportId = [NSMutableArray array];
    }
    return _datasourceReportId;
}

- (UITableView *)reportTableView
{
    if (!_reportTableView) {
        _reportTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _reportTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    return _reportTableView;
}

- (NSMutableArray *)reportLiatDatasource
{
    if (!_reportLiatDatasource) {
        _reportLiatDatasource = [NSMutableArray array];
    }
    return _reportLiatDatasource;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    self.navigationController.navigationBarHidden = NO;
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(- 10, 0, 44, 20);
    
    [rightBtn setTitle:@"提交"  forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(reportListSetup:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = backItem;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"举报";
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    seletedIdArray = [[NSMutableArray alloc] init];
    
    [self fetchNetData];
    
    [self createTableView];

}

- (void)createTableView{
    self.reportTableView.delegate = self;
    self.reportTableView.dataSource = self;
    [self.reportTableView registerNib:[UINib nibWithNibName:@"ReportCell" bundle:nil] forCellReuseIdentifier:@"ReportCELL"];
    [self.view addSubview:self.reportTableView];

}


- (void)fetchNetData{
    
    XXEHomeReportListApi *reportListApi = [[XXEHomeReportListApi alloc]initWithToReportListUserId:parameterUser_Id XXID:parameterXid];
    [reportListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        NSLog(@"%@",request.responseJSONObject);
//        NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
        NSMutableArray *data = [request.responseJSONObject objectForKey:@"data"];
        for (int i =0; i<data.count; i++) {
            XXEReportModel *model = [[XXEReportModel alloc]initWithDictionary:data[i] error:nil];
            [self.reportLiatDatasource addObject:model];
        }
//        NSLog(@"%ld",self.reportLiatDatasource.count);
//        NSLog(@"%@",self.reportLiatDatasource);
        [self.reportTableView reloadData];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.reportLiatDatasource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportCELL" forIndexPath:indexPath];
    XXEReportModel *model = self.reportLiatDatasource[indexPath.row];
    cell.titleLbl.text = model.reportName;
    NSLog(@"%@",model.reportName);
    cell.selectBtn.tag =indexPath.row +100;
    [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"report_unselected_icon"] forState:UIControlStateNormal];
    [cell.selectBtn addTarget:self action:@selector(reportChangeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)reportChangeButtonClick:(UIButton *)btn  {
    
    XXEReportModel *model  = self.reportLiatDatasource[btn.tag - 100];
    
            if (btn.selected) {
                //由已勾选 变为 未勾选
                [btn setBackgroundImage:[UIImage imageNamed:@"report_unselected_icon"] forState:UIControlStateNormal];
                btn.selected =NO;
                [self.datasourceReportId removeObject:model.reportId];
            }
            else{
                //由未勾选 变为 已勾选
                [btn setBackgroundImage:[UIImage imageNamed:@"report_selected_icon"] forState:UIControlStateNormal];
               btn.selected =YES;
                [self.datasourceReportId addObject:model.reportId];
            }
    NSLog(@"举报内容的ID%@",self.datasourceReportId);
}

#pragma mark - 提交action
- (void)reportListSetup:(UIButton*)barItem{
    NSString *stringReportId = [NSString string];
    if (self.datasourceReportId.count >0) {
        for (int i =0; i<self.datasourceReportId.count; i++) {
            NSString *stringId = [NSString stringWithFormat:@"%@,",self.datasourceReportId[i]];
            stringReportId = [stringReportId stringByAppendingString:stringId];

        }
        NSLog(@"%@",stringReportId);
        [self reportSubmitMessage:stringReportId];
    }else {
        [self showString:@"请选择举报内容" forSecond:1.f];
    }
}

#pragma mark - 提交举报的网络信息
- (void)reportSubmitMessage:(NSString *)string
{
    
//    NSLog(@"%@ --- %@ ", )
    
    if (_other_xidStr == nil) {
        _other_xidStr = @"";
    }
    if (_origin_pageStr == nil) {
        _origin_pageStr = @"";
    }

    if (_picUrlStr == nil) {
        _picUrlStr = @"";
    }

    if (_report_type == nil) {
        _report_type = @"";
    }

    
    XXEReportSubmitMessageApi *submitApi = [[XXEReportSubmitMessageApi alloc]initWithReportSubmitUserID:parameterUser_Id UserXID:parameterXid OtherXid:self.other_xidStr ReportNameId:string ReportType:self.report_type PhotoUrl:self.picUrlStr OriginPage:self.origin_pageStr];
    [submitApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        NSLog(@"%@",request.responseJSONObject);
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        if ([code intValue]==1) {
            [self showString:@"举报成功,谢谢你的举报" forSecond:2.f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            NSString *msg = [request.responseJSONObject objectForKey:@"msg"];
            [self showString:msg forSecond:1.f];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}



@end
