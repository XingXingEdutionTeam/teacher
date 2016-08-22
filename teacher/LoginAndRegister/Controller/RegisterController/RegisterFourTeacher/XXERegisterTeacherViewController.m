//
//  XXERegisterHeadMasterViewController.m
//  teacher
//
//  Created by codeDing on 16/8/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERegisterTeacherViewController.h"
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
#import "XXERegisterTeacherHeadApi.h"
#import "XXERegisterTeacherFileApi.h"
#import "YTKBatchRequest.h"
//选择城市相关
#import "TWSelectCityView.h"
#import "XXESelectMessageView.h"
#import "FSImagePickerView.h"
#import "UtilityFunc.h"
#import "XXELoginViewController.h"
#import "FSImageModel.h"
#define awayX 20
@interface XXERegisterTeacherViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UIButton *landBtn;
    
    //ding
    NSArray *_titleArr;
    NSArray *_titleTextArr;
}
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UISearchController *searchDC;
@property (nonatomic, strong)FSImagePickerView *picker;

/** 没有转换的学校类型 */
@property (nonatomic, copy)NSString *schoolType;

/** 老师注册的tableView */
@property (nonatomic, strong)UITableView *teacherTableView;
/** 数据源 */
@property (nonatomic, strong)NSMutableArray *datasource;

/** 学校名称数组 */
@property (nonatomic, strong)NSMutableArray *schoolNameArray;
/** 班级信息数据源 */
@property (nonatomic, strong)NSMutableArray *gradeNameDatasource;
/** 班级名称 */
@property (nonatomic, strong)NSMutableArray *gradeNameArray;
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

/** 最红教师注册所选的学校id */
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

/** 选择相片的数据源 */
@property (nonatomic, strong)NSMutableArray *fileImageArray;

@end

static NSString *IdentifierCELL = @"TeacherCell";
static NSString *IdentifierMessCELL = @"TeacherMessCell";

@implementation XXERegisterTeacherViewController

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
    self.navigationItem.title = @"4/4注册老师";
    self.navigationController.navigationBarHidden = NO;
}

