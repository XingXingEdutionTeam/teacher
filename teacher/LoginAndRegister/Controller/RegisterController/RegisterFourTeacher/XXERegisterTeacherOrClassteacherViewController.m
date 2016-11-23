

//
//  XXERegisterTeacherOrClassteacherViewController.m
//  teacher
//
//  Created by Mac on 2016/11/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERegisterTeacherOrClassteacherViewController.h"
#import "WZYSearchSchoolViewController.h"
#import "XXERegisterGradeSchoolApi.h"
#import "XXERegisterClassSchoolApi.h"
#import "XXETeacherModel.h"
#import "XXETeachSubjectModel.h"
//#import "FSImageModel.h"
#import "XXELoginViewController.h"
#import "FSImagePickerView.h"
#import "XXERegisterPicApi.h"



@interface XXERegisterTeacherOrClassteacherViewController ()<XXESearchSchoolMessageDelegate>
{
   //上 bgView
    UIView *upBgView;
   //中bgView
    UIView *middleBgView;
    //底部bgView
    UIView *downBgView;
    //搜索学校返回结果
    XXETeacherModel *searchModel;
    
    NSMutableArray *_titleArr;
    //学校类型
    NSMutableArray *_schoolTypeArr;
    //
    NSMutableArray *_courseIdArray;
    
    NSString *schoolTypeStr;
    NSString *gradeStr;
    NSString *courseIdStr;
    NSString *classIdStr;
    NSString *auditIdStr;
    
    //邀请码
    UITextField *codeTextField;
    
    //注册 按钮
    UIButton *registButton;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;

}
/** 判断是否有值 */
@property (nonatomic, assign)BOOL isHave;
//学校类型
@property (nonatomic, strong) UIView *schoolTypeView;

//年级 数组
@property(nonatomic,strong)NSMutableArray *gradeNameArr;
@property(nonatomic,strong)UIView *gradeNameView;
//班级 数组
@property(nonatomic,strong)NSMutableArray *classNameArr;
@property (nonatomic, strong) NSMutableArray *classIdArray;
@property(nonatomic,strong)UIView *classNameView;
//教学类型 数组
@property(nonatomic,strong)NSMutableArray *teachSubjectArr;
//审核人员
@property(nonatomic,strong)NSMutableArray *auditPeopleArr;
@property(nonatomic,strong)UIView *auditPeopleView;
@property(nonatomic,strong)NSMutableArray *auditNameArr;
@property (nonatomic, strong) NSMutableArray *auditIdArray;

//学校名称
@property (nonatomic, strong) UITextField *schoolNameTextField;
//学校类型
@property (nonatomic, strong) WJCommboxView *schoolTypeCombox;
//年级
@property(nonatomic,strong)WJCommboxView *gradeNameCombox;
//班级
@property(nonatomic,strong)WJCommboxView *classNameCombox;
//教学类型
@property(nonatomic,strong)WJCommboxView *teachSubjectCombox;
//审核人员
@property(nonatomic,strong)WJCommboxView *auditNameCombox;
//上传图片
@property (nonatomic, strong)FSImagePickerView *picker;
/** 获取证件url */
@property (nonatomic, copy)NSString *theEndFileImage;
/** 选择相片的数据源 */
@property (nonatomic, strong)NSMutableArray *fileImageArray;
/** 获取头像url */
@property (nonatomic, copy)NSString *theEndUserAvatarImage;

/** 测试照片 */
@property (nonatomic, strong)NSMutableArray *mutableArray;


@end

@implementation XXERegisterTeacherOrClassteacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XXEBackgroundColor;
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

    //导航栏的按钮
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(-10,0,22,22)];
    [rightButton setImage:[UIImage imageNamed:@"search_icon"]  forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    _titleArr = [[NSMutableArray alloc] initWithObjects:@"学校名称:",@"学校类型:",@"年级信息:",@"班级信息:",@"教学类型:",@"",@"审核人员:",@"邀请码", nil];
    _schoolTypeArr = [[NSMutableArray alloc]initWithObjects:@"幼儿园",@"小学",@"初中",@"培训机构",nil];
    
    [self headImageUpLoad];
    
    [self createContent];

    
    
}

