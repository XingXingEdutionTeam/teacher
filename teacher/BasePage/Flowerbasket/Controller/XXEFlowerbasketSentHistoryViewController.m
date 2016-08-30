


//
//  XXEFlowerbasketSentHistoryViewController.m
//  teacher
//
//  Created by Mac on 16/8/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFlowerbasketSentHistoryViewController.h"
#import "XXEFlowerbasketSentHistoryApi.h"
#import "XXEFlowerbasketSentHistoryModel.h"
#import "XXEFlowerbasketTableViewCell.h"

#define URL @"http://www.xingxingedu.cn/Teacher/fbasket_withdraw_record"


@interface XXEFlowerbasketSentHistoryViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    NSInteger page;
}


@end

@implementation XXEFlowerbasketSentHistoryViewController


- (void)viewWillAppear:(BOOL)animated{
    page = 1;
    
    [_myTableView reloadData];
    
}
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
    
//    _dataSourceArray = [[NSMutableArray alloc] init];
    
    self.title = @"花篮提现记录";
    
    //    [self fetchNetData];
    
    [self createTableView];
    
}


- (void)fetchNetData{
    /*
     【花篮->花篮提现记录】
     
     接口类型:1
     
     接口:
     http://www.xingxingedu.cn/Teacher/fbasket_withdraw_record
     
     传参:
     */
    
//    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
    
    XXEFlowerbasketSentHistoryApi *flowerbasketSentHistoryApi = [[XXEFlowerbasketSentHistoryApi alloc] initWithUrlString:URL appkey:APPKEY backtype:BACKTYPE xid:XID user_id:USER_ID user_type:USER_TYPE];
    [flowerbasketSentHistoryApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        _dataSourceArray = [[NSMutableArray alloc] init];
        //        NSLog(@"111   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            NSArray *modelArray = [XXEFlowerbasketSentHistoryModel parseResondsData:request.responseJSONObject[@"data"]];
            
            [_dataSourceArray addObjectsFromArray:modelArray];
        }else{
            
        }
        
        [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
//        NSLog(@"222  %@", request);
        
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
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight) style:UITableViewStyleGrouped];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
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
    page ++ ;
    
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
    XXEFlowerbasketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEFlowerbasketTableViewCell" owner:self options:nil]lastObject];
    }
    XXEFlowerbasketSentHistoryModel *model = _dataSourceArray[indexPath.row];
    /*
     0 :表示 自己 头像 ，需要添加 前缀
     1 :表示 第三方 头像 ，不需要 添加 前缀
     //判断是否是第三方头像
     */
//    NSString * head_img;
//    if([[NSString stringWithFormat:@"%@",model.head_img_type]isEqualToString:@"0"]){
//        head_img = [picURL stringByAppendingString:model.head_img];
//    }else{
//        head_img = model.head_img;
//    }
    
//    cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width / 2;
//    cell.iconImageView.layer.masksToBounds = YES;
    
//    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"SCHOOLLOGO172x172"]];
    cell.nameLabel.text = [XXETool dateStringFromNumberTimer:model.tname];
    //[condit] => 0			//0:处理中  1:处理完成
    if ([model.condit isEqualToString:@"0"]) {
      cell.numberLabel.text = @"处理中......";
    }else if ([model.condit isEqualToString:@"1"]){
       cell.numberLabel.text = @"提现成功!";
    }
    cell.contentLabel.text = [NSString stringWithFormat:@"提现%@个花篮   +%@元", model.num, model.money];
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00001;
}


@end
