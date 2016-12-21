//
//  XXEIdentityAddHeadViewController.m
//  teacher
//
//  Created by codeDing on 16/9/5.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEIdentityAddHeadViewController.h"
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

@interface XXEIdentityAddHeadViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,XXESearchSchoolMessageDelegate,UITextFieldDelegate>{
    UIButton *landBtn;
    //ding
    NSArray *_titleArr;
    NSArray *_titleTextArr;
    NSMutableArray *_schoolTypeArr;
}

@property (nonatomic, strong)FSImagePickerView *picker;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UISearchController *searchDC;
/** 没有转换的学校类型 */
@property (nonatomic, copy)NSString *schoolType;
/** 老师注册的tableView */
@property (nonatomic, strong)UITableView *teacherTableView;
/** 单元格 */
@property (nonatomic, strong)XXETeacherTableViewCell *teacherCell;
/** 数据源 */
@property (nonatomic, strong)NSMutableArray *schoolDatasource;
/** 学校名称数组 */
@property (nonatomic, strong)NSMutableArray *schoolNameArray;

/** 审核人的数据源 */
@property (nonatomic, strong)NSMutableArray *reviewerDatasource;
/** 审核人姓名 */
@property (nonatomic, strong)NSMutableArray *reviewerNameArray;
@property (nonatomic, strong)WZYSearchSchoolViewController *schoolVC;

/** 判断是否有值 */
@property (nonatomic, assign)BOOL isHave;

/** 最后教师注册所选的学校id */
@property (nonatomic, copy)NSString *theEndSchoolId;
/** 班级Id */
@property (nonatomic, copy)NSString *theEndClassId;
/** 学校类型 */
@property (nonatomic, copy)NSString *theEndSchoolType;

/** 审核人Id */
@property (nonatomic, copy)NSString *theEndReviewerId;
/** 邀请码 */
@property (nonatomic, copy)NSString *theEndInviteCode;
/** 学校的联系方式 */
@property (nonatomic, copy)NSString *schoolTel;
//手动输入的时候
/** 学校的详细地址 */
@property (nonatomic, copy)NSString *schoolAddrss;
/** 学校的名字 */
@property (nonatomic, copy)NSString *schoolName;
/** 学校的省 */
@property (nonatomic, copy)NSString *schoolProvince;
/** 学校的城市 */
@property (nonatomic, copy)NSString *schoolCity;
/** 学校的区 */
@property (nonatomic, copy)NSString *schoolDistrict;

/** 获取证件url */
@property (nonatomic, copy)NSString *theEndFileImage;

/** 证件照片 */
@property (nonatomic, strong)NSMutableArray *fileHeadImageArray;

@end

static NSString *IdentifierCELL = @"TeacherCell";
static NSString *IdentifierMessCELL = @"TeacherMessCell";

@implementation XXEIdentityAddHeadViewController

- (NSMutableArray *)fileHeadImageArray
{
    if (!_fileHeadImageArray) {
        _fileHeadImageArray = [NSMutableArray array];
    }
    return _fileHeadImageArray;
}

- (NSMutableArray *)reviewerNameArray
{
    if (!_reviewerNameArray) {
        _reviewerNameArray = [NSMutableArray array];
    }
    return _reviewerNameArray;
}

- (NSMutableArray *)reviewerDatasource
{
    if (!_reviewerDatasource) {
        _reviewerDatasource = [NSMutableArray array];
    }
    return _reviewerDatasource;
}

- (NSMutableArray *)schoolDatasource
{
    if (!_schoolDatasource) {
        _schoolDatasource = [NSMutableArray array];
    }
    return _schoolDatasource;
}

- (UITableView *)teacherTableView
{
    if (!_teacherTableView) {
        _teacherTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -33, KScreenWidth, 500*kScreenRatioHeight) style:UITableViewStyleGrouped];
        _teacherTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _teacherTableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    
    self.navigationItem.title = @"完善资料";
    
    self.navigationController.navigationBarHidden = NO;
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self LnitializeTheParameter];
    [self commBoxInfo];
    
    self.isHave = NO;
    
    _titleArr = @[@"学校名称:",@"学校类型:",@"学校地址:",@"详细地址:",@"联系方式:",@"",@"审核人员:",@"邀请码"];
    
    _titleTextArr = @[@"请输入或搜索学校名称",@"请选择你学校类型",@"学校地址",@"请输入详细地址",@"联系方式",@"",@"请选择审核人",@"可不填"];
    NSArray *arr = @[@"幼儿园",@"小学",@"初中",@"培训机构",@"高中"];
    _schoolTypeArr = [arr copy];
    self.teacherTableView.delegate = self;
    self.teacherTableView.dataSource = self;
    [self.teacherTableView registerNib:[UINib nibWithNibName:@"XXETeacherTableViewCell" bundle:nil] forCellReuseIdentifier:IdentifierCELL];
    [self.teacherTableView registerNib:[UINib nibWithNibName:@"XXETeacherMessTableViewCell" bundle:nil] forCellReuseIdentifier:IdentifierMessCELL];
    [self.view addSubview:self.teacherTableView];
}


