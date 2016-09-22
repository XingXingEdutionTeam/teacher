

//
//  XXECourseManagerCourseSettingViewController.m
//  teacher
//
//  Created by Mac on 16/9/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECourseManagerCourseSettingViewController.h"

#import "HZQDatePickerView.h"


@interface XXECourseManagerCourseSettingViewController ()<HZQDatePickerViewDelegate,UITextFieldDelegate, UITextViewDelegate>
{
    UIView *startBgView;
    UIView *endBgView;
    UIView *courseSettingBgView;
    UIView *courseContentBgView;
    
    UITextField *startTextField;
    UITextField *endTextField;
    
    
    WJCommboxView *timesCommbox;
    WJCommboxView *lengthCommbox;
//    WJCommboxView *subjectCommbox3;
    
    UIView *timesCommboxBgView1;
    UIView *lengthCommboxBgView2;
//    UIView *subjectCommboxBgView3;
    
//    UITextField *timesTextField;
//    UITextField *lengthTextField;
    
    HZQDatePickerView *_pikerView;
    //上课 次数 数组
    NSArray *timesArray;
    //上课 时长 数组
    NSArray *lengthsArray;

}




@end

@implementation XXECourseManagerCourseSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = XXEBackgroundColor;
    
    //开始
    [self createStartBgView];
    
    //结束
    [self createEndBgView];
    
    //课程 安排
    [self createCourseSettingBgView];
    
    //课程 时间表
    [self createCourseContentBgView];
    
    //确认 按钮
    [self createCertainButton];

}

#pragma mark - ----------  开始 bgview -----------------
// 开始 view
- (void)createStartBgView{
    startBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    startBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:startBgView];
    UILabel *startLabel = [UILabel createLabelWithFrame:CGRectMake(20, 10, 70, 20) Font:14 Text:@"开始日期:"];
    startTextField = [[UITextField alloc] initWithFrame:CGRectMake(90 * kScreenRatioWidth, 5, 260, 30)];
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
    UILabel *endLabel = [UILabel createLabelWithFrame:CGRectMake(20, 10, 70, 20) Font:14 Text:@"结束日期:"];
    endTextField = [[UITextField alloc] initWithFrame:CGRectMake(90 * kScreenRatioWidth, 5, 260, 30)];
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
    UILabel *courseLabel = [UILabel createLabelWithFrame:CGRectMake(20, 10, 100, 20) Font:14 Text:@"课程安排:"];
    
    UILabel *lengthLabel = [UILabel createLabelWithFrame:CGRectMake(220, 10, 40, 20) Font:14 Text:@"课时:"];

    timesCommbox = [[WJCommboxView alloc] initWithFrame:CGRectMake(90 * kScreenRatioWidth, 5, 120, 30)];
    
    timesArray = [[NSArray alloc]initWithObjects:@"一周1次", @"一周2次", @"一周3次", @"一周4次", @"一周5次", @"一周6次", @"一周7次", nil];
    timesCommbox.dataArray = timesArray;
    CGRect rect1 = timesCommbox.textField.frame;
    rect1.size.height = 30;
    timesCommbox.textField.frame = rect1;
    
    timesCommbox.textField.tag = 11;
    timesCommbox.textField.placeholder = @"";
    timesCommbox.textField.textAlignment = NSTextAlignmentLeft;
    timesCommbox.textField.borderStyle=UITextBorderStyleRoundedRect;
    [timesCommbox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"1"];
    
    timesCommboxBgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kWidth,kHeight+300)];
    timesCommboxBgView1.backgroundColor = [UIColor clearColor];
    timesCommboxBgView1.alpha = 0.5;
    UITapGestureRecognizer *singleTouch1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden1)];
    [timesCommboxBgView1 addGestureRecognizer:singleTouch1];
    
    //-------------------- subjectCommbox2 ---------------
    lengthCommbox = [[WJCommboxView alloc] initWithFrame:CGRectMake(260 * kScreenRatioWidth, 5, 90, 30)];
    lengthsArray = [[NSArray alloc]initWithObjects:@"30分钟", @"45分钟", @"60分钟", @"90分钟", @"120分钟", @"180分钟", nil];
    lengthCommbox.dataArray = lengthsArray;
    CGRect rect2 = lengthCommbox.textField.frame;
    rect2.size.height = 30;
    lengthCommbox.textField.frame = rect2;
    
    lengthCommbox.textField.tag = 12;
    lengthCommbox.textField.placeholder = @"";
    lengthCommbox.textField.textAlignment = NSTextAlignmentLeft;
    lengthCommbox.textField.borderStyle=UITextBorderStyleRoundedRect;
    [lengthCommbox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"2"];
    
    lengthCommboxBgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kWidth,kHeight+300)];
    lengthCommboxBgView2.backgroundColor = [UIColor clearColor];
    lengthCommboxBgView2.alpha = 0.5;
    //    subjectCommboxBgView2.tag = 12;
    UITapGestureRecognizer *singleTouch2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden2)];
    [lengthCommboxBgView2 addGestureRecognizer:singleTouch2];
    
    [courseSettingBgView addSubview:courseLabel];
    [courseSettingBgView addSubview:lengthLabel];
    [courseSettingBgView addSubview:timesCommbox];
    [courseSettingBgView addSubview:lengthCommbox];

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
        [self.view endEditing:YES];
    }
    
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
        case DateTypeOfStart:
            startTextField.text = [NSString stringWithFormat:@"%@", date];
            
            break;
            
        default:
            break;
    }
}


