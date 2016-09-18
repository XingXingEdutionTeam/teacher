

//
//  XXEAuditAndReleaseViewController.m
//  teacher
//
//  Created by Mac on 16/9/14.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEAuditAndReleaseViewController.h"
#import "XXECommentRequestTableViewCell.h"
#import "XXEReleaseViewController.h"
#import "XXEAuditAndReleaseApi.h"
#import "XXEAuditAndReleaseModel.h"
#import "XXEAuditDetailInfoViewController.h"
#import "XXEReleaseDetailInfoViewController.h"

@interface XXEAuditAndReleaseViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_myTableView;
    UISegmentedControl *segementedControl;
    //审核 a=0; 发布 a=1;
    NSInteger a;
    //审核 数据
    NSMutableArray *_auditDataSourceArray;
    //发布 数据
    NSMutableArray *_releaseDataSourecArray;
    //审核 page
    NSInteger auditPage;
    //发布 page
    NSInteger releasePage;
    //数据请求参数
    NSString *parameterXid;
    NSString *parameterUser_Id;
    //占位图
    UIImageView *placeholderImageView;
}


@end

@implementation XXEAuditAndReleaseViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    _auditDataSourceArray = [[NSMutableArray alloc] init];
    _releaseDataSourecArray = [[NSMutableArray alloc] init];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    auditPage = 0;
    releasePage = 0;
    
    [_myTableView reloadData];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_myTableView.header beginRefreshing];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    a = 0;
    
    UIButton *rightBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 22, 22) backGruondImageName:@"comment_request_icon" Target:self Action:@selector(rightBtnClick:) Title:@""];
    UIBarButtonItem *sentItem =[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem =sentItem;
    
    [self createSegementControl];
    
    [self createTableView];
    
}

- (void)rightBtnClick:(UIButton *)button{
    XXEReleaseViewController *releaseVC = [[XXEReleaseViewController alloc] init];
    releaseVC.schoolId = _schoolId;
    releaseVC.classId = _classId;
    
    [self.navigationController pushViewController:releaseVC animated:YES];
}


