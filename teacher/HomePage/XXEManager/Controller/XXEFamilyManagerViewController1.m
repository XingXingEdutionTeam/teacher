//
//  XXEFamilyManagerViewController1.m
//  teacher
//
//  Created by Mac on 16/9/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFamilyManagerViewController1.h"
#import "XXEFamilyManagerPersonInfoModel.h"
#import "XXEFamilyManagerClassInfoModel.h"
#import "XXERedFlowerSentHistoryTableViewCell.h"
#import "XXEBabyFamilyInfoDetailViewController.h"
#import "XXEFamilyManagerRefuseApi.h"
#import "XXEFamilyManagerDeleteApi.h"
#import "XXEFamilyManagerAgreeApi.h"
#import "XXEFamilyManagerApi.h"

@interface XXEFamilyManagerViewController1 ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    //班级 model 数组
    NSMutableArray *classModelArray;
    //学生 model 数组
    NSMutableArray *studentModelArray;
    //占位图
    UIImageView *placeholderImageView;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}
//同意 按钮
@property (nonatomic, strong) UIButton *agreeBtn;
//拒绝 按钮
@property (nonatomic, strong) UIButton *refuseBtn;
//删除 按钮
@property (nonatomic, strong) UIButton *deletebtn;


@end

@implementation XXEFamilyManagerViewController1

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
    
    XXEFamilyManagerApi *familyManagerApi = [[XXEFamilyManagerApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:_schoolId school_type:_schoolType class_id:_classId position:_position];
    
    [familyManagerApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        classModelArray = [[NSMutableArray alloc] init];
//        NSLog(@"111   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            NSArray *classModelArr = [[NSArray alloc] init];
            classModelArr = [XXEFamilyManagerClassInfoModel parseResondsData:request.responseJSONObject[@"data"]];
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
    // 如果 有占位图 先 移除
    [self removePlaceholderImageView];
    
    if (classModelArray.count == 0) {
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
    
    XXEFamilyManagerClassInfoModel *model = classModelArray[section];
    return model.parent_list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXERedFlowerSentHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXERedFlowerSentHistoryTableViewCell" owner:self options:nil]lastObject];
    }

    //宝贝 信息
    XXEFamilyManagerClassInfoModel *classModel = classModelArray[indexPath.section];
    XXEFamilyManagerPersonInfoModel *studentModel = classModel.parent_list[indexPath.row];
    
    //宝贝 头像 全部 是拼接 的
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, studentModel.head_img]] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width / 2;
    cell.iconImageView.layer.masksToBounds = YES;
    cell.titleLabel.text = studentModel.tname;
    if (![studentModel.relation_name isEqualToString:@""]) {
        cell.contentLabel.text = [NSString stringWithFormat:@"%@的%@", studentModel.baby_tname, studentModel.relation_name];
    }
    cell.timeLabel.text = [XXETool dateStringFromNumberTimer:studentModel.date_tm];
    
    //点击 头像 进入 宝贝详情 界面
    cell.iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *iconTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconTap:)];
    cell.iconImageView.tag =100+indexPath.row;
    [cell.iconImageView addGestureRecognizer:iconTap];
    
    /*
     16.家长管理,删除按钮的权限,授课老师看不见这个按钮,其他3个身份才可以操作删除
     
     17.家长管理和教师管理,班级年级后面写上需要显示已审核的家人数,待审核人的人数
     18.家长管理和教师管理,待审核状态只有2个按钮,同意和拒绝,拒绝的时候需要提醒用户:是否不在接收此用户的申请
     19.家长管理和教师管理,审核通过的只有1个删除按钮
     
     [condit] => 0 	 //0:待审核 1:审核通过
     */