/** 这个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self commBoxInfo];
    
    _titleArr = @[@"学校名称:",@"学校类型:",@"班级信息:",@"教学类型:",@"",@"审核人员:",@"邀请码"];
    
    _titleTextArr = @[@"请选择学校名称",@"请选择你学校类型",@"班级信息",@"请选择职位",@"",@"请选择审核人",@"可不填"];
    
    self.teacherTableView.delegate = self;
    self.teacherTableView.dataSource = self;
    [self.teacherTableView registerNib:[UINib nibWithNibName:@"XXETeacherTableViewCell" bundle:nil] forCellReuseIdentifier:IdentifierCELL];
    [self.teacherTableView registerNib:[UINib nibWithNibName:@"XXETeacherMessTableViewCell" bundle:nil] forCellReuseIdentifier:IdentifierMessCELL];
    [self.view addSubview:self.teacherTableView];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        return 132*kScreenRatioHeight;
    }else {
        return 53*kScreenRatioHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
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
            XXESelectMessageView *schoolName = [[XXESelectMessageView alloc]initWithTWFrame:self.view.bounds TWselectCityTitle:@"选择学校" MessageArray:self.schoolNameArray];
            NSLog(@"%@",self.schoolNameArray);
            [schoolName showCityView:^(NSString *proviceStr) {
               WeakSelf.teacherCell = [WeakSelf cellAtIndexRow:0 andAtSection:0 Message:[NSString  stringWithFormat:@"%@",proviceStr]];
                for (int i =0; i < self.schoolNameArray.count; i++) {
                    if ([proviceStr isEqualToString:self.schoolNameArray[i]]) {
                        _indexDatsource = i;
                    }
                }
                NSLog(@"%ld",(long)_indexDatsource);
                NSLog(@"%@",proviceStr);
                //学校类型
                XXETeacherModel *model = self.datasource[_indexDatsource];
                WeakSelf.teacherCell = [WeakSelf cellAtIndexRow:1 andAtSection:0 Message:[NSString  stringWithFormat:@"%@",model.type]];
                NSLog(@"学校Id%@ 学校类型%@",model.schoolId,model.type);
                //获取班级类型
                [self getoutSchoolGradeSchoolId:model.schoolId SchoolType:model.type];
                //获取教学类型
                [self getoutTeachTypeSchoolType:model.type];
                //获取审核人
                [self getoutTeacherReviewerSchoolID:model.schoolId];
                
            }];
                
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
            NSLog(@"%@",self.schoolNameArray);
            [schoolName showCityView:^(NSString *proviceStr) {
                WeakSelf.teacherCell = [WeakSelf cellAtIndexRow:2 andAtSection:0 Message:[NSString  stringWithFormat:@"%@",proviceStr]];
                for (int i =0; i <self.gradeNameArray.count; i++) {
                    if ([proviceStr isEqualToString:self.gradeNameArray[i]]) {
                        _indexDatsource = i;
                    }
                }
                XXETeacherGradeModel *model = self.gradeNameDatasource[_indexDatsource];
                self.theEndClassId = model.course_id;
                NSLog(@"%@",proviceStr);
                
            }];
            }
            break;
        }
        case 3:{
            if (self.teachOfTypeArray.count == 0) {
                [self showString:@"请搜索学校" forSecond:1.f];
            }else {
            XXESelectMessageView *schoolName = [[XXESelectMessageView alloc]initWithTWFrame:self.view.bounds TWselectCityTitle:@"选择教学类型" MessageArray:self.teachOfTypeArray];
            NSLog(@"%@",self.teachOfTypeArray);
            [schoolName showCityView:^(NSString *proviceStr) {
                WeakSelf.teacherCell = [WeakSelf cellAtIndexRow:3 andAtSection:0 Message:[NSString  stringWithFormat:@"%@",proviceStr]];
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
        case 4:{
            
            break;
        }
        case 5:{
            XXESelectMessageView *reviewerName = [[XXESelectMessageView alloc]initWithTWFrame:self.view.bounds TWselectCityTitle:@"请选择审核人" MessageArray:self.reviewerNameArray];
            [reviewerName showCityView:^(NSString *proviceStr) {
                WeakSelf.teacherCell = [WeakSelf cellAtIndexRow:5 andAtSection:0 Message:[NSString stringWithFormat:@"%@",proviceStr]];
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
        case 6:{
            WeakSelf.teacherCell = [WeakSelf cellAtIndexRow:6 andAtSection:0 Message:@""];
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
    //搜索框
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kWidth, 44)];
    UIImage *backgroundImg = [UtilityFunc createImageWithColor:UIColorFromHex(0xf0eaf3) size:_searchBar.frame.size];
    [_searchBar setBackgroundImage:backgroundImg];
    _searchBar.placeholder =@"请输入你要查询的学校";
    _searchBar.tintColor = [UIColor blackColor];
    _searchBar.delegate =self;
    _searchDC = [[UISearchController alloc]initWithSearchResultsController:self];
    [self.teacherTableView addSubview:_searchBar];
    
    //    //选择图片
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    FSImagePickerView *picker = [[FSImagePickerView alloc] initWithFrame:CGRectMake(20, 295*kScreenRatioHeight, KScreenWidth -  40, 75*kScreenRatioHeight) collectionViewLayout:layout];
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


#pragma mark - search选择学校类型与学校名称
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"%@",searchBar.text);
    XXERegisterSearchSchoolApi *searchSchoolApi = [[XXERegisterSearchSchoolApi alloc]initWithRegisterSearchSchoolName:searchBar.text];
    [searchSchoolApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSLog(@"%@",request.responseJSONObject);

        if ([[request.responseJSONObject objectForKey:@"code"] intValue] == 1)
        {
            NSArray *dic = [request.responseJSONObject objectForKey:@"data"];
            NSLog(@"搜索的学校的信息:%@",dic);
            for (int i = 0; i < dic.count; i++) {
                XXETeacherModel *model = [[XXETeacherModel alloc]initWithDictionary:dic[i] error:nil];
                self.schoolType = model.type;
                if ([model.type isEqualToString:@"1"]) {
                    model.type = @"幼儿园";
                    
                } else if ([model.type isEqualToString:@"2"]) {
                model.type = @"小学";
                    
                } else if ([model.type isEqualToString:@"3"]){
                model.type = @"中学";
                } else if ([model.type isEqualToString:@"4"]){
                    model.type = @"培训机构";
                }
                [self.datasource addObject:model];
                NSLog(@"搜索上学校获得的数据:%@",self.datasource);
                NSLog(@"学校类型:%@",model.type);
                [self.schoolNameArray addObject:model.name];
                
            }
            //给单元格赋值  默认为第一个
            if (self.datasource.count > 0) {
                XXETeacherModel *model = self.datasource[0];
                // 给单元格赋值
                self.teacherCell = [self cellAtIndexRow:0 andAtSection:0 Message:model.name];
                self.teacherCell = [self cellAtIndexRow:1 andAtSection:0 Message:model.type];
                
                //获取班级信息的网络请求
                [self getoutSchoolGradeSchoolId:model.schoolId SchoolType:model.type];
                
                //获取教学类型网络请求
                [self getoutTeachTypeSchoolType:model.type];
                
                //获取教师的审核人信息
                [self getoutTeacherReviewerSchoolID:model.schoolId];
            }
        } else {
        
            [self showString:@"搜索失败,请确认学校名称" forSecond:1.f];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self showString:@"搜索失败,请确认学校名称" forSecond:1.f];
    }];
}

#pragma mark - 获取班级信息
- (void)getoutSchoolGradeSchoolId:(NSString *)schoolId SchoolType:(NSString *)schoolType
{
    /** 获取班级信息局部学校ID */
    NSString *schoolTYPE;
        if ([schoolType isEqualToString:@"幼儿园"]) {
            schoolTYPE = @"1";
        }else if ([schoolType isEqualToString:@"小学"]){
            schoolTYPE = @"2";
        } else if ([schoolType isEqualToString:@"中学"]){
            schoolTYPE = @"3";
        }  else{
            schoolTYPE = @"4";
        }
    
    NSLog(@"学校ID%@ 学校类型%@",schoolId,schoolTYPE);
    //获取默认的信息
    self.theEndSchoolId = schoolId;
    self.theEndSchoolType = schoolTYPE;
    
    
    XXERegisterGradeSchoolApi *schoolApi = [[XXERegisterGradeSchoolApi alloc]initWithGetOutSchoolGradeSchoolId:schoolId SchoolType:schoolTYPE];
    
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
            XXETeacherGradeModel *model = self.gradeNameDatasource[0];
            //默认为没有选择的时候
            self.theEndClassId = model.course_id;
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
    NSString *teachSchoolType;
    
        if ([schoolType isEqualToString:@"幼儿园"]) {
            teachSchoolType = @"1";
        }else if ([schoolType isEqualToString:@"小学"]){
            teachSchoolType = @"2";
        } else if ([schoolType isEqualToString:@"中学"]){
            teachSchoolType = @"3";
        }  else{
            teachSchoolType = @"4";
        }
    NSLog(@"=======教学类型:%@",teachSchoolType);
    
    
    XXERegisterTeachOfTypeApi *teachTypeApi = [[XXERegisterTeachOfTypeApi alloc]initWithRegisTeachTypeSchoolType:teachSchoolType];
    
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
            self.teacherCell = [self cellAtIndexRow:3 andAtSection:0 Message:self.teachOfTypeArray[0]];
            XXETeachOfTypeModel *model = self.teachOfTypeDatasource[0];
            self.theEndTeachType = model.teachTypeId;
        }else {
        
            [self showString:@"教学类型数据请求失败" forSecond:1.f];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [self showString:@"教学类型请求失败请重试" forSecond:1.f];
    }];
}

