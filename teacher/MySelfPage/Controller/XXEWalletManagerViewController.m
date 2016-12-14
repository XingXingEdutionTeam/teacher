

//
//  XXEWalletManagerViewController.m
//  teacher
//
//  Created by Mac on 16/10/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEWalletManagerViewController.h"
#import "XXETransactionRecordsViewController.h"
#import "XXEAccountManagerViewController.h"
#import "XXEModifyCodeViewController.h"
#import "XXESchoolWithdrawPageApi.h"


@interface XXEWalletManagerViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    NSString *totalMoney;
    NSString *fbasket_commission_per;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
    NSString *schoolId;
    NSString *position;
    NSString *classId;
//    NSString *position;

}


@end

@implementation XXEWalletManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    schoolId = [DEFAULTS objectForKey:@"SCHOOL_ID"];
    
    position = [DEFAULTS objectForKey:@"POSITION"];
    
    classId = [DEFAULTS objectForKey:@"CLASS_ID"];
    
    _dataSourceArray = [[NSMutableArray alloc] initWithObjects:@"交易记录", @"设置支付密码", nil];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    totalMoney = @"";
    
    //提现
    UIButton *sentBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 42, 25) backGruondImageName:@"home_flowerbasket_withdrawIcon72x44" Target:self Action:@selector(sent:) Title:@""];
    UIBarButtonItem *sentItem =[[UIBarButtonItem alloc]initWithCustomView:sentBtn];
    self.navigationItem.rightBarButtonItem =sentItem;
    
    [self fetchNetData];
    
    [self createTableView];
    
}


//提现
- (void)sent:(UIButton *)button{
    
    XXEAccountManagerViewController *accountManagerVC = [[XXEAccountManagerViewController alloc] init];
    
    accountManagerVC.fromFlagStr = @"wallet";

    [self.navigationController pushViewController:accountManagerVC animated:YES];
    
}

- (void)fetchNetData{
    
    XXESchoolWithdrawPageApi *schoolWithdrawPageApi = [[XXESchoolWithdrawPageApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:schoolId position:position];
    [schoolWithdrawPageApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSDictionary *dict = request.responseJSONObject[@"data"];
            
            //总 资产
            totalMoney = dict[@"money_able"];
            
            //提现 手续费
            fbasket_commission_per = dict[@"fbasket_commission_per"];
            
        [DEFAULTS setObject:totalMoney forKey:@"totalMoney"];
        [DEFAULTS setObject:fbasket_commission_per forKey:@"fbasket_commission_per"];
        }else{
            
        }
        
        [_myTableView reloadData];
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}




- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    
    cell.textLabel.text = _dataSourceArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
    headerView.backgroundColor = UIColorFromRGB(0, 170, 42);
    
    UILabel *titleLabel1 = [UILabel createLabelWithFrame:CGRectMake(10, 10, KScreenWidth - 20, 20) Font:14 Text:@"当前总资产"];
    titleLabel1.textColor = [UIColor whiteColor];
    [headerView addSubview:titleLabel1];
    
    UILabel *titleLabel2 = [UILabel createLabelWithFrame:CGRectMake(10, titleLabel1.frame.origin.y + titleLabel1.height + 20 * kScreenRatioHeight, KScreenWidth - 20, 20) Font:20 Text:@""];
    titleLabel2.text = [NSString stringWithFormat:@"¥%@元", totalMoney];
    titleLabel2.textColor = [UIColor whiteColor];
    [headerView addSubview:titleLabel2];
    
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
      //交易 记录
        XXETransactionRecordsViewController *transactionRecordsVC = [[XXETransactionRecordsViewController alloc] init];
        
        [self.navigationController pushViewController:transactionRecordsVC animated:YES];
        
    }else if (indexPath.row){
    //修改 支付 密码
        XXEModifyCodeViewController *modifyCodeVC = [[XXEModifyCodeViewController alloc] init];
        modifyCodeVC.fromflagStr = @"modifyPayCode";
        
        [self.navigationController pushViewController:modifyCodeVC animated:YES];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
