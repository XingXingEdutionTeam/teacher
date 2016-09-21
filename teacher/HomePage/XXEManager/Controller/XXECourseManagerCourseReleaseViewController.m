


//
//  XXECourseManagerCourseReleaseViewController.m
//  teacher
//
//  Created by Mac on 16/9/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECourseManagerCourseReleaseViewController.h"
#import "HZQDatePickerView.h"
#import "FSImagePickerView.h"

#define KLabelW 65
#define KLabelH 25

#define awayX 20
#define spaceX 10
#define spaceY 30


@interface XXECourseManagerCourseReleaseViewController ()<UITextFieldDelegate, HZQDatePickerViewDelegate, UITextViewDelegate>

{
//#define KLabelW 65
//#define KLabelH 25
//    
//#define awayX 20
//#define spaceX 10
//#define spaceY 30
//    CGFloat KLabelW;
//    CGFloat KLabelH;
//    CGFloat awayX;
    
    
    NSMutableArray * studentArray;
    int checkNum;
    int noCheckNum;
    
    UIScrollView *bgScrollView;
    //课程类型 3个下拉框
    WJCommboxView *subjectCommbox1;
    WJCommboxView *subjectCommbox2;
    WJCommboxView *subjectCommbox3;
    
    //老师名称 textfield (不可手动输入,内容只能从后面列表中选取)
    WJCommboxView *teacherNameCommbox;
    
    
    UILabel* subjectLabel;
    
    UILabel* teacherLabel;
    UITextField *teacherText1;
    
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
    
    //是否 允许 退班 下拉框
    WJCommboxView *exitClassCommbox;
    
    UITextField *oldMoneyText;
    UITextField *newMoneyText;
    
    //是否 允许 扣除 猩币 下拉框
    WJCommboxView *deductXingIconCommbox;
    
    UIButton *saveBtn;
    UIButton *releaseBtn;
    UITapGestureRecognizer * _gesture;
}

@end

@implementation XXECourseManagerCourseReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self creatFields];
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
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
    subjectCommbox1.textField.placeholder = @"请选择类目";
    subjectCommbox1.textField.textAlignment = NSTextAlignmentLeft;
    subjectCommbox1.textField.borderStyle=UITextBorderStyleRoundedRect;
    
    subjectCommbox2 = [[WJCommboxView alloc] initWithFrame:CGRectMake(subjectCommbox1.x +subjectCommbox1.size.width + 5, subjectLabel.y, (kWidth - subjectLabel.x - subjectLabel.size.width - 30)/3, KLabelH)];
    subjectCommbox2.textField.placeholder = @"";
    subjectCommbox2.textField.textAlignment = NSTextAlignmentLeft;
    subjectCommbox2.textField.borderStyle=UITextBorderStyleRoundedRect;
    
    subjectCommbox3 = [[WJCommboxView alloc] initWithFrame:CGRectMake(subjectCommbox2.x +subjectCommbox2.size.width + 5, subjectLabel.y, (kWidth - subjectLabel.x - subjectLabel.size.width - 30)/3, KLabelH)];
    subjectCommbox3.textField.placeholder = @"";
    subjectCommbox3.textField.textAlignment = NSTextAlignmentLeft;
    subjectCommbox3.textField.borderStyle=UITextBorderStyleRoundedRect;
    
    [bgScrollView addSubview:subjectLabel];
    [bgScrollView addSubview:subjectCommbox1];
    [bgScrollView addSubview:subjectCommbox2];
    [bgScrollView addSubview:subjectCommbox3];
    
    
    //课程名称
    arrangeLabel=[UILabel createLabelWithFrame:CGRectMake(awayX, 10+spaceY*1, KLabelW , KLabelH) Font:14 Text:@"课程名称:"];
    arrangeText = [UITextField createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(arrangeLabel.frame) + spaceX, 10+spaceY*1, kWidth - subjectLabel.x - subjectLabel.size.width - awayX, KLabelH) placeholder:@"" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    arrangeText.borderStyle=UITextBorderStyleRoundedRect;
    arrangeText.delegate = self;
    [bgScrollView addSubview:arrangeLabel];
    [bgScrollView addSubview:arrangeText];
    
    
    
