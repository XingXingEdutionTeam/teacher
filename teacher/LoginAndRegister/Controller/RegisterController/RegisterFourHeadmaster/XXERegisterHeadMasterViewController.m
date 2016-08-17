//
//  XXERegisterHeadMasterViewController.m
//  teacher
//
//  Created by codeDing on 16/8/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERegisterHeadMasterViewController.h"
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

#define  kDropDownListTag 1000

#define awayX 20
#define spaceX 5
#define spaceY 35

#define Kmarg 10.0f
#define KLabelW 70.0f
#define KLabelH 30.0f
#define KTextFW 200.0f
#define KtextFH 30.0f
@interface XXERegisterHeadMasterViewController ()<LMComBoxViewDelegate,UISearchBarDelegate>{
    
    UILabel *parentsNameLabel;   //姓名
    UILabel *parentsIDCardLabel;   //身份证号
    UILabel *inviteCodeLabel;   //邀请码
    UITextField *parentsName;   //姓名
    UITextField *parentsIDCard;   //身份证号
    UITextField *inviteCode;   //邀请码
    UIView *bgView;//背景
    
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

//丁
/** 选择学校 */
@property (nonatomic, strong)WJCommboxView *schoolNameChangeView;



@property(nonatomic,strong)UIButton *teacherDateBtn;
@end

@implementation XXERegisterHeadMasterViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    self.navigationItem.title = @"4/4注册校长";
    self.navigationController.navigationBarHidden = NO;
}

/** 这个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadD];
    [self commBoxInfo];
    
//  [self setBgScrollView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)commBoxInfo{
    //搜索框
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
    UIImage *backgroundImg = [UtilityFunc createImageWithColor:UIColorFromHex(0xf0eaf3) size:_searchBar.frame.size];
    [_searchBar setBackgroundImage:backgroundImg];
    _searchBar.placeholder =@"请输入你要查询的学校";
    _searchBar.tintColor = [UIColor blackColor];
    _searchBar.delegate =self;
    _searchDC = [[UISearchController alloc]initWithSearchResultsController:self];
    [self.view addSubview:_searchBar];
    
    __weak typeof(self)weakSelf = self;
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchBar.mas_bottom).offset(2);
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, 455*kScreenRatioHeight));
    }];
    
    /**
     学校名称
     */
    
    UILabel *schoolNameLabel = [UILabel setupMessageLabel:@"学校名称:"];
//    schoolNameLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:schoolNameLabel];
    [schoolNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.top.equalTo(_searchBar.mas_bottom).offset(3);
        make.size.mas_equalTo(CGSizeMake(117*kScreenRatioWidth, 48*kScreenRatioHeight));
    }];
    
    self.teacherTypeArr = [[NSArray alloc]initWithObjects:@"大学",@"大学",@"大学",@"大学",nil];
    
    _schoolNameChangeView = [[WJCommboxView alloc]initWithFrame:CGRectMake(117*kScreenRatioWidth, 57*kScreenRatioHeight, 245*kScreenRatioWidth, 70*kScreenRatioHeight)];
//    _schoolNameChangeView.backgroundColor = [UIColor redColor];
    _schoolNameChangeView.textField.placeholder = @"请选择学校";
    _schoolNameChangeView.textField.textAlignment = NSTextAlignmentLeft;
    _schoolNameChangeView.textField.borderStyle = UITextBorderStyleNone;
    _schoolNameChangeView.textField.tag = 102;
    _schoolNameChangeView.dataArray = self.teacherTypeArr;
    _schoolNameChangeView.listTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_schoolNameChangeView];
    
    
    UILabel *schoolTypeLabel = [UILabel setupMessageLabel:@"学校名称:"];
//    schoolTypeLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:schoolTypeLabel];
    [schoolTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.top.equalTo(schoolNameLabel.mas_bottom).offset(3);
        make.size.mas_equalTo(CGSizeMake(117*kScreenRatioWidth, 48*kScreenRatioHeight));
    }];

    WJCommboxView *schoolTypeView = [[WJCommboxView alloc]initWithFrame:CGRectMake(117*kScreenRatioWidth, 105*kScreenRatioHeight, 245*kScreenRatioWidth, 70*kScreenRatioHeight)];
//    schoolTypeView.backgroundColor = [UIColor redColor];
    schoolTypeView.textField.placeholder = @"请选择学校";
    schoolTypeView.textField.textAlignment = NSTextAlignmentLeft;
    schoolTypeView.textField.borderStyle = UITextBorderStyleNone;
    schoolTypeView.textField.tag = 102;
    schoolTypeView.dataArray = self.teacherTypeArr;
    schoolTypeView.listTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:schoolTypeView];
    
    UILabel *schoolMessLabel = [UILabel setupMessageLabel:@"学校信息:"];
