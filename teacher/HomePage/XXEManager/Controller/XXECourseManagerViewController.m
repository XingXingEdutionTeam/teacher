

//
//  XXECourseManagerViewController.m
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECourseManagerViewController.h"
#import "XXECourseManagerCourseDetailInfoViewController.h"
#import "XXECourseManagerTableViewCell.h"
#import "XXECourseManagerModel.h"
#import "XXECourseManagerApi.h"



@interface XXECourseManagerViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    UIImageView *placeholderImageView;
    
    NSInteger page;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXECourseManagerViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    _dataSourceArray = [[NSMutableArray alloc] init];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    page = 0;
    
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

    self.title = @"管理";
    
//    [self fetchNetData];
    
    [self createTableView];
    
}


- (void)fetchNetData{
    /*
     【课程管理->课程列表(含草稿箱列表)】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Teacher/edit_course_list
     传参:
     school_id	//学校id
     condit 		//要求需要返回的数据   //0:待完善(草稿)  1:等待校长审核   2:等待官方审核  3:已上线(官方审核通过)  4:校长驳回  5:官方驳回    */
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
    
    XXECourseManagerApi *courseManagerApi = [[XXECourseManagerApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:_schoolId condit:_condit page:pageStr];
    [courseManagerApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//     NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {

            NSArray *modelArray = [XXECourseManagerModel parseResondsData:request.responseJSONObject[@"data"]];
            
            [_dataSourceArray addObjectsFromArray:modelArray];
        }else{
            
        }
        
        [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
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
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 160) style:UITableViewStyleGrouped];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];
    
    _myTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    _myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
    
    
}

-(void)loadNewData{
    page ++;
    
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
    XXECourseManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[XXECourseManagerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    XXECourseManagerModel *model = _dataSourceArray[indexPath.row];
    /*
     0 :表示 自己 头像 ，需要添加 前缀
     1 :表示 第三方 头像 ，不需要 添加 前缀
     //判断是否是第三方头像
     */
    NSString *head_img = [kXXEPicURL stringByAppendingString:model.course_pic];
    cell.bookIconImage.layer.cornerRadius = cell.bookIconImage.frame.size.width / 2;
    cell.bookIconImage.layer.masksToBounds = YES;
    
    [cell.bookIconImage sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    
    cell.courseNameLabel.text = model.course_name;
    
    if ([model.teacher_tname_group count] != 0) {
        
        for (int i = 0; i < [model.teacher_tname_group count]; i++) {
            UILabel *teacherNameLabel = [UILabel createLabelWithFrame:CGRectMake((190 + 65 * i) * kWidth / 375, 35 , 60 * kWidth / 375, 20) Font:14 * kWidth / 375 Text:model.teacher_tname_group[i]];
            [cell.contentView addSubview:teacherNameLabel];
        }
        
    }
    
    cell.totalNumberLabel.text = [NSString stringWithFormat:@"%@人班级", model.need_num];
    NSString *leftNumStr = [NSString stringWithFormat:@"%ld", [model.need_num integerValue] - [model.now_num integerValue]];
    cell.numberLabel.text = [NSString stringWithFormat:@"还剩%@人", leftNumStr];
    
    cell.oldPriceLabel.text = [NSString stringWithFormat:@"原价:%@", model.original_price];
    cell.nowPriceLbl.text = [NSString stringWithFormat:@"限时抢购价:%@", model.now_price];
    
    //    cell.coinImageView.image = [UIImage imageNamed:@"猩币icon28x30"];
    //    cell.reduceImageView.image = [UIImage imageNamed:@"退icon28x30@2x.png"];
    //    cell.saveImageView.image = [UIImage imageNamed:@"收藏icon28x30"];
    cell.fullImageView.image = [UIImage imageNamed:@"courseManager_full_icon28x30"];
    if ([leftNumStr integerValue] != 0) {
        cell.fullImageView.hidden = YES;
    }
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XXECourseManagerModel *model = _dataSourceArray[indexPath.row];
    
    XXECourseManagerCourseDetailInfoViewController *courseManagerCourseDetailInfoVC = [[XXECourseManagerCourseDetailInfoViewController alloc] init];
    courseManagerCourseDetailInfoVC.schoolId = _schoolId;
    courseManagerCourseDetailInfoVC.schoolType = _schoolType;
    courseManagerCourseDetailInfoVC.classId = _classId;
    courseManagerCourseDetailInfoVC.position = _position;
    
    //courseId
    courseManagerCourseDetailInfoVC.courseId = model.course_id;
    
    [self.navigationController pushViewController:courseManagerCourseDetailInfoVC animated:YES];
}


@end