#pragma mark - 审核人的数据获取
- (void)getoutTeacherReviewerSchoolID:(NSString *)reviewerSchoolId
{
    NSLog(@"%@%@",self.userIdentifier,reviewerSchoolId);
    XXEReviewerApi *reviewerApi = [[XXEReviewerApi alloc]initReviwerNameSchoolId:reviewerSchoolId PositionID:self.userIdentifier];
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
        self.teacherCell = [self cellAtIndexRow:5 andAtSection:0 Message:self.reviewerNameArray[0]];
        XXEReviewerModel *model = self.reviewerDatasource[0];
        self.theEndReviewerId = model.reviewerId;
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
    
}

#pragma mark - 点击确定提交注册
- (void)sureButtonClick:(UIButton *)sender
{
    NSLog(@"确认按钮");
    NSLog(@"学校ID%@ 学校类型%@ 班级Id%@ 教学类型%@ 审核人ID%@",self.theEndSchoolId,self.theEndSchoolType,self.theEndClassId,self.theEndTeachType,self.theEndReviewerId);
    NSLog(@"登录类型%@ 电话号码%@ 密码%@ 用户姓名%@ 用户身份证%@ 年龄%@ 性别%@ 用户身份%@",self.login_type,self.userPhoneNum,self.userPassword,self.userName,self.userIDCarNum,self.userAge,self.userSex,self.userIdentifier);
    
    
//    self.login_type 登录类型
//    self.userPhoneNum 电话号码
//    self.userPassword 密码
//    self.userName 用户姓名
//    self.userIDCarNum 用户的身份证号
//    self.userAge 用户的年龄
//    self.userSex 用户的性别
//    self.userIdentifier 用户的身份
    
    NSMutableArray *arrApi = [NSMutableArray array];
//
    XXERegisterTeacherApi *teacherApi = [[XXERegisterTeacherApi alloc]initWithRegisterTeacherLoginType:self.login_type PhoneNum:self.userPhoneNum Password:self.userPassword UserName:self.userName IDCard:self.userIDCarNum PassPort:@"" Age:self.userAge Sex:self.userSex Position:self.userIdentifier TeachId:self.theEndTeachType SchoolId:self.theEndSchoolId ClassId:self.theEndClassId SchoolType:self.theEndSchoolType ExamineId:self.theEndReviewerId Code:self.theEndInviteCode];
    [arrApi addObject:teacherApi];


    XXERegisterTeacherHeadApi *teacherHeadApi = [[XXERegisterTeacherHeadApi alloc]initWithRegisterTeacherLoginType:self.login_type PhoneNum:self.userPhoneNum Password:self.userPassword UserName:self.userName IDCard:self.userIDCarNum PassPort:@"" Age:self.userAge Sex:self.userSex Position:self.userIdentifier TeachId:self.theEndTeachType SchoolId:self.theEndSchoolId ClassId:self.theEndClassId SchoolType:self.theEndSchoolType ExamineId:self.theEndReviewerId Code:self.theEndInviteCode HeadImage:self.userAvatarImage];
    
    [arrApi addObject:teacherHeadApi];
    [self setupFileImage];
    if (self.fileImageArray.count > 0) {
        for (int i = 0; i < self.fileImageArray.count; i++) {
            XXERegisterTeacherFileApi *teacherFileApi = [[XXERegisterTeacherFileApi alloc]initWithRegisterTeacherLoginType:self.login_type PhoneNum:self.userPhoneNum Password:self.userPassword UserName:self.userName IDCard:self.userIDCarNum PassPort:@"" Age:self.userAge Sex:self.userSex Position:self.userIdentifier TeachId:self.theEndTeachType SchoolId:self.theEndSchoolId ClassId:self.theEndClassId SchoolType:self.theEndSchoolType ExamineId:self.theEndReviewerId Code:self.theEndInviteCode FileImage:self.fileImageArray[i]];
            [arrApi addObject:teacherFileApi];
        }
        
        YTKBatchRequest *bathRequest = [[YTKBatchRequest alloc]initWithRequestArray:arrApi];
        [bathRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
            NSArray *array = bathRequest.requestArray;
            
            XXERegisterTeacherApi *api1 = (XXERegisterTeacherApi *)array[0];
            NSLog(@"信息%@",api1.responseJSONObject);
            
            XXERegisterTeacherHeadApi *head = (XXERegisterTeacherHeadApi *)array[1];
            NSLog(@"图像%@",head.responseJSONObject);
            XXERegisterTeacherFileApi *file = (XXERegisterTeacherFileApi *)array[2];
             NSLog(@"证件1%@",file.responseJSONObject);
            XXERegisterTeacherFileApi *file1 = (XXERegisterTeacherFileApi *)array[3];
             NSLog(@"证件2%@",file1.responseJSONObject);
            XXERegisterTeacherFileApi *file2 = (XXERegisterTeacherFileApi *)array[4];
             NSLog(@"证件3%@",file2.responseJSONObject);
            
            
            [self showString:@"注册成功" forSecond:1.f];
            
        } failure:^(YTKBatchRequest *batchRequest) {
            [self showHudWithString:@"上传失败" forSecond:1.f];
        }];
        
    }else {
        [teacherApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            NSLog(@"%@",request.responseJSONObject);
            NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
            
        } failure:^(__kindof YTKBaseRequest *request) {
            
        }];
    }

        NSLog(@"照片的数组%@",self.fileImageArray);
    
}

#pragma mark - 获取身份图片
- (void)setupFileImage
{
    NSMutableArray *arr = [NSMutableArray array];
    [self.picker.data removeLastObject];
    arr = self.picker.data;
    
    for (int i =0; i <arr.count; i++) {
        FSImageModel *model = self.picker.data[i];
        UIImage *fileImage = [UIImage imageWithData:model.data];
        [self.fileImageArray addObject:fileImage];
    }
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

@end