//
#pragma mark - 上传头像网络请求
- (void)headImageUpLoad
{
//    NSLog(@"用户头像%@",self.userAvatarImage);
    
    if (self.userAvatarImage != nil) {
        XXERegisterPicApi *headPicApi = [[XXERegisterPicApi alloc]initUpLoadRegisterPicFileType:@"1" PageOrigin:@"1" UploadFormat:@"1" UIImageHead:self.userAvatarImage];
        [headPicApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            NSString *code = [request.responseJSONObject objectForKey:@"code"];
            if ([code intValue]== 1) {
                NSString *avatar = [request.responseJSONObject objectForKey:@"data"];
                self.theEndUserAvatarImage = avatar;
                
            }
            
//            NSLog(@"%@",request.responseJSONObject);
//            NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
            
        } failure:^(__kindof YTKBaseRequest *request) {
            
        }];
    }else{
        
    }
    
}



- (void)searchButtonClick:(UIButton *)sender
{
    NSLog(@"点击搜搜");
    
    WZYSearchSchoolViewController *searchVC = [[WZYSearchSchoolViewController alloc]init];
    
    [searchVC returnModel:^(XXETeacherModel *teacherModel) {
        //
        if (teacherModel != nil) {
            self.isHave = YES;
        }else {
            self.isHave = NO;
        }
        searchModel = teacherModel;
        searchVC.delegate = self;
//        NSLog(@"qqqq %@", teacherModel);
    }];
    
    
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - 搜索的代理方法
- (void)searchSchoolMessage:(XXETeacherModel *)model
{
   //学校名称
    _schoolNameTextField.text = model.name;
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
    _schoolTypeCombox.textField.text = typeName;
    
    //获取  年级信息
    [self getoutSchoolGradeSchoolId:model.schoolId SchoolType:model.type];

}


- (void)createContent{
    //创建上部 学校信息
    [self createUpContent];
    //创建中部 上传照片
    [self createMiddleContent];
    //创建底部 审核人员
    [self createDownContent];
    
    //创建 提交 按钮
    CGFloat buttonX = (KScreenWidth - 325 * kScreenRatioWidth) / 2;
    CGFloat buttonY = downBgView.frame.origin.y + downBgView.height + 10;
    CGFloat buttonW = 325 * kScreenRatioWidth;
    CGFloat buttonH = 42 * kScreenRatioHeight;
    
    registButton = [UIButton createButtonWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH) backGruondImageName:@"login_green" Target:self Action:@selector(registButtonClick) Title:@"注     册"];
    [registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:registButton];
}




#pragma mark ======== 创建上部 学校信息 =======
- (void)createUpContent{
    upBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 200)];
    upBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:upBgView];

    for (int i = 0; i < 5; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5 + 40 * i, 70 * kScreenRatioWidth, 20)];
        titleLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
        titleLabel.text = _titleArr[i];
        [upBgView addSubview:titleLabel];
        
        if (i != 4) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 40 * (i + 1), KScreenWidth - 20, 1)];
            lineView.backgroundColor = XXEBackgroundColor;
            [upBgView addSubview:lineView];
  
        }

}
    
    //学校名称
    _schoolNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(90 * kScreenRatioWidth, 5, KScreenWidth - 120, 30)];
    _schoolNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _schoolNameTextField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_schoolNameTextField];
    
    //学校类型
    _schoolTypeCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(90 * kScreenRatioWidth, 5 + 40, KScreenWidth - 120, 20)];
    _schoolTypeCombox.textField.placeholder = @"学校类型";
    _schoolTypeCombox.textField.textAlignment = NSTextAlignmentCenter;
    _schoolTypeCombox.dataArray = _schoolTypeArr;
    [_schoolTypeCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"11"];
    [self.view addSubview:_schoolTypeCombox];
    
    //年级
    _gradeNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(90 * kScreenRatioWidth, 5 + 40 * 2, KScreenWidth - 120, 20)];
    _gradeNameCombox.textField.placeholder = @"年级";
    _gradeNameCombox.textField.textAlignment = NSTextAlignmentCenter;
     [_gradeNameCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"12"];
    [self.view addSubview:_gradeNameCombox];
    
    //班级
    _classNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(90 * kScreenRatioWidth, 5 + 40 * 3, KScreenWidth - 120, 20)];
    _classNameCombox.textField.placeholder = @"班级";
    _classNameCombox.textField.textAlignment = NSTextAlignmentCenter;
    [_classNameCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"13"];
    [self.view addSubview:_classNameCombox];
    
    //教学类型
    _teachSubjectCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(90 * kScreenRatioWidth, 5 + 40 * 4, KScreenWidth - 120, 20)];
    _teachSubjectCombox.textField.placeholder = @"教学类型";
    _teachSubjectCombox.textField.textAlignment = NSTextAlignmentCenter;
    [_teachSubjectCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"14"];
    [self.view addSubview:_teachSubjectCombox];

}