#pragma mark - 初始化参数
- (void)LnitializeTheParameter
{
    self.theEndInviteCode = @"";
    self.schoolAddrss = @"";
    self.schoolTel = @"";
    self.theEndSchoolId = @"";
    self.theEndSchoolType = @"";
    self.schoolName = @"";
    self.theEndClassId = @"";
    self.schoolProvince = @"";
    self.schoolCity = @"";
    self.schoolDistrict = @"";
    self.theEndReviewerId = @"";
    [self.picker removeFromSuperview];
    [self.picker.data removeAllObjects];
    self.teacherCell = [self cellAtIndexRow:3 andAtSection:0 Message:@""];
    self.teacherCell = [self cellAtIndexRow:4 andAtSection:0 Message:@""];
    self.teacherCell = [self cellAtIndexRow:7 andAtSection:0 Message:@""];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        return 125*kScreenRatioHeight;
    }else {
        return 45*kScreenRatioHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        XXETeacherMessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentifierMessCELL forIndexPath:indexPath];
        return cell;
    } else {
        XXETeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentifierCELL forIndexPath:indexPath];
        cell.teacherRegisLabel.text = [_titleArr objectAtIndex:indexPath.row];
        cell.teacherRegisTextField.placeholder = [_titleTextArr objectAtIndex:indexPath.row];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    switch (indexPath.row) {
        case 0:{
            self.teacherCell = [self cellAtIndexRow:0 andAtSection:0 Message:@""];
            [self tureOrFalseCellClick:YES Tag:100];
            break;
        }
        case 1:{
            XXESelectMessageView *schoolType = [[XXESelectMessageView alloc]initWithTWFrame:self.view.bounds TWselectCityTitle:@"学校类型" MessageArray:_schoolTypeArr];
            
            [schoolType showCityView:^(NSString *proviceStr) {
                
                self.teacherCell = [self cellAtIndexRow:1 andAtSection:0 Message:[NSString  stringWithFormat:@"%@",proviceStr]];
                self.theEndSchoolType = proviceStr;
            }];
            break;
        }
        case 2:{
            TWSelectCityView *city = [[TWSelectCityView alloc] initWithTWFrame:CGRectMake(0, -61, KScreenWidth, KScreenHeight) TWselectCityTitle:@"选择地区"];
            [city showCityView:^(NSString *proviceStr, NSString *cityStr, NSString *distr) {
                NSString *string = [NSString stringWithFormat:@"%@-%@-%@",proviceStr,cityStr,distr];
                self.teacherCell = [self cellAtIndexRow:2 andAtSection:0 Message:string];
                self.schoolProvince = proviceStr;
                self.schoolCity = cityStr;
                self.schoolDistrict = distr;
                NSLog(@"地点%@",self.teacherCell.teacherRegisTextField.text);
            }];
            //            }
            break;
        }
        case 3:{
            self.teacherCell = [self cellAtIndexRow:3 andAtSection:0 Message:@""];
            [self tureOrFalseCellClick:YES Tag:103];
            NSLog(@"详细地点%@",self.teacherCell.teacherRegisTextField.text);
            break;
        }
        case 4:{
            self.teacherCell = [self cellAtIndexRow:4 andAtSection:0 Message:@""];
            [self tureOrFalseCellClick:YES Tag:104];
            
            NSLog(@"电话%@",self.teacherCell.teacherRegisTextField.text);
            break;
        }
        case 6:{
            
                self.teacherCell = [self cellAtIndexRow:6 andAtSection:0 Message:@"平台审核"];
            [self tureOrFalseCellClick:NO Tag:106];
            break;
        }
        case 7:{
            self.teacherCell = [self cellAtIndexRow:7 andAtSection:0 Message:@""];
            [self tureOrFalseCellClick:YES Tag:107];
            
            NSLog(@"蛇和好%@",self.teacherCell.teacherRegisTextField.text);
            break;
        }
        default:
            break;
    }
}

#pragma mark - 判断单元格能不能点击
- (void)tureOrFalseCellClick:(BOOL)click Tag:(NSInteger)tags
{
    self.teacherCell.teacherRegisTextField.enabled = click;
    self.teacherCell.teacherRegisTextField.tag = tags;
    self.teacherCell.teacherRegisTextField.delegate = self;
}


