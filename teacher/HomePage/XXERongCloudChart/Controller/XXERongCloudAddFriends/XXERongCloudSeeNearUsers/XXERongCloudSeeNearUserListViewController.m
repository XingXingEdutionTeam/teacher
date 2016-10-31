//
//  XXERongCloudSeeNearUserListViewController.m
//  teacher
//
//  Created by Mac on 16/10/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERongCloudSeeNearUserListViewController.h"
#import "XXERongCloudSeeNearUserListTableViewCell.h"

#import "XXERongCloudSeeNearUserListModel.h"
#import "XXERongCloudAddFriendRequestApi.h"
#import "XXERongCloudSeeNearUserListApi.h"



@interface XXERongCloudSeeNearUserListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    NSInteger page;
    NSString *parameterXid;
    NSString *parameterUser_Id;
    //经度
    NSString *longitudeString;
    //纬度
    NSString *latitudeString;
}


@end

@implementation XXERongCloudSeeNearUserListViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.topItem.title = @"小红花";
    _dataSourceArray = [[NSMutableArray alloc] init];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    page = 0;
    longitudeString = @"";
    latitudeString = @"";
    /*
     [DEFAULTS setObject:self.longitudeString forKey:@"Longitude"];
     [DEFAULTS setObject:self.latitudeString forKey:@"LatitudeString"];
     */
    longitudeString = [DEFAULTS objectForKey:@"Longitude"];
    latitudeString = [DEFAULTS objectForKey:@"LatitudeString"];
    
//    NSLog(@"经度:%@ ===== 纬度:%@", longitudeString, latitudeString);
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_myTableView reloadData];
    [_myTableView.header beginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self createTableView];
    
}

- (void)fetchNetData{
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
    
    XXERongCloudSeeNearUserListApi *rongCloudSeeNearUserListApi = [[XXERongCloudSeeNearUserListApi alloc] initWithXid:parameterXid user_id:parameterUser_Id page:pageStr lng:longitudeString lat:latitudeString];
    [rongCloudSeeNearUserListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//                NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSDictionary *dict = request.responseJSONObject[@"data"];

            NSArray *modelArray = [XXERongCloudSeeNearUserListModel parseResondsData:dict];
            
            [_dataSourceArray addObjectsFromArray:modelArray];
        }else{
//            [self showHudWithString:@"" forSecond:1.5];
        }
        
        [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}


// 有数据 和 无数据 进行判断
- (void)customContent{
    
    if (_dataSourceArray.count == 0) {
        
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 1、无数据的时候
        UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth / 2 - myImageWidth / 2, (KScreenHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];
        
    }else{
        //2、有数据的时候
        [_myTableView reloadData];
        
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
    page ++;
    
    [self fetchNetData];
    [ _myTableView.header endRefreshing];
}
-(void)endRefresh{
    [_myTableView.header endRefreshing];
    [_myTableView.footer endRefreshing];
}

- (void)loadFooterNewData{
    page ++ ;
    
    [self fetchNetData];
    [ _myTableView.footer endRefreshing];
    
}


#pragma mark
#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSourceArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXERongCloudSeeNearUserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXERongCloudSeeNearUserListTableViewCell" owner:self options:nil]lastObject];
    }
    XXERongCloudSeeNearUserListModel *model = _dataSourceArray[indexPath.row];
    /*
     0 :表示 自己 头像 ，需要添加 前缀
     1 :表示 第三方 头像 ，不需要 添加 前缀
     //判断是否是第三方头像
     */
    NSString * head_img;
    if([model.head_img_type integerValue] == 0){
        head_img = [kXXEPicURL stringByAppendingString:model.head_img];
    }else{
        head_img = model.head_img;
    }
    cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width / 2;
    cell.iconImageView.layer.masksToBounds = YES;
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    
    cell.nameLabel.text = model.nickname;
    cell.distanceLabel.text = [NSString stringWithFormat:@"距离:%@km", model.distance];
    cell.sexLabel.text = model.sex;

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加好友" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        //
        textField.placeholder = @"申请备注";
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        [self requestAddFriend:indexPath];
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)requestAddFriend:(NSIndexPath *)path{
    XXERongCloudSeeNearUserListModel *model = _dataSourceArray[path.row];
    NSString *otherXid = model.xid;
    XXERongCloudAddFriendRequestApi *rongCloudAddFriendRequestApi = [[XXERongCloudAddFriendRequestApi alloc] initWithXid:parameterXid user_id:parameterUser_Id other_xid:otherXid];
    [rongCloudAddFriendRequestApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//      NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        /*
         ★其他结果需提醒用户
         code:4	//不能请求自己
         code:5	//已经是好友了(不能对好友发起请求)
         code:6	//对方在我的黑名单中,无法发起请求!
         code:7	//您已经在对方黑名单中,无法发起请求!
         code:8	//不能重复对同一个人发起请求!
         code:9	//对方已同意,可以直接聊天了 (对方设置了任何人请求直接通过)
         */
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"请求发送成功!" forSecond:1.5];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
        }else if ([codeStr isEqualToString:@"4"]) {
            [self showHudWithString:@"不能请求自己!" forSecond:1.5];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
        }else if ([codeStr isEqualToString:@"5"]) {
            [self showHudWithString:@"对方已经是您的好友!" forSecond:1.5];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
        }else if ([codeStr isEqualToString:@"6"]) {
            [self showHudWithString:@"对方在我的黑名单中,无法发起请求!" forSecond:1.5];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
        }else if ([codeStr isEqualToString:@"7"]) {
            [self showHudWithString:@"您已经在对方黑名单中,无法发起请求!" forSecond:1.5];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
        }else if ([codeStr isEqualToString:@"8"]) {
            [self showHudWithString:@"不能重复对同一个人发起请求!" forSecond:1.5];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
        }else if ([codeStr isEqualToString:@"9"]) {
            [self showHudWithString:@"对方已同意,可以直接聊天了!" forSecond:1.5];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
        }else if ([codeStr isEqualToString:@"10"]) {
            [self showHudWithString:@"添加成功!" forSecond:1.5];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
        }else{
            [self showHudWithString:@"请求发送失败!" forSecond:1.5];
        }
                
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];

}


@end
