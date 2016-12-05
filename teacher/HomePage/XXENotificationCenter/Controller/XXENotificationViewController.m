

//
//  XXENotificationViewController.m
//  teacher
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXENotificationViewController.h"
#import "XXERedFlowerSentHistoryTableViewCell.h"
#import "XXESchoolNotificationDetailViewController.h"
#import "XXESystemNotificationDetailViewController.h"
#import "XXESchoolNotificationModel.h"
#import "XXESystemNotificationModel.h"
#import "XXESystemNotificationApi.h"
#import "XXESchoolNotificationApi.h"
#import "XXEAuditAndReleaseViewController.h"

@interface XXENotificationViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_myTableView;
    UISegmentedControl *segementedControl;
    //学校通知 a=0; 系统通知 a=1;
//    NSInteger a;
    NSString *condit;
    
    //学校通知 数据
    NSMutableArray *_schoolDataSourceArray;
    //系统通知 数据
    NSMutableArray *_systemDataSourecArray;
    //学校通知 page
    NSInteger schoolPage;
    //系统通知 page
    NSInteger systemPage;
    //身份
    NSString *position;
    //数据请求参数
    NSString *parameterXid;
    NSString *parameterUser_Id;
    //无数据 时 的占位图
    UIImageView *placeholderImageView;
    
}


@end

@implementation XXENotificationViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (_schoolDataSourceArray.count != 0) {
        [_schoolDataSourceArray removeAllObjects];
    }
    
    if (_systemDataSourecArray.count != 0) {
        [_systemDataSourecArray removeAllObjects];
    }
    
    schoolPage = 0;
    systemPage = 0;
    if (condit == nil) {
        condit = @"0";
    }

//    if ([condit integerValue] == 0) {
//        //        a = 0;
//        [self fetchSchoolNetData];
//        
//    }else if ([condit integerValue] == 1){
//        //        a = 1;
//        [self fetchSystemNetData];
//    }
    
    [_myTableView reloadData];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_myTableView.header beginRefreshing];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XXEBackgroundColor;
    _schoolDataSourceArray = [[NSMutableArray alloc] init];
    _systemDataSourecArray = [[NSMutableArray alloc] init];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    

//    a = 0;
    condit = @"0";
    
    position = [DEFAULTS objectForKey:@"POSITION"];
    
    self.navigationController.navigationBar.backgroundColor = XXEColorFromRGB(0, 170, 42);
    self.navigationController.navigationBarHidden = NO;    

    UIButton *rightBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 22, 22) backGruondImageName:@"home_notification_release_icon44x44" Target:self Action:@selector(rightBtnClick:) Title:@""];
    UIBarButtonItem *sentItem =[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem =sentItem;
    
    [self createSegementControl];
    
    [self createTableView];
    
}

- (void)rightBtnClick:(UIButton *)button{

    XXEAuditAndReleaseViewController *auditAndReleaseVC = [[XXEAuditAndReleaseViewController alloc] init];
    
    auditAndReleaseVC.schoolId = _schoolId;
    auditAndReleaseVC.classId = _classId;
    
    [self.navigationController pushViewController:auditAndReleaseVC animated:YES];
    
}

- (void)createSegementControl{
    
    CGFloat segWidth = 100 * kScreenRatioWidth;
    CGFloat segHeight = 30 * kScreenRatioHeight;
    
    segementedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake((KScreenWidth - segWidth)/2, (49 - segHeight)/2, segWidth, segHeight)];
    [segementedControl insertSegmentWithTitle:@"校园通知" atIndex:0 animated:NO];
    [segementedControl insertSegmentWithTitle:@"系统通知" atIndex:1 animated:NO];
    self.navigationItem.titleView = segementedControl;
    segementedControl.tintColor = [UIColor whiteColor];
    segementedControl.selectedSegmentIndex = 0;
    [segementedControl addTarget:self action:@selector(controlPressed:) forControlEvents:UIControlEventValueChanged];

}

- (void)controlPressed:(UISegmentedControl *)segment{
//    NSInteger index = segment.selectedSegmentIndex;
   condit = [NSString stringWithFormat:@"%ld", segment.selectedSegmentIndex];
    if ([condit integerValue] == 0) {
//        a = 0;
        [self fetchSchoolNetData];
        
    }else if ([condit integerValue] == 1){
//        a = 1;
        [self fetchSystemNetData];
    }
}

//校园通知
- (void)fetchSchoolNetData{
/*
 传参:
	school_id	//学校id (测试值:1)
	class_id	//班级id (测试值:1)
	position	//身份 1,2,3,4 (校长和管理身份不需要传class_id)
	page		//页码,不传值默认1
 */
    NSString *pageStr = [NSString stringWithFormat:@"%ld", schoolPage];
    
//    NSLog(@"pageStr === %@", pageStr);
    
    XXESchoolNotificationApi *schoolNotificationApi = [[XXESchoolNotificationApi alloc] initWithXid:parameterXid user_id:parameterUser_Id class_id:_classId school_id:_schoolId position:position page:pageStr];
    [schoolNotificationApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//        NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
         NSArray *modelArray = [XXESchoolNotificationModel parseResondsData:request.responseJSONObject[@"data"]];
            
            [_schoolDataSourceArray addObjectsFromArray:modelArray];
        }else{
            
        }
        
        [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];

}

