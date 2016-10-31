


//
//  XXECourseManagerCourseReleaseViewController.m
//  teacher
//
//  Created by Mac on 16/9/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECourseManagerCourseReleaseViewController.h"
#import "XXECourseManagerCourseSettingViewController.h"
//获取 课程 三级类目
#import "XXECourseManagerCourseCategoryApi.h"
//获取 该学校 老师 列表
#import "XXECourseManagerSchoolTeacherListApi.h"

#import "XXECourseManagerSchoolTeacherModel.h"
#import "XXECourseManagerClassModel1.h"
#import "XXECourseManagerClassModel2.h"
#import "XXECourseManagerClassModel3.h"
#import "FSImagePickerView.h"

#import "XXECourseManagerCourseReleaseApi.h"

#define KLabelW 65
#define KLabelH 25

#define awayX 20
#define spaceX 10
#define spaceY 35

#define MAX_STARWORDS_LENGTH 10

@interface XXECourseManagerCourseReleaseViewController ()<UITextFieldDelegate ,UITextViewDelegate>

{
    
    NSMutableArray * studentArray;
    int checkNum;
    int noCheckNum;
    
    UIScrollView *bgScrollView;
    //课程类型 3个下拉框
    WJCommboxView *subjectCommbox1;
    WJCommboxView *subjectCommbox2;
    WJCommboxView *subjectCommbox3;
    
    UIView *subjectCommboxBgView1;
    UIView *subjectCommboxBgView2;
    UIView *subjectCommboxBgView3;
    
    //老师名称 
    WJCommboxView *teacherNameCommbox;
    UIView *teacherNameCommboxBgView;
    
    UILabel* subjectLabel;
    
    UILabel* teacherLabel;
    //该 学校 老师 模型 数组
    NSMutableArray *teacherArray;
    //授课 老师 id
    NSString *teacherId;
    NSMutableArray *teacherNameArray;
    
    UILabel* studentCountLabel;
    UITextField *studentCountText;
    
    UILabel* studentAgeLabel;
    UITextField *studentAgeText1;
    UITextField *studentAgeText2;
    
    UILabel* targetLabel;
    UITextField *targetText;
    
    UILabel* arrangeLabel;
    UITextField *arrangeText;
    
    UILabel* timeLabel;
    UITextField *timeText;
    
    UITextField *addressText;
    
    //是否 允许 插班 下拉框
    WJCommboxView *insertClassCommbox;
    UIView *insertClassCommboxBgView;
    
    //是否 允许 退班 下拉框
    WJCommboxView *exitClassCommbox;
    UIView *exitClassCommboxBgView;
    
    UITextField *oldMoneyText;
    UITextField *newMoneyText;
    
    //是否 允许 扣除 猩币 下拉框
    WJCommboxView *deductXingIconCommbox;
    UIView *deductXingIconCommboxBgView;
    
    //课程 详情
    UITextView *courseDetailTextView;
    
    UIButton *saveBtn;
    UIButton *releaseBtn;
    UITapGestureRecognizer * _gesture;
    
    //传参
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
    //三级类目 数据
    NSMutableArray *classGroupArray1;
    NSMutableArray *classGroupArray2;
    NSMutableArray *classGroupArray3;
    NSMutableDictionary *classGroupDic2;
    NSMutableDictionary *classGroupDic3;
    
    NSString *className1;
    NSString *className2;
    NSString *className3;

    NSString *classID1;
    NSString *classID2;
    NSString *classID3;
    
    //课程 设置 结果 信息
    //开始 日期
    NSString *startTimeStr;
    //结束 日期
    NSString *endTimeStr;
    //一周 几次
    NSString *timesStr;
    //课时 多少分钟
    NSString *lengthStr;

    //第二部分 传参
    NSMutableArray *secondPartResultArray;
    NSString *secondJsonString;
    
    //第三部分 传参   具体 上课 时间  数组
    NSDictionary *courseTimeDict;
    NSString *thirdJsonString;
    
    //课程 图片
    NSMutableArray *coursePicArray;
    //图片 选择 器
    FSImagePickerView *pickerView;
    //图片 先 上传后 得到 的图片 url
    NSString *url_groupStr;
    
    //是否 允许 插班 字符串
    NSString *insertFlagStr;
    //是否 允许 退班 字符串
    NSString *exitFlagStr;
    //是否 允许 猩币 抵扣
    NSString *deductFlagStr;

    /*
     publish_type	//发布类型 (分4种,传数字)
     //1:发布课程
     //2:发布时选择保存草稿箱
     //3:修改数据后发布课程 (除了原始图片,其他数据都要重新上传,包括新图片)
     //4:修改数据后保存草稿箱 (除了原始图片,其他数据都要重新上传,包括新图片)
     注:草稿箱中修改课程和审核状态,驳回状态修改课程,都属于修改.当修改的时候,请保证至少有一个参数用户改动了,才允许提交.
     */
    NSString *publish_type;

    NSString *course_name;
    NSString *need_num;
    NSString *age_up;
    NSString *age_down;
    NSString *teach_goal;
    NSString *address;
    NSString *original_price;
    NSString *now_price;
    NSString *details;
    
}

@end

@implementation XXECourseManagerCourseReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    className1 = @"";
    className2 = @"";
    className3 = @"";
    classID1 = @"";
    classID2 = @"";
    classID3 = @"";
    publish_type = @"";
    insertFlagStr = @"";
    exitFlagStr = @"";
    deductFlagStr = @"";
    url_groupStr = @"";
    secondJsonString = @"";
    thirdJsonString = @"";
    
    startTimeStr = @"";
    endTimeStr = @"";
    timesStr = @"";
    lengthStr = @"";
    courseTimeDict = [[NSDictionary alloc] init];

    course_name = @"";
    need_num = @"";
    age_up = @"";
    age_down = @"";
    teach_goal = @"";
    address = @"";
    original_price = @"";
    course_name = @"";
    now_price = @"";
    details = @"";
    teacherId = @"";
    
    [self fetchNetData];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self creatFields];
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //课程名称 字数 限制 监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)name:@"UITextFieldTextDidChangeNotification" object:arrangeText];
    
    
}

- (void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > MAX_STARWORDS_LENGTH)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}


