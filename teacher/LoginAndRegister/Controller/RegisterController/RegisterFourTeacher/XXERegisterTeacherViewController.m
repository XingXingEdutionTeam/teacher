//
//  XXERegisterHeadMasterViewController.m
//  teacher
//
//  Created by codeDing on 16/8/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERegisterTeacherViewController.h"
#import "FSImagePickerView.h"
#import "HHControl.h"
#import "WJCommboxView.h"
#import "CheckIDCard.h"
#import "SchoolInfoViewController.h"
#import "VPImageCropperViewController.h"
#import "LMContainsLMComboxScrollView.h"
#import "LMComBoxView.h"
#import "UtilityFunc.h"
#import "Constants.h"
#import "HZQDatePickerView.h"
#import "XXELoginViewController.h"
#define ORIGINAL_MAX_WIDTH 640.0f
#define  kDropDownListTag 1000
#define awayX 20
#define spaceX 5
#define spaceY 35

#define Kmarg 10.0f
#define KLabelW 70.0f
#define KLabelH 30.0f
#define KTextFW 200.0f
#define KtextFH 30.0f
@interface XXERegisterTeacherViewController ()<LMComBoxViewDelegate,UISearchBarDelegate>{
    UIView *bgView;
    UILabel *parentsNameLabel;   //姓名
    UILabel *parentsIDCardLabel;   //身份证号
    UILabel *inviteCodeLabel;   //邀请码
    UITextField *parentsName;   //姓名
    UITextField *parentsIDCard;   //身份证号
    UITextField *inviteCode;   //邀请码
    
    
    LMContainsLMComboxScrollView *bgScrollView;
    NSMutableDictionary *addressDict;
    NSDictionary *areaDict;
    NSArray *provinceArr;
    NSArray *cityArr;
    NSArray *districtArr;
    NSString *selectProvinceStr;
    NSString *selectCityStr;
    NSString *selectAreaStr;
    UILabel *trainAgencyLbl;
    UIButton *landBtn;
    UITextField *schoolNameText;
    
    UILabel *addressLabel;
    UITextField *addressText;
    UILabel *phoneLabel;
    UITextField *phoneText;
    UILabel *provcLabel;
    
}
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UISearchController *searchDC;
@property(nonatomic,strong)UIView *schoolTypeView;
@property(nonatomic,strong)NSArray *schoolNameArr;
@property(nonatomic,strong)NSArray *schoolTypeArr;
@property(nonatomic,strong)UIView *schoolNameView;
@property(nonatomic,strong)NSArray *gradeNameArr;
@property(nonatomic,strong)UIView *gradeNameView;
@property(nonatomic,strong)NSArray *classNameArr;
@property(nonatomic,strong)UIView *classNameView;
@property(nonatomic,strong)NSArray *trainAgencyArr;
@property(nonatomic,strong)UIView *trainAgencyView;
@property(nonatomic,strong)NSArray *auditPeopleArr;
@property(nonatomic,strong)NSArray *teacherTypeArr;
@property(nonatomic,strong)NSArray *teacherSubjectArr;
@property(nonatomic,strong)UIView *auditPeopleView;



@property(nonatomic,strong)WJCommboxView *schoolTypeCombox;
@property(nonatomic,strong)WJCommboxView *schoolNameCombox;
@property(nonatomic,strong)WJCommboxView *gradeNameCombox;
@property(nonatomic,strong)WJCommboxView *classNameCombox;
@property(nonatomic,strong)WJCommboxView *trainSubjectCombox;
@property(nonatomic,strong)WJCommboxView *auditNameCombox;
@property(nonatomic,strong)WJCommboxView *teacherTypeCombox;
@property(nonatomic,strong)WJCommboxView *teacherSubjectCombox;

@property(nonatomic,strong)UILabel * auditNameLabel;
@property(nonatomic,strong)UILabel * schoolNameLabel;
@property(nonatomic,strong)UILabel * trainNameLabel;
@property(nonatomic,strong)UILabel *trainLabel;
@property(nonatomic,strong)UILabel *teacherTypeLabel;
@property(nonatomic,strong)UILabel *teacherDateLabel;
@property(nonatomic,strong)UILabel *teacherSubjectLabel;