//系统通知
- (void)fetchSystemNetData{
/*
 【系统消息】
  接口类型:1
  接口:
 http://www.xingxingedu.cn/Global/official_notice
  传参:
	app_type	//1:家长端, 2:教师端
	page		//页码,加载更多, 默认1
 */
    NSString *pageStr = [NSString stringWithFormat:@"%ld", systemPage];
    XXESystemNotificationApi *systemNotificationApi = [[XXESystemNotificationApi alloc] initWithXid:parameterXid user_id:parameterUser_Id app_type:@"2" page:pageStr];
    [systemNotificationApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        //        NSLog(@"2222---   %@", request.responseJSONObject);
        NSDictionary *dic = request.responseJSONObject;
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", dic[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
        NSArray *modelArray = [XXESystemNotificationModel parseResondsData:dic[@"data"]];
            
            [_systemDataSourecArray addObjectsFromArray:modelArray];
        }else{
            
        }
        
        [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];

}

// 有数据 和 无数据 进行判断
- (void)customContent{
    // 如果 有占位图 先 移除
    [self removePlaceholderImageView];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    if ([condit integerValue] == 0) {
        dataArray = _schoolDataSourceArray;
    }else if ([condit integerValue] == 1){
        dataArray = _systemDataSourecArray;
    }
    
//    NSLog(@"dataArray.count === %ld", dataArray.count);
    
    
    if (dataArray.count == 0) {
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 1、无数据的时候
        [self createPlaceholderView];
        
    }else{
//        [_myTableView reloadData];
    }
    
    [_myTableView reloadData];
    
}


//没有 数据 时,创建 占位图
- (void)createPlaceholderView{
    // 1、无数据的时候
    UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
    CGFloat myImageWidth = myImage.size.width;
    CGFloat myImageHeight = myImage.size.height;
    
    placeholderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
    placeholderImageView.image = myImage;
    [self.view addSubview:placeholderImageView];
}

//去除 占位图
- (void)removePlaceholderImageView{
    if (placeholderImageView != nil) {
        [placeholderImageView removeFromSuperview];
    }
}


- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];
    
    _myTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    _myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
    
}

-(void)loadNewData{
    if ([condit integerValue] == 0) {
        schoolPage ++;
        [self fetchSchoolNetData];
    }else if ([condit integerValue] == 1){
        systemPage ++;
        [self fetchSystemNetData];
    }
    [ _myTableView.header endRefreshing];
}
-(void)endRefresh{
    [_myTableView.header endRefreshing];
    [_myTableView.footer endRefreshing];
}

- (void)loadFooterNewData{
    if ([condit integerValue] == 0) {
        schoolPage ++;
        [self fetchSchoolNetData];
    }else if ([condit integerValue] == 1){
        systemPage ++;
        [self fetchSystemNetData];
    }
    [ _myTableView.footer endRefreshing];
    
}


#pragma mark
#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    if ([condit integerValue] == 0) {
        dataArray = _schoolDataSourceArray;
    }else if ([condit integerValue] == 1){
        dataArray = _systemDataSourecArray;
    }
    return dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXERedFlowerSentHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXERedFlowerSentHistoryTableViewCell" owner:self options:nil]lastObject];
    }
    
    if ([condit integerValue] == 0) {
        XXESchoolNotificationModel * model = _schoolDataSourceArray[indexPath.row];
        cell.iconImageView.layer.cornerRadius =cell.iconImageView.bounds.size.width/2;
        cell.iconImageView.layer.masksToBounds =YES;
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kXXEPicURL,model.school_logo]] placeholderImage:[UIImage imageNamed:@""]];
        cell.titleLabel.text = model.school_name;
        cell.contentLabel.text = model.title;
        
        cell.timeLabel.text = [XXETool dateStringFromNumberTimer:model.date_tm];
    }else if ([condit integerValue] == 1){
        XXESystemNotificationModel *model = _systemDataSourecArray[indexPath.row];
        cell.iconImageView.layer.cornerRadius =cell.iconImageView.bounds.size.width/2;
        cell.iconImageView.layer.masksToBounds =YES;
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kXXEPicURL,model.school_logo]] placeholderImage:[UIImage imageNamed:@""]];
        
        cell.titleLabel.text =model.school_name;
        cell.contentLabel.text =model.title;
        cell.timeLabel.text = [XXETool dateStringFromNumberTimer:model.date_tm];
    }
    
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch ([condit integerValue]) {
        case 0:
        {
            XXESchoolNotificationDetailViewController *schoolNotificationDetailVC =[[XXESchoolNotificationDetailViewController alloc]init];
            XXESchoolNotificationModel *model = _schoolDataSourceArray[indexPath.row];
            
            schoolNotificationDetailVC.name = model.school_name;
            //[type] => 2		//通知范围需要  1:班级通知, 2:学校通知
            if ([model.type integerValue] == 1) {
                schoolNotificationDetailVC.scope = @"班级通知";
            }else if ([model.type integerValue] == 2){
                schoolNotificationDetailVC.scope = @"学校通知";
            }
            
            schoolNotificationDetailVC.time =[XXETool dateStringFromNumberTimer:model.date_tm];
            schoolNotificationDetailVC.content = model.con;
            schoolNotificationDetailVC.titleStr = model.title;
            [self.navigationController pushViewController:schoolNotificationDetailVC animated:YES];
        }
            break;
        case 1:
        {
            XXESystemNotificationDetailViewController *systemNotificationDetailVC =[[XXESystemNotificationDetailViewController alloc]init];
            XXESystemNotificationModel *model = _systemDataSourecArray[indexPath.row];
            
            systemNotificationDetailVC.name = model.school_name;
            systemNotificationDetailVC.time =[XXETool dateStringFromNumberTimer:model.date_tm];
            systemNotificationDetailVC.content = model.con;
            systemNotificationDetailVC.titleStr = model.title;
            [self.navigationController pushViewController:systemNotificationDetailVC animated:YES];
        }
            break;
        default:
            break;
    }

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
