
//
//  XXECourseManagerTimeSettingModifyViewController.m
//  teacher
//
//  Created by Mac on 16/9/27.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECourseManagerTimeSettingModifyViewController.h"
#import "HZQDatePickerView.h"


@interface XXECourseManagerTimeSettingModifyViewController ()<HZQDatePickerViewDelegate,UITextFieldDelegate, UITextViewDelegate>
{
    UIView *startBgView;
    UIView *endBgView;
    UIView *courseSettingBgView;
    UIView *courseContentBgView;
    
    UITextField *startTextField;
    UITextField *endTextField;
    
    //一周几次 下拉框 所选择的 选项 下标
    NSInteger indexNum;
    
    
    UITextField *timesTextField;
    
    WJCommboxView *lengthCommbox;
    
    UIView *timesCommboxBgView1;
    UIView *lengthCommboxBgView2;
    
    //一周 7次 下拉框
    WJCommboxView *courseTimeCommbox11;
    WJCommboxView *courseTimeCommbox12;
    
    WJCommboxView *courseTimeCommbox21;
    WJCommboxView *courseTimeCommbox22;
    
    WJCommboxView *courseTimeCommbox31;
    WJCommboxView *courseTimeCommbox32;
    
    WJCommboxView *courseTimeCommbox41;
    WJCommboxView *courseTimeCommbox42;
    
    WJCommboxView *courseTimeCommbox51;
    WJCommboxView *courseTimeCommbox52;
    
    WJCommboxView *courseTimeCommbox61;
    WJCommboxView *courseTimeCommbox62;
    
    WJCommboxView *courseTimeCommbox71;
    WJCommboxView *courseTimeCommbox72;
    
    HZQDatePickerView *_pikerView;
    //上课 次数 数组
    NSArray *timesArray;
    //上课 时长 数组
    NSArray *lengthsArray;
    
    UIButton *certainBtn;
    
    //开始 日期
    NSString *startTimeStr;
    //结束 日期
    NSString *endTimeStr;
    //一周 几次
    NSString *timesStr;
    //课时 多少分钟
    NSString *lengthStr;
    //具体 上课 时间  数组
    //    NSMutableArray *courseTimeArray;
    NSDictionary *courseAllInfoDic;
    
    //一条 课程 时间 数组
    NSDictionary *courseInfoDic1;
    NSDictionary *courseInfoDic2;
    NSDictionary *courseInfoDic3;
    NSDictionary *courseInfoDic4;
    NSDictionary *courseInfoDic5;
    NSDictionary *courseInfoDic6;
    NSDictionary *courseInfoDic7;
    
    //点击 确定  要返回 的数组
    NSMutableArray *resultArray;
    
    //
    NSArray *courseTimeArray00;
    //
    NSArray *courseTimeArray01;
    

}


@end

@implementation XXECourseManagerTimeSettingModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = XXEBackgroundColor;
    courseTimeArray00 = [[NSArray alloc]initWithObjects:@"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", @"星期日", nil];
    
    courseTimeArray01 = [[NSArray alloc]initWithObjects:@"8:00", @"9:00", @"10:00", @"11:00", @"12:00", @"13:00", @"14:00", @"15:00", @"16:00", @"17:00", @"18:00", @"19:00", @"20:00", @"21:00", @"22:00", @"23:00", nil];
    
    //开始
    [self createStartBgView];
    
    //结束
    [self createEndBgView];
    
    //课程 安排
    [self createCourseSettingBgView];
    
    //更新 下拉框 数据
    [self updateTextFieldInfo];
    
}

#pragma mark - ----------  开始 bgview -----------------
// 开始 view
- (void)createStartBgView{
    startBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    startBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:startBgView];
    UILabel *startLabel = [UILabel createLabelWithFrame:CGRectMake(20 * kScreenRatioWidth, 10 , 70 * kScreenRatioWidth, 20) Font:14 * kScreenRatioWidth Text:@"开始日期:"];
    startTextField = [[UITextField alloc] initWithFrame:CGRectMake(90 * kScreenRatioWidth, 5, 260 * kScreenRatioWidth, 30)];
    startTextField.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    CGRect rect1 = startTextField.frame;
    rect1.size.height = 30;
    startTextField.frame = rect1;
    startTextField.delegate = self;
    startTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    [startBgView addSubview:startLabel];
    [startBgView addSubview:startTextField];
    
}

#pragma mark - ----------  结束 bgview -----------------
// 结束 view
- (void)createEndBgView{
    endBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, 40)];
    endBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:endBgView];
    UILabel *endLabel = [UILabel createLabelWithFrame:CGRectMake(20 * kScreenRatioWidth, 10, 70 * kScreenRatioWidth, 20) Font:14 * kScreenRatioWidth Text:@"结束日期:"];
    endTextField = [[UITextField alloc] initWithFrame:CGRectMake(90 * kScreenRatioWidth, 5, 260 * kScreenRatioWidth, 30)];
    endTextField.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    endTextField.borderStyle = UITextBorderStyleRoundedRect;
    CGRect rect2 = endTextField.frame;
    rect2.size.height = 30;
    endTextField.frame = rect2;
    endTextField.delegate = self;
    
    [endBgView addSubview:endLabel];
    [endBgView addSubview:endTextField];
    
}