#pragma mark =================== 老师 名称 ====================
    //授课老师
    teacherLabel=[UILabel createLabelWithFrame:CGRectMake(awayX, 10+spaceY*2, KLabelW , KLabelH) Font:14 Text:@"授课老师:"];
    
    teacherText1 = [UITextField createTextFieldWithFrame:CGRectMake(subjectLabel.x +subjectLabel.size.width + spaceX, CGRectGetMaxY(arrangeText.frame) + 5, (kWidth - subjectLabel.x - subjectLabel.size.width - 26)/2, KLabelH) placeholder:@"" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    teacherText1.enabled = NO;
    teacherText1.borderStyle = UITextBorderStyleRoundedRect;
    

    teacherNameCommbox = [[WJCommboxView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(teacherText1.frame) + 5, CGRectGetMaxY(arrangeText.frame) + 5, (kWidth - subjectLabel.x - subjectLabel.size.width - 26)/2, KLabelH)];
    teacherNameCommbox.textField.placeholder = @"";
    teacherNameCommbox.textField.textAlignment = NSTextAlignmentLeft;
    teacherNameCommbox.textField.borderStyle = UITextBorderStyleRoundedRect;
    teacherText1.text = teacherNameCommbox.textField.text;
    
    [bgScrollView addSubview:teacherLabel];
    [bgScrollView addSubview:teacherText1];
    [bgScrollView addSubview:teacherNameCommbox];
   
#pragma mark *******************  招生人数  ***************
    //招生人数
    studentCountLabel=[UILabel createLabelWithFrame:CGRectMake(awayX, 10+spaceY*3, KLabelW , KLabelH) Font:14 Text:@"招生人数:"];
    studentCountText = [UITextField createTextFieldWithFrame:CGRectMake(subjectLabel.x +subjectLabel.size.width + spaceX, CGRectGetMaxY(teacherNameCommbox.frame) + 3, kWidth - subjectLabel.x - subjectLabel.size.width - awayX, KLabelH) placeholder:@"" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    studentCountText.borderStyle = UITextBorderStyleRoundedRect;
    studentCountText.keyboardType=UIKeyboardTypeNumberPad;
    studentCountText.delegate = self;
    [bgScrollView addSubview:studentCountLabel];
    [bgScrollView addSubview:studentCountText];
    
    //适用人群
    studentAgeLabel=[UILabel createLabelWithFrame:CGRectMake(awayX, CGRectGetMaxY(studentCountText.frame) + 5, KLabelW , KLabelH) Font:14 Text:@"适用人群:"];
    
    studentAgeText1 = [UITextField createTextFieldWithFrame:CGRectMake(subjectLabel.x +subjectLabel.size.width + spaceX, CGRectGetMaxY(studentCountText.frame) + 5, 70, KLabelH) placeholder:@"年龄" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    
    studentAgeText1.borderStyle=UITextBorderStyleRoundedRect;
    studentAgeText1.keyboardType=UIKeyboardTypeNumberPad;
    studentAgeText1.delegate = self;
    [bgScrollView addSubview:[UILabel createLabelWithFrame:CGRectMake(awayX+150+spaceX*1, CGRectGetMaxY(studentCountText.frame) + 5, 30, 30) Font:14 Text:@"至"]];
    
    studentAgeText2 = [UITextField createTextFieldWithFrame:CGRectMake(awayX+40+spaceX*1+140, CGRectGetMaxY(studentCountText.frame) + 5, 70, KLabelH) placeholder:@"年龄" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    studentAgeText2.borderStyle=UITextBorderStyleRoundedRect;
    studentAgeText2.keyboardType=UIKeyboardTypeNumberPad;
    [bgScrollView addSubview:studentAgeLabel];
    [bgScrollView addSubview:studentAgeText1];
    [bgScrollView addSubview:studentAgeText2];
    
    
    //教学目标
    targetLabel=[UILabel createLabelWithFrame:CGRectMake(awayX, 10+spaceY*5, KLabelW , KLabelH) Font:14 Text:@"教学目标:"];
    targetText = [UITextField createTextFieldWithFrame:CGRectMake(subjectLabel.x +subjectLabel.size.width + spaceX, CGRectGetMaxY(studentAgeText2.frame)+4 , kWidth - subjectLabel.x - subjectLabel.size.width - awayX, KLabelH) placeholder:@"" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    targetText.borderStyle=UITextBorderStyleRoundedRect;
    targetText.delegate = self;
    [bgScrollView addSubview:targetLabel];
    [bgScrollView addSubview:targetText];
    
    //课程安排
    timeLabel=[UILabel createLabelWithFrame:CGRectMake(awayX, 10+spaceY*6, KLabelW , KLabelH) Font:14 Text:@"课程安排:"];
    
    timeText = [UITextField createTextFieldWithFrame:CGRectMake(subjectLabel.x +subjectLabel.size.width + spaceX, 10+spaceY*6, kWidth - subjectLabel.x - subjectLabel.size.width - awayX, KLabelH) placeholder:@"" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    timeText.borderStyle=UITextBorderStyleRoundedRect;
    timeText.tag = 100;
    timeText.delegate = self;
    [bgScrollView addSubview:timeLabel];
    [bgScrollView addSubview:timeText];
    
    //上课地址
    [bgScrollView addSubview:[UILabel createLabelWithFrame:CGRectMake(awayX, 10+spaceY*7, KLabelW , KLabelH) Font:14 Text:@"上课地址:"]];
    addressText = [UITextField createTextFieldWithFrame:CGRectMake(subjectLabel.x +subjectLabel.size.width + spaceX, 10+spaceY*7, kWidth - subjectLabel.x - subjectLabel.size.width - awayX, KLabelH) placeholder:@"" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    addressText.borderStyle=UITextBorderStyleRoundedRect;
    addressText.delegate = self;
    [bgScrollView addSubview:addressText];
    
    //插班规则
    [bgScrollView addSubview:[UILabel createLabelWithFrame:CGRectMake(awayX, 10+spaceY*8, KLabelW , KLabelH) Font:14 Text:@"允许插班:"]];
    NSArray *inRuleTextArr = [[NSArray alloc]initWithObjects:@"是",@"否",nil];
    insertClassCommbox = [[WJCommboxView alloc] initWithFrame:CGRectMake(subjectLabel.x +subjectLabel.size.width + spaceX, 10+spaceY*8, kWidth - subjectLabel.x - subjectLabel.size.width - awayX, KLabelH)];
    insertClassCommbox.textField.placeholder = @"";
    insertClassCommbox.textField.textAlignment = NSTextAlignmentLeft;
    insertClassCommbox.dataArray = inRuleTextArr;
    insertClassCommbox.textField.borderStyle=UITextBorderStyleRoundedRect;
    [bgScrollView addSubview:insertClassCommbox];
    
    //退班规则
    [bgScrollView addSubview:[UILabel createLabelWithFrame:CGRectMake(awayX, 10+spaceY*9, KLabelW , KLabelH) Font:14 Text:@"退班规则:"]];
    NSArray *outRuleTextArr = [[NSArray alloc]initWithObjects:@"是",@"否",nil];
    exitClassCommbox = [[WJCommboxView alloc] initWithFrame:CGRectMake(subjectLabel.x +subjectLabel.size.width + spaceX, 10+spaceY*9, kWidth - subjectLabel.x - subjectLabel.size.width - awayX, KLabelH)];
    exitClassCommbox.textField.placeholder = @"";
    exitClassCommbox.textField.textAlignment = NSTextAlignmentLeft;
    exitClassCommbox.dataArray = outRuleTextArr;
    exitClassCommbox.textField.borderStyle=UITextBorderStyleRoundedRect;
    [bgScrollView addSubview:exitClassCommbox];
    
    //学费 原价
    [bgScrollView addSubview:[UILabel createLabelWithFrame:CGRectMake(awayX, 10+spaceY*10, KLabelW , KLabelH) Font:14 Text:@"原       价:"]];
    
    oldMoneyText = [UITextField createTextFieldWithFrame:CGRectMake(subjectLabel.x +subjectLabel.size.width + spaceX, 10+spaceY*10, kWidth - subjectLabel.x - subjectLabel.size.width - awayX, KLabelH) placeholder:@"" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    oldMoneyText.borderStyle=UITextBorderStyleRoundedRect;
        oldMoneyText.keyboardType=UIKeyboardTypeNumberPad;
    oldMoneyText.delegate = self;
    [bgScrollView addSubview:oldMoneyText];
    
    //招生学费
    [bgScrollView addSubview:[UILabel createLabelWithFrame:CGRectMake(awayX, 10+spaceY*11, KLabelW , KLabelH) Font:14 Text:@"现       价:"]];
    
    newMoneyText = [UITextField createTextFieldWithFrame:CGRectMake(subjectLabel.x +subjectLabel.size.width + spaceX, 10+spaceY*11, kWidth - subjectLabel.x - subjectLabel.size.width - awayX, KLabelH) placeholder:@"" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    newMoneyText.borderStyle = UITextBorderStyleRoundedRect;
        newMoneyText.keyboardType=UIKeyboardTypeNumberPad;
    newMoneyText.delegate = self;
    [bgScrollView addSubview:newMoneyText];
    
    
    [bgScrollView addSubview:[UILabel createLabelWithFrame:CGRectMake(awayX,  10+spaceY*12, KLabelW , KLabelH) Font:14 Text:@"猩币抵扣:"]];
    NSArray *xingIconArr = [[NSArray alloc]initWithObjects:@"允许猩币抵扣  上限为1%",@"不允许猩币抵扣",nil];
    deductXingIconCommbox = [[WJCommboxView alloc] initWithFrame:CGRectMake( subjectLabel.x +subjectLabel.size.width + spaceX, 10+spaceY*12, kWidth - subjectLabel.x - subjectLabel.size.width - awayX, KLabelH)];
    deductXingIconCommbox.textField.placeholder = @"";
    deductXingIconCommbox.textField.textAlignment = NSTextAlignmentLeft;
    deductXingIconCommbox.dataArray = xingIconArr;
    deductXingIconCommbox.textField.borderStyle=UITextBorderStyleRoundedRect;
    [bgScrollView addSubview: deductXingIconCommbox];
    
    
    //课程说明
    UIView *belowBg = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(deductXingIconCommbox.frame) + spaceX, kWidth, 300)];
    belowBg.backgroundColor = UIColorFromRGB(204, 204, 204);
    [bgScrollView addSubview:belowBg];
    UIView *subjectShowBg = [[UIView alloc] initWithFrame:CGRectMake(0, spaceX, kWidth, 120)];
    subjectShowBg.backgroundColor = UIColorFromRGB(255, 255, 255);
    [belowBg addSubview:subjectShowBg];
    UILabel *subjectShow = [UILabel createLabelWithFrame:CGRectMake(awayX, spaceX, KLabelW , KLabelH) Font:14 Text:@"课程说明:"];
    [subjectShowBg addSubview:subjectShow];
    
    
    //选取图片
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    FSImagePickerView *picker = [[FSImagePickerView alloc] initWithFrame:CGRectMake(awayX, subjectShow.y + subjectShow.size.height + spaceX, kWidth - 100, 63) collectionViewLayout:layout];
    picker.showsHorizontalScrollIndicator = NO;
    picker.controller = self;
    [subjectShowBg addSubview:picker];
    
    //保存到草稿
    saveBtn=[UIButton createButtonWithFrame:CGRectMake(awayX, subjectShowBg.y + subjectShowBg.size.height + spaceX, 325 * kScreenRatioWidth, 42 * kScreenRatioHeight) backGruondImageName:@"login_green" Target:self Action:@selector(saveDraftsBtn:) Title:@"保存到草稿"];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [belowBg addSubview:saveBtn];
    
    //提交到草稿
    releaseBtn=[UIButton createButtonWithFrame:CGRectMake(awayX, saveBtn.y + saveBtn.size.height + spaceX, 325 * kScreenRatioWidth, 42 * kScreenRatioHeight) backGruondImageName:@"login_green" Target:self Action:@selector(releaseBtn:) Title:@"提交审核"];
    [releaseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [belowBg addSubview:releaseBtn];
    
    CGFloat maxH = belowBg.y + belowBg.size.height + 50;
    bgScrollView.contentSize = CGSizeMake(0, maxH);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textField:) name:@"textField" object:nil];
    
}
//通知相应事件
-(void)textField:(NSNotification *)text{
    NSString *teacherName =[NSString stringWithFormat:@"%@", text.userInfo[@"teacher"]];
    teacherText1.text = teacherName;
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    if (textField.tag == 100) {
//        TimeSelectViewController *timeVC = [[TimeSelectViewController alloc] init];
//        [self.navigationController pushViewController:timeVC animated:YES];
//        [self.view endEditing:YES];
//        textField.text = @"已设置";
//    }
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

//保存草稿
- (void)saveDraftsBtn:(id)sender {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确认保存到草稿？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showHudWithString:@"保存到草稿成功" forSecond:1.5];
        
//        [SVProgressHUD showSuccessWithStatus:@"保存到草稿成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//提交审核
- (void)releaseBtn:(UIButton *)button{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确认提交到审核？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showHudWithString:@"请等待审核" forSecond:1.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}


@end
