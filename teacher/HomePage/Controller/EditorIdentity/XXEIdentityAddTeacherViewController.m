//
//  XXEIdentityAddTeacherViewController.m
//  teacher
//
//  Created by codeDing on 16/9/5.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEIdentityAddTeacherViewController.h"
#import "XXETeacherTableViewCell.h"
#import "XXETeacherMessTableViewCell.h"
#import "XXERegisterSearchSchoolApi.h"
#import "XXETeacherModel.h"
#import "XXERegisterGradeSchoolApi.h"
#import "XXETeacherGradeModel.h"
#import "XXETeachOfTypeModel.h"
#import "XXERegisterTeachOfTypeApi.h"
#import "XXEReviewerApi.h"
#import "XXEReviewerModel.h"
#import "XXERegisterTeacherApi.h"
#import "YTKBatchRequest.h"
#import "WZYSearchSchoolViewController.h"
#import "XXERegisterClassSchoolApi.h"
#import "XXETeacherClassModel.h"
#import "XXELoginViewController.h"
#import "XXEAddIdentityViewController.h"
//选择城市相关
#import "TWSelectCityView.h"
#import "XXESelectMessageView.h"
#import "FSImagePickerView.h"
#import "UtilityFunc.h"
#import "XXELoginViewController.h"
#import "FSImageModel.h"
#import "XXERegisterPicApi.h"

@interface XXEIdentityAddTeacherViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,XXESearchSchoolMessageDelegate>{
    UIButton *landBtn;
    
    //ding
    NSArray *_titleArr;
    NSArray *_titleTextArr;
}

@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UISearchController *searchDC;
@property (nonatomic, strong)FSImagePickerView *picker;
@property (nonatomic, strong)WZYSearchSchoolViewController *schoolVC;

/** 判断是否有值 */
@property (nonatomic, assign)BOOL isHave;

/** 没有转换的学校类型 */
@property (nonatomic, copy)NSString *schoolType;

/** 老师注册的tableView */
@property (nonatomic, strong)UITableView *teacherTableView;
/** 数据源 */
@property (nonatomic, strong)NSMutableArray *datasource;

/** 返回的数据源*/
@property (nonatomic, strong)NSMutableArray *schoolDatasource;

/** 学校名称数组 */
@property (nonatomic, strong)NSMutableArray *schoolNameArray;
/** 班级信息数据源 */
@property (nonatomic, strong)NSMutableArray *gradeNameDatasource;
/** 班级名称 */
@property (nonatomic, strong)NSMutableArray *gradeNameArray;

/** 获取年级名称 */
@property (nonatomic, strong)NSMutableArray *classNameArray;
/** 获取年级数据源 */
@property (nonatomic, strong)NSMutableArray *classNameDatasource;
/** 获取年级信息的二级数组 */
@property (nonatomic, strong)NSMutableArray *classNameTwoArray;

/** 单元格 */
@property (nonatomic, strong)XXETeacherTableViewCell *teacherCell;
/** 教学类型名称 */
@property (nonatomic, strong)NSMutableArray *teachOfTypeArray;
/** 教学类型数据源 */
@property (nonatomic, strong)NSMutableArray *teachOfTypeDatasource;
/** 审核人的数据源 */
@property (nonatomic, strong)NSMutableArray *reviewerDatasource;
/** 审核人姓名 */
@property (nonatomic, strong)NSMutableArray *reviewerNameArray;
/** 索引学校在数组中的位置 */
@property (nonatomic, assign)NSInteger indexDatsource;

/** 最后教师注册所选的学校id */
@property (nonatomic, copy)NSString *theEndSchoolId;
/** 班级Id */
@property (nonatomic, copy)NSString *theEndClassId;
/** 学校类型 */
@property (nonatomic, copy)NSString *theEndSchoolType;
/** 教学类型 */
@property (nonatomic, copy)NSString *theEndTeachType;
/** 审核人Id */
@property (nonatomic, copy)NSString *theEndReviewerId;
/** 邀请码 */
@property (nonatomic, copy)NSString *theEndInviteCode;
/** 获取头像url */
@property (nonatomic, copy)NSString *theEndUserAvatarImage;
/** 获取证件url */
@property (nonatomic, copy)NSString *theEndFileImage;

