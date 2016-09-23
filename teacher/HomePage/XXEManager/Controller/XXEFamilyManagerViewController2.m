


//
//  XXEFamilyManagerViewController2.m
//  teacher
//
//  Created by Mac on 16/9/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFamilyManagerViewController2.h"
#import "XXEFamilyManagerPersonInfoModel.h"
#import "XXEFamilyManagerClassInfoModel.h"
#import "XXERedFlowerSentHistoryTableViewCell.h"
#import "XXEBabyFamilyInfoDetailViewController.h"
#import "XXEFamilyManagerRefuseApi.h"
#import "XXEFamilyManagerAgreeApi.h"
#import "XXEFamilyManagerApi.h"



@interface XXEFamilyManagerViewController2 ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    //班级 model 数组
    NSMutableArray *classModelArray;
    //学生家人 model 数组
    NSMutableArray *familyModelArray;
    
    UIButton *arrowButton;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}
//展开 收缩 判断 值
@property (nonatomic,strong) NSMutableArray *flagArray;
@property (nonatomic , strong) NSMutableArray *selectedBabyInfoArr;

//同意 按钮
@property (nonatomic, strong) UIButton *agreeBtn;
//拒绝 按钮
@property (nonatomic, strong) UIButton *refuseBtn;
//删除 按钮
@property (nonatomic, strong) UIButton *deletebtn;

@end

@implementation XXEFamilyManagerViewController2

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
    
    [self createTableView];
}


- (void)fetchNetData{
    XXEFamilyManagerApi *familyManagerApi = [[XXEFamilyManagerApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:_schoolId school_type:_schoolType class_id:_classId position:_position];
    
    [familyManagerApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        classModelArray = [[NSMutableArray alloc] init];
        _flagArray = [[NSMutableArray alloc] init];
//                    NSLog(@"111   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            NSArray *classModelArr = [[NSArray alloc] init];
            classModelArr = [XXEFamilyManagerClassInfoModel parseResondsData:request.responseJSONObject[@"data"]];
            [classModelArray addObjectsFromArray:classModelArr];
            
            for (int i = 0; i < classModelArray.count; i ++) {
                //最初 设置 为关闭
                NSNumber *flagN = [NSNumber numberWithBool:NO];
                [_flagArray addObject:flagN];
            }
            
        }else{
            
        }
        //        NSLog(@"%@  ---  %@", classModelArray, _flagArray);
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
//返回多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return classModelArray.count;
}

//每组 返回 多少 个
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //        NSLog(@"%@ -- %@", _flagArray, classModelArray);
    
    if ([self.flagArray[section] boolValue] == YES) {
        XXEFamilyManagerClassInfoModel *model = classModelArray[section];
        
        return model.parent_list.count;
    }else{
        return 0;
    }
    
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

    return cell;
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
    NSString *currentBabyId = stuModel.examine_id;
    
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
    
//    XXEStudentManagerDeleteApi *studentManagerDeleteApi = [[XXEStudentManagerDeleteApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:_schoolId class_id:currentClassId baby_id:currentBabyId];
//    
//    [studentManagerDeleteApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        
//        //              NSLog(@"2222---   %@", request.responseJSONObject);
//        
//        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
//        
//        if ([codeStr isEqualToString:@"1"]) {
//            
//            [self showHudWithString:@"删除成功!" forSecond:1.5];
//            //从 数据源中 删除
//            XXEClassInfoModel *classModel = classModelArray[path.section];
//            [classModel.baby_list removeObjectAtIndex:path.row];
//            //从 列表 中 删除
//            [_myTableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
//        }else{
//            
//        }
//        [_myTableView reloadData];
//        
//    } failure:^(__kindof YTKBaseRequest *request) {
//        
//        [self showHudWithString:@"提交失败!" forSecond:1.5];
//    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    if (indexPath.section == 0) {
    //        //点击 宝贝 cell 先进入到 宝贝家人 列表
    //        XXEBabyFamilyInfoViewController *babyFamilyInfoVC = [[XXEBabyFamilyInfoViewController alloc] init];
    //        XXEClassAddressStudentInfoModel *model = _dataSourceArray[indexPath.section][indexPath.row];
    //        //        NSLog(@"%@", model);
    //        babyFamilyInfoVC.baby_id = model.baby_id;
    //        babyFamilyInfoVC.familyInfoArray = model.parent_list;
    //        [self.navigationController pushViewController:babyFamilyInfoVC animated:YES];
    //
    //    }else if (indexPath.section == 1){
    //
    //    }else if (indexPath.section == 2){
    //
    //    }
    
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


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    view.userInteractionEnabled = YES;
    
    view.tag = 100 + section;
    
    UITapGestureRecognizer *viewPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewPressClick:)];
    [view addGestureRecognizer:viewPress];
    
    arrowButton = [[UIButton alloc]initWithFrame:CGRectMake(10, (40-12)/2, 12, 12)];
    NSNumber *flagN = self.flagArray[section];
    
    if ([flagN boolValue]) {
        [arrowButton setBackgroundImage:[UIImage imageNamed:@"narrow_icon"] forState:UIControlStateNormal];
        CGAffineTransform currentTransform =arrowButton.transform;
        CGAffineTransform newTransform =CGAffineTransformRotate(currentTransform, M_PI/2);
        arrowButton.transform =newTransform;
        
    }else
    {
        [arrowButton setBackgroundImage:[UIImage imageNamed:@"narrow_icon"] forState:UIControlStateNormal ];
        
    }
    arrowButton.tag = 300+section;
    [view addSubview:arrowButton];
    
    
    XXEFamilyManagerClassInfoModel *model = classModelArray[section];
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
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, 200 * kScreenRatioWidth, 30)];
    nameLabel.text = [NSString stringWithFormat:@"%@",classNameStr];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:16 * kScreenRatioWidth];
    [view addSubview:nameLabel];
    
    //已审核的家人数
    UILabel *auditedLabel = [[UILabel alloc]initWithFrame:CGRectMake(230, 5, 70 * kScreenRatioWidth, 30)];
    auditedLabel.text = [NSString stringWithFormat:@"已审核:%@",numStr];
    auditedLabel.textColor = [UIColor blackColor];
    auditedLabel.font = [UIFont boldSystemFontOfSize:14 * kScreenRatioWidth];
    [view addSubview:auditedLabel];
    
    //待审核的家人数
    UILabel *unauditLabel = [[UILabel alloc]initWithFrame:CGRectMake(300, 5, 70 * kScreenRatioWidth, 30)];
    unauditLabel.text = [NSString stringWithFormat:@"待审核:%@",wait_numStr];
    unauditLabel.textColor = [UIColor blackColor];
    unauditLabel.font = [UIFont boldSystemFontOfSize:14 * kScreenRatioWidth];
    [view addSubview:unauditLabel];
    
    //线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, KScreenWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(229, 232, 233);
    [view addSubview:lineView];

    
    return view;
}

- (void)viewPressClick:(UITapGestureRecognizer *)press{
    //    NSLog(@" 头视图  tag  %ld", press.view.tag - 100);
    
    if ([self.flagArray[press.view.tag - 100] boolValue]) {
        [self.flagArray replaceObjectAtIndex:(press.view.tag - 100) withObject:[NSNumber  numberWithBool:NO]];
        
    }else{
        [self.flagArray replaceObjectAtIndex:(press.view.tag - 100) withObject:[NSNumber numberWithBool:YES]];
    }
    [_myTableView reloadData ];
    
    
}
//返回每个分组的表头视图的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
