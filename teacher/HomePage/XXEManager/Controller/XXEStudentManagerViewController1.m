

//
//  XXEStudentManagerViewController1.m
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStudentManagerViewController1.h"
#import "XXEStudentManagerTableViewCell.h"
#import "XXEStudentManagerMoveToClassViewController.h"
#import "XXEStudentManagerApi.h"
#import "XXEStudentManagerDeleteApi.h"
#import "XXEBabyInfoViewController.h"
#import "XXEClassModel.h"
#import "XXEStudentModel.h"

@interface XXEStudentManagerViewController1 ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    //班级 model 数组
    NSMutableArray *classModelArray;
    //学生 model 数组
    NSMutableArray *studentModelArray;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}
@property (nonatomic, strong) UIButton *moveBtn;

@property (nonatomic, strong) UIButton *deletebtn;

@end

@implementation XXEStudentManagerViewController1

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_myTableView reloadData];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_myTableView.header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
//    NSLog(@"%@ ---- %@ ----- %@ ---- %@ --- %@", parameterXid, parameterUser_Id, _schoolId, _schoolType, _classId);
    self.title = @"管理";
    
//    [self fetchNetData];
    
    [self createTableView];
    
}


- (void)fetchNetData{
    
    XXEStudentManagerApi *studentManagerApi = [[XXEStudentManagerApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:_schoolId school_type:_schoolType class_id:_classId position:_position];
    
    [studentManagerApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        classModelArray = [[NSMutableArray alloc] init];
//        NSLog(@"111   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            NSArray *classModelArr = [[NSArray alloc] init];
            classModelArr = [XXEClassModel parseResondsData:request.responseJSONObject[@"data"]];
            [classModelArray addObjectsFromArray:classModelArr];
 
        }else{
            
        }
        [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}



// 有数据 和 无数据 进行判断
- (void)customContent{
    
    if (classModelArray.count == 0) {
        
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
    }
    [_myTableView reloadData];
}


- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 50) style:UITableViewStyleGrouped];
    
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
    
    XXEClassModel *model = classModelArray[section];
    return model.baby_list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXEStudentManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEStudentManagerTableViewCell" owner:self options:nil]lastObject];
    }
    
    //宝贝 信息
    XXEClassModel *classModel = classModelArray[indexPath.section];
    XXEStudentModel *model = classModel.baby_list[indexPath.row];
    //宝贝 头像 全部 是拼接 的
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, model.head_img]] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width / 2;
    cell.iconImageView.layer.masksToBounds = YES;
    cell.titleLabel.text = model.tname;
    cell.timeLabel.text = [XXETool dateStringFromNumberTimer:model.date_tm];
    
    //点击 头像 进入 宝贝详情 界面
    cell.iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *iconTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconTap:)];
    cell.iconImageView.tag =100+indexPath.row;
    [cell.iconImageView addGestureRecognizer:iconTap];
    
    