//    schoolMessLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:schoolMessLabel];
    [schoolMessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.top.equalTo(schoolTypeLabel.mas_bottom).offset(3);
        make.size.mas_equalTo(CGSizeMake(117*kScreenRatioWidth, 48*kScreenRatioHeight));
    }];
    
    NSArray *keys = [NSArray arrayWithObjects:@"province",@"city",@"area", nil];
    for(NSInteger i=0;i<3;i++)
    {
        LMComBoxView *schoolBoxView = [[LMComBoxView alloc]initWithFrame:CGRectMake(117*kScreenRatioWidth+72*i, 160*kScreenRatioHeight, 75*kScreenRatioWidth, 30*kScreenRatioHeight)];
        
        schoolBoxView.arrowImgName = @"down_dark0.png";
        NSMutableArray *itemsArray = [NSMutableArray arrayWithArray:[addressDict objectForKey:[keys objectAtIndex:i]]];
        schoolBoxView.layer.cornerRadius = 5;
        [schoolBoxView.layer setMasksToBounds:YES];
        schoolBoxView.titlesList = itemsArray;
        schoolBoxView.delegate = self;
        schoolBoxView.supView = self.view;
        schoolBoxView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [schoolBoxView defaultSettings];
        schoolBoxView.tag = kDropDownListTag + i;
        
        [self.view addSubview:schoolBoxView];
        [self.view bringSubviewToFront:schoolBoxView];
    }
    
    //详细地址
    
    UILabel *schoolAddressLabel = [UILabel setupMessageLabel:@"详细地址:"];
//    schoolAddressLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:schoolAddressLabel];
    [schoolAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.top.equalTo(schoolMessLabel.mas_bottom).offset(3);
        make.size.mas_equalTo(CGSizeMake(117*kScreenRatioWidth, 48*kScreenRatioHeight));
    }];
   
    UITextField *schoolAddressTextField = [UITextField createTextFieldWithIsOpen:NO textPlaceholder:@"请输入学校详细地址"];
    [self.view addSubview:schoolAddressTextField];
    [schoolAddressTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(schoolAddressLabel.mas_right).offset(5);
        make.right.equalTo(weakSelf.view.mas_right).offset(-5);
        make.centerY.equalTo(schoolAddressLabel.mas_centerY);
        make.height.mas_equalTo(@(48*kScreenRatioHeight));
    }];
    

    
    //联系电话
    phoneLabel=[HHControl createLabelWithFrame:CGRectMake(awayX, CGRectGetMaxY(addressLabel.frame) + Kmarg, KLabelW, KLabelH) Font:16 Text:@"联系方式:"];
    [bgView addSubview:phoneLabel];
    phoneText=[HHControl createTextFielfFrame:CGRectMake(CGRectGetMaxX(phoneLabel.frame) + Kmarg, CGRectGetMaxY(addressText.frame) + Kmarg, KTextFW, KtextFH) font:[UIFont systemFontOfSize:14] placeholder:@"请输入联系方式"];
    phoneText.backgroundColor=[UIColor whiteColor];
    phoneText.borderStyle = UITextBorderStyleNone;
    phoneText.keyboardType=UIKeyboardTypeNumberPad;
//    [bigBgView addSubview:phoneText];
    
    //上传相关张证明
    provcLabel=[HHControl createLabelWithFrame:CGRectMake(awayX, CGRectGetMaxY(phoneLabel.frame), kWidth - awayX * 2, 50) Font:11 Text:@"请上传以下相关证明:身份证，工作证，营业资格证，如有疑问请联系客服(021-60548858)"];
    provcLabel.numberOfLines=2;
    [bgView addSubview:provcLabel];
    
    //    //选择图片
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    FSImagePickerView *picker = [[FSImagePickerView alloc] initWithFrame:CGRectMake(awayX, CGRectGetMaxY(provcLabel.frame), kWidth - awayX * 2, 75) collectionViewLayout:layout];
    picker.backgroundColor = UIColorFromRGB(255, 255, 255);
    picker.showsHorizontalScrollIndicator = NO;
    picker.controller = self;
//    [bigBgView addSubview:picker];
    
    /**
     审核人员
     */
    self.auditPeopleArr = [[NSArray alloc]initWithObjects:@"平台审核",nil];
    self.auditNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(awayX, CGRectGetMaxY(picker.frame) + Kmarg *2, KLabelW, KtextFH)];
    self.auditNameLabel.text=@"审核人员:";
    self.auditNameLabel.font = [UIFont systemFontOfSize:16];
