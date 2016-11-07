


//
//  XXESchoolTimetableAddCourseViewController.m
//  teacher
//
//  Created by Mac on 16/11/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolTimetableAddCourseViewController.h"
#import "XXESchoolTimetableCourseAddApi.h"
#import "HZQDatePickerView.h"


@interface XXESchoolTimetableAddCourseViewController ()<UITextFieldDelegate, HZQDatePickerViewDelegate>
{
    //icon 数组
    NSMutableArray *iconArray;
    //placeholder 数组
    NSMutableArray *placeholderArray;
    //拷贝 下拉框
    WJCommboxView *copyCommbox;
    UIView *copyCommboxBgView;
    
    //周数
    NSMutableArray *weeksArray;
    
    //时间 选择器
    HZQDatePickerView *_pikerView;
    
    NSInteger seletedTag;
    
    //添加课程 传参
    NSString *start_date;//从课程开始 的 时间中截取
    
    NSString *course_name;
    NSString *teacher_name;
    NSString *classroom;
    NSString *notes;
    NSString *lesson_start_tm;
    NSString *lesson_end_tm;
    NSString *copy_week_num;

    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@end

@implementation XXESchoolTimetableAddCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XXEBackgroundColor;
    self.navigationController.navigationBar.backgroundColor = XXEColorFromRGB(0, 170, 42);
    self.navigationController.navigationBarHidden = NO;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    weeksArray = [[NSMutableArray alloc] init];
    start_date = @"";
    classroom = @"";
    teacher_name = @"";
    course_name = @"";
    lesson_start_tm = @"";
    lesson_end_tm = @"";
    notes = @"";
    copy_week_num = @"";
    
    
    for (int i = 0; i < 20; i++) {
        NSString *str = [NSString stringWithFormat:@"%d周",i+1];
        [weeksArray addObject:str];
    }
    
    iconArray = [[NSMutableArray alloc] initWithObjects:@"schooltimetable_classname_icon40x50", @"schooltimetable_people_icon40x50", @"schooltimetable_coursename_icon40x50", @"schooltimetable_noti_icon40x50", @"schooltimetable_time_icon40x50", @"schooltimetable_time_icon40x50", @"schooltimetable_copy_icon40x50", nil];
    placeholderArray = [[NSMutableArray alloc] initWithObjects:@"请输入班级名称", @"请输入老师名称", @"请输入科目名称", @"请输入上课地址", @"请输入上课时间", @"请输入下课时间", nil];
    
    
    [self createContent];
    [self createRightButton];
    
}

- (void)createContent{
    
    for (int i = 0; i < 7; i++) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, i * (40 + 5), KScreenWidth, 40)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bgView];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 25)];
        iconImageView.image = [UIImage imageNamed:iconArray[i]];
        [bgView addSubview:iconImageView];
        
        if (i != 6) {
            UITextField *contentTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, 10, KScreenWidth - 50, 20)];
            contentTextField.tag = i + 10;
            contentTextField.delegate = self;
            contentTextField.placeholder = placeholderArray[i];
            contentTextField.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
            [bgView addSubview:contentTextField];
        }else{
            copyCommbox = [[WJCommboxView alloc] initWithFrame:CGRectMake(40 * kScreenRatioWidth, i * (40 + 5) + 5, KScreenWidth - 60, 30)];
            copyCommbox.textField.borderStyle =UITextBorderStyleNone;
            copyCommbox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
            copyCommbox.textField.placeholder = @"请选择当前复制的周数";
            copyCommbox.dataArray = weeksArray;
            copyCommbox.textField.textAlignment = NSTextAlignmentCenter;
            copyCommbox.textField.tag = 1001;
            [self.view addSubview:copyCommbox];
            
            //监听
            [copyCommbox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"1"];
            
            copyCommboxBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kWidth,kHeight+300)];
            copyCommboxBgView.backgroundColor = [UIColor clearColor];
            copyCommboxBgView.alpha = 0.5;
            
            UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden)];
            [copyCommboxBgView addGestureRecognizer:singleTouch];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
        
        }
    }
}

- (void)commboxAction:(NSNotification *)notif{
    switch ([notif.object integerValue]) {
        case 1001:
        {
            
            [copyCommbox removeFromSuperview];
            
            [self.view addSubview:copyCommboxBgView];
            [self.view addSubview:copyCommbox];
            
        }
            break;
        default:
            break;
    }
    
}


- (void)commboxHidden{
    
    [copyCommboxBgView removeFromSuperview];
    [copyCommbox setShowList:NO];
    copyCommbox.listTableView.hidden = YES;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    switch ([[NSString stringWithFormat:@"%@",context] integerValue]) {
        case 1:
        {
            if ([keyPath isEqualToString:@"text"]) {
                NSString * newName=[change objectForKey:@"new"];
                
                NSInteger index = [weeksArray indexOfObject:newName];
                copy_week_num = [NSString stringWithFormat:@"%ld", index + 1];
                
            }
            
        }
            break;
        default:
            break;
    }
}




- (void)createRightButton{
    UIButton *submitButton =[UIButton createButtonWithFrame:CGRectMake(-10, 0, 44, 20) backGruondImageName:@"" Target:self Action:@selector(submitButtonClick:) Title:@"提交"];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *submitItem =[[UIBarButtonItem alloc]initWithCustomView:submitButton];
    self.navigationItem.rightBarButtonItem =submitItem;
}

