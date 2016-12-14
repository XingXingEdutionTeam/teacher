

//
//  XXESchoolTimetableCourseDetailViewController.m
//  teacher
//
//  Created by Mac on 16/11/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolTimetableCourseDetailViewController.h"
#import "XXESchoolTimetableCourseModifyApi.h"
#import "HZQDatePickerView.h"



@interface XXESchoolTimetableCourseDetailViewController ()<UITextFieldDelegate, HZQDatePickerViewDelegate>
{
    //icon 数组
    NSMutableArray *iconArray;
    //content 数组
    NSMutableArray *contentArray;
    //
    NSMutableArray *placeholderArray;
    
    //时间 选择器
    HZQDatePickerView *_pikerView;
    
    NSInteger seletedTag;
    //修改 传参
    NSString *course_name;
    NSString *teacher_name;
    NSString *classroom;
    NSString *notes;
    NSString *lesson_start_tm;
    NSString *lesson_end_tm;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}


@end

@implementation XXESchoolTimetableCourseDetailViewController

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

    iconArray = [[NSMutableArray alloc] initWithObjects:@"schooltimetable_classname_icon40x50", @"schooltimetable_people_icon40x50", @"schooltimetable_coursename_icon40x50", @"schooltimetable_noti_icon40x50", @"schooltimetable_time_icon40x50", @"schooltimetable_time_icon40x50", nil];
    
    placeholderArray = [[NSMutableArray alloc] initWithObjects:@"请输入班级名称", @"请输入老师名称", @"请输入科目名称", @"请输入备注内容", @"请输入上课时间", @"请输入下课时间", nil];
    
    contentArray = [[NSMutableArray alloc] initWithObjects:_model.classroom, _model.teacher_name, _model.course_name, _model.notes, _model.lesson_start_tm, _model.lesson_end_tm, nil];
    classroom = _model.classroom;
    teacher_name = _model.teacher_name;
    notes = _model.notes;
    course_name = _model.course_name;
    lesson_start_tm = _model.lesson_start_tm;
    lesson_end_tm = _model.lesson_end_tm;
    
//    NSLog(@"_type ---- %@", _type);
    
    [self createContent];
    
}

- (void)createContent{

    for (int i = 0; i < 6; i++) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, i * (40 + 5), KScreenWidth, 40)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bgView];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 25)];
        iconImageView.image = [UIImage imageNamed:iconArray[i]];
        [bgView addSubview:iconImageView];
        
        UITextField *contentTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, 10, KScreenWidth - 50, 20)];
        contentTextField.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
        contentTextField.delegate = self;
        contentTextField.tag = i + 10;
        if ([_type integerValue] == 3) {
            contentTextField.userInteractionEnabled = YES;
            contentTextField.placeholder = placeholderArray[i];
        }else{
            contentTextField.userInteractionEnabled = NO;
        }
        
        contentTextField.text = contentArray[i];
        [bgView addSubview:contentTextField];
        
    }
    
    if ([_type integerValue] == 3) {
        
        CGFloat buttonX = (KScreenWidth - 325 * kScreenRatioWidth) / 2;
        CGFloat buttonY = 5 * (40 + 5) + 100;
        CGFloat buttonWidth = 325 * kScreenRatioWidth;
        CGFloat buttonHeight = 42 * kScreenRatioHeight;
        
        UIButton *modifyButton = [UIButton createButtonWithFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight) backGruondImageName:@"login_green" Target:self Action:@selector(modifyButtonClick) Title:@"修       改"];
        modifyButton.titleLabel.font = [UIFont systemFontOfSize:16 * kScreenRatioWidth];
        [modifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:modifyButton];
    }
    
}


- (void)modifyButtonClick{
    /*
     lesson_start_tm		//上课时间,请限制用户格式:09:15 //必传
     lesson_end_tm		//下课时间                   //必传
     course_name		//课程名                     //必传
     */
    
//    NSLog(@"%@", )
    
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
                [self submitModifyInfo];
            }else if([startArr[0] integerValue] == [endArr[0] integerValue]){
                // 小时: 开始 = 结束 -> 进一步判断 分钟: 开始 < 结束 -> 可以提交
                if ([startArr[1] integerValue] < [endArr[1] integerValue]) {
                    [self submitModifyInfo];
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

- (void)submitModifyInfo{
    XXESchoolTimetableCourseModifyApi *schoolTimetableCourseModifyApi = [[XXESchoolTimetableCourseModifyApi alloc] initWithXid:parameterXid user_id:parameterUser_Id week_date:_week_date schedule_id:_schedule_id wd:_wd lesson_start_tm:lesson_start_tm lesson_end_tm:lesson_end_tm course_name:course_name teacher_name:teacher_name classroom:classroom notes:notes];
    [schoolTimetableCourseModifyApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
//        NSLog(@"%@", request.responseJSONObject);
        
        NSString *codeStr = request.responseJSONObject[@"code"];
        if ([codeStr integerValue] == 1) {
            [self showHudWithString:@"修改成功!" forSecond:1.5];
            NSString *str1 = course_name;
            NSString *str2 = lesson_start_tm;
            
            NSMutableArray *mArr = [[NSMutableArray alloc] initWithObjects:str1, str2, nil];
            self.ReturnArrayBlock(mArr);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"修改失败!" forSecond:1.5];
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //[type] => 3			//类型,3是自定义,允许修改
    if ([_type integerValue] == 3) {
         if (textField.tag == 14 || textField.tag == 15) {
            if (textField.tag == 14) {
                seletedTag = 14;
            }else if (textField.tag == 15){
                seletedTag = 15;
            }
        
            [self setupDateView:DateTypeOfStart textField:textField];
            [self.view endEditing:YES];
        }

    }

}

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

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)setupDateView:(DateType)type textField:(UITextField *)textField{
    
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
        {
            UITextField *textField = (UITextField *)[self.view viewWithTag:seletedTag];
            
            //2016-11-02 17:00:47  需填写 17:00
            NSRange range = NSMakeRange(10, 6);
            NSString *string = [NSString stringWithFormat:@"%@", [date substringWithRange:range]];
            textField.text = string;
            
            if (seletedTag == 14) {
                lesson_start_tm = string;
                
            }else if (seletedTag == 15){
                lesson_end_tm = string;
                
            }
        
        }
            break;
            
        default:
            break;
    }
}

- (void)returnArray:(ReturnArrayBlock)block{
    self.ReturnArrayBlock = block;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
