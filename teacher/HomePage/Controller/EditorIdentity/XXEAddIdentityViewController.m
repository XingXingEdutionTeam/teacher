//
//  XXEAddIdentityViewController.m
//  teacher
//
//  Created by codeDing on 16/9/1.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEAddIdentityViewController.h"
#import "XXEHomeIdentityApi.h"
#import "XXEIdentityListViewCell.h"
#import "XXEIdentityListModel.h"

@interface XXEAddIdentityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *identityTableView;
/** 身份列表的数据 */
@property (nonatomic, strong)NSMutableArray *idenDatasouce;

@end

@implementation XXEAddIdentityViewController

- (UITableView *)identityTableView
{
    if (!_identityTableView) {
        _identityTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _identityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _identityTableView.delegate = self;
        _identityTableView.dataSource = self;
    }
    return _identityTableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    self.navigationController.navigationBarHidden = NO;
    [self creatNavigaRightButton];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.identityTableView registerNib:[UINib nibWithNibName:@"XXEIdentityListViewCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    [self.view addSubview:self.identityTableView];
    //获取网络数据
    [self setupIdentityList];
}

#pragma mark - 获取网络 数据
- (void)setupIdentityList
{
    NSString *strngXid;
    NSString *homeUserId;
    if ([XXEUserInfo user].login) {
        strngXid = [XXEUserInfo user].xid;
        homeUserId = [XXEUserInfo user].user_id;
    }else {
        strngXid = XID;
        homeUserId = USER_ID;
    }
    XXEHomeIdentityApi *identityApi = [[XXEHomeIdentityApi alloc]initWithHomeIdentityUserXid:strngXid UserId:homeUserId];
    [identityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"%@",request.responseJSONObject);
        NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        NSLog(@"%@",code);
        if ([code intValue]== 1) {
            NSLog(@"成功");
        }else{
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}

#pragma mark - UITableViewDelegate Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XXEIdentityListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - 按钮的点击事件
- (void)addNavigationButton:(UIButton *)sender
{
    
}


#pragma mark - 创建导航栏后边的按钮
- (void)creatNavigaRightButton
{
    UIButton *addButton = [UIButton createButtonWithFrame:CGRectMake(0, 0, 22, 22) backGruondImageName:@"home_flowerbasket_addIcon44x44" Target:self Action:@selector(addNavigationButton:) Title:@""];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = rightItem;
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