//监听方法
- (void)keyboardWillShow {
    _gesture.enabled = YES;
}
//隐藏键盘
- (void)hidesKeyboard{
    [self.view endEditing:YES];
    _gesture.enabled = NO;
}
-(void)creatFields{
    //背景
    bgScrollView = [[UIScrollView alloc] init];
    bgScrollView.frame = CGRectMake(0, 0, WinWidth, WinHeight);
    bgScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgScrollView];
    //添加点击收起键盘手势
    _gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidesKeyboard)];
    _gesture.enabled = NO;//最开始手势设为no
    [bgScrollView addGestureRecognizer:_gesture];
    
    bgScrollView.pagingEnabled = NO;
    bgScrollView.bounces = NO;
    bgScrollView.userInteractionEnabled = YES;
    bgScrollView.clipsToBounds = YES;
    bgScrollView.showsHorizontalScrollIndicator = YES;
    bgScrollView.showsVerticalScrollIndicator  = YES;
    
#pragma mark ------------ 课程 类型 三个 下拉框 ------------------
    
    subjectLabel=[UILabel createLabelWithFrame:CGRectMake(awayX, spaceX, KLabelW , KLabelH) Font:14 Text:@"课程类型:"];
    subjectCommbox1 = [[WJCommboxView alloc] initWithFrame:CGRectMake(subjectLabel.x +subjectLabel.size.width + spaceX, subjectLabel.y, (kWidth - subjectLabel.x - subjectLabel.size.width - 30)/3, KLabelH)];
    CGRect rect1 = subjectCommbox1.textField.frame;
    rect1.size.height = KLabelH;
    subjectCommbox1.textField.frame = rect1;
    
    subjectCommbox1.textField.tag = 11;
    subjectCommbox1.textField.placeholder = @"";
    subjectCommbox1.textField.textAlignment = NSTextAlignmentLeft;
    subjectCommbox1.textField.borderStyle=UITextBorderStyleRoundedRect;
    [subjectCommbox1.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"1"];
    
    subjectCommboxBgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kWidth,kHeight+300)];
    subjectCommboxBgView1.backgroundColor = [UIColor clearColor];
    subjectCommboxBgView1.alpha = 0.5;
    UITapGestureRecognizer *singleTouch1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden1)];
    [subjectCommboxBgView1 addGestureRecognizer:singleTouch1];
    
//-------------------- subjectCommbox2 ---------------
    subjectCommbox2 = [[WJCommboxView alloc] initWithFrame:CGRectMake(subjectCommbox1.x +subjectCommbox1.size.width + 5, subjectLabel.y, (kWidth - subjectLabel.x - subjectLabel.size.width - 30)/3, KLabelH)];
    CGRect rect2 = subjectCommbox2.textField.frame;
    rect2.size.height = KLabelH;
    subjectCommbox2.textField.frame = rect2;
    subjectCommbox2.textField.placeholder = @"";
    subjectCommbox2.textField.textAlignment = NSTextAlignmentLeft;
    subjectCommbox2.textField.borderStyle=UITextBorderStyleRoundedRect;
    [subjectCommbox2.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"2"];
    
    subjectCommboxBgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kWidth,kHeight+300)];
    subjectCommboxBgView2.backgroundColor = [UIColor clearColor];
    subjectCommboxBgView2.alpha = 0.5;
    UITapGestureRecognizer *singleTouch2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden2)];
    [subjectCommboxBgView2 addGestureRecognizer:singleTouch2];
    
    //+++++++++++++++++++++ subjectCommbox3 ++++++++++++++++++
    subjectCommbox3 = [[WJCommboxView alloc] initWithFrame:CGRectMake(subjectCommbox2.x +subjectCommbox2.size.width + 5, subjectLabel.y, (kWidth - subjectLabel.x - subjectLabel.size.width - 30)/3, KLabelH)];
    CGRect rect3 = subjectCommbox3.textField.frame;
    rect3.size.height = KLabelH;
    subjectCommbox3.textField.frame = rect3;
    
    subjectCommbox3.textField.tag = 13;
    subjectCommbox3.textField.placeholder = @"";
    subjectCommbox3.textField.textAlignment = NSTextAlignmentLeft;
    subjectCommbox3.textField.borderStyle=UITextBorderStyleRoundedRect;
    [subjectCommbox3.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"3"];
    
    subjectCommboxBgView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kWidth,kHeight+300)];
    subjectCommboxBgView3.backgroundColor = [UIColor clearColor];
    subjectCommboxBgView3.alpha = 0.5;
//    subjectCommboxBgView3.tag = 13;
    UITapGestureRecognizer *singleTouch3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden3)];
    [subjectCommboxBgView3 addGestureRecognizer:singleTouch3];
    
    [bgScrollView addSubview:subjectLabel];
    [bgScrollView addSubview:subjectCommbox1];
    [bgScrollView addSubview:subjectCommbox2];
    [bgScrollView addSubview:subjectCommbox3];
    
    //课程名称
    arrangeLabel=[UILabel createLabelWithFrame:CGRectMake(awayX, 10+spaceY*1, KLabelW , KLabelH) Font:14 Text:@"课程名称:"];
    arrangeText = [UITextField createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(arrangeLabel.frame) + spaceX, 10+spaceY*1, kWidth - subjectLabel.x - subjectLabel.size.width - awayX, KLabelH) placeholder:@"请输入10字以内的课程名称" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    arrangeText.borderStyle=UITextBorderStyleRoundedRect;
    arrangeText.delegate = self;
    [bgScrollView addSubview:arrangeLabel];
    [bgScrollView addSubview:arrangeText];
    
#pragma mark =================== 老师 名称 ====================
    //授课老师
    teacherLabel=[UILabel createLabelWithFrame:CGRectMake(awayX, 10+spaceY*2, KLabelW , KLabelH) Font:14 Text:@"授课老师:"];
   
    teacherNameCommbox = [[WJCommboxView alloc] initWithFrame:CGRectMake(subjectLabel.x +subjectLabel.size.width + spaceX, 10 + spaceY * 2, kWidth - subjectLabel.x - subjectLabel.size.width - awayX, KLabelH)];
    CGRect rect4 = teacherNameCommbox.textField.frame;
    rect4.size.height = KLabelH;
    teacherNameCommbox.textField.frame = rect4;
    
    teacherNameCommbox.textField.tag = 14;
    teacherNameCommbox.textField.placeholder = @"";
    teacherNameCommbox.textField.textAlignment = NSTextAlignmentLeft;
    teacherNameCommbox.textField.borderStyle = UITextBorderStyleRoundedRect;
    
    [teacherNameCommbox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"4"];
    
    teacherNameCommboxBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kWidth,kHeight+300)];
    teacherNameCommboxBgView.backgroundColor = [UIColor clearColor];
    teacherNameCommboxBgView.alpha = 0.5;
    UITapGestureRecognizer *singleTouch4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden4)];
    [teacherNameCommboxBgView addGestureRecognizer:singleTouch4];
    
    
    [bgScrollView addSubview:teacherLabel];
    [bgScrollView addSubview:teacherNameCommbox];
   