#pragma mark - ----------  课程安排 bgview -----------------
// 课程安排  view
- (void)createCourseSettingBgView{
    courseSettingBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, KScreenWidth, 40)];
    courseSettingBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:courseSettingBgView];
    UILabel *courseLabel = [UILabel createLabelWithFrame:CGRectMake(20  *kScreenRatioWidth, 10, 100 * kScreenRatioWidth, 20) Font:14 * kScreenRatioWidth Text:@"课程安排:"];
    
    UILabel *lengthLabel = [UILabel createLabelWithFrame:CGRectMake(220 * kScreenRatioWidth, 10, 40 * kScreenRatioWidth, 20) Font:14 * kScreenRatioWidth Text:@"课时:"];
    
    timesTextField = [[UITextField alloc] initWithFrame:CGRectMake(90 * kScreenRatioWidth, courseSettingBgView.frame.origin.y + 5, 120 * kScreenRatioWidth, 30)];
    timesArray = [[NSArray alloc]initWithObjects:@"一周1节课", @"一周2节课", @"一周3节课", @"一周4节课", @"一周5节课", @"一周6节课", @"一周7节课", nil];
    timesTextField.tag = 11;
    if ([_week_times integerValue] >= 1) {
      timesTextField.text = timesArray[[_week_times integerValue] - 1];
    }
    
    timesTextField.textColor = [UIColor lightGrayColor];
    timesTextField.enabled = NO;
    timesTextField.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    timesTextField.delegate = self;
    [timesTextField addTarget:self action:@selector(timesTextFieldCick) forControlEvents:UIControlEventTouchUpInside];
    
    //创建 具体 课程 时间 表
    if ([_week_times integerValue] >= 0) {
        [self updateCourseContentBgViewInfo:[_week_times integerValue]];
    }
    
    //-------------------- subjectCommbox2 ---------------
    lengthCommbox = [[WJCommboxView alloc] initWithFrame:CGRectMake(260 * kScreenRatioWidth, courseSettingBgView.frame.origin.y + 5, 90 * kScreenRatioWidth, 30)];
    lengthsArray = [[NSArray alloc]initWithObjects:@"30分钟", @"45分钟", @"60分钟", @"90分钟", @"120分钟", @"180分钟", nil];
    lengthCommbox.dataArray = lengthsArray;
    CGRect rect2 = lengthCommbox.textField.frame;
    rect2.size.height = 30;
    lengthCommbox.textField.frame = rect2;
    
    lengthCommbox.textField.tag = 12;
    lengthCommbox.textField.placeholder = @"";
    lengthCommbox.textField.textAlignment = NSTextAlignmentLeft;
    lengthCommbox.textField.borderStyle=UITextBorderStyleRoundedRect;
    
    lengthCommboxBgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kWidth,kHeight+300)];
    lengthCommboxBgView2.backgroundColor = [UIColor clearColor];
    lengthCommboxBgView2.alpha = 0.5;
    UITapGestureRecognizer *singleTouch2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden2)];
    [lengthCommboxBgView2 addGestureRecognizer:singleTouch2];
    
    [courseSettingBgView addSubview:courseLabel];
    [courseSettingBgView addSubview:lengthLabel];
    [self.view addSubview:timesTextField];
    [self.view addSubview:lengthCommbox];
    
}


- (void)timesTextFieldCick{

    [self showHudWithString:@"每周上课次数不可更改!" forSecond:1.5];
}


#pragma mark - ----------  课程时间表 bgview -----------------
// 课程时间表  view
- (void)createCourseContentBgView{
    courseContentBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, KScreenWidth, KScreenHeight - 300)];
    courseContentBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:courseContentBgView];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == startTextField) {
        [self setupDateView:DateTypeOfStart];
        
    }else if (textField == endTextField) {
        [self setupDateView:DateTypeOfEnd];
    }
    [self.view endEditing:YES];
}

- (void)setupDateView:(DateType)type {
    
    _pikerView = [HZQDatePickerView instanceDatePickerView];
    _pikerView.frame = CGRectMake(0, 0, kWidth  , kHeight + 20);
    [_pikerView setBackgroundColor:[UIColor clearColor]];
    _pikerView.delegate = self;
    _pikerView.type = type;
    
    // 今天开始往后的日期
    [_pikerView.datePickerView
     setMinimumDate:[NSDate date]];
    // 在今天之前的日期
    //    [_pikerView.datePickerView setMaximumDate:[NSDate date]];
    [self.view addSubview:_pikerView];
    
}

- (void)getSelectDate:(NSString *)date type:(DateType)type {
    
    switch (type) {
        case DateTypeOfStart:{
            NSArray *array = [date componentsSeparatedByString:@" "];
            startTextField.text = array[0];
            break;
            
        }
        case DateTypeOfEnd:{
            NSArray *array = [date componentsSeparatedByString:@" "];
            endTextField.text = array[0];
            break;
            
        }
        default:
            break;
    }
}


#pragma mark ------------- 确认 按钮 ---------------
- (void)createCertainButton{
    
    CGFloat buttonWtdth = 325 * kScreenRatioWidth;
    CGFloat buttonHeight = 42 * kScreenRatioHeight;
    
    certainBtn = [UIButton createButtonWithFrame:CGRectMake((KScreenWidth - buttonWtdth) / 2, courseContentBgView.frame.origin.y + courseContentBgView.frame.size.height + 20, buttonWtdth, buttonHeight) backGruondImageName:@"login_green" Target:self Action:@selector(certainBtnClick) Title:@"确定"];
    [certainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:certainBtn];
    
}