#pragma mark ========= 创建中部 上传照片 ========
- (void)createMiddleContent{
    middleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, upBgView.frame.origin.y + upBgView.height + 10, KScreenWidth, 120)];
    middleBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:middleBgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"请上传以下相关证明:工作证/教师资格证,如有疑问请拨打:021-60548858";
    titleLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    [middleBgView addSubview:titleLabel];
    
    //选择图片
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _picker = [[FSImagePickerView alloc] initWithFrame:CGRectMake(10, titleLabel.frame.origin.y + titleLabel.height, kWidth - 10 * kScreenRatioWidth * 2, 80 * kScreenRatioHeight) collectionViewLayout:layout1];
    _picker.showsHorizontalScrollIndicator = NO;
    _picker.backgroundColor = [UIColor whiteColor];
    _picker.controller = self;
    
    [middleBgView addSubview:_picker];


}


#pragma mark - 获取身份图片
- (void)setupFileImage
{
//    NSLog(@"self.picker.data === %@", self.picker.data);
//     NSLog(@"self.picker.data.count === %ld", self.picker.data.count);
    
    NSMutableArray *arr = [NSMutableArray array];
    if (self.picker.data.count ==1) {
        //往服务器传所有的参数
        self.theEndFileImage = @"";
        [self uploadRegisterMessage];
    }else{
        [self.picker.data removeLastObject];
        arr = self.picker.data;
//        self.mutableArray = self.picker.data;
        for (int i =0; i <arr.count; i++) {
            
//            NSLog(@"aaabb === %@", arr[i]);
            
            FSImageModel *model = self.picker.data[i];
            UIImage *fileImage = [UIImage imageWithData:model.data];
            _fileImageArray = [[NSMutableArray alloc] init];
            [self.fileImageArray addObject:fileImage];
        }
        //用户的证件照
        [self fileUserSomeImage];
    }
    
    
}