#warning position 1:教师  2:主任  3:管理员  4:校长  === XXEStudentManagerViewController1控制器针对 1/2 ,但是1没有  "移动"/"删除" 学生的操作,故当1时,隐藏 "移动"/"删除" 按钮
    if ([_position isEqualToString:@"2"] || [_position isEqualToString:@"3"] || [_position isEqualToString:@"4"]) {
        if ([studentModel.condit isEqualToString:@"0"]) {
            _agreeBtn = [UIButton createButtonWithFrame:CGRectMake(245 * kScreenRatioWidth, 27, 50, 25) backGruondImageName:nil Target:self Action:@selector(onClickagreeBtn:) Title:@"同意"];
            [_agreeBtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
            _agreeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [_agreeBtn.layer setBorderColor:UIColorFromRGB(0, 170, 42).CGColor];
            [_agreeBtn.layer setBorderWidth:1];
            [_agreeBtn.layer setMasksToBounds:YES];
            
            _refuseBtn = [UIButton createButtonWithFrame:CGRectMake(300 * kScreenRatioWidth, 27, 50, 25) backGruondImageName:nil Target:self Action:@selector(onClickRefuseBtn:) Title:@"拒绝"];
            [_refuseBtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
            _refuseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [_refuseBtn.layer setBorderColor:UIColorFromRGB(0, 170, 42).CGColor];
            [_refuseBtn.layer setBorderWidth:1];
            [_refuseBtn.layer setMasksToBounds:YES];
            
            [cell.contentView addSubview:_agreeBtn];
            [cell.contentView addSubview:_refuseBtn];
            
            _agreeBtn.tag=100;
            _refuseBtn.tag=101;
        }else if ([studentModel.condit isEqualToString:@"1"]){
            _deletebtn = [UIButton createButtonWithFrame:CGRectMake(300 * kScreenRatioWidth, 27, 50, 25) backGruondImageName:nil Target:self Action:@selector(onClickDeleteBtn:) Title:@"删除"];
            [_deletebtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
            _deletebtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [_deletebtn.layer setBorderColor:UIColorFromRGB(0, 170, 42).CGColor];
            [_deletebtn.layer setBorderWidth:1];
            [_deletebtn.layer setMasksToBounds:YES];
            
            [cell.contentView addSubview:_deletebtn];
            
            _deletebtn.tag=102;
        }
 
    }

    return cell;
}

- (void)iconTap:(UITapGestureRecognizer*)tap{
    XXERedFlowerSentHistoryTableViewCell *cell = (XXERedFlowerSentHistoryTableViewCell *)[[tap.view superview] superview];
    NSIndexPath *path = [_myTableView indexPathForCell:cell];
    XXEFamilyManagerClassInfoModel *classModel = classModelArray[path.section];
    XXEFamilyManagerPersonInfoModel *stuModel = classModel.parent_list[tap.view.tag - 100];
    //    if ([XXEUserInfo user].login){
    XXEBabyFamilyInfoDetailViewController *babyFamilyInfoDetailVC = [[XXEBabyFamilyInfoDetailViewController alloc] init];
    babyFamilyInfoDetailVC.baby_id = stuModel.baby_id;
    babyFamilyInfoDetailVC.parent_id = stuModel.examine_id;
    [self.navigationController pushViewController:babyFamilyInfoDetailVC animated:YES];
    //    }else{
    //        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
    //    }
    
}

-(void)onClickagreeBtn:(UIButton *)btn{
    
    XXERedFlowerSentHistoryTableViewCell *cell = (XXERedFlowerSentHistoryTableViewCell *)[[btn superview] superview];
    
    NSIndexPath *path = [_myTableView indexPathForCell:cell];
    
    XXEFamilyManagerClassInfoModel *classModel = classModelArray[path.section];
    XXEFamilyManagerPersonInfoModel *stuModel = classModel.parent_list[path.row];
    
    //当前 所要删除 学生 的 babyid 及 所在 的classid
    //    NSString *currentClassId = classModel.class_id;
    NSString *currentparentId = stuModel.examine_id;
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"同意申请？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self agreeFamilyInfo:currentparentId];
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)agreeFamilyInfo:(NSString *)currentparentId{
    XXEFamilyManagerAgreeApi *familyManagerAgreeApi = [[XXEFamilyManagerAgreeApi alloc] initWithXid:parameterXid user_id:parameterUser_Id examine_id:currentparentId];
    
    [familyManagerAgreeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        //        NSLog(@"同意 2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"审核通过!" forSecond:1.5];
            
        }else{
            
        }
        
        [self fetchNetData];
        
        [_myTableView reloadData];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showHudWithString:@"提交失败!" forSecond:1.5];
    }];
    
    
}


