


//
//  XXEClassManagerClassReleaseViewController.m
//  teacher
//
//  Created by Mac on 16/9/28.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEClassManagerClassReleaseViewController.h"
#import "XXEClassManagerSettingClassTimeViewController.h"
#import "XXEClassManagerAddClassInfoApi.h"


@interface XXEClassManagerClassReleaseViewController ()
{
    //学校类型 school_type
    NSString *school_type;
    
    //是否 设置时间
    NSString *settingTimeFlagStr;
    NSString *parameterXid;
    NSString *parameterUser_Id;

}


@end

@implementation XXEClassManagerClassReleaseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获取当前 学校类型
    school_type = [DEFAULTS objectForKey:@"SCHOOL_TYPE"];
    //根据学校类型 年级 班级 的提示语相应改变
    //幼儿园/小学/初中/机构/高中    1/2/3/4/5
    if ([school_type integerValue] == 1) {
        //幼儿园
        _gradeTextField.placeholder = @"大/中/小 班";
        _classTextField.placeholder = @"1~5";
    }else if ([school_type integerValue] == 2) {
        //小学
        _gradeTextField.placeholder = @"1~6";
        _classTextField.placeholder = @"1~20";
    }else if ([school_type integerValue] == 3) {
        //初中
        _gradeTextField.placeholder = @"1~3";
        _classTextField.placeholder = @"1~20";
    }else if ([school_type integerValue] == 4) {
        //机构
        _gradeTextField.placeholder = @"课程名称";
        _classTextField.placeholder = @"1~5";
    }else if ([school_type integerValue] == 5) {
        //高中
        _gradeTextField.placeholder = @"1~3";
        _classTextField.placeholder = @"1~20";
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

    _gradeTextField.keyboardType=UIKeyboardTypeNumberPad;
    _classTextField.keyboardType=UIKeyboardTypeNumberPad;
    _classNumTextField.keyboardType =UIKeyboardTypeNumberPad;

    settingTimeFlagStr = @"";
    
    UIButton *timeBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 22, 22) backGruondImageName:@"manager_time_icon44x44" Target:self Action:@selector(timeBtn:) Title:@""];
    UIBarButtonItem *timeItem =[[UIBarButtonItem alloc]initWithCustomView:timeBtn];
    self.navigationItem.rightBarButtonItem =timeItem;
}

- (void)timeBtn:(UIButton *)button{

    XXEClassManagerSettingClassTimeViewController *classManagerSettingClassTimeVC = [[XXEClassManagerSettingClassTimeViewController alloc] init];
    classManagerSettingClassTimeVC.schoolId = _schoolId;
    classManagerSettingClassTimeVC.schoolType = _schoolType;
    classManagerSettingClassTimeVC.classId = _classId;
    classManagerSettingClassTimeVC.position = _position;
    
    [classManagerSettingClassTimeVC returnStr:^(NSString *str) {
        //
        settingTimeFlagStr = str;
    }];
    
    [self.navigationController pushViewController:classManagerSettingClassTimeVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)releaseButton:(UIButton *)sender {
    
    if ([_gradeTextField.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善年级信息" forSecond:1.5];
        
    }else if ([_classTextField.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善班级信息" forSecond:1.5];
        
    }else if ([_teacherTextField.text isEqualToString:@""]){
        [self showHudWithString:@"请完善班主任信息" forSecond:1.5];
        
    } else if ([_classNumTextField.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善班级人数" forSecond:1.5];
        
    }else{
    
        //幼儿园/小学/初中/机构/高中    1/2/3/4/5
        if ([school_type integerValue] == 1) {
            //幼儿园
//            _gradeTextField.placeholder = @"大/中/小";
//            _classTextField.placeholder = @"1~5";
            if (![_gradeTextField.text isEqualToString:@"大"] || ![_gradeTextField.text isEqualToString:@"中"] || ![_gradeTextField.text isEqualToString:@"小"]) {
                [self showHudWithString:@"年级名称请填写 '大'或'中'或'小'" forSecond:1.5];
            }else if ([_classTextField.text integerValue]<=0 || [_classTextField.text integerValue] > 5){
                [self showHudWithString:@"班级名称请输入1~5" forSecond:1.5];
            }

        }else if ([school_type integerValue] == 2) {
            //小学
//            _gradeTextField.placeholder = @"1~6";
//            _classTextField.placeholder = @"1~20";
            if ([_gradeTextField.text integerValue]<=0 || [_gradeTextField.text integerValue] > 6){
                [self showHudWithString:@"年级名称请输入1~6" forSecond:1.5];
            }else if ([_classTextField.text integerValue]<=0 || [_classTextField.text integerValue] > 20){
                [self showHudWithString:@"班级名称请输入1~20" forSecond:1.5];
            }
            
        }else if ([school_type integerValue] == 3) {
            //初中
//            _gradeTextField.placeholder = @"1~3";
//            _classTextField.placeholder = @"1~20";
            if ([_gradeTextField.text integerValue]<=0 || [_gradeTextField.text integerValue] > 3){
                [self showHudWithString:@"年级名称请输入1~3" forSecond:1.5];
            }else if ([_classTextField.text integerValue]<=0 || [_classTextField.text integerValue] > 20){
                [self showHudWithString:@"班级名称请输入1~20" forSecond:1.5];
            }
        }else if ([school_type integerValue] == 4) {
            //机构
//            _gradeTextField.placeholder = @"课程名称";
//            _classTextField.placeholder = @"1~5";
            if ([_classTextField.text integerValue]<=0 || [_classTextField.text integerValue] > 5){
                [self showHudWithString:@"班级名称请输入1~5" forSecond:1.5];
            }
        }else if ([school_type integerValue] == 5) {
            //高中
//            _gradeTextField.placeholder = @"1~3";
//            _classTextField.placeholder = @"1~20";
            if ([_gradeTextField.text integerValue]<=0 || [_gradeTextField.text integerValue] > 3){
                [self showHudWithString:@"年级名称请输入1~3" forSecond:1.5];
            }else if ([_classTextField.text integerValue]<=0 || [_classTextField.text integerValue] > 20){
                [self showHudWithString:@"班级名称请输入1~20" forSecond:1.5];
            }
        
        }
        
    }
    
    if (![settingTimeFlagStr isEqualToString:@"设置时间成功"]) {
        [self showHudWithString:@"请完善时间" forSecond:1.5];
    }else{
        
        [self releaseClassInfo];
    }
    
}


- (void)releaseClassInfo{
    XXEClassManagerAddClassInfoApi *classManagerAddClassInfoApi = [[XXEClassManagerAddClassInfoApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_type:_schoolType school_id:_schoolId position:_position grade:_gradeTextField.text class:_classTextField.text num_up:_classNumTextField.text teacher_boss:_teacherTextField.text];
    
    [classManagerAddClassInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//    NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"发布成功!" forSecond:1.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else if ([codeStr isEqualToString:@"6"]) {
            [self showHudWithString:@"班级已存在!" forSecond:1.5];
            
        }else{
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showHudWithString:@"发布失败!" forSecond:1.5];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}

@end
