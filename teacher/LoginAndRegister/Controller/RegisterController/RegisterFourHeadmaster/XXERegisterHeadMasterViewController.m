//
//  XXERegisterHeadMasterViewController.m
//  teacher
//
//  Created by codeDing on 16/8/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//


//
//  XXERegisterHeadMasterViewController.m
//  teacher
//
//  Created by codeDing on 16/8/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERegisterHeadMasterViewController.h"
#import "XXETeacherTableViewCell.h"
#import "XXETeacherMessTableViewCell.h"
#import "XXERegisterSearchSchoolApi.h"
#import "XXETeacherModel.h"
#import "WZYSearchSchoolViewController.h"
#import "XXEReviewerApi.h"
#import "XXEReviewerModel.h"
//选择城市相关
#import "TWSelectCityView.h"
#import "XXESelectMessageView.h"
#import "FSImagePickerView.h"
#import "FSImageModel.h"
#import "UtilityFunc.h"
#import "XXELoginViewController.h"
#import "XXERegisterPicApi.h"
#import "XXEUserInfo.h"
#import "XXESearchAccurateApi.h"
#import "SchoolModel.h"
#import "MBProgressHUD.h"


#define awayX 20
@interface XXERegisterHeadMasterViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,XXESearchSchoolMessageDelegate,UITextFieldDelegate>{
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

/** 获取头像url */
@property (nonatomic, copy)NSString *theEndUserAvatarImage;
/** 获取证件url */
@property (nonatomic, copy)NSString *theEndFileImage;

/** 证件照片 */
@property (nonatomic, strong)NSMutableArray *fileHeadImageArray;

///** 测试存储的图片 */
//@property (nonatomic, strong)NSMutableArray *mutableHeadArray;

@end

static NSString *IdentifierCELL = @"TeacherCell";
static NSString *IdentifierMessCELL = @"TeacherMessCell";

@implementation XXERegisterHeadMasterViewController


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
    
    if ([self.login_type isEqualToString:@"1"]) {
       self.navigationItem.title = @"4/4注册";
    }else{
        self.navigationItem.title = @"完善资料2/2";
    }
    self.navigationController.navigationBarHidden = NO;
    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(-10,0,22,22)];
    [rightButton setImage:[UIImage imageNamed:@"search_icon"]  forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [self.picker removeFromSuperview];
}