#pragma mark - 用户所选择的证件照
- (void)fileUserSomeImage
{
//    NSLog(@"fileImageArray 0000=== %@",self.fileImageArray);
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
        
//        NSLog(@"responseObject === %@", responseObject);
        
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

#pragma mark ========= 创建底部 审核人员 =========
- (void)createDownContent{

    downBgView = [[UIView alloc] initWithFrame:CGRectMake(0, middleBgView.frame.origin.y + middleBgView.height + 10, KScreenWidth, 80)];
    downBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:downBgView];
    
    
    NSMutableArray *titleArray = [[NSMutableArray alloc] initWithObjects:@"审核人员", @"邀请码", nil];
    
    for (int i = 0; i < 2; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5 + 40 * i, 70 * kScreenRatioWidth, 20)];
        titleLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
        titleLabel.text = titleArray[i];
        [downBgView addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 40 * (i + 1), KScreenWidth - 20, 1)];
        lineView.backgroundColor = XXEBackgroundColor;
        [downBgView addSubview:lineView];
        
    }
    
    //审核人员
    _auditNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(90 * kScreenRatioWidth, downBgView.frame.origin.y + 5, KScreenWidth - 120, 20)];
    _auditNameCombox.textField.placeholder = @"审核人员";
    _auditNameCombox.textField.textAlignment = NSTextAlignmentCenter;
    [_auditNameCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"15"];
    [self.view addSubview:_auditNameCombox];
    
    //邀请码
   codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(90 * kScreenRatioWidth, 40 + 5, KScreenWidth - 120, 30)];
    codeTextField.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    codeTextField.borderStyle = UITextBorderStyleRoundedRect;
    codeTextField.textAlignment = NSTextAlignmentCenter;
    [downBgView addSubview:codeTextField];

}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    switch ([[NSString stringWithFormat:@"%@",context] integerValue]) {
        case 11:
        {
            //用户选择 学校 类型
            if (_schoolNameTextField.text) {
                NSString *str1 = self.schoolTypeCombox.textField.text;
                
                if (str1) {
                    
                    NSInteger index = [_schoolTypeArr indexOfObject: str1];
                    
                    NSString *newStr = [NSString stringWithFormat:@"%ld", index + 1];
                    
                    schoolTypeStr = newStr;
//                    获取 学校 年级 数据
                    [self fetchGradeData:searchModel.schoolId SchoolType:searchModel.type];
 
                }
            }else{
                [self showString:@"请搜索学校" forSecond:1.5];
            }
        }
            break;
            
            case 12:
        {
            //年级
            if (_gradeNameCombox.textField.text) {
                
                gradeStr = self.gradeNameCombox.textField.text;
                
                if (gradeStr) {
                    
                NSInteger index = [_gradeNameArr indexOfObject: gradeStr];

                courseIdStr = [NSString stringWithFormat:@"%@", _courseIdArray[index]];
//                    //获取 班级 数据
                    [self fetchClassData:searchModel.schoolId grade:gradeStr course_id:courseIdStr];
                    
                }
            }else{
                
                [self showString:@"请完善年级信息" forSecond:1.5];
                
            }
            
        }
            break;
            
        case 13:
        {
            //班级
            if (_classNameCombox.textField.text) {
                
                NSString *classStr = self.classNameCombox.textField.text;
                
                if (classStr) {
                    NSInteger index = [_classNameArr indexOfObject: classStr];
                    
                  classIdStr = [NSString stringWithFormat:@"%@", _classIdArray[index]];
                    
                    //获取 教学类型 数据
                    [self fetchTeachSubjectData:searchModel.type];
                    
                }
            }else{
                [self showString:@"请完善班级信息" forSecond:1.5];
                
            }
            
        }
            break;
        case 14:
        {
            //教学类型
            if (_teachSubjectCombox.textField.text) {
                
                NSString *teachSubjectNameStr = _teachSubjectCombox.textField.text;
                
                if (teachSubjectNameStr) {

                    //获取 审核人员
                    [self fetchAuditData:searchModel.schoolId position:_userIdentifier];
                }
            }else{
                [self showString:@"请完善教学类型" forSecond:1.5];
            }
            
        }
            break;
        case 15:
        {
            //审核人员
            if (_auditNameCombox.textField.text) {
                
                NSString *auditNameStr = _auditNameCombox.textField.text;
                
                NSInteger index = [_auditNameArr indexOfObject:auditNameStr];
                
                auditIdStr = [_auditIdArray objectAtIndex:index];
//               
            }else{
                [self showString:@"请完善教学类型" forSecond:1.5];
            }
            
        }
            break;

        default:
            break;
    }
    
    
}

#pragma mark - 获取班级信息
- (void)getoutSchoolGradeSchoolId:(NSString *)schoolId SchoolType:(NSString *)schoolType
{
//        NSLog(@"%@ == %@",schoolId,schoolType);
    XXERegisterGradeSchoolApi *schoolApi = [[XXERegisterGradeSchoolApi alloc]initWithGetOutSchoolGradeSchoolId:schoolId SchoolType:schoolType];
    
    [schoolApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        _gradeNameArr = [[NSMutableArray alloc] init];
        _courseIdArray  = [[NSMutableArray alloc] init];
        
//        NSLog(@"获取年级信息 %@", request.responseJSONObject);
        
        if ([[request.responseJSONObject objectForKey:@"code"] intValue] == 1) {
            
            for (NSDictionary *dic in request.responseJSONObject[@"data"]) {
                
                [_gradeNameArr addObject:dic[@"grade"]];
                [_courseIdArray addObject:dic[@"course_id"]];
            }

        }else {
            [self showString:@"请求年级数据失败" forSecond:1.f];
        }
        self.gradeNameCombox.dataArray = _gradeNameArr;
        [self.gradeNameCombox.listTableView reloadData];
    } failure:^(__kindof YTKBaseRequest *request) {
        [self showString:@"请求年级数据失败" forSecond:1.f];
    }];
}
/**
 *  年级
 */
