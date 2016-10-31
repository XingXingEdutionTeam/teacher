


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
    NSString *parameterXid;
    NSString *parameterUser_Id;

}


@end

@implementation XXEClassManagerClassReleaseViewController

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
    
    [self.navigationController pushViewController:classManagerSettingClassTimeVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)releaseButton:(UIButton *)sender {
      if ([_gradeTextField.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善年级信息" forSecond:1.5];
        
    } else if ([_gradeTextField.text integerValue] < 1 || [_gradeTextField.text integerValue] > 6) {
        [self showHudWithString:@"请输入1-6" forSecond:1.5];
        
    }else if ([_classTextField.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善班级信息" forSecond:1.5];
        
    }else if ([_classTextField.text integerValue] < 1 || [_classTextField.text integerValue] > 20) {
        [self showHudWithString:@"请输入1-20" forSecond:1.5];
        
    }else if ([_classNumTextField.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善班级人数" forSecond:1.5];
        
    }else if ([_teacherTextField.text isEqualToString:@""]){
        [self showHudWithString:@"请完善班主任信息" forSecond:1.5];
        
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
