//
//  XXERootFriendListController.m
//  teacher
//
//  Created by codeDing on 16/9/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERootFriendListController.h"
#import "FriendCell.h"
#import "KxMenu.h"
#import "XXEfriendListMdoel.h"
#import "XXERootFriendListApi.h"
#import "PersonCenterViewController.h"
@interface XXERootFriendListController ()<UITableViewDelegate,UITableViewDataSource>

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
    [self headerRereshing];

}
/** 这两个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UITableView *)friendListTableView
{
    if (!_friendListTableView) {
        _friendListTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        
    }
    return _friendListTableView;
}

- (NSMutableArray *)friendListDatasource {
    if (!_friendListDatasource) {
        _friendListDatasource = [NSMutableArray array];
    }
    return _friendListDatasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //上啦刷新
    self.friendListTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self headerRereshing];
    }];
    self.friendListTableView.delegate = self;
    self.friendListTableView.dataSource = self;
    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
    [rightButton setImage:[UIImage imageNamed:@"rcim3.png"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(showMenu:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.tabBarController.navigationItem.rightBarButtonItem= rightItem;
    
    self.tabBarController.navigationItem.title=@"聊天";
    
    [self.friendListTableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:RootFriendList];
    [self.view addSubview:self.friendListTableView];
}

- (void)headerRereshing
{
    [self rootFriendListServerDataPageNumber];
    
}

#pragma mark - 网络请求
- (void)rootFriendListServerDataPageNumber
{
    [self.friendListDatasource removeAllObjects];
    
    //请求参数
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    NSLog(@"%@",parameterXid);
    
    XXERootFriendListApi *rootFriendListApi = [[XXERootFriendListApi alloc]initWithRootFriendListUserXid:parameterXid UserId:parameterUser_Id];
    [rootFriendListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSLog(@"%@",request.responseJSONObject);
        NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        if ([code integerValue]== 1) {
            NSArray *data = [request.responseJSONObject objectForKey:@"data"];
            for (int i =0; i<data.count; i++) {
                XXEfriendListMdoel *model = [[XXEfriendListMdoel alloc]initWithDictionary:data[i] error:nil];
                [self.friendListDatasource addObject:model];
            }
        }
        [self.friendListTableView.header endRefreshing];
        [self.friendListTableView reloadData];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
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
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:RootFriendList forIndexPath:indexPath];
    XXEfriendListMdoel *model = self.friendListDatasource[indexPath.row];
    [cell xxe_rootFriendListMessage:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XXEfriendListMdoel *model = self.friendListDatasource[indexPath.row];
    PersonCenterViewController *personCenterVC = [[PersonCenterViewController alloc]init];
    personCenterVC.friendModel = model;
    personCenterVC.title = model.nickname;
    personCenterVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personCenterVC animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.friendListDatasource removeObjectAtIndex:indexPath.row];
        [self.friendListTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}


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
    NSLog(@"添加好友");
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