#warning position 1:教师  2:主任  3:管理员  4:校长  === XXEStudentManagerViewController1控制器针对 1/2 ,但是1没有  "移动"/"删除" 学生的操作,故当1时,隐藏 "移动"/"删除" 按钮
    
    if ([_position isEqualToString:@"2"] || [_position isEqualToString:@"3"] || [_position isEqualToString:@"4"]) {
    
        //移动 按钮
        _moveBtn = [UIButton createButtonWithFrame:CGRectMake(260 * kScreenRatioWidth, 27, 50 * kScreenRatioWidth, 25 * kScreenRatioHeight) backGruondImageName:nil Target:self Action:@selector(onClickMoveBtn:) Title:@"移动"];
        [_moveBtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
        _moveBtn.titleLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
        [_moveBtn.layer setBorderColor:UIColorFromRGB(0, 170, 42).CGColor];
        [_moveBtn.layer setBorderWidth:1];
        [_moveBtn.layer setMasksToBounds:YES];
        
        //删除 按钮
        _deletebtn = [UIButton createButtonWithFrame:CGRectMake(315 * kScreenRatioWidth, 27, 50 * kScreenRatioWidth, 25 * kScreenRatioHeight) backGruondImageName:nil Target:self Action:@selector(onClickDeleteBtn:) Title:@"删除"];
        [_deletebtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
        _deletebtn.titleLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
        [_deletebtn.layer setBorderColor:UIColorFromRGB(0, 170, 42).CGColor];
        [_deletebtn.layer setBorderWidth:1];
        [_deletebtn.layer setMasksToBounds:YES];
        
        [cell.contentView addSubview:_moveBtn];
        [cell.contentView addSubview:_deletebtn];
        
        _moveBtn.tag=100;
        _deletebtn.tag=101;
    }   
    
    return cell;
}

- (void)iconTap:(UITapGestureRecognizer*)tap{
    XXEStudentManagerTableViewCell *cell = (XXEStudentManagerTableViewCell *)[[tap.view superview] superview];
    NSIndexPath *path = [_myTableView indexPathForCell:cell];
    XXEClassModel *classModel = classModelArray[path.section];
    XXEStudentModel *model = classModel.baby_list[tap.view.tag - 100];
    //    if ([XXEUserInfo user].login){
    XXEBabyInfoViewController *babyInfoVC =[[XXEBabyInfoViewController alloc]init];
    
    babyInfoVC.babyId = model.baby_id;
    
    babyInfoVC.babyClassName = classModel.class_name;
    [self.navigationController pushViewController:babyInfoVC animated:NO];
    //    }else{
    //        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
    //    }
    
}



-(void)onClickMoveBtn:(UIButton *)button{
    XXEStudentManagerTableViewCell *cell = (XXEStudentManagerTableViewCell *)[[button superview] superview];
    NSIndexPath *path = [_myTableView indexPathForCell:cell];
    XXEClassModel *classModel = classModelArray[path.section];
    XXEStudentModel *stuModel = classModel.baby_list[path.row];
    
    XXEStudentManagerMoveToClassViewController *studentManagerMoveToClassVC = [[XXEStudentManagerMoveToClassViewController alloc] init];
    
    studentManagerMoveToClassVC.schoolId = _schoolId;
    studentManagerMoveToClassVC.schoolType = _schoolType;
    studentManagerMoveToClassVC.currentSelectedClassId = classModel.class_id;
    studentManagerMoveToClassVC.babyId = stuModel.baby_id;
    
    [self.navigationController pushViewController:studentManagerMoveToClassVC animated:YES];
}

-(void)onClickDeleteBtn:(UIButton *)button{
    XXEStudentManagerTableViewCell *cell = (XXEStudentManagerTableViewCell *)[[button superview] superview];
    NSIndexPath *path = [_myTableView indexPathForCell:cell];
    XXEClassModel *classModel = classModelArray[path.section];
    XXEStudentModel *stuModel = classModel.baby_list[path.row];
    
    //当前 所要删除 学生 的 babyid 及 所在 的classid
    NSString *currentClassId = classModel.class_id;
    NSString *currentBabyId = stuModel.baby_id;
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定删除？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
#pragma mark - 删除=======================================
        [self deleteStudentInfo:currentClassId andWithBabyId:currentBabyId andIndexPath:path];
        
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)deleteStudentInfo:(NSString *)currentClassId andWithBabyId:(NSString *)currentBabyId andIndexPath:(NSIndexPath *)path{
    
    XXEStudentManagerDeleteApi *studentManagerDeleteApi = [[XXEStudentManagerDeleteApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:_schoolId class_id:currentClassId baby_id:currentBabyId];
    
    [studentManagerDeleteApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        //              NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"删除成功!" forSecond:1.5];
            //从 数据源中 删除
            XXEClassModel *classModel = classModelArray[path.section];
            [classModel.baby_list removeObjectAtIndex:path.row];
            //从 列表 中 删除
            [_myTableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            
        }
        [_myTableView reloadData];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showHudWithString:@"提交失败!" forSecond:1.5];
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    XXEClassModel *classModel = classModelArray[section];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    NSString *classNameStr ;
    NSString *numStr;
    if (classModel.class_name == nil) {
        classNameStr = @"";
    }else{
        classNameStr = classModel.class_name;
    }
    if (classModel.num == nil) {
        numStr = @"";
    }else{
        numStr = classModel.num;
    }

    
    CGFloat labelWidth = KScreenWidth ;
    UILabel *titleLabel1 = [UILabel createLabelWithFrame:CGRectMake(0, 10, labelWidth, 20) Font:14 Text:@""];
    
    titleLabel1.text = [NSString stringWithFormat:@"%@(%@人)",classNameStr, numStr];
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel1];

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
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
//    redFlowerDetialVC.collect_conditStr =model.collect_condit;
//    redFlowerDetialVC.collect_id = model.collectionId;
//    [self.navigationController pushViewController:redFlowerDetialVC animated:YES];
    
}


@end
