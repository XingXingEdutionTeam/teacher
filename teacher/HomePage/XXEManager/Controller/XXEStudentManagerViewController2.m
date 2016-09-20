

//
//  XXEStudentManagerViewController2.m
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStudentManagerViewController2.h"
#import "XXEStudentManagerMoveToClassViewController.h"
#import "XXEStudentManagerTableViewCell.h"
#import "XXEBabyInfoViewController.h"
#import "XXEStudentManagerDeleteApi.h"
#import "XXEStudentManagerApi.h"
#import "XXEClassInfoModel.h"


@interface XXEStudentManagerViewController2 ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    //班级 model 数组
    NSMutableArray *classModelArray;
    //学生 model 数组
    NSMutableArray *studentModelArray;
    
    UIButton *arrowButton;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}
//展开 收缩 判断 值
@property (nonatomic,strong) NSMutableArray *flagArray;
@property (nonatomic , strong) NSMutableArray *selectedBabyInfoArr;
@property (nonatomic, strong) UIButton *moveBtn;

@property (nonatomic, strong) UIButton *deletebtn;

@end

@implementation XXEStudentManagerViewController2

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
    XXEStudentManagerApi *studentManagerApi = [[XXEStudentManagerApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:_schoolId school_type:_schoolType class_id:_classId position:@"4"];
    
    [studentManagerApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        classModelArray = [[NSMutableArray alloc] init];
        _flagArray = [[NSMutableArray alloc] init];
//            NSLog(@"111   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            NSArray *classModelArr = [[NSArray alloc] init];
            classModelArr = [XXEClassInfoModel parseResondsData:request.responseJSONObject[@"data"]];
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
        XXEClassInfoModel *model = classModelArray[section];
        
        return model.baby_list.count;
    }else{
        return 0;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXEStudentManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEStudentManagerTableViewCell" owner:self options:nil]lastObject];
    }
    
    //宝贝 信息
    XXEClassInfoModel *classModel = classModelArray[indexPath.section];
    XXEStudentInfoModel *studentModel = classModel.baby_list[indexPath.row];
    
    //宝贝 头像 全部 是拼接 的
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, studentModel.head_img]] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width / 2;
    cell.iconImageView.layer.masksToBounds = YES;
    cell.titleLabel.text = studentModel.tname;
    cell.timeLabel.text = [XXETool dateStringFromNumberTimer:studentModel.date_tm];
    
    //点击 头像 进入 宝贝详情 界面
    cell.iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *iconTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconTap:)];
    cell.iconImageView.tag =100+indexPath.row;
    [cell.iconImageView addGestureRecognizer:iconTap];
    
    //移动 按钮
    _moveBtn = [UIButton createButtonWithFrame:CGRectMake(260, 27, 50, 25) backGruondImageName:nil Target:self Action:@selector(onClickMoveBtn:) Title:@"移动"];
    [_moveBtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
    _moveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_moveBtn.layer setBorderColor:UIColorFromRGB(0, 170, 42).CGColor];
    [_moveBtn.layer setBorderWidth:1];
    [_moveBtn.layer setMasksToBounds:YES];
    
    //删除 按钮
    _deletebtn = [UIButton createButtonWithFrame:CGRectMake(315, 27, 50, 25) backGruondImageName:nil Target:self Action:@selector(onClickDeleteBtn:) Title:@"删除"];
    [_deletebtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
    _deletebtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_deletebtn.layer setBorderColor:UIColorFromRGB(0, 170, 42).CGColor];
    [_deletebtn.layer setBorderWidth:1];
    [_deletebtn.layer setMasksToBounds:YES];
    
    [cell.contentView addSubview:_moveBtn];
    [cell.contentView addSubview:_deletebtn];
    
    _moveBtn.tag=100;
    _deletebtn.tag=101;
    
    return cell;
}

-(void)onClickMoveBtn:(UIButton *)button{
    XXEStudentManagerTableViewCell *cell = (XXEStudentManagerTableViewCell *)[[button superview] superview];
    NSIndexPath *path = [_myTableView indexPathForCell:cell];
    XXEClassInfoModel *classModel = classModelArray[path.section];
    XXEStudentInfoModel *stuModel = classModel.baby_list[path.row];
    
    XXEStudentManagerMoveToClassViewController *studentManagerMoveToClassVC = [[XXEStudentManagerMoveToClassViewController alloc] init];
    
    studentManagerMoveToClassVC.schoolId = _schoolId;
    studentManagerMoveToClassVC.schoolType = _schoolType;
    studentManagerMoveToClassVC.currentSelectedClassId = classModel.class_id;
    studentManagerMoveToClassVC.babyId = stuModel.babyId;
    
    [self.navigationController pushViewController:studentManagerMoveToClassVC animated:YES];
}

-(void)onClickDeleteBtn:(UIButton *)button{
    XXEStudentManagerTableViewCell *cell = (XXEStudentManagerTableViewCell *)[[button superview] superview];
    NSIndexPath *path = [_myTableView indexPathForCell:cell];
    XXEClassInfoModel *classModel = classModelArray[path.section];
    XXEStudentInfoModel *stuModel = classModel.baby_list[path.row];
    
    //当前 所要删除 学生 的 babyid 及 所在 的classid
    NSString *currentClassId = classModel.class_id;
    NSString *currentBabyId = stuModel.babyId;
    
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
            XXEClassInfoModel *classModel = classModelArray[path.section];
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
    XXEStudentManagerTableViewCell *cell = (XXEStudentManagerTableViewCell *)[[tap.view superview] superview];
    NSIndexPath *path = [_myTableView indexPathForCell:cell];
    XXEClassInfoModel *classModel = classModelArray[path.section];
    XXEStudentInfoModel *stuModel = classModel.baby_list[tap.view.tag - 100];
    //    if ([XXEUserInfo user].login){
    XXEBabyInfoViewController *babyInfoVC =[[XXEBabyInfoViewController alloc]init];
    
    babyInfoVC.babyId = stuModel.babyId;
    babyInfoVC.babyClassName = classModel.class_name;
    [self.navigationController pushViewController:babyInfoVC animated:NO];
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
    
    arrowButton = [[UIButton alloc]initWithFrame:CGRectMake(10, (40-20)/2, 17.5, 20)];
    NSNumber *flagN = self.flagArray[section];
    
    if ([flagN boolValue]) {
        [arrowButton setBackgroundImage:[UIImage imageNamed:@"triangle"] forState:UIControlStateNormal];
        CGAffineTransform currentTransform =arrowButton.transform;
        CGAffineTransform newTransform =CGAffineTransformRotate(currentTransform, M_PI/2);
        arrowButton.transform =newTransform;
        
    }else
    {
        [arrowButton setBackgroundImage:[UIImage imageNamed:@"triangle"] forState:UIControlStateNormal ];
        
    }
    arrowButton.tag = 300+section;
    [view addSubview:arrowButton];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, KScreenWidth - 40, 30)];
    
    XXEClassInfoModel *model = classModelArray[section];
    NSString *classNameStr ;
    NSString *numStr;
    
    if (model.class_name == nil) {
        classNameStr = @"";
    }else{
        classNameStr = model.class_name;
    }
    if (model.num == nil) {
        numStr = @"";
    }else{
        numStr = model.num;
    }
    
    label.text = [NSString stringWithFormat:@"%@(%@人)",classNameStr, numStr];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont boldSystemFontOfSize:14];
    [view addSubview:label];
    
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