@property(nonatomic,strong)UIButton *teacherDateBtn;
@end

@implementation XXERegisterTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"注册4/4";
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor= [UIColor colorWithRed:229/255.0f green:232/255.0f blue:234/255.0f alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0, 170, 42);
    [self commBoxInfo];
    //    [self reloadD];
    //    [self setBgScrollView];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
    [self.view addSubview:_searchBar];
    
    //添加背景
    UIView *bigBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchBar.frame), kWidth, kHeight)];
    bigBgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bigBgView];
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 150)];
    bgView.backgroundColor = [UIColor whiteColor];
    [bigBgView addSubview:bgView];
    //？？
    self.schoolTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.schoolTypeView.backgroundColor = [UIColor clearColor];
    self.schoolTypeView.alpha = 0.5;
    /**
     学校名称
     */
    _schoolNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(awayX, Kmarg, KLabelW, KLabelH)];
    _schoolNameLabel.text=@"学校名称:";
    _schoolNameLabel.font = [UIFont systemFontOfSize:16];
    schoolNameText=[HHControl createTextFielfFrame:CGRectMake(CGRectGetMaxX(_schoolNameLabel.frame) + Kmarg, Kmarg, KTextFW, KtextFH) font:[UIFont systemFontOfSize:14] placeholder:@"请输入学校名称"];
    schoolNameText.backgroundColor=[UIColor whiteColor];
    [bigBgView addSubview:_schoolNameLabel];
    [bigBgView addSubview:schoolNameText];
    
    //学校类型
    self.schoolTypeArr = [[NSArray alloc]initWithObjects:@"幼儿园",@"小学",@"中学",@"培训机构",nil];
    UILabel * schoolTypeLabel=[[UILabel alloc]initWithFrame:CGRectMake(awayX, CGRectGetMaxY(_schoolNameLabel.frame) + Kmarg, KLabelW, KLabelH)];
    schoolTypeLabel.text=@"学校类型:";
    schoolTypeLabel.font = [UIFont systemFontOfSize:16];
    self.schoolTypeCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(schoolTypeLabel.frame) + Kmarg, CGRectGetMaxY(schoolNameText.frame) + Kmarg, KTextFW + 51, KtextFH)];
    self.schoolTypeCombox.textField.backgroundColor =UIColorFromRGB(255, 255, 255);
    self.schoolTypeCombox.textField.placeholder = @"请选择学校类型";
    self.schoolTypeCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.schoolTypeCombox.textField.tag = 101;
    self.schoolTypeCombox.textField.borderStyle = UITextBorderStyleNone;
    self.schoolTypeCombox.dataArray = self.schoolTypeArr;
    [bigBgView addSubview:schoolTypeLabel];
    [bigBgView addSubview:self.schoolTypeCombox];
    
    /**
     年级信息
     */
    UILabel * gradeNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(awayX, CGRectGetMaxY(schoolTypeLabel.frame) + Kmarg, KLabelW, KLabelH)];
    self.gradeNameArr = [[NSArray alloc]initWithObjects:@"小班",@"中班",@"大班",@"一年级",@"二年级",@"三年级",@"四年级",@"五年级",@"六年级",nil];
    gradeNameLabel.text=@"班级信息:";
    gradeNameLabel.font = [UIFont systemFontOfSize:16];
    self.gradeNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(gradeNameLabel.frame) + Kmarg, CGRectGetMaxY(schoolTypeLabel.frame) + Kmarg, 120, KtextFH)];
    self.gradeNameCombox.textField.placeholder = @"年级";
    self.gradeNameCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.gradeNameCombox.textField.borderStyle = UITextBorderStyleNone;
    self.gradeNameCombox.textField.tag = 103;
    self.gradeNameCombox.dataArray = self.gradeNameArr;
    //？？
    self.gradeNameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.gradeNameView.backgroundColor = UIColorFromRGB(246, 246, 246);
    self.gradeNameView.alpha = 0.5;
    
    self.classNameArr = [[NSArray alloc]initWithObjects:@"1班",@"2班",@"3班",@"4班",@"5班",@"6班",nil];
    self.classNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.gradeNameCombox.frame) + Kmarg, CGRectGetMaxY(schoolTypeLabel.frame) + Kmarg, 120, 30)];
    self.classNameCombox.textField.placeholder = @"班级";
    self.classNameCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.classNameCombox.textField.borderStyle = UITextBorderStyleNone;
    self.classNameCombox.textField.tag = 104;
    self.classNameCombox.dataArray = self.classNameArr;
    
    [bigBgView addSubview:gradeNameLabel];
    [bigBgView addSubview:self.gradeNameCombox];
    [bigBgView addSubview:self.classNameCombox];
    
    
    /**
     教学类型
     */
    self.teacherSubjectArr = [[NSArray alloc]initWithObjects:@"器乐老师",@"美术老师",@"舞蹈老师",@"音乐老师",@"幼教老师",@"小学老师",@"初中老师",@"体育老师",@"武术老师",@"棋牌老师",@"语言老师",@"其他",nil];
    
    _teacherSubjectLabel=[[UILabel alloc]initWithFrame:CGRectMake(awayX, CGRectGetMaxY(self.classNameCombox.frame)+ Kmarg, KLabelW, KLabelH)];
    _teacherSubjectLabel.text=@"教学类型:";
    _teacherSubjectLabel.font = [UIFont systemFontOfSize:16];
    self.teacherSubjectCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_teacherSubjectLabel.frame) + Kmarg , CGRectGetMaxY(self.classNameCombox.frame)+ Kmarg, KTextFW+ 51, KtextFH)];
    self.teacherSubjectCombox.textField.placeholder = @"请选择职位";
    self.teacherSubjectCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.teacherSubjectCombox.textField.borderStyle = UITextBorderStyleNone;
    self.teacherSubjectCombox.textField.tag = 102;
    self.teacherSubjectCombox.dataArray = self.teacherSubjectArr;
    [bigBgView addSubview:_teacherSubjectLabel];
    [bigBgView addSubview:self.teacherSubjectCombox];
    
    self.classNameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.classNameView.backgroundColor = UIColorFromRGB(246, 246, 246);
    self.classNameView.alpha = 0.5;
    
    //上传相关张证明
    provcLabel=[HHControl createLabelWithFrame:CGRectMake(awayX, CGRectGetMaxY(_teacherSubjectLabel.frame) + Kmarg, kWidth - awayX * 2, 50) Font:11 Text:@"请上传以下相关证明:身份证，工作证，教师资格证,如有疑问请联系客服(021-60548858)"];
    provcLabel.numberOfLines=2;
    [bigBgView addSubview:provcLabel];
    
    //    //选择图片
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    FSImagePickerView *picker = [[FSImagePickerView alloc] initWithFrame:CGRectMake(awayX, CGRectGetMaxY(provcLabel.frame), kWidth - awayX * 2, 75) collectionViewLayout:layout];
    picker.backgroundColor = UIColorFromRGB(255, 255, 255);
    picker.showsHorizontalScrollIndicator = NO;
    picker.controller = self;
    [bigBgView addSubview:picker];
    
    /**
     审核人员
     */
    self.auditPeopleArr = [[NSArray alloc]initWithObjects:@"王老师",@"李老师",@"陈老师",@"平台审核",nil];
    self.auditNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(awayX, CGRectGetMaxY(picker.frame) + Kmarg, KLabelW, KLabelH)];
    self.auditNameLabel.text=@"审核人员:";
    self.auditNameLabel.font = [UIFont systemFontOfSize:16];
    [bigBgView addSubview:self.auditNameLabel];
    
    self.auditNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.auditNameLabel.frame) + Kmarg, CGRectGetMaxY(picker.frame) + Kmarg, KTextFW+ 51, KtextFH)];
    self.auditNameCombox.textField.placeholder = @"请选择审核人员";
    self.auditNameCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.auditNameCombox.textField.borderStyle = UITextBorderStyleNone;
    self.auditNameCombox.dataArray = self.auditPeopleArr;
    [bigBgView addSubview:self.auditNameCombox];
    
    self.auditPeopleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.auditPeopleView.backgroundColor = UIColorFromRGB(246, 246, 246);
    self.auditPeopleView.alpha = 0.5;
    //邀请码
    inviteCodeLabel=[HHControl createLabelWithFrame:CGRectMake(awayX, CGRectGetMaxY(self.auditNameLabel.frame) + Kmarg, KLabelW, KLabelH) Font:16 Text:@"邀请码:"];
    inviteCodeLabel.font = [UIFont systemFontOfSize:16];
    inviteCode=[HHControl createTextFielfFrame:CGRectMake(CGRectGetMaxX(self.auditNameLabel.frame) + Kmarg, CGRectGetMaxY(self.auditNameLabel.frame) + Kmarg, KTextFW, KtextFH) font:nil placeholder:@"可不填"];
    inviteCode.backgroundColor=[UIColor whiteColor];
    [bigBgView addSubview:inviteCode];
    [bigBgView addSubview:inviteCodeLabel];
    
    CGFloat maxH = CGRectGetMaxY(inviteCode.frame) + Kmarg;
    bgView.frame = CGRectMake(0, 0, kWidth, maxH);
    
    //确认按钮
    landBtn=[HHControl createButtonWithFrame:CGRectMake(awayX, CGRectGetMaxY(bgView.frame) + 100, 325, 42) backGruondImageName:@"login_green" Target:self Action:@selector(landClick) Title:@"完成"];
    landBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    landBtn.titleLabel.textColor = UIColorFromRGB(255, 255, 255);
    [self.view addSubview:landBtn];
    
    //添加线条
    for (int i = 1; i < 4 ; i ++ ) {
        UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_schoolNameLabel.frame) * i + 3, bgView.size.width, 1)];
        line1.backgroundColor = UIColorFromRGB(204, 204, 204);
        [bgView addSubview:line1];
    }
    
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_teacherSubjectLabel.frame) + 5 , bgView.size.width, 5)];
    line2.backgroundColor = UIColorFromRGB(204, 204, 204);
    [bgView addSubview:line2];
    
    UIImageView *line3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(picker.frame) , bgView.size.width, 5)];
    line3.backgroundColor = UIColorFromRGB(204, 204, 204);
    [bgView addSubview:line3];
    
    UIImageView *line4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.auditNameCombox.frame) + 5 , bgView.size.width, 1)];
    line4.backgroundColor = UIColorFromRGB(204, 204, 204);
    [bgView addSubview:line4];
    
}