- (void)commboxAction:(NSNotification *)notif{
    switch ([notif.object integerValue]) {
        case 12:
        {
            
            [lengthCommbox removeFromSuperview];
            [courseSettingBgView addSubview:lengthCommboxBgView2];
            [courseSettingBgView addSubview:lengthCommbox];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)commboxHidden2{
    [lengthCommboxBgView2 removeFromSuperview];
    [lengthCommbox setShowList:NO];
    lengthCommbox.listTableView.hidden = YES;
}


- (void)updateCourseContentBgViewInfo:(NSInteger)index{
    if (courseContentBgView) {
        [courseContentBgView removeFromSuperview];
    }
    
    if (certainBtn) {
        [certainBtn removeFromSuperview];
    }
    courseContentBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, KScreenWidth, KScreenHeight - 300)];
    courseContentBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:courseContentBgView];
    //    NSLog(@"%ld", index);
    
    //    courseTimeArray = [[NSMutableArray alloc] init];
    courseAllInfoDic = [[NSDictionary alloc] init];
    
    for (int i = 1; i <= index; i++) {
        
        //课程 安排
        UILabel *label = [UILabel createLabelWithFrame:CGRectMake(20 * kScreenRatioWidth, 10 + (5 + 40) * (i - 1), 100 * kScreenRatioWidth, 20) Font:14 * kScreenRatioWidth Text:@"上课时间:"];
        [courseContentBgView addSubview:label];
        
        //上课时间  下拉框
        if (i == 1) {
            
            [self createCourseTimeCommbox1:i];
            
        }else if (i == 2) {
            [self createCourseTimeCommbox2:i];
            
        }else if (i == 3) {
            [self createCourseTimeCommbox3:i];
            
        }else if (i == 4) {
            [self createCourseTimeCommbox4:i];
            
        }else if (i == 5) {
            [self createCourseTimeCommbox5:i];
            
        }else if (i == 6) {
            [self createCourseTimeCommbox6:i];
            
        }else if (i == 7) {
            [self createCourseTimeCommbox7:i];
            
        }
        
    }
    
    [self createCertainButton];
}

//创建 第1条 课程 时间 数据
- (void)createCourseTimeCommbox1:(NSInteger)k{
    courseTimeCommbox11 = [[WJCommboxView alloc] initWithFrame:CGRectMake(90 * kScreenRatioWidth, 5 + (5 + 40) * (k - 1), 120 * kScreenRatioWidth, 30)];
    
    courseTimeCommbox11.dataArray = courseTimeArray00;
    CGRect rect1 = courseTimeCommbox11.textField.frame;
    rect1.size.height = 30;
    courseTimeCommbox11.textField.frame = rect1;
    
    //    courseTimeCommbox11.textField.tag = 100 + k;
    courseTimeCommbox11.textField.placeholder = @"";
    courseTimeCommbox11.textField.textAlignment = NSTextAlignmentLeft;
    courseTimeCommbox11.textField.borderStyle=UITextBorderStyleRoundedRect;
    [courseContentBgView addSubview:courseTimeCommbox11];
    
    //-------------------- subjectCommbox2 ---------------
    courseTimeCommbox12 = [[WJCommboxView alloc] initWithFrame:CGRectMake(260 * kScreenRatioWidth, 5 + (5 + 40) * (k - 1), 90 * kScreenRatioWidth, 30)];
    
    courseTimeCommbox12.dataArray = courseTimeArray01;
    CGRect rect2 = courseTimeCommbox12.textField.frame;
    rect2.size.height = 30;
    courseTimeCommbox12.textField.frame = rect2;
    
    //    courseTimeCommbox12.textField.tag = 1000 + k;
    courseTimeCommbox12.textField.placeholder = @"";
    courseTimeCommbox12.textField.textAlignment = NSTextAlignmentLeft;
    courseTimeCommbox12.textField.borderStyle=UITextBorderStyleRoundedRect;
    
    [courseContentBgView addSubview:courseTimeCommbox12];
}

//创建 第2条 课程 时间 数据
- (void)createCourseTimeCommbox2:(NSInteger)k{
    courseTimeCommbox21 = [[WJCommboxView alloc] initWithFrame:CGRectMake(90 * kScreenRatioWidth, 5 + (5 + 40) * (k - 1), 120 * kScreenRatioWidth, 30)];
    
    courseTimeCommbox21.dataArray = courseTimeArray00;
    CGRect rect1 = courseTimeCommbox21.textField.frame;
    rect1.size.height = 30;
    courseTimeCommbox21.textField.frame = rect1;
    
    //    courseTimeCommbox21.textField.tag = 100 + k;
    courseTimeCommbox21.textField.placeholder = @"";
    courseTimeCommbox21.textField.textAlignment = NSTextAlignmentLeft;
    courseTimeCommbox21.textField.borderStyle=UITextBorderStyleRoundedRect;
    [courseContentBgView addSubview:courseTimeCommbox21];
    
    //-------------------- subjectCommbox2 ---------------
    courseTimeCommbox22 = [[WJCommboxView alloc] initWithFrame:CGRectMake(260 * kScreenRatioWidth, 5 + (5 + 40) * (k - 1), 90 * kScreenRatioWidth, 30)];
    
    courseTimeCommbox22.dataArray = courseTimeArray01;
    CGRect rect2 = courseTimeCommbox22.textField.frame;
    rect2.size.height = 30;
    courseTimeCommbox22.textField.frame = rect2;
    
    //    courseTimeCommbox22.textField.tag = 1000 + k;
    courseTimeCommbox22.textField.placeholder = @"";
    courseTimeCommbox22.textField.textAlignment = NSTextAlignmentLeft;
    courseTimeCommbox22.textField.borderStyle=UITextBorderStyleRoundedRect;
    
    [courseContentBgView addSubview:courseTimeCommbox22];
}


