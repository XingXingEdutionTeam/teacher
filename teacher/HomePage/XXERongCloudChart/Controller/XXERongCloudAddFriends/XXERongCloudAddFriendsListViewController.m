
//
//  XXERongCloudAddFriendsListViewController.m
//  teacher
//
//  Created by Mac on 16/10/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERongCloudAddFriendsListViewController.h"
#import "XXEClassAddressHeadermasterAndManagerViewController.h"
#import "XXERongCloudAddFirendListDetailViewController.h"
#import "XXEClassAddressEveryclassInfoViewController.h"
#import "XXERongCloudSeeNearUserListViewController.h"
#import "XXERongCloudSearchFriendViewController.h"
#import "XXERongCloudFriendRequestListModel.h"
#import "XXERongCloudDeleteFriendRequestApi.h"
#import "XXERongCloudAgreeFriendRequestApi.h"
#import "XXERongCloudFriendRequestListApi.h"
#import "FriendApplicationTableViewCell.h"
//从 手机 通讯录 中 添加好友
#import "HomeViewController.h"

@interface XXERongCloudAddFriendsListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_myTableView;
    
    //好友请求列表
    NSMutableArray * requestListModelArray;
    NSMutableArray *idArray;
    
    NSMutableArray *searchArray;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}

@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation XXERongCloudAddFriendsListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    requestListModelArray = [[NSMutableArray alloc] init];
    searchArray = [[NSMutableArray alloc] init];
    
    [_myTableView reloadData];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_myTableView.header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    [self fetchNetData];
    
    [self settingButtons];

    [self createTableView];

}


- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _LookNearUserBtn.frame.origin.y + 20 + _LookNearUserBtn.height, KScreenWidth, KScreenHeight - 49 - 64 - 20 -  _LookNearUserBtn.frame.origin.y - _LookNearUserBtn.height) style:UITableViewStyleGrouped];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];
    
    _myTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    _myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
    
    
}

-(void)loadNewData{
    
    [self fetchNetData];
    [_myTableView.header endRefreshing];
}
-(void)endRefresh{
    [_myTableView.header endRefreshing];
    [_myTableView.footer endRefreshing];
}

- (void)loadFooterNewData{
    
    [self fetchNetData];
    [ _myTableView.footer endRefreshing];
    
}


