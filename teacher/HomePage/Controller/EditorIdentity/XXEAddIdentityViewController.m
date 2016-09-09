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
#import "XXEDiffentIdentityViewController.h"

@interface XXEAddIdentityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *identityTableView;
/** 身份列表的数据 */
@property (nonatomic, strong)NSMutableArray *idenDatasouces;

@end

@implementation XXEAddIdentityViewController

- (NSMutableArray *)idenDatasouces
{
    if (!_idenDatasouces) {
        _idenDatasouces = [NSMutableArray array];
    }
    return _idenDatasouces;
}

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
    self.navigationItem.title = @"编辑身份";
    self.navigationController.navigationBarHidden = NO;
    [self creatNavigaRightButton];
    //获取网络数据
    [self setupIdentityList];
}

/** 这个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.identityTableView registerNib:[UINib nibWithNibName:@"XXEIdentityListViewCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    [self.view addSubview:self.identityTableView];
    //获取网络数据
//    [self setupIdentityList];
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
    [self.idenDatasouces removeAllObjects];
    XXEHomeIdentityApi *identityApi = [[XXEHomeIdentityApi alloc]initWithHomeIdentityUserXid:strngXid UserId:homeUserId];
    [identityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"%@",request.responseJSONObject);
        NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        NSLog(@"%@",code);
        if ([[request.responseJSONObject objectForKey:@"data"] isKindOfClass:[NSString class]]) {
            [self showString:@"没有数据" forSecond:1.f];
            return ;
        }else if ([code intValue]==1) {
            
             NSMutableArray *messageArray = [request.responseJSONObject objectForKey:@"data"];
            for (int i =0; i<messageArray.count; i++) {
                XXEIdentityListModel *identityModel = [[XXEIdentityListModel alloc]initWithDictionary:messageArray[i] error:nil];
                NSLog(@"model的值:%@",identityModel);
                [self.idenDatasouces addObject:identityModel];
            }
            NSLog(@"编辑学校详情%@",self.idenDatasouces);
            [self.identityTableView reloadData];
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
    return self.idenDatasouces.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XXEIdentityListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    XXEIdentityListModel *model = self.idenDatasouces[indexPath.row];
    [cell identityListMessage:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - 按钮的点击事件
- (void)addNavigationButton
{
    XXEDiffentIdentityViewController *diffentIdVC = [[XXEDiffentIdentityViewController alloc]init];
    [self.navigationController pushViewController:diffentIdVC animated:YES];
}


#pragma mark - 创建导航栏后边的按钮
- (void)creatNavigaRightButton
{
    //设置 navigationBar 右边 上传图片
    UIButton *updataButton = [UIButton buttonWithType:UIButtonTypeCustom];
    updataButton.frame = CGRectMake(300, 5, 22, 22);
    [updataButton setImage:[UIImage imageNamed:@"home_flowerbasket_addIcon44x44"] forState:UIControlStateNormal];
    [updataButton addTarget:self action:@selector(addNavigationButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithCustomView:updataButton];
    self.navigationItem.rightBarButtonItem = rightItem1;
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