#pragma mark *******************  招生人数  **********************
    //招生人数
    studentCountLabel=[UILabel createLabelWithFrame:CGRectMake(awayX, 10+spaceY*3, KLabelW , KLabelH) Font:14 Text:@"招生人数:"];
    studentCountText = [UITextField createTextFieldWithFrame:CGRectMake(subjectLabel.x +subjectLabel.size.width + spaceX, 10+spaceY*3, kWidth - subjectLabel.x - subjectLabel.size.width - awayX, KLabelH) placeholder:@"" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    studentCountText.borderStyle = UITextBorderStyleRoundedRect;
    studentCountText.keyboardType=UIKeyboardTypeNumberPad;
    studentCountText.delegate = self;
    [bgScrollView addSubview:studentCountLabel];
    [bgScrollView addSubview:studentCountText];

#pragma mark *******************  适用人群  **********************
    //适用人群
    studentAgeLabel=[UILabel createLabelWithFrame:CGRectMake(awayX, 10+spaceY*4, KLabelW , KLabelH) Font:14 Text:@"适用人群:"];
    
    studentAgeText1 = [UITextField createTextFieldWithFrame:CGRectMake(subjectLabel.x +subjectLabel.size.width + spaceX, 10+spaceY*4, (kWidth - studentAgeLabel.x - studentAgeLabel.size.width - 26 - 30)/2, KLabelH) placeholder:@"年龄" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    
    studentAgeText1.borderStyle=UITextBorderStyleRoundedRect;
    studentAgeText1.keyboardType=UIKeyboardTypeNumberPad;
    studentAgeText1.delegate = self;
    
    UILabel *label1 = [UILabel createLabelWithFrame:CGRectMake(studentAgeText1.x + studentAgeText1.size.width, 10+spaceY*4, 30, 30) Font:14 Text:@"至"];
    label1.textAlignment = NSTextAlignmentCenter;
    [bgScrollView addSubview:label1];
    
    studentAgeText2 = [UITextField createTextFieldWithFrame:CGRectMake(awayX+40+spaceX*1+170 * kScreenRatioWidth, 10+spaceY*4, (kWidth - studentAgeLabel.x - studentAgeLabel.size.width - 26 - 30)/2, KLabelH) placeholder:@"年龄" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    studentAgeText2.borderStyle=UITextBorderStyleRoundedRect;
    studentAgeText2.keyboardType=UIKeyboardTypeNumberPad;
    [bgScrollView addSubview:studentAgeLabel];
    [bgScrollView addSubview:studentAgeText1];
    [bgScrollView addSubview:studentAgeText2];
    
#pragma mark *******************  教学目标  **********************
    //教学目标
    targetLabel=[UILabel createLabelWithFrame:CGRectMake(awayX, 10+spaceY*5, KLabelW , KLabelH) Font:14 Text:@"教学目标:"];
    targetText = [UITextField createTextFieldWithFrame:CGRectMake(subjectLabel.x +subjectLabel.size.width + spaceX, 10+spaceY*5, kWidth - subjectLabel.x - subjectLabel.size.width - awayX, KLabelH) placeholder:@"" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    targetText.borderStyle=UITextBorderStyleRoundedRect;
    targetText.delegate = self;
    [bgScrollView addSubview:targetLabel];
    [bgScrollView addSubview:targetText];

#pragma mark *******************  课程安排  **********************
    //课程安排
    timeLabel=[UILabel createLabelWithFrame:CGRectMake(awayX, 10+spaceY*6, KLabelW , KLabelH) Font:14 Text:@"课程安排:"];

    
    timeText = [UITextField createTextFieldWithFrame:CGRectMake(subjectLabel.x +subjectLabel.size.width + spaceX, 10+spaceY*6, kWidth - subjectLabel.x - subjectLabel.size.width - awayX, KLabelH) placeholder:@"去设置" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 120 * kScreenRatioWidth, 5 , 10, 16)];
    rightImageView.image = [UIImage imageNamed:@"narrow_icon14x26"];
    [timeText addSubview:rightImageView];
    
    timeText.borderStyle=UITextBorderStyleRoundedRect;
    timeText.tag = 100;
    timeText.delegate = self;
    [bgScrollView addSubview:timeLabel];
    [bgScrollView addSubview:timeText];

#pragma mark *******************  上课地址  **********************
    //上课地址
    [bgScrollView addSubview:[UILabel createLabelWithFrame:CGRectMake(awayX, 10+spaceY*7, KLabelW , KLabelH) Font:14 Text:@"上课地址:"]];
    addressText = [UITextField createTextFieldWithFrame:CGRectMake(subjectLabel.x +subjectLabel.size.width + spaceX, 10+spaceY*7, kWidth - subjectLabel.x - subjectLabel.size.width - awayX, KLabelH) placeholder:@"" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    addressText.borderStyle=UITextBorderStyleRoundedRect;
    addressText.delegate = self;
    [bgScrollView addSubview:addressText];

#pragma mark *******************  插班规则  **********************
    //插班规则
    [bgScrollView addSubview:[UILabel createLabelWithFrame:CGRectMake(awayX, 10+spaceY*8, KLabelW , KLabelH) Font:14 Text:@"插班规则:"]];
    NSArray *inRuleTextArr = [[NSArray alloc]initWithObjects:@"是",@"否",nil];
    insertClassCommbox = [[WJCommboxView alloc] initWithFrame:CGRectMake(subjectLabel.x +subjectLabel.size.width + spaceX, 10+spaceY*8, kWidth - subjectLabel.x - subjectLabel.size.width - awayX, KLabelH)];
    CGRect rect5 = insertClassCommbox.textField.frame;
    rect5.size.height = KLabelH;
    insertClassCommbox.textField.frame = rect5;
    
    insertClassCommbox.textField.tag = 15;
    insertClassCommbox.textField.placeholder = @"";
    insertClassCommbox.textField.textAlignment = NSTextAlignmentCenter;
    insertClassCommbox.dataArray = inRuleTextArr;
    insertClassCommbox.textField.borderStyle=UITextBorderStyleRoundedRect;
    
    insertClassCommboxBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kWidth,kHeight+300)];
    insertClassCommboxBgView.backgroundColor = [UIColor clearColor];
    insertClassCommboxBgView.alpha = 0.5;
    //    subjectCommboxBgView1.tag = 11;
    UITapGestureRecognizer *singleTouch5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden5)];
    [insertClassCommboxBgView addGestureRecognizer:singleTouch5];
    
    
    [bgScrollView addSubview:insertClassCommbox];