//创建 第3条 课程 时间 数据
- (void)createCourseTimeCommbox3:(NSInteger)k{
    courseTimeCommbox31 = [[WJCommboxView alloc] initWithFrame:CGRectMake(90 * kScreenRatioWidth, 5 + (5 + 40) * (k - 1), 120 * kScreenRatioWidth, 30)];
    
    courseTimeCommbox31.dataArray = courseTimeArray00;
    CGRect rect1 = courseTimeCommbox31.textField.frame;
    rect1.size.height = 30;
    courseTimeCommbox31.textField.frame = rect1;
    
    //    courseTimeCommbox31.textField.tag = 100 + k;
    courseTimeCommbox31.textField.placeholder = @"";
    courseTimeCommbox31.textField.textAlignment = NSTextAlignmentLeft;
    courseTimeCommbox31.textField.borderStyle=UITextBorderStyleRoundedRect;
    [courseContentBgView addSubview:courseTimeCommbox31];
    
    //-------------------- subjectCommbox2 ---------------
    courseTimeCommbox32 = [[WJCommboxView alloc] initWithFrame:CGRectMake(260 * kScreenRatioWidth, 5 + (5 + 40) * (k - 1), 90 * kScreenRatioWidth, 30)];
    
    courseTimeCommbox32.dataArray = courseTimeArray01;
    CGRect rect2 = courseTimeCommbox32.textField.frame;
    rect2.size.height = 30;
    courseTimeCommbox32.textField.frame = rect2;
    
    //    courseTimeCommbox32.textField.tag = 1000 + k;
    courseTimeCommbox32.textField.placeholder = @"";
    courseTimeCommbox32.textField.textAlignment = NSTextAlignmentLeft;
    courseTimeCommbox32.textField.borderStyle=UITextBorderStyleRoundedRect;
    
    [courseContentBgView addSubview:courseTimeCommbox32];
}

//创建 第4条 课程 时间 数据
- (void)createCourseTimeCommbox4:(NSInteger)k{
    courseTimeCommbox41 = [[WJCommboxView alloc] initWithFrame:CGRectMake(90 * kScreenRatioWidth, 5 + (5 + 40) * (k - 1), 120 * kScreenRatioWidth, 30)];
    
    courseTimeCommbox41.dataArray = courseTimeArray00;
    CGRect rect1 = courseTimeCommbox41.textField.frame;
    rect1.size.height = 30;
    courseTimeCommbox41.textField.frame = rect1;
    
    //    courseTimeCommbox41.textField.tag = 100 + k;
    courseTimeCommbox41.textField.placeholder = @"";
    courseTimeCommbox41.textField.textAlignment = NSTextAlignmentLeft;
    courseTimeCommbox41.textField.borderStyle=UITextBorderStyleRoundedRect;
    [courseContentBgView addSubview:courseTimeCommbox41];
    
    //-------------------- subjectCommbox2 ---------------
    courseTimeCommbox42 = [[WJCommboxView alloc] initWithFrame:CGRectMake(260 * kScreenRatioWidth, 5 + (5 + 40) * (k - 1), 90 * kScreenRatioWidth, 30)];
    
    courseTimeCommbox42.dataArray = courseTimeArray01;
    CGRect rect2 = courseTimeCommbox42.textField.frame;
    rect2.size.height = 30;
    courseTimeCommbox42.textField.frame = rect2;
    
    //    courseTimeCommbox42.textField.tag = 1000 + k;
    courseTimeCommbox42.textField.placeholder = @"";
    courseTimeCommbox42.textField.textAlignment = NSTextAlignmentLeft;
    courseTimeCommbox42.textField.borderStyle=UITextBorderStyleRoundedRect;
    
    [courseContentBgView addSubview:courseTimeCommbox42];
}

//创建 第5条 课程 时间 数据
- (void)createCourseTimeCommbox5:(NSInteger)k{
    courseTimeCommbox51 = [[WJCommboxView alloc] initWithFrame:CGRectMake(90 * kScreenRatioWidth, 5 + (5 + 40) * (k - 1), 120 * kScreenRatioWidth, 30)];
    
    courseTimeCommbox51.dataArray = courseTimeArray00;
    CGRect rect1 = courseTimeCommbox51.textField.frame;
    rect1.size.height = 30;
    courseTimeCommbox51.textField.frame = rect1;
    
    //    courseTimeCommbox51.textField.tag = 100 + k;
    courseTimeCommbox51.textField.placeholder = @"";
    courseTimeCommbox51.textField.textAlignment = NSTextAlignmentLeft;
    courseTimeCommbox51.textField.borderStyle=UITextBorderStyleRoundedRect;
    [courseContentBgView addSubview:courseTimeCommbox51];
    
    //-------------------- subjectCommbox2 ---------------
    courseTimeCommbox52 = [[WJCommboxView alloc] initWithFrame:CGRectMake(260 * kScreenRatioWidth, 5 + (5 + 40) * (k - 1), 90  * kScreenRatioWidth, 30)];
    
    courseTimeCommbox52.dataArray = courseTimeArray01;
    CGRect rect2 = courseTimeCommbox52.textField.frame;
    rect2.size.height = 30;
    courseTimeCommbox52.textField.frame = rect2;
    
    //    courseTimeCommbox52.textField.tag = 1000 + k;
    courseTimeCommbox52.textField.placeholder = @"";
    courseTimeCommbox52.textField.textAlignment = NSTextAlignmentLeft;
    courseTimeCommbox52.textField.borderStyle=UITextBorderStyleRoundedRect;
    
    [courseContentBgView addSubview:courseTimeCommbox52];
}

