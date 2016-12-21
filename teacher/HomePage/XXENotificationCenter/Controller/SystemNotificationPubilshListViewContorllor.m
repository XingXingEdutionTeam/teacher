//
//  SystemNotificationPubilshListViewContorllor.m
//  teacher
//
//  Created by codeDing on 16/12/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "SystemNotificationPubilshListViewContorllor.h"
#import "XXECommentRequestTableViewCell.h"
#import "XXEAuditAndReleaseApi.h"
#import "XXEAuditAndReleaseModel.h"
#import "XXEReleaseDetailInfoViewController.h"

@interface SystemNotificationPubilshListViewContorllor ()<UITableViewDataSource,UITableViewDelegate>
{
    //发布 数据
    NSMutableArray *_releaseDataSourecArray;
    //发布 page
    NSInteger releasePage;
    //数据请求参数
    NSString *parameterXid;
    NSString *parameterUser_Id;
    //占位图
    UIImageView *placeholderImageView;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SystemNotificationPubilshListViewContorllor

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (_releaseDataSourecArray.count != 0) {
        [_releaseDataSourecArray removeAllObjects];
    }
    
    releasePage = 0;
    
    
    [self.tableView reloadData];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView.header beginRefreshing];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    [self initTableView];
    // Do any additional setup after loading the view.
}

- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 95;
//    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
}

-(void)loadNewData{

    releasePage ++;
    [self fetchReleaseNetData];
    [self.tableView.header endRefreshing];
}

-(void)endRefresh{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

- (void)loadFooterNewData{
    releasePage ++;
    [self fetchReleaseNetData];
    [self.tableView.footer endRefreshing];
    
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
    
    //    NSLog(@"releasePage --- %@", pageStr);
    XXEAuditAndReleaseApi *auditAndReleaseApi = [[XXEAuditAndReleaseApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:_schoolId class_id:_classId request_type:@"2" page:pageStr];
    [auditAndReleaseApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //        if (_releaseDataSourecArray.count != 0) {
        //            [_releaseDataSourecArray removeAllObjects];
        //        }
        //                NSLog(@"99999---   %@", request.responseJSONObject);
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
    dataArray = _releaseDataSourecArray;
    
    if (dataArray.count != 0) {
        NSLog(@"dataArray[0] == %@", dataArray[0]);
    }
    
    if (dataArray.count == 0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 1、无数据的时候
        [self createPlaceholderView];
        
    }else{
        
    }
    
    [self.tableView reloadData];
    
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _releaseDataSourecArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXECommentRequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXECommentRequestTableViewCell" owner:self options:nil]lastObject];
    }
    
    XXEAuditAndReleaseModel *model = _releaseDataSourecArray[indexPath.row];
    cell.iconImageView.layer.cornerRadius =cell.iconImageView.bounds.size.width/2;
    cell.iconImageView.layer.masksToBounds =YES;
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kXXEPicURL,model.school_logo]] placeholderImage:[UIImage imageNamed:@"school_logo"]];
    if ([model.condit isEqualToString:@"0"]) {
        cell.stateImageView.image = [UIImage imageNamed:@"daishenghe"];
    }else if ([model.condit isEqualToString:@"1"]) {
        cell.stateImageView.image = [UIImage imageNamed:@"yishenghe"];
    }else if ([model.condit isEqualToString:@"2"]) {
        cell.stateImageView.image = [UIImage imageNamed:@"no_pass"];
    }
    cell.nameLabel.text =model.school_name;
    cell.contentLabel.text =model.title;
    cell.timeLabel.text = [XXETool dateStringFromNumberTimer:model.date_tm];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
            //发布 详情
            XXEReleaseDetailInfoViewController *releaseDetailInfoVC =[[XXEReleaseDetailInfoViewController alloc]init];
            //            if (_auditDataSourceArray.count != 0) {
            XXEAuditAndReleaseModel *model = _releaseDataSourecArray[indexPath.row];
            
            releaseDetailInfoVC.subjectStr = model.title;
            releaseDetailInfoVC.contentStr = model.con;
            
            //            }
            [self.navigationController pushViewController:releaseDetailInfoVC animated:YES];
}


- (void)didReceiveMemoryWarning {
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

@end
