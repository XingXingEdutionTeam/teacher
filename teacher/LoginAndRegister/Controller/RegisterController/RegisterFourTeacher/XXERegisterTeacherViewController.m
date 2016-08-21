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
//选择城市相关
#import "TWSelectCityView.h"
#import "XXESelectMessageView.h"
#import "FSImagePickerView.h"
#import "UtilityFunc.h"
#import "XXELoginViewController.h"
#define awayX 20
@interface XXERegisterTeacherViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{
    UIButton *landBtn;
    //ding
    NSArray *_titleArr;
    NSArray *_titleTextArr;
}
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UISearchController *searchDC;

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

@end

static NSString *IdentifierCELL = @"TeacherCell";
static NSString *IdentifierMessCELL = @"TeacherMessCell";

@implementation XXERegisterTeacherViewController

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
//        else if (indexPath.row == 1 || indexPath.row == 6) {
//        XXETeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentifierCELL forIndexPath:indexPath];
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        return cell;
//    }
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
                [self getoutTeachTypeSchoolType:model.type];
                
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
                NSLog(@"%@",proviceStr);
                
                //获取教学类型数据信息
//                [self getoutTeachTypeSchoolType];
                
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
                NSLog(@"%@",proviceStr);
            }];
            }
            break;
        }
        case 4:{
            
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
    picker.backgroundColor = UIColorFromRGB(255, 255, 255);
    picker.showsHorizontalScrollIndicator = NO;
    picker.controller = self;
    [self.teacherTableView addSubview:picker];
    
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

- (void)sureButtonClick:(UIButton *)sender
{
    NSLog(@"确认按钮");
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
//    if (_indexDatsource != 0) {
//        XXETeacherModel *model = self.datasource[_indexDatsource];
//        NSLog(@"学校类型:%@",model.type);
//        NSLog(@"xuexiao%@",self.schoolType);
//        if ([model.type isEqualToString:@"幼儿园"]) {
//            self.schoolType = @"1";
//        }else if ([model.type isEqualToString:@"小学"]){
//            self.schoolType = @"2";
//        } else if ([model.type isEqualToString:@"中学"]){
//            self.schoolType = @"3";
//        }  else{
//            self.schoolType = @"4";
//        }
//        schoolID = model.schoolId;
//        NSLog(@"学校ID:%@, 学校类型Id%@",model.schoolId,self.schoolType);
//        
//    }else {
        if ([schoolType isEqualToString:@"幼儿园"]) {
            schoolTYPE = @"1";
        }else if ([schoolType isEqualToString:@"小学"]){
            schoolTYPE = @"2";
        } else if ([schoolType isEqualToString:@"中学"]){
            schoolTYPE = @"3";
        }  else{
            schoolTYPE = @"4";
        }
//        schoolID = schoolId;
//    }
    
    NSLog(@"学校ID%@ 学校类型%@",schoolId,schoolTYPE);
    
    
    XXERegisterGradeSchoolApi *schoolApi = [[XXERegisterGradeSchoolApi alloc]initWithGetOutSchoolGradeSchoolId:schoolId SchoolType:schoolTYPE];
    
    [schoolApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
       
        if ([[request.responseJSONObject objectForKey:@"code"] intValue] == 1) {
            NSLog(@"%@",request.responseJSONObject);
            NSArray *data = [request.responseJSONObject objectForKey:@"data"];
            NSLog(@"%@",data);
            
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
//    if (_indexDatsource != 0) {
//        XXETeacherModel *model = self.datasource[_indexDatsource];
//        NSLog(@"xuexiao%@",model.type);
//        if ([model.type isEqualToString:@"幼儿园"]) {
//            teachSchoolType = @"1";
//        }else if ([model.type isEqualToString:@"小学"]){
//            teachSchoolType = @"2";
//        } else if ([model.type isEqualToString:@"中学"]){
//            teachSchoolType = @"3";
//        }  else{
//            teachSchoolType = @"4";
//        }
//        
//    }else {
    
        if ([schoolType isEqualToString:@"幼儿园"]) {
            teachSchoolType = @"1";
        }else if ([schoolType isEqualToString:@"小学"]){
            teachSchoolType = @"2";
        } else if ([schoolType isEqualToString:@"中学"]){
            teachSchoolType = @"3";
        }  else{
            teachSchoolType = @"4";
        }
//    }
    NSLog(@"=======教学类型:%@",teachSchoolType);
    
    XXERegisterTeachOfTypeApi *teachTypeApi = [[XXERegisterTeachOfTypeApi alloc]initWithRegisTeachTypeSchoolType:teachSchoolType];
    
    [teachTypeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSLog(@"%@",request.responseJSONObject);
        if ([[request.responseJSONObject objectForKey:@"code"]intValue]== 1) {
            NSArray *data = [request.responseJSONObject objectForKey:@"data"];
            //获取教学类型前 先清空数组
            [self.teachOfTypeDatasource removeAllObjects];
            [self.teachOfTypeArray removeAllObjects];
            
            for (int i =0; i<data.count; i++) {
                XXETeachOfTypeModel *model = [[XXETeachOfTypeModel alloc]initWithDictionary:data[i] error:nil];
                [self.teachOfTypeDatasource addObject:model];
                [self.teachOfTypeArray addObject:model.teachTypeName];
            }
            self.teacherCell = [self cellAtIndexRow:3 andAtSection:0 Message:self.teachOfTypeArray[0]];
        }else {
        
            [self showString:@"教学类型数据请求失败" forSecond:1.f];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [self showString:@"教学类型请求失败请重试" forSecond:1.f];
    }];
}

#pragma mark - 审核人的数据获取


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