- (void)fetchGradeData:(NSString *)schoolId SchoolType:(NSString *)schoolType{
    /*
     【通过学校获取年级】
     接口:
     http://www.xingxingedu.cn/Global/give_school_get_grade
     传参:
     school_id	//学校id
     school_type 	//学校类型,请传数字代号:幼儿园/小学/中学/培训机构 1/2/3/4
     */
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/give_school_get_grade";
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"school_type":schoolType, @"school_id":schoolId};
    //    NSLog(@"年级 *******   %@", params);
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        _gradeNameArr = [[NSMutableArray alloc] init];
        _courseIdArray  = [[NSMutableArray alloc] init];
        //
        //  NSLog(@"学校 id -responseObj --- %@", responseObj);
        NSArray *dataSource = responseObj[@"data"];
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {

            for (NSDictionary *dic in dataSource) {
                
                [_gradeNameArr addObject:dic[@"grade"]];
                [_courseIdArray addObject:dic[@"course_id"]];
            }
        }else{
            
            
        }
        
        self.gradeNameCombox.dataArray = _gradeNameArr;
        [self.gradeNameCombox.listTableView reloadData];
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
}




//获取 班级
- (void)fetchClassData:(NSString *)schoolId grade:(NSString *)grade course_id:(NSString *)course_id{
    
    /*
     【通过年级获取班级】
     接口:
     http://www.xingxingedu.cn/Global/give_grade_get_class
     传参:
     school_id	//学校id
     grade 		//年级
     course_id		//课程id
     */
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/give_grade_get_class";
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"course_id":course_id, @"school_id":schoolId, @"grade":grade};
    
//        NSLog(@"班级  -----=====  %@", params);
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        _classNameArr = [[NSMutableArray alloc] init];
        _classIdArray  = [[NSMutableArray alloc] init];
        //                NSLog(@"班级 -responseObj --- %@", responseObj);
        NSArray *dataSource = responseObj[@"data"];
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            for (NSDictionary *dic in dataSource) {
                
                [_classNameArr addObject:dic[@"class"]];
                [_classIdArray addObject:dic[@"class_id"]];
            }
            
        }else{
            
        }
        self.classNameCombox.dataArray = _classNameArr;
        [self.classNameCombox.listTableView reloadData];
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
}

//教学类型
- (void)fetchTeachSubjectData:(NSString *)school_type{
/*
 【获取教学类型(授课名)】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Teacher/get_teach_name
 
 传参(参数名):
 school_type		//学校类型: 幼儿园/小学/中学/机构 1/2/3/4
 */
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Teacher/get_teach_name";
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"school_type":school_type};
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        _teachSubjectArr = [[NSMutableArray alloc] init];
        //
//        NSLog(@"教学类型 === %@", responseObj);
        NSArray *dataSource = responseObj[@"data"];
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            for (NSDictionary *dic in dataSource) {
                
                [_teachSubjectArr addObject:dic[@"name"]];
            }

        }else{
            
        }
        self.teachSubjectCombox.dataArray = _teachSubjectArr;
        [self.teachSubjectCombox.listTableView reloadData];

    } failure:^(NSError *error) {
        //
        [self showString:@"获取数据失败!" forSecond:1.5];
    }];
    
}


//获取审核人员数组
- (void)fetchAuditData:(NSString *)school_id position:(NSString *)position{
    /*
     【获取审核人员(管理员,校长,以及平台审核)】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Teacher/get_examine_teacher
     传参(参数名):
     school_id 		//学校id
     position		//教职身份(传数字,1:授课老师  2:主任  3:管理  4:校长)
     */
    
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Teacher/get_examine_teacher";
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"position":_userIdentifier, @"school_id":searchModel.schoolId};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        _auditIdArray = [[NSMutableArray alloc] init];
        _auditNameArr  = [[NSMutableArray alloc] init];
