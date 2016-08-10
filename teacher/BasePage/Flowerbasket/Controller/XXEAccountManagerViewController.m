




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


@interface XXEAccountManagerViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

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
    
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Teacher/financial_account_list";
    
    //请求参数
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":XID,
                             @"user_id":USER_ID,
                             @"user_type":USER_TYPE
                             };
    [XXEHttpTool post:urlStr params:params success:^(id responseObj) {
        _dataSourceArray = [[NSMutableArray alloc] init];
        //
//        NSLog(@"%@", responseObj);
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            NSArray *modelArray = [XXEAccountManagerModel parseResondsData:responseObj[@"data"]];
            
            [_dataSourceArray addObjectsFromArray:modelArray];
            
        }else{
            
        }
        
        [self customContent];
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
        
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
    cell.accountNumberLabel.text = model.account;
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00001;
}



@end