#pragma mark  - UITextField
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 100:
            NSLog(@"%@",textField.text);
            self.schoolName = textField.text;
            break;
        case 103:
            NSLog(@"%@",textField.text);
            self.schoolAddrss = textField.text;
            break;
        case 104:
            NSLog(@"%@",textField.text);
            self.schoolTel = textField.text;
            break;
        case 107:
            NSLog(@"%@",textField.text);
            self.theEndInviteCode = textField.text;
            break;
        default:
            break;
    }
}


//获取tableView的cell
- (XXETeacherTableViewCell *)cellAtIndexRow:(NSInteger)row andAtSection:(NSInteger) section
{
    XXETeacherTableViewCell *cell = [_teacherTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    return cell;
}

//获取对应的cell
- (XXETeacherMessTableViewCell *)cellMessAtIndex:(NSInteger)row andAtSection:(NSInteger)section
{
    XXETeacherMessTableViewCell *cell = [_teacherTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    return cell;
}


-(void)commBoxInfo{
    //    //选择图片
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    FSImagePickerView *picker = [[FSImagePickerView alloc] initWithFrame:CGRectMake(20, 310*kScreenRatioHeight, KScreenWidth -  40, 70*kScreenRatioHeight) collectionViewLayout:layout];
    self.picker = picker;
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

#pragma mark - actionClick
//注册成功的按钮
- (void)sureButtonClick:(UIButton *)sender
{
    NSLog(@"蛇和人的ID %@",self.theEndReviewerId);
    
    if ([self.theEndReviewerId isEqualToString:@""]) {
        [self showString:@"请选择审核人" forSecond:1.f];
        return;
    }else if ([self.schoolAddrss isEqualToString:@""] ){
        [self showString:@"请填写学校详细地址" forSecond:1.f];
        return;
    }else if ([self.schoolTel isEqualToString:@""]){
        [self showString:@"请填写学校电话" forSecond:1.f];
        return;
    }else if ([self.schoolType isEqualToString:@""]){
        [self showString:@"请选择学校类" forSecond:1.f];
        return;
    }else if ([self.schoolProvince isEqualToString:@""]){
        [self showString:@"请填写学校地址" forSecond:1.f];
        return;
    }else
    {
        [self getIdCardPhotoImage];
    }
    
    NSLog(@"邀请码%@ 学校详细地址%@ 学校电话%@ 学校ID%@ 学校类型%@ 学校名字%@ 学校省%@ 学校市%@ 学校区%@ 审核人%@",self.theEndInviteCode,self.schoolAddrss,self.schoolTel,self.theEndSchoolId,self.theEndSchoolType,self.schoolName,self.schoolProvince,self.schoolCity,self.schoolDistrict,self.theEndReviewerId);
}

#pragma mark - 获取证件图片
- (void)getIdCardPhotoImage
{
    NSMutableArray *arr = [NSMutableArray array];
    if (self.picker.data.count ==1) {
        //往服务器传所有的参数
        self.theEndFileImage = @"";
        [self uploadHeadMasterRegisterMessage];
    }else{
        [self.picker.data removeLastObject];
        arr = self.picker.data;
        for (int i =0; i <arr.count; i++) {
            FSImageModel *model = self.picker.data[i];
            UIImage *fileImage = [UIImage imageWithData:model.data];
            [self.fileHeadImageArray addObject:fileImage];
        }
        //用户的证件照
        [self fileUserUpLoadSomeImage];
    }
}

#pragma mark - 用户的证件照上传服务器得到返回值
- (void)fileUserUpLoadSomeImage
{
    NSLog(@"%@",self.fileHeadImageArray);
    NSDictionary *dict = @{@"file_type":@"1",
                           @"page_origin":@"2",
                           @"upload_format":@"2",
                           @"appkey":APPKEY,
                           @"user_type":USER_TYPE,
                           @"backtype":BACKTYPE
                           };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:XXERegisterUpLoadPicUrl parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i< _fileHeadImageArray.count; i++) {
            NSData *data = UIImageJPEGRepresentation(_fileHeadImageArray[i], 0.5);
            NSString *name = [NSString stringWithFormat:@"%d.jpeg",i];
            NSString *formKey = [NSString stringWithFormat:@"file%d",i];
            NSString *type = @"image/jpeg";
            [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
        }
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
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
            [self uploadHeadMasterRegisterMessage];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self showString:@"注册失败" forSecond:1.f];
    }];
    
}