#pragma mark ------------- 确认 按钮 ---------------
- (void)createCertainButton{
    
    CGFloat buttonWtdth = 325 * kScreenRatioWidth;
    CGFloat buttonHeight = 42 * kScreenRatioHeight;
    
    UIButton *certainBtn = [UIButton createButtonWithFrame:CGRectMake((KScreenWidth - buttonWtdth) / 2, courseContentBgView.frame.origin.y + courseContentBgView.frame.size.height + 20, buttonWtdth, buttonHeight) backGruondImageName:@"login_green" Target:self Action:@selector(certainBtnClick) Title:@"确定"];
    [certainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:certainBtn];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    switch ([[NSString stringWithFormat:@"%@", context] integerValue]) {
        case 1:
        {
            //class1
            if ([keyPath isEqualToString:@"text"]) {
                NSString * newName=[change objectForKey:@"new"];
                if (newName) {
//                    className1 = newName;
                    
                    NSInteger index = [timesArray indexOfObject:newName];
                    
                    
                    
                    //更新  数据
                    [self updateCourseContentBgViewInfo:index];
                }
            }else{
                
            }
            
        }
            break;
        case 2:
        {
            //class2
//            if (subjectCommbox1.textField.text) {
                if ([keyPath isEqualToString:@"text"]) {
                    NSString * newName=[change objectForKey:@"new"];
//                    if (newName) {
//                        className2 = newName;
//                    }
//                    //更新 class3 数据
//                    [self updateSubjectCommbox3];
                }
//            }else{
//                [self showHudWithString:@"请先完善“前面”信息" forSecond:1.5];
            }
            
//        }
            break;
        case 3:
        {
            //class3
            
        }
            break;
        case 4:
//        {
//            //老师 列表
//            if ([keyPath isEqualToString:@"text"]) {
//                //更新 老师 名称  数据
//                [self updateTeacherTextFieldInfo];
//                
//            }else{
//                [self showHudWithString:@"请先完善“前面”信息" forSecond:1.5];
//            }
//        }
        default:
            break;
    }
    
    
}

- (void)commboxAction:(NSNotification *)notif{
    switch ([notif.object integerValue]) {
        case 11:
        {
            [timesCommbox removeFromSuperview];
            [courseSettingBgView addSubview:timesCommboxBgView1];
            [courseSettingBgView addSubview:timesCommbox];
            
        }
            break;
        case 12:
        {
            
            [lengthCommbox removeFromSuperview];
            [courseSettingBgView addSubview:lengthCommboxBgView2];
            [courseSettingBgView addSubview:lengthCommbox];
        }
            break;
//        case 13:
//        {
//            
//            [subjectCommbox3 removeFromSuperview];
//            [bgScrollView addSubview:subjectCommboxBgView3];
//            [bgScrollView addSubview:subjectCommbox3];
//        }
//            break;
//        case 14:
//        {
//            
//            [teacherNameCommbox removeFromSuperview];
//            [bgScrollView addSubview:teacherNameCommboxBgView];
//            [bgScrollView addSubview:teacherNameCommbox];
//        }
//            break;
//        case 15:
//        {
//            
//            [insertClassCommbox removeFromSuperview];
//            [bgScrollView addSubview:insertClassCommboxBgView];
//            [bgScrollView addSubview:insertClassCommbox];
//        }
//            break;
//        case 16:
//        {
//            
//            [exitClassCommbox removeFromSuperview];
//            [bgScrollView addSubview:exitClassCommboxBgView];
//            [bgScrollView addSubview:exitClassCommbox];
//        }
//            break;
//        case 17:
//        {
//            
//            [deductXingIconCommbox removeFromSuperview];
//            [bgScrollView addSubview:deductXingIconCommboxBgView];
//            [bgScrollView addSubview:deductXingIconCommbox];
//        }
//            break;
        default:
            break;
    }
    
}


- (void)commboxHidden1{
    [timesCommboxBgView1 removeFromSuperview];
    [timesCommbox setShowList:NO];
    timesCommbox.listTableView.hidden = YES;
}

- (void)commboxHidden2{
    [lengthCommboxBgView2 removeFromSuperview];
    [lengthCommbox setShowList:NO];
    lengthCommbox.listTableView.hidden = YES;
}

//- (void)commboxHidden3{
//    [subjectCommboxBgView3 removeFromSuperview];
//    [subjectCommbox3 setShowList:NO];
//    subjectCommbox3.listTableView.hidden = YES;
//}


- (void)updateCourseContentBgViewInfo:(NSInteger)index{

    for (int i = 0; i < index; i++) {
       
        
        
    }

}


- (void)certainBtnClick{

    NSLog(@"确定 ----------  ");

}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [timesCommbox.textField removeObserver:self forKeyPath:@"text"];
    
    [lengthCommbox.textField removeObserver:self forKeyPath:@"text"];
    
//    [subjectCommbox3.textField removeObserver:self forKeyPath:@"text"];
//    
//    [teacherNameCommbox.textField removeObserver:self forKeyPath:@"text"];
    
    //    [self.schoolNameCombox.textField removeObserver:self forKeyPath:@"text"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