/** 选择相片的数据源 */
@property (nonatomic, strong)NSMutableArray *fileImageArray;

/** 测试照片 */
@property (nonatomic, strong)NSMutableArray *mutableArray;

@end

static NSString *IdentifierCELL = @"TeacherCell";
static NSString *IdentifierMessCELL = @"TeacherMessCell";

@implementation XXEIdentityAddTeacherViewController

- (NSMutableArray *)mutableArray
{
    if (!_mutableArray) {
        _mutableArray = [NSMutableArray array];
    }
    return _mutableArray;
}

- (NSMutableArray *)classNameTwoArray
{
    if (!_classNameTwoArray) {
        _classNameTwoArray = [NSMutableArray array];
    }
    return _classNameTwoArray;
}

- (NSMutableArray *)classNameArray
{
    if (!_classNameArray) {
        _classNameArray = [NSMutableArray array];
    }
    return _classNameArray;
}

- (NSMutableArray *)classNameDatasource
{
    if (!_classNameDatasource) {
        _classNameDatasource = [NSMutableArray array];
    }
    return _classNameDatasource;
}

- (NSMutableArray *)schoolDatasource
{
    if (!_schoolDatasource) {
        _schoolDatasource = [NSMutableArray array];
    }
    return _schoolDatasource;
}

- (NSMutableArray *)fileImageArray
{
    if (!_fileImageArray) {
        _fileImageArray = [NSMutableArray array];
    }
    return _fileImageArray;
}

- (NSMutableArray *)reviewerDatasource
{
    if (!_reviewerDatasource) {
        _reviewerDatasource = [NSMutableArray array];
    }
    return _reviewerDatasource;
}

- (NSMutableArray *)reviewerNameArray
{
    if (!_reviewerNameArray) {
        _reviewerNameArray = [NSMutableArray array];
    }
    return _reviewerNameArray;
}


- (NSMutableArray *)teachOfTypeArray
{
    if (!_teachOfTypeArray) {
        _teachOfTypeArray = [NSMutableArray array];
    }
    return _teachOfTypeArray;
}

- (NSMutableArray *)teachOfTypeDatasource
{
    if (!_teachOfTypeDatasource) {
        _teachOfTypeDatasource = [NSMutableArray array];
    }
    return _teachOfTypeDatasource;
}


- (NSMutableArray *)gradeNameArray
{
    if (!_gradeNameArray) {
        _gradeNameArray = [NSMutableArray array];
    }
    return _gradeNameArray;
}

- (NSMutableArray *)gradeNameDatasource
{
    if (!_gradeNameDatasource) {
        _gradeNameDatasource = [NSMutableArray array];
    }
    return _gradeNameDatasource;
}

- (NSMutableArray *)schoolNameArray
{
    if (!_schoolNameArray) {
        _schoolNameArray = [NSMutableArray array];
    }
    return _schoolNameArray;
}

- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}


- (UITableView *)teacherTableView
{
    if (!_teacherTableView) {
        _teacherTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 500*kScreenRatioHeight) style:UITableViewStyleGrouped];
        _teacherTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _teacherTableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEColorFromRGB(239, 239, 244);
    
    self.navigationItem.title = @"完善资料";
    self.navigationController.navigationBarHidden = NO;
    //导航栏的按钮
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(-10,0,22,22)];
    [rightButton setImage:[UIImage imageNamed:@"search_icon"]  forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
}