#pragma mark *******************  退班规则  **********************
    //退班规则
    [bgScrollView addSubview:[UILabel createLabelWithFrame:CGRectMake(awayX, 10+spaceY*9, KLabelW , KLabelH) Font:14 Text:@"退班规则:"]];
    NSArray *outRuleTextArr = [[NSArray alloc]initWithObjects:@"是",@"否",nil];
    exitClassCommbox = [[WJCommboxView alloc] initWithFrame:CGRectMake(subjectLabel.x +subjectLabel.size.width + spaceX, 10+spaceY*9, kWidth - subjectLabel.x - subjectLabel.size.width - awayX, KLabelH)];
    CGRect rect6 = exitClassCommbox.textField.frame;
    rect6.size.height = KLabelH;
    exitClassCommbox.textField.frame = rect6;
    
    exitClassCommbox.textField.tag = 16;
    exitClassCommbox.textField.placeholder = @"";
    exitClassCommbox.textField.textAlignment = NSTextAlignmentCenter;
    exitClassCommbox.dataArray = outRuleTextArr;
    exitClassCommbox.textField.borderStyle=UITextBorderStyleRoundedRect;
    
    exitClassCommboxBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kWidth,kHeight+300)];
    exitClassCommboxBgView.backgroundColor = [UIColor clearColor];
    exitClassCommboxBgView.alpha = 0.5;
    //    subjectCommboxBgView1.tag = 11;
    UITapGestureRecognizer *singleTouch6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden6)];
    [exitClassCommboxBgView addGestureRecognizer:singleTouch6];
    
    [bgScrollView addSubview:exitClassCommbox];

#pragma mark *******************  学费 原价  **********************
    //学费 原价
    [bgScrollView addSubview:[UILabel createLabelWithFrame:CGRectMake(awayX, 10+spaceY*10, KLabelW , KLabelH) Font:14 Text:@"原       价:"]];
    
    oldMoneyText = [UITextField createTextFieldWithFrame:CGRectMake(subjectLabel.x +subjectLabel.size.width + spaceX, 10+spaceY*10, kWidth - subjectLabel.x - subjectLabel.size.width - awayX, KLabelH) placeholder:@"请输入整数" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    oldMoneyText.borderStyle=UITextBorderStyleRoundedRect;
    oldMoneyText.keyboardType=UIKeyboardTypeNumberPad;
    oldMoneyText.delegate = self;
    [bgScrollView addSubview:oldMoneyText];

#pragma mark *******************  学费 现价  **********************
    //学费 现价
    [bgScrollView addSubview:[UILabel createLabelWithFrame:CGRectMake(awayX, 10+spaceY*11, KLabelW , KLabelH) Font:14 Text:@"现       价:"]];
    
    newMoneyText = [UITextField createTextFieldWithFrame:CGRectMake(subjectLabel.x +subjectLabel.size.width + spaceX, 10+spaceY*11, kWidth - subjectLabel.x - subjectLabel.size.width - awayX, KLabelH) placeholder:@"请输入整数" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    newMoneyText.borderStyle = UITextBorderStyleRoundedRect;
        newMoneyText.keyboardType=UIKeyboardTypeNumberPad;
    newMoneyText.delegate = self;
    [bgScrollView addSubview:newMoneyText];
    
    
    [bgScrollView addSubview:[UILabel createLabelWithFrame:CGRectMake(awayX,  10+spaceY*12, KLabelW , KLabelH) Font:14 Text:@"猩币抵扣:"]];
    NSArray *xingIconArr = [[NSArray alloc]initWithObjects:@"允许猩币抵扣  上限为1%",@"不允许猩币抵扣",nil];
    deductXingIconCommbox = [[WJCommboxView alloc] initWithFrame:CGRectMake( subjectLabel.x +subjectLabel.size.width + spaceX, 10+spaceY*12, kWidth - subjectLabel.x - subjectLabel.size.width - awayX, KLabelH)];
    CGRect rect7 = deductXingIconCommbox.textField.frame;
    rect7.size.height = KLabelH;
    deductXingIconCommbox.textField.frame = rect7;
    
    deductXingIconCommbox.textField.tag = 17;
    deductXingIconCommbox.textField.placeholder = @"";
    deductXingIconCommbox.textField.textAlignment = NSTextAlignmentCenter;
    deductXingIconCommbox.dataArray = xingIconArr;
    deductXingIconCommbox.textField.borderStyle=UITextBorderStyleRoundedRect;
    
    deductXingIconCommboxBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kWidth,kHeight+300)];
    deductXingIconCommboxBgView.backgroundColor = [UIColor clearColor];
    deductXingIconCommboxBgView.alpha = 0.5;
    UITapGestureRecognizer *singleTouch7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden7)];
    [deductXingIconCommboxBgView addGestureRecognizer:singleTouch7];
    
    [bgScrollView addSubview: deductXingIconCommbox];
    
#pragma mark *******************  课程说明  **********************
    //课程说明
    UIView *belowBg = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(deductXingIconCommbox.frame) + spaceX, kWidth, 500)];
    belowBg.backgroundColor = UIColorFromRGB(204, 204, 204);
