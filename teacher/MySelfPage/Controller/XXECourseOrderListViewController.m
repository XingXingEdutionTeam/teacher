

//
//  XXECourseOrderListViewController.m
//  teacher
//
//  Created by Mac on 2016/11/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECourseOrderListViewController.h"
#import "XXECourseOrderListViewTableViewCell.h"
#import "XXECourseOrderListModel.h"
#import "XXECourseOrderDetailViewController.h"

@interface XXECourseOrderListViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    UISegmentedControl *_segmentedControl;
    NSMutableDictionary  *_listVCQueue;
    
    UITableView *_myTableView;
    NSMutableArray *_dataSourceArray;
    
    UIImageView *placeholderImageView;
    NSString *school_id;
    NSString *condit;
    
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@end

@implementation XXECourseOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XXEBackgroundColor;
    
    self.title = @"我的订单";
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    school_id = [DEFAULTS objectForKey:@"SCHOOL_ID"];
    
    [self createSegmentedControl];
    
    [self createTableView];
    
    [self  fetchNetData:@"0"];
    
}

- (void)createSegmentedControl{
    
    NSArray *titleArray = [[NSArray alloc] initWithObjects:@"待支付", @"已支付", @"待评价", @"已评价",  nil];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:titleArray];
    _segmentedControl.frame = CGRectMake(5, 10, KScreenWidth - 10, 35);
    _segmentedControl.tintColor = UIColorFromRGB(0, 170, 42);
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    
    [_segmentedControl addTarget:self action:@selector(didClickSegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];
    
}

- (void)didClickSegmentedControlAction:(UISegmentedControl *)seg{
    if (!_listVCQueue) {
        _listVCQueue=[[NSMutableDictionary alloc] init];
    }
    
    condit = [NSString stringWithFormat:@"%ld", seg.selectedSegmentIndex];
    
    [self fetchNetData:condit];
    
}


- (void)fetchNetData:(NSString *)conditStr{
    /*
     【猩课堂--课程订单列表(我的订单)】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Global/course_order_list
     传参:
     condit		//订单状态 0:待付款 ,1:已付款, 2:待评价 ,3:已评价
     school_id	//学校id,教师端调用此接口时必须传参*/
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/course_order_list";
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"condit":conditStr,
                             @"school_id":school_id
                             };
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        _dataSourceArray = [[NSMutableArray alloc] init];
        
        //
//                NSLog(@"kkkk %@", responseObj);
        
        if ([responseObj[@"code"] integerValue] == 1) {
            
            NSArray *modelArray = [[NSArray alloc] init];
            
            modelArray = [XXECourseOrderListModel parseResondsData:responseObj[@"data"]];
            
            [_dataSourceArray addObjectsFromArray:modelArray];
            
        }
        [self customContent];
        
    } failure:^(NSError *error) {
        //
        [self showString:@"获取数据失败!" forSecond:1.5];
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
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, KScreenHeight - 50) style:UITableViewStyleGrouped];
    //    _myTableView.backgroundColor = [UIColor redColor];
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
    static NSString *identifier = @"cell";
    XXECourseOrderListViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXECourseOrderListViewTableViewCell" owner:self options:nil]lastObject];
    }
    XXECourseOrderListModel *model = _dataSourceArray[indexPath.row];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, model.pic]] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    
    cell.titleLabel.text = model.course_name;
    cell.schoolLabel.text = model.school_name;
    //0:待支付 1:已支付 2:待评价 3:已评价
    if ([condit integerValue] == 0) {
        cell.stateLabel.text = @"待支付";
        cell.stateLabel.textColor = [UIColor redColor];
    }else if ([condit integerValue] == 1) {
        cell.stateLabel.text = @"已支付";
        cell.stateLabel.textColor = [UIColor lightGrayColor];
    }else if ([condit integerValue] == 2) {
        cell.stateLabel.text = @"待评价";
        cell.stateLabel.textColor = [UIColor redColor];
    }else if ([condit integerValue] == 3) {
        cell.stateLabel.text = @"已评价";
        cell.stateLabel.textColor = [UIColor lightGrayColor];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XXECourseOrderDetailViewController*courseOrderDetailVC=  [[XXECourseOrderDetailViewController alloc]init];
    XXECourseOrderListModel *model = _dataSourceArray[indexPath.row];
    courseOrderDetailVC.order_id=model.course_order_Id;
    courseOrderDetailVC.stateFlagStr = condit;
    [self.navigationController pushViewController:courseOrderDetailVC animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