//    [bigBgView addSubview:self.auditNameLabel];
    
    self.auditNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.auditNameLabel.frame) + Kmarg, CGRectGetMaxY(picker.frame) + Kmarg *2, KTextFW+ 51, KtextFH)];
    self.auditNameCombox.textField.placeholder = @"请选择审核人员";
    self.auditNameCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.auditNameCombox.textField.borderStyle = UITextBorderStyleNone;
    self.auditNameCombox.dataArray = self.auditPeopleArr;
//    [bigBgView addSubview:self.auditNameCombox];
    
    self.auditPeopleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.auditPeopleView.backgroundColor = UIColorFromRGB(246, 246, 246);
    self.auditPeopleView.alpha = 0.5;
    
    //邀请码
    inviteCodeLabel=[HHControl createLabelWithFrame:CGRectMake(awayX, CGRectGetMaxY(self.auditNameLabel.frame) + Kmarg, KLabelW, KtextFH) Font:16 Text:@"邀请码:"];
    inviteCode=[HHControl createTextFielfFrame:CGRectMake(CGRectGetMaxX(inviteCodeLabel.frame) + Kmarg, CGRectGetMaxY(self.auditNameCombox.frame) + Kmarg, KTextFW, KtextFH) font:[UIFont systemFontOfSize:14] placeholder:@"可不填"];
    inviteCode.backgroundColor=[UIColor whiteColor];
//    [bigBgView addSubview:inviteCode];
//    [bigBgView addSubview:inviteCodeLabel];
    
    CGFloat maxH = CGRectGetMaxY(inviteCode.frame) + Kmarg;
    bgView.frame = CGRectMake(0, 0, kWidth, maxH);

    //确认按钮
    landBtn=[HHControl createButtonWithFrame:CGRectMake(awayX, 500 , 325, 42) backGruondImageName:@"login_green" Target:self Action:@selector(landClick) Title:@"完成"];
    landBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    landBtn.titleLabel.textColor = UIColorFromRGB(255, 255, 255);
    [self.view addSubview:landBtn];
    
    //添加线条
    for (int i = 1; i < 5 ; i ++ ) {
        UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_schoolNameLabel.frame) * i + 3, bgView.size.width, 1)];
        line1.backgroundColor = UIColorFromRGB(204, 204, 204);
        [bgView addSubview:line1];
    }
    
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(phoneLabel.frame) + 5 , bgView.size.width, 5)];
    line2.backgroundColor = UIColorFromRGB(204, 204, 204);
    [bgView addSubview:line2];
    
    UIImageView *line3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(picker.frame) + Kmarg , bgView.size.width, 5)];
    line3.backgroundColor = UIColorFromRGB(204, 204, 204);
    [bgView addSubview:line3];
    
    UIImageView *line5 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.auditNameCombox.frame) + 5 , bgView.size.width, 1)];
    line5.backgroundColor = UIColorFromRGB(204, 204, 204);
    [bgView addSubview:line5];
    
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
    else if ([addressText.text isEqualToString:@""]){
        [self showString:@"请填写学校详细地址" forSecond:1.f];
        return;
    }
    else if ([phoneText.text isEqualToString:@""]){
        [self showString:@"请填写学校联系方式" forSecond:1.f];
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
    UILabel *areaLable = [[UILabel alloc]initWithFrame:CGRectMake(awayX, 88, KLabelW, KLabelH)];
    areaLable.text = @"学校信息:";
    areaLable.font = [UIFont systemFontOfSize:16];
    //    areaLable.backgroundColor = [UIColor redColor];
    [bgView addSubview:areaLable];
    
    
    NSArray *keys = [NSArray arrayWithObjects:@"province",@"city",@"area", nil];
    for(NSInteger i=0;i<3;i++)
    {
        LMComBoxView *comBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(areaLable.frame) + 15 +72*i, 88, KLabelW, KLabelH)];
        comBox.arrowImgName = @"down_dark0.png";
        NSMutableArray *itemsArray = [NSMutableArray arrayWithArray:[addressDict objectForKey:[keys objectAtIndex:i]]];
        comBox.layer.cornerRadius = 5;
        [comBox.layer setMasksToBounds:YES];
        comBox.titlesList = itemsArray;
        comBox.delegate = self;
        comBox.supView = self.view;
        comBox.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [comBox defaultSettings];
        comBox.tag = kDropDownListTag + i;
        
        [bgView addSubview:comBox];
        [bgView bringSubviewToFront:comBox];
        
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
            
            NSString *provinceIndex = [NSString stringWithFormat: @"%ld", (unsigned long)[provinceArr indexOfObject: selectProvinceStr]];
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