#pragma mark - 网服务器传送注册
- (void)uploadHeadMasterRegisterMessage
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
    
    NSLog(@"邀请码%@ 学校详细地址%@ 学校电话%@ 学校ID%@ 学校类型%@ 学校名字%@ 学校省%@ 学校市%@ 学校区%@ 审核人%@ 本人类型%@",self.theEndInviteCode,self.schoolAddrss,self.schoolTel,self.theEndSchoolId,self.theEndSchoolType,self.schoolName,self.schoolProvince,self.schoolCity,self.schoolDistrict,self.theEndReviewerId,self.headPosition);
    NSLog(@"班级ID%@",_theEndClassId);
    NSDictionary *parameter = @{
                                @"position":self.headPosition,
                                @"teach_course_id":@"",
                                @"school_id":_theEndSchoolId,
                                @"class_id":_theEndClassId,
                                @"school_type":_theEndSchoolType,
                                @"examine_id":_theEndReviewerId,
                                @"code":_theEndInviteCode,
                                @"address":_schoolAddrss,
                                @"school_tel":_schoolTel,
                                @"school_name":_schoolName,
                                @"province":_schoolProvince,
                                @"city":_schoolCity,
                                @"district":_schoolDistrict,
                                
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
        
        if ([[responseObject objectForKey:@"code"] intValue]==1) {
            
            [self showString:@"你已添加成功成功" forSecond:3.f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //
                XXEAddIdentityViewController *addIdentityVC = self.navigationController.viewControllers[1];
                [self.navigationController popToViewController:addIdentityVC animated:YES];
            });

            
        } else if([[responseObject objectForKey:@"code"] intValue]==16){
            [self showString:@"你要添加的身份已存在" forSecond:2.f];
        }else{
            [self showString:@"添加身份失败" forSecond:1.f];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showString:@"添加学校失败" forSecond:1.f];
        NSLog(@"%@",error);
        
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
//        [self LnitializeTheParameter];
//        self.schoolDatasource = mArr;
//        self.schoolVC.delegate = self;
//    }];
    
    [searchVC returnModel:^(XXETeacherModel *teacherModel) {
        //
        
        NSLog(@"jjj  %@", teacherModel);
                if (teacherModel != nil) {
                    self.isHave = YES;
                }else {
                    self.isHave = NO;
                }
                [self LnitializeTheParameter];
//                self.schoolDatasource = mArr;
                self.schoolVC.delegate = self;
    }];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - 搜索的代理方法
- (void)searchSchoolMessage:(XXETeacherModel *)model
{
    
    self.theEndSchoolId = model.schoolId;
    self.theEndSchoolType = model.type;
    self.schoolName = model.name;
    self.schoolProvince = model.province;
    self.schoolCity = model.city;
    self.schoolDistrict = model.district;
    
    NSLog(@"%@ %@",model,model.name);
    self.teacherCell = [self cellAtIndexRow:0 andAtSection:0 Message:model.name];
    NSString *typeName ;
    if ([model.type isEqualToString:@"1"]) {
        typeName = @"幼儿园";
        
    } else if ([model.type isEqualToString:@"2"]) {
        typeName = @"小学";
        
    } else if ([model.type isEqualToString:@"3"]){
        typeName = @"初中";
    } else if ([model.type isEqualToString:@"4"]){
        typeName = @"培训机构";
    }else if ([model.type isEqualToString:@"5"]){
        typeName = @"高中";
    }
    self.teacherCell = [self cellAtIndexRow:1 andAtSection:0 Message:typeName];
    NSString *addressSchool = [NSString stringWithFormat:@"%@-%@-%@",model.province,model.city,model.district];
    self.teacherCell = [self cellAtIndexRow:2 andAtSection:0 Message:addressSchool];
    
    //获取审核人
    [self setupReviewerMessage:model.schoolId];
    
    
}
#pragma mark - 获取审核人

- (void)setupReviewerMessage:(NSString *)schoolID
{
    XXEReviewerApi *reviewerApi = [[XXEReviewerApi alloc]initReviwerNameSchoolId:schoolID PositionID:@"4"];
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
        self.teacherCell = [self cellAtIndexRow:6 andAtSection:0 Message:self.reviewerNameArray[0]];
        NSLog(@"self.reviewerDatasource -- %@", self.reviewerDatasource);
        
        XXEReviewerModel *model = self.reviewerDatasource[0];
        self.theEndReviewerId = model.reviewerId;
        
        NSLog(@"-=-=%@",self.theEndReviewerId);
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}


//获取tableView的cell
- (XXETeacherTableViewCell *)cellAtIndexRow:(NSInteger)row andAtSection:(NSInteger) section Message:(NSString *)message
{
    XXETeacherTableViewCell *cell = [_teacherTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    cell.teacherRegisTextField.text = message;
    return cell;
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