- (void)settingButtons{
    //搜索
    [_searchButton setTitle:@"猩ID/手机号" forState:UIControlStateNormal];
    
    UIImage *img = [UIImage imageNamed:@"rongcloud_secarh_icon" ];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//原图片显示，不失真，不会变成系统默认蓝色
    [_searchButton setImage:img forState:UIControlStateNormal];
    //UIEdgeInsets insets = {top, left, bottom, right};
    [_searchButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -20.0,0.0, 0.0)];//图片距离右边框距离减少图片的宽度，其它不边
    
    _searchButton.backgroundColor = [UIColor whiteColor];
    _searchButton.layer.cornerRadius = 8;
    _searchButton.layer.masksToBounds = YES;
    [_searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    //从班级 通讯录 导入
    _fromClassBtn.backgroundColor = UIColorFromRGB(229, 232, 233);
    [_fromClassBtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
    [_fromClassBtn addTarget:self action:@selector(fromClassBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //从 手机 通讯录 导入
    _PhoneAddressBookBtn.backgroundColor = UIColorFromRGB(229, 232, 233);
    [_PhoneAddressBookBtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
    [_PhoneAddressBookBtn addTarget:self action:@selector(phoneAddressBookBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //查看附近的人
    _LookNearUserBtn.backgroundColor = UIColorFromRGB(229, 232, 233);
    [_LookNearUserBtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
    [_LookNearUserBtn addTarget:self action:@selector(lookNearUserBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)searchButtonClick{
    
    XXERongCloudSearchFriendViewController *rongCloudSearchFriendVC = [[XXERongCloudSearchFriendViewController alloc] init];
    
    [self.navigationController pushViewController:rongCloudSearchFriendVC animated:NO];
}

#pragma mark - ---------- 从班级通讯录导入  --------------
- (void)fromClassBtnClick{
    /*
     [DEFAULTS setObject:self.schoolHomeId forKey:@"SCHOOL_ID"];
     [DEFAULTS setObject:self.classHomeId forKey:@"CLASS_ID"];
     //身份
     [DEFAULTS setObject:self.userPosition forKey:@"POSITION"];
     [DEFAULTS setObject:self.schoolType forKey:@"SCHOOL_TYPE"];
     */
    
    NSString *schoolIdStr = [DEFAULTS objectForKey:@"SCHOOL_ID"];
    NSString *classIdStr = [DEFAULTS objectForKey:@"CLASS_ID"];
    NSString *schoolTypeStr = [DEFAULTS objectForKey:@"SCHOOL_TYPE"];
    NSString *positionStr = [DEFAULTS objectForKey:@"POSITION"];
    
    //通讯录
    if ([positionStr isEqualToString:@"1"] || [positionStr isEqualToString:@"2"]) {
        
        XXEClassAddressEveryclassInfoViewController *classAddressEveryclassInfoVC = [[XXEClassAddressEveryclassInfoViewController alloc] init];
        classAddressEveryclassInfoVC.schoolId = schoolIdStr;
        classAddressEveryclassInfoVC.selectedClassId = classIdStr;
        classAddressEveryclassInfoVC.fromFlagStr = @"fromRCIM";
        
        [self.navigationController pushViewController:classAddressEveryclassInfoVC animated:YES];
    }else if([positionStr isEqualToString:@"3"] || [positionStr isEqualToString:@"4"]){
        XXEClassAddressHeadermasterAndManagerViewController *classAddressHeadermasterAndManagerVC = [[XXEClassAddressHeadermasterAndManagerViewController alloc] init];
        classAddressHeadermasterAndManagerVC.schoolId = schoolIdStr;
        classAddressHeadermasterAndManagerVC.schoolType = schoolTypeStr;
        classAddressHeadermasterAndManagerVC.fromFlagStr = @"fromRCIM";
        
        [self.navigationController pushViewController:classAddressHeadermasterAndManagerVC animated:YES];
    }
}

#pragma mark - ---------- 从手机通讯录导入  --------------
- (void)phoneAddressBookBtnClick{
    
    [self.navigationController pushViewController:[HomeViewController alloc] animated:YES];
}


#pragma mark - ---------- 查看附近用户  --------------
- (void)lookNearUserBtnClick{
    
    [self.navigationController pushViewController:[XXERongCloudSeeNearUserListViewController alloc] animated:YES];
    
}


- (void)fetchNetData{
    
    XXERongCloudFriendRequestListApi *rongCloudFriendRequestListApi = [[XXERongCloudFriendRequestListApi alloc] initWithXid:parameterXid user_id:parameterUser_Id];
    [rongCloudFriendRequestListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        if (requestListModelArray.count != 0) {
            [requestListModelArray removeAllObjects];
        }
//             NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSArray *modelArray = [XXERongCloudFriendRequestListModel parseResondsData:request.responseJSONObject[@"data"]];
            
            [requestListModelArray addObjectsFromArray:modelArray];
        }else{
            
        }
        [_myTableView reloadData];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return requestListModelArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    FriendApplicationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendApplicationTableViewCell" owner:self options:nil]lastObject];
    }
    
    XXERongCloudFriendRequestListModel *model = requestListModelArray[indexPath.row];
    
    //昵称
    cell.nameLabel.text= model.nickname;
    //内容
    cell.remarkLabel.text= model.notes;
    
    //头像
    NSString * head_img;
    if([model.head_img_type integerValue] == 0){
        head_img = [kXXEPicURL stringByAppendingString:model.head_img];
    }else{
        head_img = model.head_img;
    }
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    
    cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width / 2;
    cell.imgView.layer.masksToBounds = YES;
    
    cell.agreeBtn.tag = indexPath.row + 10;
    
    [cell.agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    [cell.agreeBtn setTintColor:UIColorFromRGB(0, 170, 42)];
    [cell.agreeBtn addTarget:self action:@selector(collectPressed:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XXERongCloudAddFirendListDetailViewController *rongCloudAddFirendListDetailVC = [[XXERongCloudAddFirendListDetailViewController alloc] init];
    XXERongCloudFriendRequestListModel *model = requestListModelArray[indexPath.row];
    rongCloudAddFirendListDetailVC.other_xid = model.requester_xid;
    rongCloudAddFirendListDetailVC.requestIdStr = model.agree_friend_request_id;
    
    [self.navigationController pushViewController:rongCloudAddFirendListDetailVC animated:YES];
}


-(void)collectPressed:(UIButton *)btn{
    
    XXERongCloudFriendRequestListModel *model = requestListModelArray[btn.tag - 10];
    NSString *requestIdStr = model.agree_friend_request_id;
    
    
//    NSLog(@"***  -- %@", requestIdStr);
    
    XXERongCloudAgreeFriendRequestApi *rongCloudAgreeFriendRequestApi = [[XXERongCloudAgreeFriendRequestApi alloc] initWithXid:parameterXid user_id:parameterUser_Id request_id:requestIdStr];
    [rongCloudAgreeFriendRequestApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        if (requestListModelArray.count != 0) {
            [requestListModelArray removeAllObjects];
        }
//        NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"添加好友成功!" forSecond:1.5];
        }else{
            [self showHudWithString:@"添加好友失败!" forSecond:1.5];
        }
        [self fetchNetData];
        
        [_myTableView reloadData];
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}

//滑动删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
       
        [self deleteRequest:indexPath];

    }
}

- (void)deleteRequest:(NSIndexPath *)path{

    XXERongCloudFriendRequestListModel *model = requestListModelArray[path.row];
    NSString *requestIdStr = model.agree_friend_request_id;
    
    XXERongCloudDeleteFriendRequestApi *rongCloudDeleteFriendRequestApi = [[XXERongCloudDeleteFriendRequestApi alloc] initWithXid:parameterXid user_id:parameterUser_Id request_id:requestIdStr];
    [rongCloudDeleteFriendRequestApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        //      NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"删除成功!" forSecond:1.5];
            
            [requestListModelArray removeObjectAtIndex:path.row];
            [_myTableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
            
        }else{
            [self showHudWithString:@"删除失败!" forSecond:1.5];
        }
        [_myTableView reloadData];
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
  
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
