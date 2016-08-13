




//
//  XXEAccountManagerViewController.m
//  teacher
//
//  Created by Mac on 16/8/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEAccountManagerViewController.h"
#import "XXEAccountManagerTableViewCell.h"
#import "XXEAccountManagerModel.h"
#import "XXEFlowerbasketWithdrawCashViewController.h"
#import "XXEAccountManagerApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/financial_account_list"

@interface XXEAccountManagerViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
//账号 中间 隐藏 一部分
@property (nonatomic, copy) NSString *aliPayAccountStr;
//账号 全部 明文显示
@property (nonatomic, copy) NSString *accountStr;

@end

@implementation XXEAccountManagerViewController

//- (void)viewWillAppear:(BOOL)animated{
//    
//    [_myTableView reloadData];
//    
//}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    [_myTableView.mj_header beginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"账号管理";
   
    [self createRightBar];
    
    
//    [self fetchNetData];
    
    [self createTableView];
    
    
}
- (void)createRightBar{
    
    UIButton *rightBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 25, 25) backGruondImageName:@"添加按钮icon" Target:self Action:@selector(add) Title:nil];
    UIBarButtonItem *rightBar =[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem =rightBar;
    
}
- (void)add{
    //提现
//    AddAccountViewController *addAccountVC =[[AddAccountViewController alloc]init];
//    [self.navigationController pushViewController:addAccountVC animated:NO];
    
}

- (void)fetchNetData{
    
    /*
     【花篮->提现账号列表】
     
     接口类型:1
     
     接口:
     http://www.xingxingedu.cn/Teacher/financial_account_list
     
     传参:     */
    
    
    XXEAccountManagerApi *accountManagerApi = [[XXEAccountManagerApi alloc] initWithUrlString:URL appkey:APPKEY backtype:BACKTYPE xid:XID user_id:USER_ID user_type:USER_TYPE];
    [accountManagerApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            _dataSourceArray = [[NSMutableArray alloc] init];
            
            NSArray *modelArray = [XXEAccountManagerModel parseResondsData:request.responseJSONObject[@"data"]];
            
            [_dataSourceArray addObjectsFromArray:modelArray];
        }else{
            
        }
        
        [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"请求失败" forSecond:1.f];
    }];
    
}

// 有数据 和 无数据 进行判断
- (void)customContent{
    
    if (_dataSourceArray.count == 0) {
        
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 1、无数据的时候
        UIImage *myImage = [UIImage imageNamed:@"人物"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth / 2 - myImageWidth / 2, (KHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];
        
    }else{
        //2、有数据的时候
        [_myTableView reloadData];
        
    }
    
}



- (void)createTableView{
    
    _myTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KWidth, KHeight) style:UITableViewStyleGrouped];
    _myTableView.dataSource =self;
    _myTableView.delegate =self;
    [self.view addSubview:_myTableView];
    
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    _myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
    
    
}

-(void)loadNewData{
    
    [self fetchNetData];
    [ _myTableView.mj_header endRefreshing];
}
-(void)endRefresh{
    [_myTableView.mj_header endRefreshing];
    [_myTableView.mj_footer endRefreshing];
}

- (void)loadFooterNewData{
    
    [self fetchNetData];
    [ _myTableView.mj_footer endRefreshing];
    
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
    XXEAccountManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEAccountManagerTableViewCell" owner:self options:nil]lastObject];
    }
    XXEAccountManagerModel *model = _dataSourceArray[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:@"zhifubaoZB"];
    cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width / 2;
    cell.iconImageView.layer.masksToBounds = YES;
    cell.nameLabel.text = model.tname;
    //账号 中间 隐藏 一部分
    _aliPayAccountStr = [model.account stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
     //138 1865 7742 ->  //138 **** 7742
    cell.accountNumberLabel.text = _aliPayAccountStr;
    //账号  全部 明文 显示
    _accountStr = model.account;
   
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00001;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    XXEFlowerbasketWithdrawCashViewController *XXEFlowerbasketWithdrawCashVC = [[XXEFlowerbasketWithdrawCashViewController alloc] init];
    
    XXEFlowerbasketWithdrawCashVC.aliPayAccountStr = _aliPayAccountStr;
    XXEFlowerbasketWithdrawCashVC.accountStr = _accountStr;
    
    [self.navigationController pushViewController:XXEFlowerbasketWithdrawCashVC animated:YES];
    
}



@end
