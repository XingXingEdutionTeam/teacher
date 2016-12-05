


//
//  XXEChiefAndTeacherViewController.m
//  teacher
//
//  Created by Mac on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEChiefAndTeacherViewController.h"
#import "XXEChiefAndTeacherTableViewCell.h"
#import "XXEChiefAndTeacherModel.h"
#import "XXEChiefAndTeacherApi.h"


@interface XXEChiefAndTeacherViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    UIImageView *placeholderImageView;
    
    NSMutableArray *_dataSourceArray;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@property (nonatomic , strong) NSMutableArray *selectedBabyInfoArr;

@end

@implementation XXEChiefAndTeacherViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    
    self.title = @"";
    
//    [self fetchNetData];
    
    [self createTableView];
    
}



- (void)fetchNetData{
    /*
     //身份  主任和老师 调用下面接口
     【学生列表(某个班级)】多个模块用到此接口
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Teacher/baby_list_oneclass
     传参:
     school_id	//学校id 
     class_id	//班级id    */
//    NSLog(@"%@---  %@", _schoolId, _classId);
    
    XXEChiefAndTeacherApi *chiefAndTeacherApi = [[XXEChiefAndTeacherApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE school_id:_schoolId class_id:_classId];
    [chiefAndTeacherApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        _dataSourceArray = [[NSMutableArray alloc] init];
        
//        NSLog(@"111   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {

            NSArray *modelArray = [XXEChiefAndTeacherModel parseResondsData:request.responseJSONObject[@"data"]];
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
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];
    
    _myTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    _myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
    
    
}

-(void)loadNewData{
    
    [self fetchNetData];
    [ _myTableView.header endRefreshing];
}
-(void)endRefresh{
    [_myTableView.header endRefreshing];
    [_myTableView.footer endRefreshing];
}

- (void)loadFooterNewData{
    
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
    XXEChiefAndTeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEChiefAndTeacherTableViewCell" owner:self options:nil]lastObject];
    }
    XXEChiefAndTeacherModel *model = _dataSourceArray[indexPath.row];
    /*
     0 :表示 自己 头像 ，需要添加 前缀
     1 :表示 第三方 头像 ，不需要 添加 前缀
     //判断是否是第三方头像
     */
    NSString *head_img = [kXXEPicURL stringByAppendingString:model.head_img];
    cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width / 2;
    cell.iconImageView.layer.masksToBounds = YES;
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"home_flowerbasket_placehoderIcon120x120"]];
    cell.nameLabel.text = model.tname;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

//    NSLog(@"hhh %@", _dataSourceArray);
    
    XXEChiefAndTeacherModel *model = _dataSourceArray[indexPath.row];
    
    if ([_didSelectBabyIdArray containsObject:model.baby_id]) {
        [self showString:@"该宝贝已选中,请重新选择赠送对象!" forSecond:1.5];
    }else{
        //选中 宝贝 头像/名称/id
        _selectedBabyInfoArr = [[NSMutableArray alloc] initWithObjects:model.head_img, model.tname, model.baby_id, model.school_id, model.class_id, nil];
        
//        NSLog(@"kk %@", _selectedBabyInfoArr);
        
        self.ReturnArrayBlock(_selectedBabyInfoArr);
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)returnArray:(ReturnArrayBlock)block{
    self.ReturnArrayBlock = block;
    
}


@end