- (void)createSegementControl{
    
    CGFloat segWidth = 100 * kScreenRatioWidth;
    CGFloat segHeight = 30 * kScreenRatioHeight;
    
    segementedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake((KScreenWidth - segWidth)/2, (49 - segHeight)/2, segWidth, segHeight)];
    [segementedControl insertSegmentWithTitle:@"审核" atIndex:0 animated:NO];
    [segementedControl insertSegmentWithTitle:@"发布" atIndex:1 animated:NO];
    self.navigationItem.titleView = segementedControl;
    segementedControl.tintColor = [UIColor whiteColor];
    segementedControl.selectedSegmentIndex = 0;
    [segementedControl addTarget:self action:@selector(controlPressed:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)controlPressed:(UISegmentedControl *)segment{
    NSInteger seletedIndex = [segment selectedSegmentIndex];
    if (seletedIndex == 0) {
        a = 0;
        [self fetchAuditNetData];
        
    }else if (seletedIndex == 1){
        a = 1;
        [self fetchReleaseNetData];
    }
}

//审核
- (void)fetchAuditNetData{
    /*
     传参:
     【校园通知--我发布的通知和我要审核的通知】
     
     接口类型:1
     
     接口:
     http://www.xingxingedu.cn/Teacher/school_notice_me
     
     传参:
     school_id	//学校id
     class_id	//班级id (校长和管理身份不需要传class_id)
     request_type	//查询类型,1:我要审核的通知   2:我发布的通知
     page		//页码,起始页1,不传值默认1

     */
    NSString *pageStr = [NSString stringWithFormat:@"%ld", auditPage];
    
//    NSLog(@"%@--- %@ --- %@ --- %@ -- %@", parameterXid, parameterUser_Id, _schoolId, _classId, pageStr);
    
    XXEAuditAndReleaseApi *auditAndReleaseApi = [[XXEAuditAndReleaseApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:_schoolId class_id:_classId request_type:@"1" page:pageStr];
    [auditAndReleaseApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        if (_auditDataSourceArray.count != 0) {
            [_auditDataSourceArray removeAllObjects];
        }
//                NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            NSArray *modelArray = [XXEAuditAndReleaseModel parseResondsData:request.responseJSONObject[@"data"]];
            
            [_auditDataSourceArray addObjectsFromArray:modelArray];
        }else{
            
        }
        
        [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}

//发布
- (void)fetchReleaseNetData{
    /*
     【校园通知--我发布的通知和我要审核的通知】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Teacher/school_notice_me
     传参:
     school_id	//学校id
     class_id	//班级id (校长和管理身份不需要传class_id)
     request_type	//查询类型,1:我要审核的通知   2:我发布的通知
     page		//页码,起始页1,不传值默认1
     */
    NSString *pageStr = [NSString stringWithFormat:@"%ld", releasePage];
    XXEAuditAndReleaseApi *auditAndReleaseApi = [[XXEAuditAndReleaseApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:_schoolId class_id:_classId request_type:@"2" page:pageStr];
    [auditAndReleaseApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        if (_releaseDataSourecArray.count != 0) {
            [_releaseDataSourecArray removeAllObjects];
        }
        //        NSLog(@"2222---   %@", request.responseJSONObject);
        NSDictionary *dic = request.responseJSONObject;
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", dic[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSArray *modelArray = [XXEAuditAndReleaseModel parseResondsData:dic[@"data"]];
            
            [_releaseDataSourecArray addObjectsFromArray:modelArray];
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
    
//    NSLog(@"%@ --- %@ ", _auditDataSourceArray, _releaseDataSourecArray);
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    if (a == 0) {
        dataArray = _auditDataSourceArray;
    }else if (a == 1){
        dataArray = _releaseDataSourecArray;
    }
    
    if (dataArray.count == 0) {
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 1、无数据的时候
        [self createPlaceholderView];
        
    }else{
        
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
    if (a == 0) {
        auditPage ++;
        [self fetchAuditNetData];
    }else if (a == 1){
        releasePage ++;
        [self fetchReleaseNetData];
    }
    [ _myTableView.header endRefreshing];
}

-(void)endRefresh{
    [_myTableView.header endRefreshing];
    [_myTableView.footer endRefreshing];
}

- (void)loadFooterNewData{
    if (a == 0) {
        auditPage ++;
        [self fetchAuditNetData];
    }else if (a == 1){
        releasePage ++;
        [self fetchReleaseNetData];
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
    if (a == 0) {
        dataArray = _auditDataSourceArray;
    }else if (a == 1){
        dataArray = _releaseDataSourecArray;
    }
    return dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXECommentRequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXECommentRequestTableViewCell" owner:self options:nil]lastObject];
    }
    
    //[condit] => 1	//0:未审核  1:已审核  2:未通过
    if (a == 0) {
        XXEAuditAndReleaseModel * model = _auditDataSourceArray[indexPath.row];
        cell.iconImageView.layer.cornerRadius =cell.iconImageView.bounds.size.width/2;
        cell.iconImageView.layer.masksToBounds =YES;
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kXXEPicURL,model.school_logo]] placeholderImage:[UIImage imageNamed:@""]];
        cell.nameLabel.text = model.school_name;
        cell.contentLabel.text = model.title;
        if ([model.condit isEqualToString:@"0"]) {
            cell.stateImageView.image = [UIImage imageNamed:@"daishenghe"];
        }else if ([model.condit isEqualToString:@"1"]) {
            cell.stateImageView.image = [UIImage imageNamed:@"yishenghe"];
        }else if ([model.condit isEqualToString:@"2"]) {
            cell.stateImageView.image = [UIImage imageNamed:@"refuse_icon_74x74"];
        }
        
        
        cell.timeLabel.text = [XXETool dateStringFromNumberTimer:model.date_tm];
    }else if (a == 1){
        XXEAuditAndReleaseModel *model = _releaseDataSourecArray[indexPath.row];
        cell.iconImageView.layer.cornerRadius =cell.iconImageView.bounds.size.width/2;
        cell.iconImageView.layer.masksToBounds =YES;
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kXXEPicURL,model.school_logo]] placeholderImage:[UIImage imageNamed:@""]];
        if ([model.condit isEqualToString:@"0"]) {
            cell.stateImageView.image = [UIImage imageNamed:@"daishenghe"];
        }else if ([model.condit isEqualToString:@"1"]) {
            cell.stateImageView.image = [UIImage imageNamed:@"yishenghe"];
        }else if ([model.condit isEqualToString:@"2"]) {
            cell.stateImageView.image = [UIImage imageNamed:@"refuse_icon_74x74"];
        }
        cell.nameLabel.text =model.school_name;
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
    switch (a) {
        case 0:
        {
            //审核 详情
            XXEAuditDetailInfoViewController *auditDetailInfoVC =[[XXEAuditDetailInfoViewController alloc]init];
            XXEAuditAndReleaseModel *model = _auditDataSourceArray[indexPath.row];
            
            auditDetailInfoVC.subjectStr = model.title;
            auditDetailInfoVC.contentStr = model.con;
            auditDetailInfoVC.notice_id = model.notice_id;
            [self.navigationController pushViewController:auditDetailInfoVC animated:YES];
        }
            break;
        case 1:
        {
            //发布 详情
            XXEReleaseDetailInfoViewController *releaseDetailInfoVC =[[XXEReleaseDetailInfoViewController alloc]init];            
//            if (_auditDataSourceArray.count != 0) {
                XXEAuditAndReleaseModel *model = _releaseDataSourecArray[indexPath.row];
                
                releaseDetailInfoVC.subjectStr = model.title;
                releaseDetailInfoVC.contentStr = model.con;

//            }
                [self.navigationController pushViewController:releaseDetailInfoVC animated:YES];
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