//        NSLog(@"审核 人员 -responseObj --- %@", responseObj);
        /*
         {
         id = 16,
         tname = 成小青
         }
         */
        NSArray *dataSource = responseObj[@"data"];
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            for (NSDictionary *dic in dataSource) {
                
                [_auditIdArray addObject:dic[@"id"]];
                [_auditNameArr addObject:dic[@"tname"]];
            }
            
        }else{
            
            
        }
        self.auditNameCombox.dataArray = _auditNameArr;
        [self.auditNameCombox.listTableView reloadData];
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
}



#pragma mark ************ registButtonClick **************
- (void)registButtonClick{
    if ([_schoolNameTextField.text isEqualToString:@""]) {
        [self showString:@"请选择学校" forSecond:1.5];
    }else if ([_gradeNameCombox.textField.text isEqualToString:@""]){
        [self showString:@"请完善年级信息" forSecond:1.5];
    }else if ([_classNameCombox.textField.text isEqualToString:@""]){
        [self showString:@"请完善班级信息" forSecond:1.5];
    }else if ([_teachSubjectCombox.textField.text isEqualToString:@""]){
        [self showString:@"请完善教学类型" forSecond:1.5];
    }else if ([_auditNameCombox.textField.text isEqualToString:@""]){
        [self showString:@"请完善审核人员" forSecond:1.5];
    }else{
        //获取身份图片
        [self setupFileImage];

        //======== 注册 =========
//        [self uploadRegisterMessage];
    }

}

#pragma mark - 点击注册按钮 提交信息
- (void)uploadRegisterMessage
{
    NSLog(@"%@",_login_type);
    
    
//    NSLog(@"%@==== %@", _theEndUserAvatarImage, _theEndFileImage);
    
    NSDictionary *parameter = @{
                                @"login_type":_login_type,
                                @"phone":_userPhoneNum,
                                @"pass":_userPassword,
                                @"tname":_userName,
                                @"id_card":_userIDCarNum,
                                @"passport":_teacherPassport,
                                @"age":_userAge,
                                @"sex":_userSex,
                                @"position":_userIdentifier,
                                @"teach_course_id":courseIdStr,
                                @"school_id":searchModel.schoolId,
                                @"class_id":classIdStr,
                                @"school_type":searchModel.type,
                                @"examine_id":auditIdStr,
                                @"code":codeTextField.text,
                                @"head_img":_theEndUserAvatarImage,
                                @"file":_theEndFileImage,
                                @"qq":_teacherThirdQQToken,
                                @"weixin":_teacherThirdWeiXinToken,
                                @"weibo":_teacherThirdSinaToken,
                                @"alipay":_teacherThirdAliPayToken,
                                @"appkey":APPKEY,
                                @"backtype":BACKTYPE,
                                @"user_type":USER_TYPE
                                };
    
    NSLog(@"注册 传参==== %@", parameter);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:XXERegisterTeacherUrl parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        
    }success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"注册 结果 === %@",responseObject);
        NSLog(@"%@",[responseObject objectForKey:@"msg"]);
        NSString *code = [responseObject objectForKey:@"code"];
        if ([code intValue]==1) {
            [self showString:@"你已注册成功,请到首页登录" forSecond:3.f];
            //跳转到登录页
            NSLog(@"-----进入主页------");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                XXELoginViewController *loginVC = [[XXELoginViewController alloc]init];
                loginVC.loginThirdType = self.login_type;
                loginVC.loginThirdQQToken = self.teacherThirdQQToken;
                loginVC.loginThirdWeiXinToken = self.teacherThirdWeiXinToken;
                loginVC.loginThirdSinaToken = self.teacherThirdSinaToken;
                loginVC.loginThirdAliPayToken = self.teacherThirdAliPayToken;
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                window.rootViewController = loginVC;
                [self.view removeFromSuperview];
            });
            
        }else {
            [self showString:@"注册失败" forSecond:2.f];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self showString:@"注册失败" forSecond:1.f];
    }];
}


- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.schoolTypeCombox.textField removeObserver:self forKeyPath:@"text"];
    [self.gradeNameCombox.textField removeObserver:self forKeyPath:@"text"];
    [self.classNameCombox.textField removeObserver:self forKeyPath:@"text"];
    [self.teachSubjectCombox.textField removeObserver:self forKeyPath:@"text"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