/** 这个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self InitializeTheMessage];
    [self commBoxInfo];
    
    
    _titleArr = @[@"学校名称:",@"学校类型:",@"班级信息:",@"年级信息:",@"教学类型:",@"",@"审核人员:",@"邀请码"];
    
    _titleTextArr = @[@"请选择学校名称",@"请选择你学校类型",@"班级信息",@"请选择年级",@"请选择职位",@"",@"请选择审核人",@"可不填"];
    
    self.teacherTableView.delegate = self;
    self.teacherTableView.dataSource = self;
    [self.teacherTableView registerNib:[UINib nibWithNibName:@"XXETeacherTableViewCell" bundle:nil] forCellReuseIdentifier:IdentifierCELL];
    [self.teacherTableView registerNib:[UINib nibWithNibName:@"XXETeacherMessTableViewCell" bundle:nil] forCellReuseIdentifier:IdentifierMessCELL];
    [self.view addSubview:self.teacherTableView];
    
}

- (void)InitializeTheMessage
{
    self.theEndSchoolId = @"";
    self.theEndClassId = @"";
    self.theEndSchoolType = @"";
    self.theEndTeachType = @"";
    self.theEndReviewerId = @"";
    self.theEndInviteCode = @"";
    self.theEndFileImage = @"";
    [self.picker removeFromSuperview];
    self.teacherCell = [self cellAtIndexRow:3 andAtSection:0 Message:@""];
    self.teacherCell = [self cellAtIndexRow:4 andAtSection:0 Message:@""];
    self.teacherCell = [self cellAtIndexRow:6 andAtSection:0 Message:@""];
    self.teacherCell = [self cellAtIndexRow:7 andAtSection:0 Message:@""];
    [self.mutableArray removeAllObjects];
    [self commBoxInfo];
}

#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_titleArr.count > 0) {
        return _titleArr.count;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        return 132*kScreenRatioHeight;
    }else {
        return 53*kScreenRatioHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        XXETeacherMessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentifierMessCELL forIndexPath:indexPath];
        return cell;
    }
    else {
        XXETeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentifierCELL forIndexPath:indexPath];
        cell.teacherRegisLabel.text = [_titleArr objectAtIndex:indexPath.row];
        cell.teacherRegisTextField.placeholder = [_titleTextArr objectAtIndex:indexPath.row];
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)WeakSelf = self;
    
    [self.view endEditing:YES];
    switch (indexPath.row) {
        case 0:{
            if (self.schoolNameArray.count==0) {
                [self showString:@"请搜索学校" forSecond:1.f];
            }else{
            }
            break;
        }
        case 1:{
            break;
        }
        case 2:{
            if (self.gradeNameArray.count == 0) {
                [self showString:@"请搜索学校" forSecond:1.f];
            }else {
                XXESelectMessageView *schoolName = [[XXESelectMessageView alloc]initWithTWFrame:self.view.bounds TWselectCityTitle:@"选择班级" MessageArray:self.gradeNameArray];
                NSLog(@"%@",self.gradeNameArray);
                [schoolName showCityView:^(NSString *proviceStr) {
                    WeakSelf.teacherCell = [WeakSelf cellAtIndexRow:2 andAtSection:0 Message:[NSString  stringWithFormat:@"%@",proviceStr]];
                    for (int i =0; i <self.gradeNameArray.count; i++) {
                        if ([proviceStr isEqualToString:self.gradeNameArray[i]]) {
                            _indexDatsource = i;
                        }
                    }
                    XXETeacherGradeModel *model = self.gradeNameDatasource[_indexDatsource];
                    [WeakSelf getoutClassMesage:model GradeName:@""];
                    
                    NSLog(@"%@",proviceStr);
                    
                }];
            }
            break;
        }
        case 3:{
            if (self.classNameArray.count == 0) {
                [self showString:@"请搜索学校" forSecond:1.f];
            }else {
                XXESelectMessageView *className = [[XXESelectMessageView alloc]initWithTWFrame:self.view.bounds TWselectCityTitle:@"选择年级" MessageArray:self.classNameArray];
                [className showCityView:^(NSString *proviceStr) {
                    WeakSelf.teacherCell = [WeakSelf cellAtIndexRow:3 andAtSection:0 Message:[NSString stringWithFormat:@"%@",proviceStr]];
                    for (int i =0; i <self.classNameArray.count; i++) {
                        if ([proviceStr isEqualToString:self.classNameArray[i]]) {
                            _indexDatsource = i;
                        }
                    }
                    XXETeacherClassModel *classModel = self.classNameDatasource[_indexDatsource];
                    self.theEndClassId = classModel.class_id;
                }];
            }
            
            break;
        }
        case 4:{
            if (self.teachOfTypeArray.count == 0) {
                [self showString:@"请搜索学校" forSecond:1.f];
            }else {
                XXESelectMessageView *schoolName = [[XXESelectMessageView alloc]initWithTWFrame:self.view.bounds TWselectCityTitle:@"选择教学类型" MessageArray:self.teachOfTypeArray];
                NSLog(@"%@",self.teachOfTypeArray);
                [schoolName showCityView:^(NSString *proviceStr) {
                    WeakSelf.teacherCell = [WeakSelf cellAtIndexRow:4 andAtSection:0 Message:[NSString  stringWithFormat:@"%@",proviceStr]];
                    for (int i =0; i<self.teachOfTypeArray.count; i++) {
                        if ([proviceStr isEqualToString:self.teachOfTypeArray[i]]) {
                            _indexDatsource = i;
                        }
                    }
                    XXETeachOfTypeModel *model = self.teachOfTypeDatasource[_indexDatsource];
                    self.theEndTeachType = model.teachTypeId;
                }];
            }
            break;
        }
        case 5:{
            
            break;
        }
        case 6:{
            XXESelectMessageView *reviewerName = [[XXESelectMessageView alloc]initWithTWFrame:self.view.bounds TWselectCityTitle:@"请选择审核人" MessageArray:self.reviewerNameArray];
            [reviewerName showCityView:^(NSString *proviceStr) {
                WeakSelf.teacherCell = [WeakSelf cellAtIndexRow:6 andAtSection:0 Message:[NSString stringWithFormat:@"%@",proviceStr]];
                for (int i =0; i <self.reviewerNameArray.count; i++) {
                    if ([proviceStr isEqualToString:self.reviewerNameArray[i]]) {
                        _indexDatsource = i;
                    }
                }
                XXEReviewerModel *model = self.reviewerDatasource[_indexDatsource];
                self.theEndReviewerId = model.reviewerId;
            }];
            break;
        }
        case 7:{
            WeakSelf.teacherCell = [WeakSelf cellAtIndexRow:7 andAtSection:0 Message:@""];
            WeakSelf.teacherCell.teacherRegisTextField.enabled = YES;
            WeakSelf.teacherCell.teacherRegisTextField.delegate = self;
            break;
        }
        default:
            break;
    }
}

//获取tableView的cell
- (XXETeacherTableViewCell *)cellAtIndexRow:(NSInteger)row andAtSection:(NSInteger) section Message:(NSString *)message
{
    XXETeacherTableViewCell *cell = [_teacherTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    cell.teacherRegisTextField.text = message;
    return cell;
}

//获取对应的cell
- (XXETeacherMessTableViewCell *)cellMessAtIndex:(NSInteger)row andAtSection:(NSInteger)section
{
    XXETeacherMessTableViewCell *cell = [_teacherTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    return cell;
}


-(void)commBoxInfo{
    //    //搜索框
    //    //选择图片
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    FSImagePickerView *picker = [[FSImagePickerView alloc] initWithFrame:CGRectMake(20, 318*kScreenRatioHeight, KScreenWidth -  40, 75*kScreenRatioHeight) collectionViewLayout:layout];
    self.picker = picker;
    picker = picker;
    picker.backgroundColor = UIColorFromRGB(255, 255, 255);
    picker.showsHorizontalScrollIndicator = NO;
    picker.controller = self;
    [self.teacherTableView addSubview:picker];
    //选择的相片加入数组
    
    __weak typeof(self)weakSelf = self;
    //确认按钮
    UIButton *nextButton = [[UIButton alloc]init];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"login_green"] forState:UIControlStateNormal];
    [nextButton setTitle:@"确认" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-30*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(335*kScreenRatioWidth, 41*kScreenRatioHeight));
    }];
}

#pragma mark - 获取班级信息
- (void)getoutSchoolGradeSchoolId:(NSString *)schoolId SchoolType:(NSString *)schoolType
{
    //获取默认的信息
    self.theEndSchoolId = schoolId;
    self.theEndSchoolType = schoolType;
    
    NSLog(@"%@%@",schoolId,schoolType);
    XXERegisterGradeSchoolApi *schoolApi = [[XXERegisterGradeSchoolApi alloc]initWithGetOutSchoolGradeSchoolId:schoolId SchoolType:schoolType];
    
    [schoolApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        if ([[request.responseJSONObject objectForKey:@"code"] intValue] == 1) {
            NSLog(@"%@",request.responseJSONObject);
            NSArray *data = [request.responseJSONObject objectForKey:@"data"];
            NSLog(@"获取班级信息:%@",data);
            
            NSString *name = [data[0] objectForKey:@"name"];
            NSLog(@"%@",name);
            //获取数据前先清空数组
            [self.gradeNameDatasource removeAllObjects];
            [self.gradeNameArray removeAllObjects];
            
            for (int i =0; i < data.count; i++) {
                XXETeacherGradeModel *model = [[XXETeacherGradeModel alloc]initWithDictionary:data[i] error:nil];
                [self.gradeNameDatasource addObject:model];
                [self.gradeNameArray addObject:model.grade];
            }
            NSLog(@"班级信息的数组%@",self.gradeNameArray);
            self.teacherCell = [self cellAtIndexRow:2 andAtSection:0 Message:self.gradeNameArray[0]];
            XXETeacherGradeModel *modelDefault = self.gradeNameDatasource[0];
            NSLog(@"获取班级信息%@",modelDefault);
            //通过班级选择年级
            [self getoutClassMesage:modelDefault GradeName:self.gradeNameArray[0]];
            //默认为没有选择的时候
            //            self.theEndClassId = model.course_id;
        }else {
            [self showString:@"请求班级数据失败" forSecond:1.f];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [self showString:@"请求班级数据失败" forSecond:1.f];
    }];
}

#pragma mark - 获取教学类型
- (void)getoutTeachTypeSchoolType:(NSString *)schoolType
{
    XXERegisterTeachOfTypeApi *teachTypeApi = [[XXERegisterTeachOfTypeApi alloc]initWithRegisTeachTypeSchoolType:schoolType];
    
    [teachTypeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSLog(@"%@",request.responseJSONObject);
        if ([[request.responseJSONObject objectForKey:@"code"]intValue]== 1) {
            NSArray *data = [request.responseJSONObject objectForKey:@"data"];
            NSLog(@"获取教学类型:%@",data);
            //获取教学类型前 先清空数组
            [self.teachOfTypeDatasource removeAllObjects];
            [self.teachOfTypeArray removeAllObjects];
            
            for (int i =0; i<data.count; i++) {
                XXETeachOfTypeModel *model = [[XXETeachOfTypeModel alloc]initWithDictionary:data[i] error:nil];
                [self.teachOfTypeDatasource addObject:model];
                [self.teachOfTypeArray addObject:model.teachTypeName];
            }
            //            self.teacherCell = [self cellAtIndexRow:4 andAtSection:0 Message:self.teachOfTypeArray[0]];
            //            XXETeachOfTypeModel *model = self.teachOfTypeDatasource[0];
            //            self.theEndTeachType = model.teachTypeId;
        }else {
            
            [self showString:@"教学类型数据请求失败" forSecond:1.f];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [self showString:@"教学类型请求失败请重试" forSecond:1.f];
    }];
}

#pragma mark - 获取年级信息
- (void)getoutClassMesage:(XXETeacherGradeModel *)model GradeName:(NSString *)gradeName
{
    NSLog(@"%@%@%@",model.grade,model.school_id,model.course_id);
    
    NSLog(@"%@",self.gradeNameDatasource);
    [self.classNameDatasource removeAllObjects];
    [self.classNameArray removeAllObjects];
    
    XXERegisterClassSchoolApi *classApi = [[XXERegisterClassSchoolApi alloc]initWithClassMessageSchoolId:model.school_id Grade:model.grade CourseId:model.course_id];
    [classApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        
        if ([code intValue]== 1) {
            NSMutableArray *data = [request.responseJSONObject objectForKey:@"data"];
            for (int i =0; i<data.count; i++) {
                XXETeacherClassModel *classModel = [[XXETeacherClassModel alloc]initWithDictionary:data[i] error:nil];
                [self.classNameDatasource addObject:classModel];
                [self.classNameArray addObject:classModel.className];
            }
            //                NSString *calssName = self.classNameArray[0];
            //                self.teacherCell = [self cellAtIndexRow:3 andAtSection:0 Message:calssName];
            //                XXETeacherClassModel *model = self.classNameDatasource[0];
            //                self.theEndClassId = model.class_id;
            
        }else {
            [self showString:@"获取班级信息失败" forSecond:1.f];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self showString:@"获取班级信息失败" forSecond:1.f];
    }];
    
}


#pragma mark - 审核人的数据获取
- (void)getoutTeacherReviewerSchoolID:(NSString *)reviewerSchoolId
{
    NSLog(@"%@%@",self.teacherPosition ,reviewerSchoolId);
    XXEReviewerApi *reviewerApi = [[XXEReviewerApi alloc]initReviwerNameSchoolId:reviewerSchoolId PositionID:self.teacherPosition];
    [reviewerApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"审核人信息:======%@",request.responseJSONObject);
        NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
        NSArray *data = [request.responseJSONObject objectForKey:@"data"];
        [self.reviewerDatasource removeAllObjects];
        [self.reviewerNameArray removeAllObjects];
        for (int i =0; i < data.count; i++) {
            XXEReviewerModel *model = [[XXEReviewerModel alloc]initWithDictionary:data[i] error:nil];
            [self.reviewerDatasource addObject:model];
            [self.reviewerNameArray addObject:model.reviewerName];
        }
        //        self.teacherCell = [self cellAtIndexRow:6 andAtSection:0 Message:self.reviewerNameArray[0]];
        //        XXEReviewerModel *model = self.reviewerDatasource[0];
        //        self.theEndReviewerId = model.reviewerId;
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}

#pragma mark - 点击确定提交注册
- (void)sureButtonClick:(UIButton *)sender
{
    NSLog(@"%@%@%@",self.theEndClassId,self.theEndTeachType,self.theEndReviewerId);
    
    if ([self.theEndClassId isEqualToString:@""]) {
        [self showString:@"请选择年级" forSecond:1.f];
        return;
    }else if ([self.theEndTeachType isEqualToString:@""]){
        [self showString:@"请选择教学类型" forSecond:1.f];
        return;
    }else if ([self.theEndReviewerId isEqualToString:@""]){
        [self showString:@"请选择审核人" forSecond:1.f];
        return;
    }else{
        //获取身份图片
        [self setupFileImage];
    }
    
    NSLog(@"确认按钮");
    NSLog(@"学校ID%@ 学校类型%@ 班级Id%@ 教学类型%@ 审核人ID%@",self.theEndSchoolId,self.theEndSchoolType,self.theEndClassId,self.theEndTeachType,self.theEndReviewerId);
}

#pragma mark - 点击注册按钮 提交信息
- (void)uploadRegisterMessage
{
    NSString *strngXid;
    NSString *homeUserId;
    if ([XXEUserInfo user].login) {
        strngXid = [XXEUserInfo user].xid;
        homeUserId = [XXEUserInfo user].user_id;
    }else {
        strngXid = XID;
        homeUserId = USER_ID;
    }
    NSDictionary *parameter = @{
                                @"position":self.teacherPosition,
                                @"teach_course_id":_theEndTeachType,
                                @"school_id":_theEndSchoolId,
                                @"class_id":_theEndClassId,
                                @"school_type":_theEndSchoolType,
                                @"examine_id":_theEndReviewerId,
                                @"code":_theEndInviteCode,
                                @"file":_theEndFileImage,
                                @"appkey":APPKEY,
                                @"backtype":BACKTYPE,
                                @"user_type":USER_TYPE,
                                @"xid":strngXid,
                                @"user_id":homeUserId
                                };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:XXEHomeAddIdentityUrl parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        
    }success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        NSLog(@"%@",[responseObject objectForKey:@"msg"]);
        NSString *code = [responseObject objectForKey:@"code"];
        if ([code intValue]==1) {
            [self showString:@"你已添加成功" forSecond:3.f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
                XXEAddIdentityViewController *addIdentityVC = self.navigationController.viewControllers[1];
                [self.navigationController popToViewController:addIdentityVC animated:YES];
            });
            
        }else if([code intValue]== 16){
            [self showString:@"您要添加的身份已存在" forSecond:2.f];
        }else{
        [self showString:@"添加身份失败" forSecond:1.f];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self showString:@"添加身份失败" forSecond:1.f];
    }];
}


- (void)searchButtonClick:(UIButton *)sender
{
    NSLog(@"点击搜搜");
    
    WZYSearchSchoolViewController *searchVC = [[WZYSearchSchoolViewController alloc]init];
    self.schoolVC = searchVC;
    
//    [searchVC returnArray:^(NSMutableArray *mArr) {
//        if (mArr != nil) {
//            self.isHave = YES;
//        }else {
//            self.isHave = NO;
//        }
//        [self InitializeTheMessage];
//        self.schoolDatasource = mArr;
//        self.schoolVC.delegate = self;
//    }];
    
    [searchVC returnModel:^(XXETeacherModel *teacherModel) {
        //
                if (teacherModel != nil) {
                    self.isHave = YES;
                }else {
                    self.isHave = NO;
                }
                [self InitializeTheMessage];
//                self.schoolDatasource = mArr;
                self.schoolVC.delegate = self;
    }];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - 搜索的代理方法
- (void)searchSchoolMessage:(XXETeacherModel *)model
{
    // 给单元格赋值
    self.teacherCell = [self cellAtIndexRow:0 andAtSection:0 Message:model.name];
    NSString *typeName ;
    if ([model.type isEqualToString:@"1"]) {
        typeName = @"幼儿园";
    } else if ([model.type isEqualToString:@"2"]) {
        typeName = @"小学";
    } else if ([model.type isEqualToString:@"3"]){
        typeName = @"中学";
    } else if ([model.type isEqualToString:@"4"]){
        typeName = @"培训机构";
    }
    self.teacherCell = [self cellAtIndexRow:1 andAtSection:0 Message:typeName];
    
    //获取班级信息的网络请求
    [self getoutSchoolGradeSchoolId:model.schoolId SchoolType:model.type];
    
    //获取教学类型网络请求
    [self getoutTeachTypeSchoolType:model.type];
    
    //获取教师的审核人信息
    [self getoutTeacherReviewerSchoolID:model.schoolId];
}

#pragma mark - 获取身份图片
- (void)setupFileImage
{
    if (self.picker.data.count ==1) {
        //往服务器传所有的参数
        self.theEndFileImage = @"";
        [self uploadRegisterMessage];
    }else{
        [self.picker.data removeLastObject];
        self.mutableArray = self.picker.data;
        for (int i =0; i <_mutableArray.count; i++) {
            FSImageModel *model = self.picker.data[i];
            UIImage *fileImage = [UIImage imageWithData:model.data];
            [self.fileImageArray addObject:fileImage];
        }
        //用户的证件照
        [self fileUserSomeImage];
    }
    
    
}

#pragma mark - 用户所选择的证件照
- (void)fileUserSomeImage
{
    NSLog(@"%@",self.fileImageArray);
    NSDictionary *dict = @{@"file_type":@"1",
                           @"page_origin":@"2",
                           @"upload_format":@"2",
                           @"appkey":APPKEY,
                           @"user_type":USER_TYPE,
                           @"backtype":BACKTYPE
                           };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:XXERegisterUpLoadPicUrl parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i< _fileImageArray.count; i++) {
            NSData *data = UIImageJPEGRepresentation(_fileImageArray[i], 0.5);
            NSString *name = [NSString stringWithFormat:@"%d.jpeg",i];
            NSString *formKey = [NSString stringWithFormat:@"file%d",i];
            NSString *type = @"image/jpeg";
            [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
        }
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSString *code = [responseObject objectForKey:@"code"];
        if ([code intValue] == 1) {
            NSArray *data = [responseObject objectForKey:@"data"];
            NSMutableString *str = [NSMutableString string];
            for (int i =0; i< data.count; i++) {
                NSString *string = data[i];
                if (i != data.count -1) {
                    [str appendFormat:@"%@,",string];
                }else {
                    [str appendFormat:@"%@",string];
                }
            }
            self.theEndFileImage = str;
            //往服务器传所有的参数
            [self uploadRegisterMessage];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark  - UITextField
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.theEndInviteCode = textField.text;
}

//点击键盘搜索取消搜索的第一响应
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"点击搜索%@",searchBar.text);
    [_searchBar resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
