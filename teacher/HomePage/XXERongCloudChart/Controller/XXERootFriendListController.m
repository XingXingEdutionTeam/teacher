//
//  XXERootFriendListController.m
//  teacher
//
//  Created by codeDing on 16/9/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERootFriendListController.h"
#import "XXERongCloudAddFriendsListViewController.h"
#import "XXERongCloudDeleteFriendApi.h"
#import "FriendCell.h"
#import "KxMenu.h"
#import "RCUserInfo+XXEAddition.h"
#import "XXERootFriendListApi.h"
#import "PersonCenterViewController.h"
#import "AppDelegate.h"

@interface XXERootFriendListController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *parameterXid;
    NSString *parameterUser_Id;
    UIImageView *placeholderImageView;
}


@property (nonatomic, strong)UITableView *friendListTableView;
/** 数据源 */
@property (nonatomic, strong)NSMutableArray *friendListDatasource;



@end

static NSString *const RootFriendList = @"RootFriendList";
@implementation XXERootFriendListController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title=@"好友列表";
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    _friendListDatasource = [[NSMutableArray alloc] init];
    
    [_friendListTableView reloadData];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_friendListTableView.header beginRefreshing];
}


/** 这两个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
    [rightButton setImage:[UIImage imageNamed:@"rcim3.png"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(showMenu:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.tabBarController.navigationItem.rightBarButtonItem= rightItem;
    
    self.tabBarController.navigationItem.title=@"聊天";
    
    [self createTableView];

}


- (void)createTableView{
    self.friendListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 49 - 64) style:UITableViewStyleGrouped];
    
    self.friendListTableView.dataSource = self;
    self.friendListTableView.delegate = self;
    
    [self.view addSubview:self.friendListTableView];
    
    self.friendListTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    self.friendListTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
    
    
}

-(void)loadNewData{
    
    [self rootFriendListServerDataPageNumber];
    [ self.friendListTableView.header endRefreshing];
}
-(void)endRefresh{
    [self.friendListTableView.header endRefreshing];
    [self.friendListTableView.footer endRefreshing];
}

- (void)loadFooterNewData{
    
    [self rootFriendListServerDataPageNumber];
    [ self.friendListTableView.footer endRefreshing];
    
}

#pragma mark - 网络请求
- (void)rootFriendListServerDataPageNumber
{
    if (self.friendListDatasource.count != 0) {
        [self.friendListDatasource removeAllObjects];
    }

    XXERootFriendListApi *rootFriendListApi = [[XXERootFriendListApi alloc]initWithRootFriendListUserXid:parameterXid UserId:parameterUser_Id];
    [rootFriendListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        if (_friendListDatasource.count != 0) {
            [_friendListDatasource removeAllObjects];
        }
//        NSLog(@"%@",request.responseJSONObject);

        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        if ([code integerValue]== 1) {
            NSArray *data = [request.responseJSONObject objectForKey:@"data"];
            for (NSDictionary *dic in data) {
                //                0 :表示 自己 头像 ，需要添加 前缀
                //                1 :表示 第三方 头像 ，不需要 添加 前缀
                //判断是否是第三方头像
                NSString * head_img;
                if([[NSString stringWithFormat:@"%@",dic[@"head_img_type"]]isEqualToString:@"0"]){
                    head_img=[kXXEPicURL stringByAppendingString:dic[@"head_img"]];
                }else{
                    head_img=dic[@"head_img"];
                }
                
                RCUserInfo *aUserInfo =[[RCUserInfo alloc]initWithUserId:dic[@"xid"] name:dic[@"nickname"] portrait:head_img QQ:nil sex:nil age:dic[@"age"]];
                
                [self.friendListDatasource addObject:aUserInfo];

            }
        }
        
        [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}


// 有数据 和 无数据 进行判断
- (void)customContent{
    // 如果 有占位图 先 移除
    [self removePlaceholderImageView];
    
    if (_friendListDatasource.count == 0) {
        _friendListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 1、无数据的时候
        [self createPlaceholderView];
        
    }else{
         //2、有数据的时候
        [AppDelegate shareAppDelegate].friendsArray = self.friendListDatasource;
    }
    
    [_friendListTableView reloadData];
    
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


#pragma mark - UITableViewDelegate UITableViewDatasource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendListDatasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendCell" owner:self options:nil]lastObject];
    }

    RCUserInfo *userInfo = self.friendListDatasource[indexPath.row];
    cell.portraitImageView.layer.cornerRadius = cell.portraitImageView.bounds.size.width/2;
    cell.portraitImageView.layer.masksToBounds = YES;
    [cell.portraitImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    cell.userNameLabel.text = userInfo.name;
    cell.QQLabel.text = [NSString stringWithFormat:@"猩ID:%@", userInfo.userId];
    cell.sexLabel.text = [NSString stringWithFormat:@"%@岁", userInfo.age];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%@", )
    
    RCUserInfo *userInfo = self.friendListDatasource[indexPath.row];
    
    PersonCenterViewController *personCenterVC = [[PersonCenterViewController alloc]init];
    personCenterVC.userInfo = userInfo;
    personCenterVC.title = userInfo.name;
    personCenterVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personCenterVC animated:YES];
    
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
//{
//    if(editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        [self deleteFriend:indexPath];
//        
//    }
//}
//
//
//- (void)deleteFriend:(NSIndexPath *)path{
//    
//    RCUserInfo *userInfo = self.friendListDatasource[path.row];
//    NSString *otherXid = userInfo.userId;
//
//    XXERongCloudDeleteFriendApi *rongCloudDeleteFriendApi = [[XXERongCloudDeleteFriendApi alloc] initWithXid:parameterXid user_id:parameterUser_Id other_xid:otherXid];
//    [rongCloudDeleteFriendApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        
////              NSLog(@"2222---   %@", request.responseJSONObject);
//        
//        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
//        
//        if ([codeStr isEqualToString:@"1"]) {
//            [self showHudWithString:@"删除成功!" forSecond:1.5];
//            
//            [self.friendListDatasource removeObjectAtIndex:path.row];
//            [self.friendListTableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
//                        
//            NSDictionary *notiDic = [NSDictionary dictionaryWithObject:otherXid forKey:@"DeleteXid"];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"delete" object:self userInfo:notiDic];
//
//        }else{
//            [self showHudWithString:@"删除失败!" forSecond:1.5];
//        }
//        [self customContent];
//    } failure:^(__kindof YTKBaseRequest *request) {
//        
//        [self showString:@"数据请求失败" forSecond:1.f];
//    }];
//    
//}


#pragma mark - 导航栏的按钮点击
- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems = @[[KxMenuItem menuItem:@"发起群聊" image:[UIImage imageNamed:@"faqiqunliao"] target:self action:@selector(pushGroupChat:)],
                           [KxMenuItem menuItem:@"添加好友" image:[UIImage imageNamed:@"tianjiahaoyou"] target:self action:@selector(pushAddFriend:)],
                           ];
    CGRect targetFrame = self.tabBarController.navigationItem.rightBarButtonItem.customView.frame;
    targetFrame.origin.y = targetFrame.origin.y +15;
    [KxMenu showMenuInView:self.tabBarController.navigationController.navigationBar.superview fromRect:targetFrame menuItems:menuItems];
}


#pragma mark - 发起群聊---添加好友
- (void)pushGroupChat:(UIButton *)sender
{
    NSLog(@"发起群聊");
    
}

- (void)pushAddFriend:(UIButton *)sender
{
//    NSLog(@"添加好友");
    XXERongCloudAddFriendsListViewController *rongCloudAddFriendsListVC = [[XXERongCloudAddFriendsListViewController alloc] init];
    
    [self.navigationController pushViewController:rongCloudAddFriendsListVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
