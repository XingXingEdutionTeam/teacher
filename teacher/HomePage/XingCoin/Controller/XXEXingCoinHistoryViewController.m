

//
//  XXEXingCoinHistoryViewController.m
//  teacher
//
//  Created by Mac on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingCoinHistoryViewController.h"
#import "XXEXingCoinHistoryTableViewCell.h"
#import "XXEXingCoinHistoryModel.h"
#import "XXEXingCoinHistoryApi.h"

#define URL @"http://www.xingxingedu.cn/Global/select_coin_msg"


@interface XXEXingCoinHistoryViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    UIImageView *placeholderImageView;
    
    NSInteger page;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@end

@implementation XXEXingCoinHistoryViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    _dataSourceArray = [[NSMutableArray alloc] init];
    
    page = 0;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    [_myTableView reloadData];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_myTableView.header beginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"猩币历史";
    
    [self createTableView];
}

- (void)fetchNetData{
    /*
     【猩猩商城--查询猩币变更记录】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Global/select_coin_msg
     传参:
     require_con = "4"	//想要查询的内容,如果是空默认全部类型,4代表互赠
     year = "2016"		//可以查询某一年,如果是空,查询所有年份的猩币记录
     page
     */
    
//    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
    
    XXEXingCoinHistoryApi *xingCoinHistoryApi = [[XXEXingCoinHistoryApi alloc] initWithXid:parameterXid user_id:parameterUser_Id require_con:@"" year:@"" page:@""];
    [xingCoinHistoryApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        _dataSourceArray = [[NSMutableArray alloc] init];
        
//        NSLog(@"111   %@", request.responseJSONObject);
        
        NSDictionary *dict = request.responseJSONObject;
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", dict[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSArray *keys = [dict[@"data"] allKeys];
            
            NSMutableArray *categoryArray=[NSMutableArray array];
            NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj2 compare:obj1 options:NSNumericSearch];
            }];
            for (NSString *categoryId in sortedArray) {
                [categoryArray addObject:[dict[@"data"]  objectForKey:categoryId]];
                
            }
            
            NSArray *modelArray = [XXEXingCoinHistoryModel parseResondsData:categoryArray];
            
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
    // 如果 有占位图 先 移除
    [self removePlaceholderImageView];
    
    if (_dataSourceArray.count == 0) {
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 1、无数据的时候
        [self createPlaceholderView];
        
    }else{
        //2、有数据的时候
    }
    
    [_myTableView reloadData];
    
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


- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];
    
    _myTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    _myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
    
    
}

-(void)loadNewData{
    page ++ ;
    
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
    XXEXingCoinHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[XXEXingCoinHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    XXEXingCoinHistoryModel *model = _dataSourceArray[indexPath.row];
    
    cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width / 2;
    cell.iconImageView.layer.masksToBounds = YES;
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"home_flowerbasket_placehoderIcon120x120"]];
//    cell.timeLabel.text = [XXETool dateStringFromNumberTimer:model.date_tm];
    NSString *timeString =[XXETool dateStringFromNumberTimer:model.date_tm];
    NSArray *arr = [NSArray arrayWithArray:[timeString componentsSeparatedByString:@" "]];
    cell.timeLabel1.text = arr[0];
    cell.timeLabel2.text = arr[1];
    
    cell.useLabel.text = model.con;
    cell.moneyLabel.text = model.coin_num;
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
    headerView.backgroundColor = [UIColor whiteColor];
    
//    CGFloat labelWidth = KScreenWidth / 3;
    UILabel *titleLabel1 = [UILabel createLabelWithFrame:CGRectMake(80 * kScreenRatioWidth, 5, 135 * kScreenRatioWidth, 20 * kScreenRatioHeight) Font:16 * kScreenRatioHeight Text:@"时间"];
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel1];
    
    UILabel *titleLabel2 = [UILabel createLabelWithFrame:CGRectMake(215 * kScreenRatioWidth, 5, 80 * kScreenRatioWidth, 20 * kScreenRatioHeight) Font:16 * kScreenRatioHeight Text:@"用途"];
    titleLabel2.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel2];
    
    UILabel *titleLabel3 = [UILabel createLabelWithFrame:CGRectMake(295 * kScreenRatioWidth, 5, 80 * kScreenRatioWidth, 20 * kScreenRatioHeight) Font:16 * kScreenRatioHeight Text:@"金额"];
    titleLabel3.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel3];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


@end
