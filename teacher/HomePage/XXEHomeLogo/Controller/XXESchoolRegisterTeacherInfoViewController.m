
//
//  XXESchoolRegisterTeacherInfoViewController.m
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolRegisterTeacherInfoViewController.h"
#import "XXESchoolRegisterTeacherInfoTableViewCell.h"
#import "XXESchoolRegisterTeacherInfoApi.h"
#import "XXESchoolRegisterTeacherInfoModel.h"

@interface XXESchoolRegisterTeacherInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    NSInteger page;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@end

@implementation XXESchoolRegisterTeacherInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.topItem.title = @"小红花";
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

    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    
    [self createTableView];
    
}

- (void)fetchNetData{
    /*
     【猩课堂--某个学校的所有老师列表】
     
     接口类型:1
     
     接口:
     http://www.xingxingedu.cn/Global/school_teacher_list
     
     传参:
     school_id	//学校id
     page		//页码(加载更多),不传参默认1
     */
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
    
    XXESchoolRegisterTeacherInfoApi *schoolRegisterTeacherInfoApi = [[XXESchoolRegisterTeacherInfoApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE school_id:_schoolId page:pageStr];
    [schoolRegisterTeacherInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//    NSLog(@"2222---   %@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSDictionary *dict = request.responseJSONObject[@"data"];

            NSArray *modelArray = [XXESchoolRegisterTeacherInfoModel parseResondsData:dict];
            
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
    
    if (_dataSourceArray.count == 0) {
        
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 1、无数据的时候
        UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth / 2 - myImageWidth / 2, (KScreenHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];
        
    }else{
        //2、有数据的时候
        [_myTableView reloadData];
        
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
    XXESchoolRegisterTeacherInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXESchoolRegisterTeacherInfoTableViewCell" owner:self options:nil]lastObject];
    }
    XXESchoolRegisterTeacherInfoModel *model = _dataSourceArray[indexPath.row];
    /*
     0 :表示 自己 头像 ，需要添加 前缀
     1 :表示 第三方 头像 ，不需要 添加 前缀
     //判断是否是第三方头像
     */
    NSString *head_img = [kXXEPicURL stringByAppendingString:model.head_img];
    cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width / 2;
    cell.iconImageView.layer.masksToBounds = YES;
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"home_flowerbasket_placehoderIcon120x120"]];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@  年龄:%@岁", model.tname, model.age];
    cell.scoreLabel.text = [NSString stringWithFormat:@"%@分", model.score_num];
    cell.courseLabel.text = [NSString stringWithFormat:@"授课范围:%@", model.teach_course];
    cell.teachingTimeLabel.text = [NSString stringWithFormat:@"教龄:%@年", model.exper_year];
    
    /*
     certification = 0;         //0 :没认证  1:已认证
     "collect_condit" = 2;      //1代表收藏过, 2代表未收藏
     */
    if ([model.certification isEqualToString:@"0"]) {
        cell.certifyImageView.image = [UIImage imageNamed:@"home_logo_registerteacher_qualification_icon36x32"];
    }
    
    if ([model.collect_condit isEqualToString:@"1"]) {
        [cell.collectionButton setBackgroundImage:[UIImage imageNamed:@"home_logo_registerteacher_collect_icon36x32"] forState:UIControlStateNormal];
    }else if ([model.collect_condit isEqualToString:@"2"]) {
        [cell.collectionButton setBackgroundImage:[UIImage imageNamed:@"home_logo_registerteacher_uncollect_icon36x32"] forState:UIControlStateNormal];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    XXERedFlowerDetialViewController *redFlowerDetialVC = [[XXERedFlowerDetialViewController alloc] init];
//    
//    XXERedFlowerSentHistoryModel *model = _dataSourceArray[indexPath.row];
//    redFlowerDetialVC.name = model.tname;
//    redFlowerDetialVC.time = [XXETool dateStringFromNumberTimer:model.date_tm];
//    redFlowerDetialVC.schoolName = model.school_name;
//    redFlowerDetialVC.className = model.class_name;
//    redFlowerDetialVC.course = model.teach_course;
//    redFlowerDetialVC.content = model.con;
//    redFlowerDetialVC.picWallArray = model.pic_arr;
//    redFlowerDetialVC.iconUrl = model.head_img;
//    [self.navigationController pushViewController:redFlowerDetialVC animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