//    belowBg.backgroundColor = [UIColor redColor];
    [bgScrollView addSubview:belowBg];
    
    //课程详情
    UIView *courseDetailBgView = [[UIView alloc] initWithFrame:CGRectMake(0, spaceX, kWidth, 140)];
    courseDetailBgView.backgroundColor = [UIColor whiteColor];
    [belowBg addSubview:courseDetailBgView];
    
    UILabel *courseDetailLabel = [UILabel createLabelWithFrame:CGRectMake(awayX, spaceX, KLabelW , KLabelH) Font:14 Text:@"课程详情:"];
    [courseDetailBgView addSubview:courseDetailLabel];
    
    courseDetailTextView = [[UITextView alloc] initWithFrame:CGRectMake(awayX, courseDetailLabel.frame.origin.y + courseDetailLabel.frame.size.height, kWidth - awayX * 2, 100)];
    courseDetailTextView.layer.borderColor = [UIColorFromRGB(229, 232, 233) CGColor];
    courseDetailTextView.layer.borderWidth = 1;
    [courseDetailBgView addSubview:courseDetailTextView];
    
    
    UIView *subjectShowBg = [[UIView alloc] initWithFrame:CGRectMake(0, 150 + spaceX, kWidth, 120)];
    subjectShowBg.backgroundColor = UIColorFromRGB(255, 255, 255);
    [belowBg addSubview:subjectShowBg];
    UILabel *subjectShow = [UILabel createLabelWithFrame:CGRectMake(awayX, spaceX, KLabelW , KLabelH) Font:14 Text:@"课程图片:"];
    [subjectShowBg addSubview:subjectShow];
    
#pragma mark *******************  选取图片  **********************
    //选取图片
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    pickerView = [[FSImagePickerView alloc] initWithFrame:CGRectMake(awayX, subjectShow.y + subjectShow.size.height, kWidth - 100, 70) collectionViewLayout:layout];
    pickerView.showsHorizontalScrollIndicator = NO;
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.controller = self;
    [subjectShowBg addSubview:pickerView];
    
    //保存到草稿
    saveBtn=[UIButton createButtonWithFrame:CGRectMake(awayX, subjectShowBg.frame.origin.y + subjectShowBg.size.height + spaceX, 325 * kScreenRatioWidth, 42 * kScreenRatioHeight) backGruondImageName:@"login_green" Target:self Action:@selector(saveDraftsBtn:) Title:@"保存到草稿"];
//    saveBtn.selected = NO;
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [belowBg addSubview:saveBtn];
    
    //提交审核
    releaseBtn=[UIButton createButtonWithFrame:CGRectMake(awayX, saveBtn.frame.origin.y + saveBtn.size.height + spaceX, 325 * kScreenRatioWidth, 42 * kScreenRatioHeight) backGruondImageName:@"login_green" Target:self Action:@selector(releaseBtn:) Title:@"提交审核"];