//创建 第6条 课程 时间 数据
- (void)createCourseTimeCommbox6:(NSInteger)k{
    courseTimeCommbox61 = [[WJCommboxView alloc] initWithFrame:CGRectMake(90 * kScreenRatioWidth, 5 + (5 + 40) * (k - 1), 120  * kScreenRatioWidth, 30)];
    
    courseTimeCommbox61.dataArray = courseTimeArray00;
    CGRect rect1 = courseTimeCommbox11.textField.frame;
    rect1.size.height = 30;
    courseTimeCommbox61.textField.frame = rect1;
    
    courseTimeCommbox61.textField.placeholder = @"";
    courseTimeCommbox61.textField.textAlignment = NSTextAlignmentLeft;
    courseTimeCommbox61.textField.borderStyle=UITextBorderStyleRoundedRect;
    [courseContentBgView addSubview:courseTimeCommbox61];
    
    //-------------------- subjectCommbox2 ---------------
    courseTimeCommbox62 = [[WJCommboxView alloc] initWithFrame:CGRectMake(260 * kScreenRatioWidth, 5 + (5 + 40) * (k - 1), 90  *kScreenRatioWidth, 30)];
    
    courseTimeCommbox62.dataArray = courseTimeArray01;
    CGRect rect2 = courseTimeCommbox12.textField.frame;
    rect2.size.height = 30;
    courseTimeCommbox62.textField.frame = rect2;
    
    courseTimeCommbox62.textField.placeholder = @"";
    courseTimeCommbox62.textField.textAlignment = NSTextAlignmentLeft;
    courseTimeCommbox62.textField.borderStyle=UITextBorderStyleRoundedRect;
    
    [courseContentBgView addSubview:courseTimeCommbox62];
}

//创建 第7条 课程 时间 数据
- (void)createCourseTimeCommbox7:(NSInteger)k{
    courseTimeCommbox71 = [[WJCommboxView alloc] initWithFrame:CGRectMake(90 * kScreenRatioWidth, 5 + (5 + 40) * (k - 1), 120  * kScreenRatioWidth, 30)];
    
    courseTimeCommbox71.dataArray = courseTimeArray00;
    CGRect rect1 = courseTimeCommbox71.textField.frame;
    rect1.size.height = 30;
    courseTimeCommbox71.textField.frame = rect1;
    
    courseTimeCommbox71.textField.placeholder = @"";
    courseTimeCommbox71.textField.textAlignment = NSTextAlignmentLeft;
    courseTimeCommbox71.textField.borderStyle=UITextBorderStyleRoundedRect;
    [courseContentBgView addSubview:courseTimeCommbox71];
    
    //-------------------- subjectCommbox2 ---------------
    courseTimeCommbox72 = [[WJCommboxView alloc] initWithFrame:CGRectMake(260 * kScreenRatioWidth, 5 + (5 + 40) * (k - 1), 90  *kScreenRatioWidth, 30)];
    
    courseTimeCommbox72.dataArray = courseTimeArray01;
    CGRect rect2 = courseTimeCommbox72.textField.frame;
    rect2.size.height = 30;
    courseTimeCommbox72.textField.frame = rect2;
    
    courseTimeCommbox72.textField.placeholder = @"";
    courseTimeCommbox72.textField.textAlignment = NSTextAlignmentLeft;
    courseTimeCommbox72.textField.borderStyle=UITextBorderStyleRoundedRect;
    
    [courseContentBgView addSubview:courseTimeCommbox72];
}