/** 这个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self LnitializeTheParameter];
//    [self commBoxInfo];
    
    self.isHave = NO;
    
//    NSLog(@"打印传过来的数据:电话号码%@ 姓名%@ 身份证%@ 密码%@ 类型%@ 头像%@ 登录类型%@ 性别%@ 年龄%@",self.userPhoneNum,self.userName,self.userIDCarNum,self.userPassword,self.userIdentifier,self.userAvatarImage,self.login_type,self.userSex,self.userAge);
    
    _titleArr = @[@"学校名称:",@"学校类型:",@"学校地址:",@"详细地址:",@"联系方式:",@"",@"审核人员:",@"邀请码"];
    
    _titleTextArr = @[@"请输入或搜索学校名称",@"请选择你学校类型",@"学校地址",@"请输入详细地址",@"联系方式",@"",@"请选择审核人",@"可不填"];
    NSArray *arr = @[@"幼儿园",@"小学",@"中学",@"培训机构",@"高中"];
    _schoolTypeArr = [arr copy];
    self.teacherTableView.delegate = self;
    self.teacherTableView.dataSource = self;
    [self.teacherTableView registerNib:[UINib nibWithNibName:@"XXETeacherTableViewCell" bundle:nil] forCellReuseIdentifier:IdentifierCELL];
    [self.teacherTableView registerNib:[UINib nibWithNibName:@"XXETeacherMessTableViewCell" bundle:nil] forCellReuseIdentifier:IdentifierMessCELL];
    [self.view addSubview:self.teacherTableView];
    
    //校长的头像
    [self headMasterImageUpLoad];
}

#pragma mark - 上传校长头像
- (void)headMasterImageUpLoad
{
    NSLog(@"用户头像%@",self.userAvatarImage);
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    
    if (self.userAvatarImage != nil) {
        XXERegisterPicApi *headPicApi = [[XXERegisterPicApi alloc]initUpLoadRegisterPicFileType:@"1" PageOrigin:@"1" UploadFormat:@"1" UIImageHead:self.userAvatarImage];
        [headPicApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            [hub hide:YES];
            NSString *code = [request.responseJSONObject objectForKey:@"code"];
            if ([code intValue]== 1) {
                NSString *avatar = [request.responseJSONObject objectForKey:@"data"];
                self.theEndUserAvatarImage = avatar;
            }
            NSLog(@"%@",request.responseJSONObject);
            NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
            
        } failure:^(__kindof YTKBaseRequest *request) {
            [hub hide:YES];
        }];
    }else{
        //设置默认头像
        self.theEndUserAvatarImage = kDefaultAvatarUrl;
        [hub hide:YES];
    }
    
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
        return 140*kScreenRatioHeight;
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
        
        if (indexPath.row == 6) {
            cell.teacherRegisTextField.text = @"平台审核";
        }
        
        cell.teacherRegisTextField.tag = 100 + indexPath.row;
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    switch (indexPath.row) {
        case 0:{
            self.teacherCell = [self cellAtIndexRow:0 andAtSection:0 Message:@""];
                [self tureOrFalseCellClick:YES];
            break;
        }
        case 1:{
            XXESelectMessageView *schoolType = [[XXESelectMessageView alloc]initWithTWFrame:self.view.bounds TWselectCityTitle:@"学校类型" MessageArray:_schoolTypeArr];
            
            [schoolType showCityView:^(NSString *proviceStr) {
                
                self.teacherCell = [self cellAtIndexRow:1 andAtSection:0 Message:[NSString  stringWithFormat:@"%@",proviceStr]];
                
                if ([proviceStr isEqualToString:@"幼儿园"]) {
                    self.theEndSchoolType = @"1";
                }else if([proviceStr isEqualToString:@"小学"]) {
                    self.theEndSchoolType = @"2";
                }else if([proviceStr isEqualToString:@"中学"]) {
                    self.theEndSchoolType = @"3";
                }else if ([proviceStr isEqualToString:@"培训机构"]) {
                    self.theEndSchoolType = @"4";
                }
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
            [self tureOrFalseCellClick:YES];
             NSLog(@"详细地点%@",self.teacherCell.teacherRegisTextField.text);
            break;
        }
        case 4:{
            self.teacherCell = [self cellAtIndexRow:4 andAtSection:0 Message:@""];
            [self tureOrFalseCellClick:YES];
            
             NSLog(@"电话%@",self.teacherCell.teacherRegisTextField.text);
            break;
        }
        case 6:{
//               self.teacherCell = [self cellAtIndexRow:6 andAtSection:0 Message:@"平台审核"];
//            self.theEndReviewerId = @"0";
//            [self tureOrFalseCellClick:NO];
            break;
        }
        case 7:{
            self.teacherCell = [self cellAtIndexRow:7 andAtSection:0 Message:@""];
            [self tureOrFalseCellClick:YES];

             NSLog(@"蛇和好%@",self.teacherCell.teacherRegisTextField.text);
            break;
        }
        default:
            break;
    }
}

#pragma mark - 判断单元格能不能点击
- (void)tureOrFalseCellClick:(BOOL)click
{
    self.teacherCell.teacherRegisTextField.enabled = click;
//    self.teacherCell.teacherRegisTextField.tag = tags;
    self.teacherCell.teacherRegisTextField.delegate = self;
}


#pragma mark  - UITextField
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField.tag == 107) {
        [UIView animateWithDuration:0.4 animations:^{
            self.view.transform = CGAffineTransformIdentity;
        }];
    }
    
    switch (textField.tag) {
        case 100:
            NSLog(@"%@",textField.text);
            self.schoolName = textField.text;
            
            if (textField.text.length == 0) {
                return;
            }
            [self checkSchoolRequestWithSchoolName:textField.text];
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

//MARK: - 验证学校网络请求
- (void)checkSchoolRequestWithSchoolName:(NSString*)schoolName {
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    hub.labelText = @"正在验证学校";
    
    UITextField *schoolNameTF = (UITextField *)[self.view viewWithTag:100];
    UITextField *schoolTypeTF = (UITextField *)[self.view viewWithTag:101];
    UITextField *schoolLocationTF = (UITextField *)[self.view viewWithTag:102];
    UITextField *schoolDetailAddressTF = (UITextField *)[self.view viewWithTag:103];
    UITextField *telTF = (UITextField *)[self.view viewWithTag:104];
    XXESearchAccurateApi *api = [[XXESearchAccurateApi alloc] initWithRegisterSearchSchoolName:schoolName];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        [hub hide:YES];
        
        
        NSString *code = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        if ([code isEqualToString:@"3"]) {
            [self showString:@"未找到该学校" forSecond:1.f];
            schoolTypeTF.text = @"";
            schoolLocationTF.text = @"";
            schoolDetailAddressTF.text = @"";
            telTF.text = @"";
            return;
        }
        
         [self showString:@"验证成功" forSecond:1.f];
        NSDictionary *dict = request.responseJSONObject[@"data"][0];
        SchoolModel *model = [SchoolModel SchoolModelWithDictionary:dict];
        self.theEndSchoolId = model.schoolId;
        schoolNameTF.text = model.schoolName;
        self.schoolName = model.schoolName;
        schoolTypeTF.text = model.schoolType;
        if ([model.schoolType isEqualToString:@"幼儿园"]) {
            self.theEndSchoolType = @"1";
        }else if([model.schoolType isEqualToString:@"小学"]) {
            self.theEndSchoolType = @"2";
        }else if([model.schoolType isEqualToString:@"中学"]) {
            self.theEndSchoolType = @"3";
        }else if ([model.schoolType isEqualToString:@"培训机构"]) {
            self.theEndSchoolType = @"4";
        }
        schoolLocationTF.text = [NSString stringWithFormat:@"%@ %@ %@", model.province,model.city,model.district];
        self.schoolProvince = model.province;
        self.schoolCity = model.city;
        self.schoolDistrict = model.district;
        schoolDetailAddressTF.text = model.address;
        self.schoolAddrss = model.address;
        telTF.text = model.tel;
        self.schoolTel = model.tel;
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [hub hide:YES];
        [self showString:@"未找到该学校" forSecond:1.f];
        schoolTypeTF.text = @"";
        schoolLocationTF.text = @"";
        schoolDetailAddressTF.text = @"";
        telTF.text = @"";
    }];
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
    FSImagePickerView *picker = [[FSImagePickerView alloc] initWithFrame:CGRectMake(20, 325*kScreenRatioHeight, KScreenWidth -  40, 70*kScreenRatioHeight) collectionViewLayout:layout];
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
    NSLog(@"证件%@",self.fileHeadImageArray);
    
    
    if ([self.theEndReviewerId isEqualToString:@""]) {
        [self showString:@"请选择审核人" forSecond:1.f];
        
    }else if ([self.schoolAddrss isEqualToString:@""] ){
        [self showString:@"请填写学校详细地址" forSecond:1.f];
        
    }else if ([self.schoolTel isEqualToString:@""]){
        [self showString:@"请填写学校电话" forSecond:1.f];
        
    }else if ([self.schoolType isEqualToString:@""]){
        [self showString:@"请选择学校类" forSecond:1.f];
        
    }else if ([self.schoolProvince isEqualToString:@""]){
        [self showString:@"请填写学校地址" forSecond:1.f];
        
    }else if (self.picker.data.count ==1){
        [self showString:@"请选择学校证件" forSecond:1.f];
        
    } else
    {
    [self getIdCardPhotoImage];
    }
    
//    NSLog(@"登录类型%@ 电话号码%@ 密码%@ 用户姓名%@ 用户身份证%@ 年龄%@ 性别%@ 用户身份%@ 用户头像%@",self.login_type,self.userPhoneNum,self.userPassword,self.userName,self.userIDCarNum,self.userAge,self.userSex,self.userIdentifier,self.userAvatarImage);
//    NSLog(@"邀请码%@ 学校详细地址%@ 学校电话%@ 学校ID%@ 学校类型%@ 学校名字%@ 学校省%@ 学校市%@ 学校区%@ 审核人%@",self.theEndInviteCode,self.schoolAddrss,self.schoolTel,self.theEndSchoolId,self.theEndSchoolType,self.schoolName,self.schoolProvince,self.schoolCity,self.schoolDistrict,self.theEndReviewerId);
}

#pragma mark - 获取证件图片
- (void)getIdCardPhotoImage
{
    NSLog(@"self.picker.data === %@", self.picker.data);
    NSLog(@"self.picker.data.count === %ld", self.picker.data.count);
    
    
    NSMutableArray *arr = [NSMutableArray array];
    if (self.picker.data.count ==1) {
        //往服务器传所有的参数
        self.theEndFileImage = @"";
        [self uploadHeadMasterRegisterMessage];
    }else{
        [self.picker.data removeLastObject];
        arr = self.picker.data;
        
        for (int i =0; i <arr.count; i++) {
            NSLog(@"arr[i] === %@", arr[i]);
            
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
//    NSLog(@"管理员 ===== 校长 ===== 上传 图片 处理 %@",self.fileHeadImageArray);
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
//        NSLog(@"+++++ %@",responseObject);
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
            
            NSLog(@"tp str === %@", str);
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
    
    if (self.userPhoneNum == nil) {
        self.userPhoneNum = @"";
    }

    NSLog(@"theEndFileImage == %@", _theEndFileImage);
    
    //_userPhoneNum
    //return_param_all = 1		//要求返回所有传参,测试用
    NSDictionary *parameter = @{
                                @"login_type":_login_type,
                                @"phone": _userPhoneNum,
                                @"pass":_userPassword,
                                @"tname":_userName,
                                @"id_card":_userIDCarNum,
                                @"passport":_headPassport,
                                @"age":_userAge,
                                @"sex":_userSex,
                                @"position":_userIdentifier,
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
                                @"head_img":_theEndUserAvatarImage,
                                @"file":_theEndFileImage,
                                @"qq":_headThirdQQToken,
                                @"weixin":_headThirdWeiXinToken,
                                @"weibo":_headThirdSinaToken,
                                @"alipay":_headThirdAliPayToken,
                                @"appkey":APPKEY,
                                @"backtype":BACKTYPE,
                                @"user_type":USER_TYPE,
                                @"return_param_all":@""
                                };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:XXERegisterTeacherUrl parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        
    }success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"注册传参 :%@",responseObject);
        NSLog(@"%@",[responseObject objectForKey:@"msg"]);
        
        if ([[responseObject objectForKey:@"code"] intValue]==1) {
            
            [self showString:@"你已注册成功,请到首页登录" forSecond:3.f];
            //跳转到登录页
            NSLog(@"-----进入主页------");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                XXELoginViewController *loginVC = [[XXELoginViewController alloc]init];
                loginVC.loginThirdType = self.login_type;
                loginVC.loginThirdQQToken = self.headThirdQQToken;
                loginVC.loginThirdWeiXinToken = self.headThirdWeiXinToken;
                loginVC.loginThirdSinaToken = self.headThirdSinaToken;
                loginVC.loginThirdAliPayToken = self.headThirdAliPayToken;
                
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                window.rootViewController = loginVC;
                [self.view removeFromSuperview];
            });
            
        } else {
            [self showString:@"注册失败" forSecond:2.f];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showString:@"注册失败" forSecond:1.f];
    }];
}

- (void)searchButtonClick:(UIButton *)sender
{
    NSLog(@"点击搜搜");
    
    WZYSearchSchoolViewController *searchVC = [[WZYSearchSchoolViewController alloc]init];
    self.schoolVC = searchVC;
    searchVC.WZYSearchFlagStr = @"fromHeadermasterVC";
    
    [searchVC returnModel:^(XXETeacherModel *teacherModel) {
        //
        if (teacherModel != nil) {
        self.isHave = YES;
        }else {
        self.isHave = NO;
        }
        [self LnitializeTheParameter];
//        self.schoolDatasource = mArr;
        self.schoolVC.delegate = self;
    }];
    
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - 搜索的代理方法
- (void)searchSchoolMessage:(XXETeacherModel *)model
{
    
//    NSLog(@" 搜索 model == %@", model);
    
    self.theEndSchoolId = model.schoolId;
    self.theEndSchoolType = model.type;
    self.schoolName = model.name;
    self.schoolProvince = model.province;
    self.schoolCity = model.city;
    self.schoolDistrict = model.district;
    self.schoolAddrss = model.address;
    self.schoolTel = model.tel;
    
    NSLog(@"%@ %@",model,model.name);
    //学校名称
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
    //学校类型
    self.teacherCell = [self cellAtIndexRow:1 andAtSection:0 Message:typeName];
    NSString *addressSchool = [NSString stringWithFormat:@"%@-%@-%@",model.province,model.city,model.district];
    self.teacherCell = [self cellAtIndexRow:2 andAtSection:0 Message:addressSchool];
    //详细地址
    self.teacherCell = [self cellAtIndexRow:3 andAtSection:0 Message:model.address];
    //联系方式
    self.teacherCell = [self cellAtIndexRow:4 andAtSection:0 Message:model.tel];
    
    //搜索结果 重新赋值后 不能再手动更改
    //学校名称
    [self tureOrFalseCellClick:NO];
    //学校类型
    [self tureOrFalseCellClick:NO];
    //学校地址
    [self tureOrFalseCellClick:NO];
    //详细地址
    [self tureOrFalseCellClick:NO];
    //联系方式
    [self tureOrFalseCellClick:NO];
    
    //获取审核人
    [self setupReviewerMessage:model.schoolId];
    
    
}
#pragma mark - 获取审核人

- (void)setupReviewerMessage:(NSString *)schoolID
{
    
    /*
     【获取审核人员(管理员,校长,以及平台审核)】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Teacher/get_examine_teacher
     传参(参数名):
     school_id 		//学校id
     position		//教职身份(传数字,1:授课老师  2:主任  3:管理  4:校长)
     */
    
//    NSLog(@"_userIdentifier == %@", _userIdentifier);
    
    XXEReviewerApi *reviewerApi = [[XXEReviewerApi alloc]initReviwerNameSchoolId:schoolID PositionID:_userIdentifier];
    [reviewerApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        NSLog(@"审核人信息:======%@",request.responseJSONObject);
//        NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
        NSArray *data = [request.responseJSONObject objectForKey:@"data"];
        [self.reviewerDatasource removeAllObjects];
        [self.reviewerNameArray removeAllObjects];
        for (int i =0; i < data.count; i++) {
            XXEReviewerModel *model = [[XXEReviewerModel alloc]initWithDictionary:data[i] error:nil];
            [self.reviewerDatasource addObject:model];
            [self.reviewerNameArray addObject:model.reviewerName];
        }
        self.teacherCell = [self cellAtIndexRow:6 andAtSection:0 Message:self.reviewerNameArray[0]];
        XXEReviewerModel *model = self.reviewerDatasource[0];
        self.theEndReviewerId = model.reviewerId;
        
//        NSLog(@"-=-=%@",self.theEndReviewerId);
        
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

//MARK: - TextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 107) {
        [UIView animateWithDuration:0.4 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -212);
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