//    releaseBtn.selected = NO;
    [releaseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [belowBg addSubview:releaseBtn];
    
    CGFloat maxH = belowBg.y + belowBg.size.height + 50;
    bgScrollView.contentSize = CGSizeMake(0, maxH);
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 100) {
        XXECourseManagerCourseSettingViewController *courseManagerCourseSettingVC = [[XXECourseManagerCourseSettingViewController alloc] init];

        [courseManagerCourseSettingVC returnStr:^(NSArray *resultArray) {
        //   resultArray = [[NSMutableArray alloc] initWithObjects:startTimeStr, endTimeStr, timesStr, lengthStr, courseTimeArray, nil];
            //课程 开始 日期
            startTimeStr = resultArray[0];
            //课程 结束 日期
            endTimeStr = resultArray[1];
            //一周 上课 次数
            timesStr =  resultArray[2];
            //一节课 时长
            lengthStr = resultArray[3];
            //课程 具体信息 数组
            courseTimeDict = resultArray[4];
            
            NSError *error;
            NSData *jsonData =[NSJSONSerialization dataWithJSONObject:courseTimeDict  options:kNilOptions error:&error];
            thirdJsonString =[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            textField.text = @"已设置";
        }];

        
        [self.navigationController pushViewController:courseManagerCourseSettingVC animated:YES];
        [self.view endEditing:YES];

    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField; {
    [textField resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark *******************  获取数据  **********************
//获取 数据
- (void)fetchNetData{
    //获取 三级 类目 的数据
    [self fetchCourseInfo];

    //获取 该学校 老师 列表
    [self fetchSchoolTeacherInfo];
}

#pragma mark - ================ 获取 三级 类目 的数据 ==============
- (void)fetchCourseInfo{

    XXECourseManagerCourseCategoryApi *courseManagerCourseCategoryApi = [[XXECourseManagerCourseCategoryApi alloc] initWithXid:parameterXid user_id:parameterUser_Id];
    
    [courseManagerCourseCategoryApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        classGroupArray1 = [[NSMutableArray alloc] init];
        classGroupDic2 = [[NSMutableDictionary alloc] init];
        classGroupDic3 = [[NSMutableDictionary alloc] init];
//                NSLog(@"111   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            NSArray *classModelArr1 = [[NSArray alloc] init];
            classModelArr1 = [XXECourseManagerClassModel1 parseResondsData:request.responseJSONObject[@"data"][@"class1_group"]];
            [classGroupArray1 addObjectsFromArray:classModelArr1];
            
            classGroupDic2 = request.responseJSONObject[@"data"][@"class2_group"];
            classGroupDic3 = request.responseJSONObject[@"data"][@"class3_group"];
            
        }else{
            
        }
        [self updateSubjectCommbox1];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}

- (void)updateSubjectCommbox1{
    //课程 更新 第一个 下拉框 的数据
    NSMutableArray *classNameArray1 = [[NSMutableArray alloc] init];
    for (XXECourseManagerClassModel1 *model1 in classGroupArray1) {
        [classNameArray1 addObject:model1.name];
    }
    subjectCommbox1.dataArray = classNameArray1;
    [subjectCommbox1.listTableView reloadData];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    switch ([[NSString stringWithFormat:@"%@", context] integerValue]) {
        case 1:
        {
            //class1
            if ([keyPath isEqualToString:@"text"]) {
                NSString * newName=[change objectForKey:@"new"];
                if (newName) {
                    className1 = newName;
                    //更新 class2 数据
                    [self updateSubjectCommbox2];
                }
            }else{
                
            }
            
        }
            break;
        case 2:
        {
            //class2
            if (subjectCommbox1.textField.text) {
                if ([keyPath isEqualToString:@"text"]) {
                    NSString * newName=[change objectForKey:@"new"];
                    if (newName) {
                        className2 = newName;
                    }
                    //更新 class3 数据
                    [self updateSubjectCommbox3];
                }
            }else{
                [self showHudWithString:@"请先完善“前面”信息" forSecond:1.5];
            }
            
        }
            break;
        case 3:
        {
            //class3
            if ([keyPath isEqualToString:@"text"]) {
                NSString * newName=[change objectForKey:@"new"];
                if (newName) {
                    for (XXECourseManagerClassModel3 *model3 in classGroupArray3) {
                        if ([model3.name isEqualToString:newName]) {
                            classID3 = model3.class3;
                        }
                    }
                    
                }
            }
            
            
        }
            break;
          case 4:
        {
            //老师 列表
            if ([keyPath isEqualToString:@"text"]) {
                NSString * newName=[change objectForKey:@"new"];
                if (newName) {
                    NSInteger index = [teacherNameArray indexOfObject:newName];
                    XXECourseManagerSchoolTeacherModel *model = teacherArray[index];
                    teacherId = model.teacherId;
                    
                }
            
            }else{
                [self showHudWithString:@"请先完善“前面”信息" forSecond:1.5];
            }
    }
            default:
            break;
    }
    
    
}

- (void)updateSubjectCommbox2{
    
    subjectCommbox2.textField.text = @"";
    classGroupArray2 = [[NSMutableArray alloc] init];
    for (XXECourseManagerClassModel1 *model1 in classGroupArray1) {
        if ([model1.name isEqualToString:subjectCommbox1.textField.text]) {
            classID1 = model1.class1;
            
            NSArray *classModelArr2 = [[NSArray alloc] init];
            classModelArr2 = [XXECourseManagerClassModel2 parseResondsData:classGroupDic2[classID1]];
            [classGroupArray2 addObjectsFromArray:classModelArr2];
            
            //课程 更新 第二个 下拉框 的数据
            NSMutableArray *classNameArray2 = [[NSMutableArray alloc] init];
            for (XXECourseManagerClassModel2 *model2 in classGroupArray2) {
                [classNameArray2 addObject:model2.name];
            }
            subjectCommbox2.dataArray = classNameArray2;
            [subjectCommbox2.listTableView reloadData];
        }
    }
    
}

//
- (void)updateSubjectCommbox3{
    subjectCommbox3.textField.text = @"";
    classGroupArray3 = [[NSMutableArray alloc] init];
    for (XXECourseManagerClassModel2 *model2 in classGroupArray2) {
        if ([model2.name isEqualToString:subjectCommbox2.textField.text]) {
            classID2 = model2.class2;
            
            NSArray *classModelArr3 = [[NSArray alloc] init];
            classModelArr3 = [XXECourseManagerClassModel3 parseResondsData:classGroupDic3[classID2]];
            [classGroupArray3 addObjectsFromArray:classModelArr3];
            
            //课程 更新 第二个 下拉框 的数据
            NSMutableArray *classNameArray3 = [[NSMutableArray alloc] init];
            for (XXECourseManagerClassModel3 *model3 in classGroupArray3) {
                [classNameArray3 addObject:model3.name];
            }
            subjectCommbox3.dataArray = classNameArray3;
            [subjectCommbox3.listTableView reloadData];
        }
    }
}


- (void)commboxAction:(NSNotification *)notif{
    switch ([notif.object integerValue]) {
        case 11:
        {
            [subjectCommbox1 removeFromSuperview];
            [bgScrollView addSubview:subjectCommboxBgView1];
            [bgScrollView addSubview:subjectCommbox1];
            
        }
            break;
        case 12:
        {
            
            [subjectCommbox2 removeFromSuperview];
            [bgScrollView addSubview:subjectCommboxBgView2];
            [bgScrollView addSubview:subjectCommbox2];
        }
            break;
        case 13:
        {
            
            [subjectCommbox3 removeFromSuperview];
            [bgScrollView addSubview:subjectCommboxBgView3];
            [bgScrollView addSubview:subjectCommbox3];
        }
            break;
        case 14:
        {
            
            [teacherNameCommbox removeFromSuperview];
            [bgScrollView addSubview:teacherNameCommboxBgView];
            [bgScrollView addSubview:teacherNameCommbox];
        }
            break;
        case 15:
        {
            
            [insertClassCommbox removeFromSuperview];
            [bgScrollView addSubview:insertClassCommboxBgView];
            [bgScrollView addSubview:insertClassCommbox];
        }
            break;
        case 16:
        {
            
            [exitClassCommbox removeFromSuperview];
            [bgScrollView addSubview:exitClassCommboxBgView];
            [bgScrollView addSubview:exitClassCommbox];
        }
            break;
        case 17:
        {
            
            [deductXingIconCommbox removeFromSuperview];
            [bgScrollView addSubview:deductXingIconCommboxBgView];
            [bgScrollView addSubview:deductXingIconCommbox];
        }
            break;
        default:
            break;
    }
    
}


- (void)commboxHidden1{
    [subjectCommboxBgView1 removeFromSuperview];
    [subjectCommbox1 setShowList:NO];
    subjectCommbox1.listTableView.hidden = YES;
}

- (void)commboxHidden2{
    [subjectCommboxBgView2 removeFromSuperview];
    [subjectCommbox2 setShowList:NO];
    subjectCommbox2.listTableView.hidden = YES;
}

- (void)commboxHidden3{
    [subjectCommboxBgView3 removeFromSuperview];
    [subjectCommbox3 setShowList:NO];
    subjectCommbox3.listTableView.hidden = YES;
}

- (void)commboxHidden4{
    [teacherNameCommboxBgView removeFromSuperview];
    [teacherNameCommbox setShowList:NO];
    teacherNameCommbox.listTableView.hidden = YES;
}

- (void)commboxHidden5{
    [insertClassCommboxBgView removeFromSuperview];
    [insertClassCommbox setShowList:NO];
    insertClassCommbox.listTableView.hidden = YES;
}


- (void)commboxHidden6{
    [exitClassCommboxBgView removeFromSuperview];
    [exitClassCommbox setShowList:NO];
    exitClassCommbox.listTableView.hidden = YES;
}


- (void)commboxHidden7{
    [deductXingIconCommboxBgView removeFromSuperview];
    [deductXingIconCommbox setShowList:NO];
    deductXingIconCommbox.listTableView.hidden = YES;
}



#pragma mark - ================ 获取 该学校 老师 列表 ==============
- (void)fetchSchoolTeacherInfo{

    XXECourseManagerSchoolTeacherListApi *courseManagerSchoolTeacherListApi = [[XXECourseManagerSchoolTeacherListApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:_schoolId];
    [courseManagerSchoolTeacherListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        teacherArray = [[NSMutableArray alloc]init];
//        NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSArray *modelArray = [XXECourseManagerSchoolTeacherModel parseResondsData:request.responseJSONObject[@"data"]];
            
            [teacherArray addObjectsFromArray:modelArray];
        }else{
            
        }
        
        teacherNameArray = [[NSMutableArray alloc] init];
        for (XXECourseManagerSchoolTeacherModel *model in teacherArray) {
            [teacherNameArray addObject:model.tname];
        }
        
        teacherNameCommbox.dataArray = teacherNameArray;
        [teacherNameCommbox.listTableView reloadData];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];


}


#pragma mark *******************  保存草稿  **********************
//保存草稿
- (void)saveDraftsBtn:(UIButton *)sender {
    if (![publish_type isEqualToString:@""]) {
        publish_type = @"";
    }
    
    publish_type = @"2";
    [self judgeCourseTextInfo1];

}



#pragma mark *******************  提交审核  **********************
//提交审核
- (void)releaseBtn:(UIButton *)button{
    if (![publish_type isEqualToString:@""]) {
        publish_type = @"";
    }
    
    publish_type = @"1";
    [self judgeCourseTextInfo2];

}

- (void)judgeCourseTextInfo1{

        if ([insertClassCommbox.textField.text isEqualToString:@"是"]){
            //(传数字,整型 1:允许 0:不允许)
            insertFlagStr = @"1";
            
        }else if ([insertClassCommbox.textField.text isEqualToString:@"否"]){
            insertFlagStr = @"0";
        }
        
        if ([exitClassCommbox.textField.text isEqualToString:@"是"]){
            exitFlagStr = @"1";
            
        }else if ([exitClassCommbox.textField.text isEqualToString:@"否"]){
            exitFlagStr = @"0";
            
        }
        
        if (![deductXingIconCommbox.textField.text isEqualToString:@"不允许猩币抵扣"]){
            deductFlagStr = @"1";
            
        }else if ([deductXingIconCommbox.textField.text isEqualToString:@"不允许猩币抵扣"]){
            deductFlagStr = @"0";
        }
        
        //判断 课程 图片
        
        if (pickerView.data.count == 1) {
            //没有图片 直接 上传文字
            [self submitIssueTextInfo];
            
            [self uploadCourseAllInfo];
        }else{
            //有图片 先 上传 图片,再上传文字
            [self judgeCoursePicInfo];
        }

}



- (void)judgeCourseTextInfo2{

    if ([subjectCommbox1.textField.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善课程类型" forSecond:1.5];
        
    }else if ([subjectCommbox2.textField.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善课程类型" forSecond:1.5];
        
    }else if ([subjectCommbox3.textField.text isEqualToString:@""]){
        [self showHudWithString:@"请完善课程类型" forSecond:1.5];
        
    }else if ([arrangeText.text isEqualToString:@""]){
        [self showHudWithString:@"请完善课程名称" forSecond:1.5];
        
    }else if ([teacherNameCommbox.textField.text isEqualToString:@""]){
        [self showHudWithString:@"请完善老师名称" forSecond:1.5];
        
    }else if ([studentCountText.text isEqualToString:@""]){
        [self showHudWithString:@"请完善招生人数" forSecond:1.5];
        
    }else if ([studentAgeText1.text isEqualToString:@""]){
        [self showHudWithString:@"请完善招生最小年龄" forSecond:1.5];
        
    }else if ([studentAgeText2.text isEqualToString:@""]){
        [self showHudWithString:@"请完善招生最大年龄" forSecond:1.5];
        
    }else if ([targetText.text isEqualToString:@""]){
        //        [self showHudWithString:@"请完善教学目标" forSecond:1.5];
        
    }else if (![timeText.text isEqualToString:@"已设置"]){
        [self showHudWithString:@"请完善课程设置" forSecond:1.5];
        
    }else if ([addressText.text isEqualToString:@""]){
        [self showHudWithString:@"请完善上课地址" forSecond:1.5];
        
    }else if ([insertClassCommbox.textField.text isEqualToString:@""]){
        [self showHudWithString:@"请完善插班规则" forSecond:1.5];
        
    }else if ([exitClassCommbox.textField.text isEqualToString:@""]){
        [self showHudWithString:@"请完善退班规则" forSecond:1.5];
        
    }else if ([oldMoneyText.text isEqualToString:@""]){
        [self showHudWithString:@"请完善课程原价" forSecond:1.5];
        
    }else if ([newMoneyText.text isEqualToString:@""]){
        [self showHudWithString:@"请完善课程现价" forSecond:1.5];
        
    }else if ([deductXingIconCommbox.textField.text isEqualToString:@""]){
        [self showHudWithString:@"请完善是否允许猩币抵扣" forSecond:1.5];
        
    }else {
        
        if ([insertClassCommbox.textField.text isEqualToString:@"是"]){
            //(传数字,整型 1:允许 0:不允许)
            insertFlagStr = @"1";
            
        }else if ([insertClassCommbox.textField.text isEqualToString:@"否"]){
            insertFlagStr = @"0";
        }
        
        if ([exitClassCommbox.textField.text isEqualToString:@"是"]){
            exitFlagStr = @"1";
            
        }else if ([exitClassCommbox.textField.text isEqualToString:@"否"]){
            exitFlagStr = @"0";
            
        }
        
        if (![deductXingIconCommbox.textField.text isEqualToString:@"不允许猩币抵扣"]){
            deductFlagStr = @"1";
            
        }else if ([deductXingIconCommbox.textField.text isEqualToString:@"不允许猩币抵扣"]){
            deductFlagStr = @"0";
        }
        
        //判断 课程 图片
        
        if (pickerView.data.count == 1) {
            [self showHudWithString:@"请完善图片信息" forSecond:1.5];
        }else{
            [self judgeCoursePicInfo];
        }
    }
}


- (void)judgeCoursePicInfo{
    // pickerView.data  里面 有一张加号占位图,所有 个数最少有 1 张
    //如果 count == 1  -> 没有 上传 图片
    coursePicArray = [[NSMutableArray alloc] init];
    
    if (pickerView.data.count > 1) {
        for (int i = 0; i < pickerView.data.count - 1; i++) {
            FSImageModel *mdoel = pickerView.data[i];
            UIImage *image1 = [UIImage imageWithData:mdoel.data];
            [coursePicArray addObject:image1];
        }
        [self showHudWithString:@"正在上传......"];
        //先 提交 图片 信息
        [self uploadCoursePicInfo];
    }else{
        [self showHudWithString:@"请完善课程图片信息" forSecond:1.5];
    }
    
}


- (void)uploadCoursePicInfo{
    
    NSString *url = @"http://www.xingxingedu.cn/Global/uploadFile";
    //page_origin  29	//课程详情
    NSDictionary *parameter = @{
                                @"appkey":APPKEY,
                                @"backtype":BACKTYPE,
                                @"xid":parameterXid,
                                @"user_id":parameterUser_Id,
                                @"user_type":USER_TYPE,
                                @"file_type":@"1",
                                @"page_origin":@"29",
                                @"upload_format":@"2"
                                };
    //    NSLog(@"传参 --  %@", parameter);
    AFHTTPRequestOperationManager *mgr =[AFHTTPRequestOperationManager manager];
    [mgr POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i< coursePicArray.count; i++) {
            NSData *data = UIImageJPEGRepresentation(coursePicArray[i], 0.5);
            NSString *name = [NSString stringWithFormat:@"%d.jpeg",i];
            NSString *formKey = [NSString stringWithFormat:@"file%d",i];
            NSString *type = @"image/jpeg";
            [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
        }
        
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict =responseObject;
//    NSLog(@"图片 <<<<<<<<<<<<<<<<<<<<<<<<<<<%@",dict);
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            NSArray *picArray = [[NSArray alloc] init];
            picArray = dict[@"data"];
            if (picArray.count == 1) {
                url_groupStr = picArray[0];
            }else if (picArray.count > 1){
                
                NSMutableString *tidStr = [NSMutableString string];
                
                for (int j = 0; j < picArray.count; j ++) {
                    NSString *str = picArray[j];
                    
                    if (j != picArray.count - 1) {
                        [tidStr appendFormat:@"%@,", str];
                    }else{
                        [tidStr appendFormat:@"%@", str];
                    }
                }
                
                url_groupStr = tidStr;
            }
        }
     [self submitIssueTextInfo];
        
     [self uploadCourseAllInfo];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

//提交 文字 信息
- (void)submitIssueTextInfo{
    //准备 第二部分 传参 信息
    /*
     class1 		//类目1 id
     class2 		//类目2 id
     class3 		//类目3 id
     course_name	//课程名 (请限制10个中文字的长度)
     need_num 	//招生人数 (传数字,整型)
     age_up 		//年龄最小 (传数字,整型)
     age_down 	//年龄最大 (传数字,整型)
     teach_goal 	//教学目标  (可选传参)
     week_times 	//一周几堂课 (传数字,整型)
     course_hour 	//课时(传数字,整型,单位分钟)
     course_start_tm	//开学时间 (格式:2016-08-01)
     course_end_tm 	//学期结束时间(格式:2016-10-01)
     address 	//上课地址
     middle_in_rule	//允许插班 (传数字,整型 1:允许 0:不允许)
     quit_rule	//允许退课 (传数字,整型 1:允许 0:不允许)
     coin		//允许猩币抵扣 (传数字,整型 1:允许 0:不允许)
     original_price	//原价,必须整型
     now_price	//现价,必须整型
     details		//课程详情 (可选传参)
     teacher		//授课老师id,多个逗号隔开,允许空(当这个学校还没有老师入住的时候)
     url_group       //课程图片url集合,多个逗号隔开
     */
        
    if (![arrangeText.text isEqualToString:@""]) {
        course_name = arrangeText.text;
    }
    
    if (![studentCountText.text isEqualToString:@""]) {
        need_num = studentCountText.text;
    }

    if (![studentAgeText1.text isEqualToString:@""]) {
        age_up = studentAgeText1.text;
    }

    if (![studentAgeText2.text isEqualToString:@""]) {
        age_down = studentAgeText2.text;
    }

    if (![targetText.text isEqualToString:@""]) {
        teach_goal = targetText.text;
    }

    if (![addressText.text isEqualToString:@""]) {
        address = addressText.text;
    }

    if (![oldMoneyText.text isEqualToString:@""]) {
        original_price = oldMoneyText.text;
    }

    if (![newMoneyText.text isEqualToString:@""]) {
        now_price = newMoneyText.text;
    }

    if (![courseDetailTextView.text isEqualToString:@""]) {
        details = courseDetailTextView.text;
    }

    NSDictionary *secondDic = [[NSDictionary alloc] init];
    secondDic = @{
                  @"class1":classID1,
                  @"class2":classID2,
                  @"class3":classID3,
                  @"course_name":course_name,
                  @"need_num":need_num,
                  @"age_up":age_up,
                  @"age_down":age_down,
                  @"teach_goal":teach_goal,
                  @"week_times":timesStr,
                  @"course_hour":lengthStr,
                  @"course_start_tm":startTimeStr,
                  @"course_end_tm":endTimeStr,
                  @"address":address,
                  @"middle_in_rule":insertFlagStr,
                  @"quit_rule":exitFlagStr,
                  @"coin":deductFlagStr,
                  @"original_price":original_price,
                  @"now_price":now_price,
                  @"details":details,
                  @"teacher":teacherId,
                  @"url_group":url_groupStr
                  };
    
    NSError *error;
    NSData *jsonData =[NSJSONSerialization dataWithJSONObject:secondDic  options:kNilOptions error:&error];
    secondJsonString =[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

}

//1:发布课程
//2:发布时选择保存草稿箱
//发布 课程
- (void)uploadCourseAllInfo{
    
//    NSLog(@"hhh %@", publish_type);
    XXECourseManagerCourseReleaseApi *courseManagerCourseReleaseApi = [[XXECourseManagerCourseReleaseApi alloc] initWithXid:parameterXid user_id:parameterUser_Id position:_position school_id:_schoolId publish_type:publish_type course_id:@"" course_info:secondJsonString course_tm:thirdJsonString];
    
    [courseManagerCourseReleaseApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//        NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"发布成功!" forSecond:1.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showHudWithString:@"发布失败!" forSecond:1.5];
    }];


}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [subjectCommbox1.textField removeObserver:self forKeyPath:@"text"];
    
    [subjectCommbox2.textField removeObserver:self forKeyPath:@"text"];
    
    [subjectCommbox3.textField removeObserver:self forKeyPath:@"text"];
    
    [teacherNameCommbox.textField removeObserver:self forKeyPath:@"text"];
    
}

@end