-(void)landClick
{
    if ([self.schoolTypeCombox.textField.text isEqualToString:@""]){
        [self showString:@"请选择学校类型" forSecond:1.f];
        return;
    }
    else if ([schoolNameText.text isEqualToString:@""]){
        [self showString:@"请填写学校名称" forSecond:1.f];
        return;
    }
    else if ([self.gradeNameCombox.textField.text isEqualToString:@""]){
        [self showString:@"请选择年级" forSecond:1.f];
        return;
    }
    else if ([self.classNameCombox.textField.text isEqualToString:@""]){
        [self showString:@"请选择班级" forSecond:1.f];
        return;
    }
    
    else if ([self.auditNameCombox.textField.text isEqualToString:@""]){
        [self showString:@"请选择审核人员" forSecond:1.f];
        return;
    }
    else{
        [self showString:@"注册成功" forSecond:1.f];
        NSLog(@"----跳转到登录页面----");
        XXELoginViewController *loginVC = [[XXELoginViewController alloc]init];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = loginVC;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//  加载Pist
- (void)reloadD{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"CityPlace" ofType:@"plist"];
    areaDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *components = [areaDict allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [NSMutableArray array];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDict objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    provinceArr = [NSArray arrayWithArray:provinceTmp];
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [provinceArr objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDict objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    cityArray = [NSArray arrayWithArray:[cityDic allKeys]];
    
    selectCityStr = [cityArray objectAtIndex:0];
    districtArr = [NSArray arrayWithArray:[cityDic objectForKey:selectCityStr]];
    
    addressDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   provinceArr,@"province",
                   cityArray,@"city",
                   districtArr,@"area",nil];
    
    selectProvinceStr = [provinceArr objectAtIndex:0];
    selectAreaStr = [districtArr objectAtIndex:0];
}

- (void)setBgScrollView{
    UILabel *areaLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 60+spaceY*2, 130, 30)];
    
    areaLable.textAlignment = NSTextAlignmentCenter;
    areaLable.text = @"学校信息：";
    [self.view addSubview:areaLable];
    
    
    NSArray *keys = [NSArray arrayWithObjects:@"province",@"city",@"area", nil];
    for(NSInteger i=0;i<3;i++)
    {
        LMComBoxView *comBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(127+(60+12)*i, 60+spaceY*2, 65, 30)];
        comBox.backgroundColor = UIColorFromRGB(246, 246, 246);
        comBox.arrowImgName = @"down_dark0.png";
        NSMutableArray *itemsArray = [NSMutableArray arrayWithArray:[addressDict objectForKey:[keys objectAtIndex:i]]];
        comBox.layer.cornerRadius = 5;
        [comBox.layer setMasksToBounds:YES];
        comBox.titlesList = itemsArray;
        comBox.delegate = self;
        comBox.supView = self.view;
        [comBox defaultSettings];
        comBox.tag = kDropDownListTag + i;
        
        [self.view addSubview:comBox];
        [self.view bringSubviewToFront:comBox];
        
    }
}
#pragma mark -LMComBoxViewDelegate
-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox
{
    NSInteger tag = _combox.tag - kDropDownListTag;
    switch (tag) {
        case 0:
        {
            selectProvinceStr =  [[addressDict objectForKey:@"province"]objectAtIndex:index];
            //字典操作
            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDict objectForKey: [NSString stringWithFormat:@"%d", index]]];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectProvinceStr]];
            NSArray *cityArray = [dic allKeys];
            NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;//递减
                }
                
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;//上升
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i=0; i<[sortedArray count]; i++) {
                NSString *index = [sortedArray objectAtIndex:i];
                NSArray *temp = [[dic objectForKey: index] allKeys];
                [array addObject: [temp objectAtIndex:0]];
            }
            cityArr = [NSArray arrayWithArray:array];
            
            NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
            districtArr = [NSArray arrayWithArray:[cityDic objectForKey:[cityArr objectAtIndex:0]]];
            //刷新市、区
            addressDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           provinceArr,@"province",
                           cityArr,@"city",
                           districtArr,@"area",nil];
            LMComBoxView *cityCombox = (LMComBoxView *)[self.view viewWithTag:tag + 1 + kDropDownListTag];
            cityCombox.titlesList = [NSMutableArray arrayWithArray:[addressDict objectForKey:@"city"]];
            [cityCombox reloadData];
            
            LMComBoxView *areaCombox = (LMComBoxView *)[self.view viewWithTag:tag + 2 + kDropDownListTag];
            areaCombox.titlesList = [NSMutableArray arrayWithArray:[addressDict objectForKey:@"area"]];
            [areaCombox reloadData];
            
            selectCityStr = [cityArr objectAtIndex:0];
            selectAreaStr = [districtArr objectAtIndex:0];
            break;
        }
        case 1:
        {
            selectCityStr = [[addressDict objectForKey:@"city"]objectAtIndex:index];
            
            NSString *provinceIndex = [NSString stringWithFormat: @"%ld", [provinceArr indexOfObject: selectProvinceStr]];
            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDict objectForKey: provinceIndex]];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectProvinceStr]];
            NSArray *dicKeyArray = [dic allKeys];
            NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: index]]];
            NSArray *cityKeyArray = [cityDic allKeys];
            districtArr = [NSArray arrayWithArray:[cityDic objectForKey:[cityKeyArray objectAtIndex:0]]];
            //刷新区
            addressDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           provinceArr,@"province",
                           cityArr,@"city",
                           districtArr,@"area",nil];
            LMComBoxView *areaCombox = (LMComBoxView *)[self.view viewWithTag:tag + 1 + kDropDownListTag];
            areaCombox.titlesList = [NSMutableArray arrayWithArray:[addressDict objectForKey:@"area"]];
            [areaCombox reloadData];
            
            selectAreaStr = [districtArr objectAtIndex:0];
            break;
        }
        case 2:
        {
            selectAreaStr = [[addressDict objectForKey:@"area"]objectAtIndex:index];
            break;
        }
        default:
            break;
    }
}

@end