- (void)certainBtnClick{
    
    //    NSLog(@"确定 ----------  ");
    courseAllInfoDic = [[NSDictionary alloc] init];
    
    if ([startTextField.text isEqualToString:@""]) {
        [self showHudWithString:@"请选择开始日期" forSecond:1.5];
    }else if ([endTextField.text isEqualToString:@""]){
        [self showHudWithString:@"请选择结束日期" forSecond:1.5];
    }else if ([lengthCommbox.textField.text isEqualToString:@""]){
        [self showHudWithString:@"请选择课时" forSecond:1.5];
    }else{
        
        if (indexNum == 0){
            //一周 1 次
            [self createCourseTimeArray1];
            
        }else if (indexNum == 1){
            //一周 2次
            [self createCourseTimeArray2];
            
        }else if (indexNum == 2){
            //一周 3次
            [self createCourseTimeArray3];
            
        }else if (indexNum == 3){
            //一周 4 次
            [self createCourseTimeArray4];
            
        }else if (indexNum == 4){
            //一周 5次
            [self createCourseTimeArray5];
            
        }else if (indexNum == 5){
            //一周 6次
            [self createCourseTimeArray6];
            
        }else if (indexNum == 6){
            //一周 7 次
            [self createCourseTimeArray7];
            
        }
        startTimeStr = startTextField.text;
        endTimeStr = endTextField.text;
        timesStr = [NSString stringWithFormat:@"%ld", indexNum + 1];
        //lengthsArray = [[NSArray alloc]initWithObjects:@"30分钟", @"45分钟", @"60分钟", @"90分钟", @"120分钟", @"180分钟", nil];
        if ([lengthCommbox.textField.text isEqualToString:@"30分钟"]) {
            lengthStr = @"30";
        }else if ([lengthCommbox.textField.text isEqualToString:@"45分钟"]){
            lengthStr = @"45";
        }else if ([lengthCommbox.textField.text isEqualToString:@"60分钟"]){
            lengthStr = @"60";
        }else if ([lengthCommbox.textField.text isEqualToString:@"90分钟"]){
            lengthStr = @"90";
        }else if ([lengthCommbox.textField.text isEqualToString:@"120分钟"]){
            lengthStr = @"120";
        }else if ([lengthCommbox.textField.text isEqualToString:@"180分钟"]){
            lengthStr = @"180";
        }
        
        resultArray = [[NSMutableArray alloc] initWithObjects:startTimeStr, endTimeStr, timesStr, lengthStr, courseAllInfoDic, nil];
        //        NSLog(@"--%@", resultArray);
        
        self.returnArrayBlock(resultArray);
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (void)returnStr:(ReturnArrayBlock)block{
    self.returnArrayBlock = block;
}


//一周 1 次
- (void)createCourseTimeArray1{
    if ([courseTimeCommbox11.textField.text isEqualToString:@""] || [courseTimeCommbox12.textField.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善上课时间" forSecond:1.5];
    }else{
        courseInfoDic1 = [[NSDictionary alloc] init];
        /*
         [0] = > array(
         course_tm_id	//上课时间id (当修改课程的时候才有此传参,这个值是修改的时候从数据库加载的数据)
         week_date	//星期几 (传数字,整型)
         sch_tm_start	//上课时间,格式13:30
         )
         */
        courseInfoDic1 = @{
                           @"course_tm_id":_courseTimeOldArray[0][@"id"],
                           @"week_date":[self transform:courseTimeCommbox11.textField.text],
                           @"sch_tm_start":courseTimeCommbox12.textField.text
                           };
    }
    courseAllInfoDic = @{@"0":courseInfoDic1};
    
}

//一周 2 次
- (void)createCourseTimeArray2{
    if ([courseTimeCommbox11.textField.text isEqualToString:@""] || [courseTimeCommbox12.textField.text isEqualToString:@"" ]|| [courseTimeCommbox21.textField.text isEqualToString:@""] || [courseTimeCommbox22.textField.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善上课时间" forSecond:1.5];
    }else{
        courseInfoDic1 = @{
                           @"course_tm_id":_courseTimeOldArray[0][@"id"],
                           @"week_date":[self transform:courseTimeCommbox11.textField.text],
                           @"sch_tm_start":courseTimeCommbox12.textField.text
                           };
        courseInfoDic2 = @{
                           @"course_tm_id":_courseTimeOldArray[1][@"id"],
                           @"week_date":[self transform:courseTimeCommbox21.textField.text],
                           @"sch_tm_start":courseTimeCommbox22.textField.text
                           };
    }
    
    courseAllInfoDic = @{@"0":courseInfoDic1,
                         @"1":courseInfoDic2
                         };
    
}

//一周 3 次
- (void)createCourseTimeArray3{
    if ([courseTimeCommbox11.textField.text isEqualToString:@""] || [courseTimeCommbox12.textField.text isEqualToString:@""] || [courseTimeCommbox21.textField.text isEqualToString:@""] || [courseTimeCommbox22.textField.text isEqualToString:@""] || [courseTimeCommbox31.textField.text isEqualToString:@""] || [courseTimeCommbox32.textField.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善上课时间" forSecond:1.5];
    }else{
        courseInfoDic1 = @{
                           @"course_tm_id":_courseTimeOldArray[0][@"id"],
                           @"week_date":[self transform:courseTimeCommbox11.textField.text],
                           @"sch_tm_start":courseTimeCommbox12.textField.text
                           };
        courseInfoDic2 = @{
                           @"course_tm_id":_courseTimeOldArray[1][@"id"],
                           @"week_date":[self transform:courseTimeCommbox21.textField.text],
                           @"sch_tm_start":courseTimeCommbox22.textField.text
                           };
        courseInfoDic3 = @{
                           @"course_tm_id":_courseTimeOldArray[2][@"id"],
                           @"week_date":[self transform:courseTimeCommbox31.textField.text],
                           @"sch_tm_start":courseTimeCommbox32.textField.text
                           };
    }
    courseAllInfoDic = @{@"0":courseInfoDic1,
                         @"1":courseInfoDic2,
                         @"2":courseInfoDic3
                         };
}

//一周 4 次
- (void)createCourseTimeArray4{
    if ([courseTimeCommbox11.textField.text isEqualToString:@""] || [courseTimeCommbox12.textField.text isEqualToString:@""] || [courseTimeCommbox21.textField.text isEqualToString:@""] || [courseTimeCommbox22.textField.text isEqualToString:@""] || [courseTimeCommbox31.textField.text isEqualToString:@""] || [courseTimeCommbox32.textField.text isEqualToString:@""] || [courseTimeCommbox41.textField.text isEqualToString:@""] || [courseTimeCommbox42.textField.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善上课时间" forSecond:1.5];
    }else{
        
        courseInfoDic1 = @{
                           @"course_tm_id":_courseTimeOldArray[0][@"id"],
                           @"week_date":[self transform:courseTimeCommbox11.textField.text],
                           @"sch_tm_start":courseTimeCommbox12.textField.text
                           };
        courseInfoDic2 = @{
                           @"course_tm_id":_courseTimeOldArray[1][@"id"],
                           @"week_date":[self transform:courseTimeCommbox21.textField.text],
                           @"sch_tm_start":courseTimeCommbox22.textField.text
                           };
        courseInfoDic3 = @{
                           @"course_tm_id":_courseTimeOldArray[2][@"id"],
                           @"week_date":[self transform:courseTimeCommbox31.textField.text],
                           @"sch_tm_start":courseTimeCommbox32.textField.text
                           };
        courseInfoDic4 = @{
                           @"course_tm_id":_courseTimeOldArray[3][@"id"],
                           @"week_date":[self transform:courseTimeCommbox41.textField.text],
                           @"sch_tm_start":courseTimeCommbox42.textField.text
                           };
    }
    courseAllInfoDic = @{@"0":courseInfoDic1,
                         @"1":courseInfoDic2,
                         @"2":courseInfoDic3,
                         @"3":courseInfoDic4
                         };
    
}

//一周 5 次
- (void)createCourseTimeArray5{
    if ([courseTimeCommbox11.textField.text isEqualToString:@""] || [courseTimeCommbox12.textField.text isEqualToString:@""] || [courseTimeCommbox21.textField.text isEqualToString:@""] || [courseTimeCommbox22.textField.text isEqualToString:@""] || [courseTimeCommbox31.textField.text isEqualToString:@""] || [courseTimeCommbox32.textField.text isEqualToString:@""] || [courseTimeCommbox41.textField.text isEqualToString:@""] || [courseTimeCommbox42.textField.text isEqualToString:@""] ||[courseTimeCommbox51.textField.text isEqualToString:@""] || [courseTimeCommbox52.textField.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善上课时间" forSecond:1.5];
    }else{
        
        courseInfoDic1 = @{
                           @"course_tm_id":_courseTimeOldArray[0][@"id"],
                           @"week_date":[self transform:courseTimeCommbox11.textField.text],
                           @"sch_tm_start":courseTimeCommbox12.textField.text
                           };
        courseInfoDic2 = @{
                           @"course_tm_id":_courseTimeOldArray[1][@"id"],
                           @"week_date":[self transform:courseTimeCommbox21.textField.text],
                           @"sch_tm_start":courseTimeCommbox22.textField.text
                           };
        courseInfoDic3 = @{
                           @"course_tm_id":_courseTimeOldArray[2][@"id"],
                           @"week_date":[self transform:courseTimeCommbox31.textField.text],
                           @"sch_tm_start":courseTimeCommbox32.textField.text
                           };
        courseInfoDic4 = @{
                           @"course_tm_id":_courseTimeOldArray[3][@"id"],
                           @"week_date":[self transform:courseTimeCommbox41.textField.text],
                           @"sch_tm_start":courseTimeCommbox42.textField.text
                           };
        courseInfoDic5 = @{
                           @"course_tm_id":_courseTimeOldArray[4][@"id"],
                           @"week_date":[self transform:courseTimeCommbox51.textField.text],
                           @"sch_tm_start":courseTimeCommbox52.textField.text
                           };
    }
    courseAllInfoDic = @{@"0":courseInfoDic1,
                         @"1":courseInfoDic2,
                         @"2":courseInfoDic3,
                         @"3":courseInfoDic4,
                         @"4":courseInfoDic5
                         };
    
}

//一周 6 次
- (void)createCourseTimeArray6{
    if ([courseTimeCommbox11.textField.text isEqualToString:@""] || [courseTimeCommbox12.textField.text isEqualToString:@""] || [courseTimeCommbox21.textField.text isEqualToString:@""] || [courseTimeCommbox22.textField.text isEqualToString:@""] || [courseTimeCommbox31.textField.text isEqualToString:@""] || [courseTimeCommbox32.textField.text isEqualToString:@""] || [courseTimeCommbox41.textField.text isEqualToString:@""] || [courseTimeCommbox42.textField.text isEqualToString:@""] ||[courseTimeCommbox51.textField.text isEqualToString:@""] || [courseTimeCommbox52.textField.text isEqualToString:@""] || [courseTimeCommbox61.textField.text isEqualToString:@""] || [courseTimeCommbox62.textField.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善上课时间" forSecond:1.5];
    }else{
        courseInfoDic1 = @{
                           @"course_tm_id":_courseTimeOldArray[0][@"id"],
                           @"week_date":courseTimeCommbox11.textField.text,
                           @"sch_tm_start":courseTimeCommbox12.textField.text
                           };
        courseInfoDic2 = @{
                           @"course_tm_id":_courseTimeOldArray[1][@"id"],
                           @"week_date":courseTimeCommbox21.textField.text,
                           @"sch_tm_start":courseTimeCommbox22.textField.text
                           };
        courseInfoDic3 = @{
                           @"course_tm_id":_courseTimeOldArray[2][@"id"],
                           @"week_date":courseTimeCommbox31.textField.text,
                           @"sch_tm_start":courseTimeCommbox32.textField.text
                           };
        courseInfoDic4 = @{
                           @"course_tm_id":_courseTimeOldArray[3][@"id"],
                           @"week_date":courseTimeCommbox41.textField.text,
                           @"sch_tm_start":courseTimeCommbox42.textField.text
                           };
        courseInfoDic5 = @{
                           @"course_tm_id":_courseTimeOldArray[4][@"id"],
                           @"week_date":courseTimeCommbox51.textField.text,
                           @"sch_tm_start":courseTimeCommbox52.textField.text
                           };
        courseInfoDic6 = @{
                           @"course_tm_id":_courseTimeOldArray[5][@"id"],
                           @"week_date":courseTimeCommbox61.textField.text,
                           @"sch_tm_start":courseTimeCommbox62.textField.text
                           };
        
    }
    courseAllInfoDic = @{@"0":courseInfoDic1,
                         @"1":courseInfoDic2,
                         @"2":courseInfoDic3,
                         @"3":courseInfoDic4,
                         @"4":courseInfoDic5,
                         @"5":courseInfoDic6
                         };
}

//一周 7 次
- (void)createCourseTimeArray7{
    if ([courseTimeCommbox11.textField.text isEqualToString:@""] || [courseTimeCommbox12.textField.text isEqualToString:@""] || [courseTimeCommbox21.textField.text isEqualToString:@""] || [courseTimeCommbox22.textField.text isEqualToString:@""] || [courseTimeCommbox31.textField.text isEqualToString:@""] || [courseTimeCommbox32.textField.text isEqualToString:@""] || [courseTimeCommbox41.textField.text isEqualToString:@""] || [courseTimeCommbox42.textField.text isEqualToString:@""] ||[courseTimeCommbox51.textField.text isEqualToString:@""] || [courseTimeCommbox52.textField.text isEqualToString:@""] || [courseTimeCommbox61.textField.text isEqualToString:@""] || [courseTimeCommbox62.textField.text isEqualToString:@""] || [courseTimeCommbox71.textField.text isEqualToString:@""] || [courseTimeCommbox72.textField.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善上课时间" forSecond:1.5];
    }else{
        courseInfoDic1 = @{
                           @"course_tm_id":_courseTimeOldArray[0][@"id"],
                           @"week_date":courseTimeCommbox11.textField.text,
                           @"sch_tm_start":courseTimeCommbox12.textField.text
                           };
        courseInfoDic2 = @{
                           @"course_tm_id":_courseTimeOldArray[1][@"id"],
                           @"week_date":courseTimeCommbox21.textField.text,
                           @"sch_tm_start":courseTimeCommbox22.textField.text
                           };
        courseInfoDic3 = @{
                           @"course_tm_id":_courseTimeOldArray[2][@"id"],
                           @"week_date":courseTimeCommbox31.textField.text,
                           @"sch_tm_start":courseTimeCommbox32.textField.text
                           };
        courseInfoDic4 = @{
                           @"course_tm_id":_courseTimeOldArray[3][@"id"],
                           @"week_date":courseTimeCommbox41.textField.text,
                           @"sch_tm_start":courseTimeCommbox42.textField.text
                           };
        courseInfoDic5 = @{
                           @"course_tm_id":_courseTimeOldArray[4][@"id"],
                           @"week_date":courseTimeCommbox51.textField.text,
                           @"sch_tm_start":courseTimeCommbox52.textField.text
                           };
        courseInfoDic6 = @{
                           @"course_tm_id":_courseTimeOldArray[5][@"id"],
                           @"week_date":courseTimeCommbox61.textField.text,
                           @"sch_tm_start":courseTimeCommbox62.textField.text
                           };
        courseInfoDic7 = @{
                           @"course_tm_id":_courseTimeOldArray[7][@"id"],
                           @"week_date":courseTimeCommbox71.textField.text,
                           @"sch_tm_start":courseTimeCommbox72.textField.text
                           };
    }
    courseAllInfoDic = @{@"0":courseInfoDic1,
                         @"1":courseInfoDic2,
                         @"2":courseInfoDic3,
                         @"3":courseInfoDic4,
                         @"4":courseInfoDic5,
                         @"5":courseInfoDic6,
                         @"6":courseInfoDic7
                         };
}

- (NSString *)transform:(NSString *)str{
    if ([str isEqualToString:@"星期一"]) {
        return @"1";
    }else if ([str isEqualToString:@"星期二"]){
        return @"2";
    }else if ([str isEqualToString:@"星期三"]){
        return @"3";
    }else if ([str isEqualToString:@"星期四"]){
        return @"4";
    }else if ([str isEqualToString:@"星期五"]){
        return @"5";
    }else if ([str isEqualToString:@"星期六"]){
        return @"6";
    }else if ([str isEqualToString:@"星期日"]){
        return @"7";
    }
    return nil;
}

//更新 textfield 的数据
- (void)updateTextFieldInfo{
    
   //开始 日期
    NSString *str1;
    str1 = @"";
    if (![_startDateStr isEqualToString:@"0"]) {
      NSString * string = [XXETool dateStringFromNumberTimer:_startDateStr];
        NSArray *array = [string componentsSeparatedByString:@" "];
        str1 = array[0];
    }
    startTextField.text = str1;
    
    //结束 日期
    NSString *str2;
    str2 = @"";
    if (![_endDateStr isEqualToString:@"0"]) {
    NSString *string = [XXETool dateStringFromNumberTimer:_endDateStr];
    NSArray *array = [string componentsSeparatedByString:@" "];
        str2 = array[0];
    }
      endTextField.text = str2;
    //课时
    lengthCommbox.textField.text = [NSString stringWithFormat:@"%@分钟", _course_hour];
    
    //课程 具体 时间 表 至少有一条
    if (courseTimeCommbox11) {
        
        if (_courseTimeOldArray.count > 0) {
            courseTimeCommbox11.textField.text = _courseTimeOldArray[0][@"week_date_name"];
            
            courseTimeCommbox12.textField.text = _courseTimeOldArray[0][@"sch_tm_start"];
        }

    }
    
    if (courseTimeCommbox21) {
        if (_courseTimeOldArray.count > 1) {
        courseTimeCommbox21.textField.text = _courseTimeOldArray[1][@"week_date_name"];
        
        courseTimeCommbox22.textField.text = _courseTimeOldArray[1][@"sch_tm_start"];
        }
    }
    
    if (courseTimeCommbox31) {
        if (_courseTimeOldArray.count > 2) {
        courseTimeCommbox31.textField.text = _courseTimeOldArray[2][@"week_date_name"];
        
        courseTimeCommbox32.textField.text = _courseTimeOldArray[2][@"sch_tm_start"];
        }
    }
    
    if (courseTimeCommbox41) {
        courseTimeCommbox41.textField.text = _courseTimeOldArray[3][@"week_date_name"];
        
        courseTimeCommbox42.textField.text = _courseTimeOldArray[3][@"sch_tm_start"];
    }

    
    if (courseTimeCommbox51) {
        courseTimeCommbox51.textField.text = _courseTimeOldArray[4][@"week_date_name"];
        
        courseTimeCommbox52.textField.text = _courseTimeOldArray[4][@"sch_tm_start"];
    }

    
    if (courseTimeCommbox61) {
        courseTimeCommbox61.textField.text = _courseTimeOldArray[5][@"week_date_name"];
        
        courseTimeCommbox62.textField.text = _courseTimeOldArray[5][@"sch_tm_start"];
    }

    
    if (courseTimeCommbox71) {
        courseTimeCommbox71.textField.text = _courseTimeOldArray[6][@"week_date_name"];
        
        courseTimeCommbox72.textField.text = _courseTimeOldArray[6][@"sch_tm_start"];
    }

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