-(void)onClickRefuseBtn:(UIButton *)btn{
    XXERedFlowerSentHistoryTableViewCell *cell = (XXERedFlowerSentHistoryTableViewCell *)[[btn superview] superview];
    
    NSIndexPath *path = [_myTableView indexPathForCell:cell];
    
    XXEFamilyManagerClassInfoModel *classModel = classModelArray[path.section];
    XXEFamilyManagerPersonInfoModel *stuModel = classModel.parent_list[path.row];
    
    //当前 所要删除 学生 的 babyid 及 所在 的classid
    //    NSString *currentClassId = classModel.class_id;
    NSString *currentparentId = stuModel.examine_id;
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"拒绝该申请？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self refuseFamilyInfo:currentparentId andIndexPath:path];
        
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)refuseFamilyInfo:(NSString *)currentparentId andIndexPath:(NSIndexPath *)path{
    
    XXEFamilyManagerRefuseApi *familyManagerRefuseApi = [[XXEFamilyManagerRefuseApi alloc] initWithXid:parameterXid user_id:parameterUser_Id examine_id:currentparentId];
    
    [familyManagerRefuseApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        //    NSLog(@"拒绝 2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            //从 数据源中 删除
            XXEFamilyManagerClassInfoModel *classModel = classModelArray[path.section];
            [classModel.parent_list removeObjectAtIndex:path.row];
            //从 列表 中 删除
            [_myTableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            
        }
        [self fetchNetData];
        [_myTableView reloadData];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showHudWithString:@"提交失败!" forSecond:1.5];
    }];
    
    
}


-(void)onClickDeleteBtn:(UIButton *)button{
    XXERedFlowerSentHistoryTableViewCell *cell = (XXERedFlowerSentHistoryTableViewCell *)[[button superview] superview];
    NSIndexPath *path = [_myTableView indexPathForCell:cell];
    XXEFamilyManagerClassInfoModel *classModel = classModelArray[path.section];
    XXEFamilyManagerPersonInfoModel *stuModel = classModel.parent_list[path.row];
    
    //当前 所要删除 学生 的 babyid 及 所在 的classid
    NSString *currentClassId = classModel.class_id;
    NSString *currentParentId = stuModel.parent_id;
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定删除？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
#pragma mark - 删除=======================================
        [self deleteStudentInfo:currentClassId andWithParentId:currentParentId andIndexPath:path];
        
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}



- (void)deleteStudentInfo:(NSString *)currentClassId andWithParentId:(NSString *)currentParentId andIndexPath:(NSIndexPath *)path{

//    NSLog(@"%@ --- %@ -- %@", _schoolId ,currentClassId, currentParentId);
    
    XXEFamilyManagerDeleteApi *familyManagerDeleteApi = [[XXEFamilyManagerDeleteApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:_schoolId class_id:currentClassId parent_id:currentParentId];
    
    [familyManagerDeleteApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//        NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"删除成功!" forSecond:1.5];
            //从 数据源中 删除
            XXEFamilyManagerClassInfoModel *classModel = classModelArray[path.section];
            [classModel.parent_list removeObjectAtIndex:path.row];
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
    
    return 95;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    XXEFamilyManagerClassInfoModel *model = classModelArray[section];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    
    NSString *classNameStr ;
    NSString *numStr;
    NSString *wait_numStr;
    //班级名称
    if (model.class_name == nil) {
        classNameStr = @"";
    }else{
        classNameStr = model.class_name;
    }
    //已审核的家人数
    if (model.num == nil) {
        numStr = @"";
    }else{
        numStr = model.num;
    }
    //待审核的家人数
    if (model.wait_num == nil) {
        wait_numStr = @"";
    }else{
        wait_numStr = model.wait_num;
    }
    
    //班级名称
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * kScreenRatioWidth, 5, 200 * kScreenRatioWidth, 30 * kScreenRatioHeight)];
    nameLabel.text = [NSString stringWithFormat:@"%@",classNameStr];
    nameLabel.textColor = [UIColor lightGrayColor];
    nameLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    [headerView addSubview:nameLabel];
    
    //已审核的家人数
    UILabel *auditedLabel = [[UILabel alloc]initWithFrame:CGRectMake(230 * kScreenRatioWidth, 5, 70 * kScreenRatioWidth, 30 * kScreenRatioHeight)];
    auditedLabel.text = [NSString stringWithFormat:@"已审核:%@",numStr];
    auditedLabel.textColor = [UIColor lightGrayColor];
    auditedLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    [headerView addSubview:auditedLabel];
    
    //待审核的家人数
    UILabel *unauditLabel = [[UILabel alloc]initWithFrame:CGRectMake(300 * kScreenRatioWidth, 5, 70 * kScreenRatioWidth, 30 * kScreenRatioHeight)];
    unauditLabel.text = [NSString stringWithFormat:@"待审核:%@",wait_numStr];
    unauditLabel.textColor = [UIColor lightGrayColor];
    unauditLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    [headerView addSubview:unauditLabel];

    
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