- (void)submitButtonClick:(UIButton *)button{
    if ([lesson_start_tm isEqualToString:@""]) {
        [self showHudWithString:@"上课时间不能为空" forSecond:1.5];
    }else if ([lesson_end_tm isEqualToString:@""]) {
        [self showHudWithString:@"下课时间不能为空" forSecond:1.5];
    }else if ([course_name isEqualToString:@""]) {
        [self showHudWithString:@"课程名称不能为空" forSecond:1.5];
    }else{
        
        // 开始时间 应该比结束时间小
        NSArray *startArr = [[NSArray alloc] initWithArray:[lesson_start_tm componentsSeparatedByString:@":"]];
        NSArray *endArr = [[NSArray alloc] initWithArray:[lesson_end_tm componentsSeparatedByString:@":"]];
        if (startArr.count != 0 && endArr.count != 0) {
            // 小时: 开始 < 结束 ->可以提交
            if ([startArr[0] integerValue] < [endArr[0] integerValue]) {
                [self submitNewCourseInfo];
            }else if([startArr[0] integerValue] == [endArr[0] integerValue]){
                // 小时: 开始 = 结束 -> 进一步判断 分钟: 开始 < 结束 -> 可以提交
                if ([startArr[1] integerValue] < [endArr[1] integerValue]) {
                    [self submitNewCourseInfo];
                }else{
                    [self showHudWithString:@"开始时间应该小于结束时间" forSecond:1.5];
                }
            }else if([startArr[0] integerValue] > [endArr[0] integerValue]){
                // 小时: 开始 < 结束 ->不可提交
                [self showHudWithString:@"开始时间应该小于结束时间" forSecond:1.5];
            }
        }
    }

}

- (void)submitNewCourseInfo{

    XXESchoolTimetableCourseAddApi *schoolTimetableCourseAddApi = [[XXESchoolTimetableCourseAddApi alloc] initWithXid:parameterXid user_id:parameterUser_Id date:start_date lesson_start_tm:lesson_start_tm lesson_end_tm:lesson_end_tm course_name:course_name teacher_name:teacher_name classroom:classroom notes:notes copy_week_num:copy_week_num];
    [schoolTimetableCourseAddApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//                NSLog(@"%@", request.responseJSONObject);
        
        NSString *codeStr = request.responseJSONObject[@"code"];
        if ([codeStr integerValue] == 1) {
            [self showHudWithString:@"提交成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"提交失败!" forSecond:1.5];
    }];


}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 14 || textField.tag == 15) {
//        NSLog(@"vvvv");
        [self.view endEditing:YES];
        
        if (textField.tag == 14) {
            seletedTag = 14;
        }else if (textField.tag == 15){
            seletedTag = 15;
        }
        
        [self setupDateView:DateTypeOfStart textField:textField];
        
        return NO;
    }
    
    return YES;
}


//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    
//        if (textField.tag == 14 || textField.tag == 15) {
//            
//            
//            if (textField.tag == 14) {
//                seletedTag = 14;
//            }else if (textField.tag == 15){
//                seletedTag = 15;
//            }
////            [textField resignFirstResponder];
//            [self.view endEditing:YES];
//            [self setupDateView:DateTypeOfStart textField:textField];
//            
//        }
//    
//}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag == 10) {
        classroom = textField.text;
    }else if (textField.tag == 11){
        teacher_name = textField.text;
    }else if (textField.tag == 12){
        course_name = textField.text;
    }else if (textField.tag == 13){
        notes = textField.text;
    }else if (textField.tag == 14){
        lesson_start_tm = textField.text;
    }else if (textField.tag == 15){
        lesson_end_tm = textField.text;
    }
//    [textField resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
//    [textField resignFirstResponder];
//    return YES;
    
    NSLog(@"00000");
    
    NSLog(@"www %@", NSStringFromClass([UITextField class]));
    
    
    return [textField resignFirstResponder];
}

- (void)setupDateView:(DateType)type textField:(UITextField *)textField{
    
    _pikerView = [HZQDatePickerView instanceDatePickerView];
    _pikerView.frame = CGRectMake(0, 0, kWidth  , kHeight + 20);
    [_pikerView setBackgroundColor:[UIColor clearColor]];
//    _pikerView.userInteractionEnabled = YES;
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
        {
            UITextField *textField = (UITextField *)[self.view viewWithTag:seletedTag];
            
            //2016-11-02 17:00:47  需填写 17:00
            NSRange range = NSMakeRange(10, 6);
            NSString *string = [NSString stringWithFormat:@"%@", [date substringWithRange:range]];
            textField.text = string;
            NSArray *arr = [date componentsSeparatedByString:@" "];
            
            if (seletedTag == 14) {
                lesson_start_tm = string;
                if (arr.count != 0) {
                    start_date = arr[0];
                }
                
            }else if (seletedTag == 15){
                lesson_end_tm = string;
                
            }
            
        }
            break;
            
        default:
            break;
    }
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [copyCommbox.textField removeObserver:self forKeyPath:@"text" context:@"1"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
