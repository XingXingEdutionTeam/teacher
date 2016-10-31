
//
//  XXEClassManagerSettingClassTimeViewController.m
//  teacher
//
//  Created by Mac on 16/9/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEClassManagerSettingClassTimeViewController.h"
#import "XXEClassManagerSettingClassTimeApi.h"
#import "XXEClassManagerClassDefaultTimeApi.h"
#import "HZQDatePickerView.h"

@interface XXEClassManagerSettingClassTimeViewController ()<HZQDatePickerViewDelegate, UITextFieldDelegate>
{
    HZQDatePickerView *_pikerView;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    NSInteger seletedTag;
    NSString *flagStr;
    
    //修改前时间
    NSString *oldSpringStartTime;
    NSString *oldSpringEndTime;
    NSString *oldAutumnStartTime;
    NSString *oldAutumnEndTime;
}




@end

@implementation XXEClassManagerSettingClassTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置学校开学时间";
    seletedTag = 0;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    _startMonthTextField1.delegate = self;
    _startMonthTextField2.delegate = self;

    _endMonthTextField1.delegate = self;
    _endMonthTextField2.delegate = self;
    
    [self fetchNetData];
 
}


- (void)fetchNetData{

    XXEClassManagerClassDefaultTimeApi *classManagerClassDefaultTimeApi = [[XXEClassManagerClassDefaultTimeApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:_schoolId position:_position];
    
    [classManagerClassDefaultTimeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//    NSLog(@"2222---   %@", request.responseJSONObject);

        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            NSDictionary *dic = request.responseJSONObject[@"data"];
            
            oldSpringStartTime = dic[@"term_start_tm_s"];
            oldSpringEndTime  = dic[@"term_start_tm_a"];
            oldAutumnStartTime = dic[@"term_end_tm_s"];
            oldAutumnEndTime = dic[@"term_end_tm_a"];
            
            _startMonthTextField1.text = dic[@"term_start_tm_s"];
            _startMonthTextField2.text = dic[@"term_start_tm_a"];
            
            _endMonthTextField1.text = dic[@"term_end_tm_s"];
            _endMonthTextField2.text = dic[@"term_end_tm_a"];
            
        }else{
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showHudWithString:@"发布失败!" forSecond:1.5];
    }];
}

- (IBAction)submitButton:(UIButton *)sender {
    
    if ([_startMonthTextField1.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善春季开学时间" forSecond:1.5];
        
    }else if ([_startMonthTextField1.text isEqualToString:oldSpringStartTime]) {
        [self showHudWithString:@"修改时间不能与原有时间一样" forSecond:1.5];
        
    }else if ([_endMonthTextField1.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善春季结束时间" forSecond:1.5];
        
    }else if ([_startMonthTextField1.text isEqualToString:oldSpringEndTime]) {
        [self showHudWithString:@"修改时间不能与原有时间一样" forSecond:1.5];
        
    }else if ([_startMonthTextField2.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善秋季开学时间" forSecond:1.5];
        
    }else if ([_startMonthTextField1.text isEqualToString:oldAutumnStartTime]) {
        [self showHudWithString:@"修改时间不能与原有时间一样" forSecond:1.5];
        
    }else if ([_endMonthTextField2.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善秋季结束时间" forSecond:1.5];
        
    }else if ([_startMonthTextField1.text isEqualToString:oldAutumnEndTime]) {
        [self showHudWithString:@"修改时间不能与原有时间一样" forSecond:1.5];
        
    }
    
   
    NSArray *startArray1 = [_startMonthTextField1.text componentsSeparatedByString:@"-"];
    NSString *startMonthStr1 = startArray1[0];
    NSString *startDayStr1 = startArray1[1];
    
    NSArray *endArray1 = [_endMonthTextField1.text componentsSeparatedByString:@"-"];
    NSString *endMonthStr1 = endArray1[0];
    NSString *endDayStr1 = endArray1[1];
    
    NSArray *startArray2 = [_startMonthTextField2.text componentsSeparatedByString:@"-"];
    NSString *startMonthStr2 = startArray2[0];
    NSString *startDayStr2 = startArray2[1];
    
    NSArray *endArray2 = [_endMonthTextField2.text componentsSeparatedByString:@"-"];
    NSString *endMonthStr2 = endArray2[0];
    NSString *endDayStr2 = endArray2[1];
    
    flagStr = @"1";
    
    if ([startMonthStr1 integerValue] > [endMonthStr1 integerValue]) {
        flagStr = @"0";
        [self showHudWithString:@"结束时间不能小于开始时间" forSecond:1.5];
    }else if ([startMonthStr1 integerValue] == [endMonthStr1 integerValue]){
        if ([startDayStr1 integerValue] >= [endDayStr1 integerValue]) {
            flagStr = @"0";
            [self showHudWithString:@"结束时间不能小于开始时间" forSecond:1.5];
        }
    
    }else if ([startMonthStr2 integerValue] > [endMonthStr2 integerValue]) {
        flagStr = @"0";
        [self showHudWithString:@"结束时间不能小于开始时间" forSecond:1.5];
    }else if ([startMonthStr2 integerValue] == [endMonthStr2 integerValue]){
        if ([startDayStr2 integerValue] >= [endDayStr2 integerValue]) {
            flagStr = @"0";
            [self showHudWithString:@"结束时间不能小于开始时间" forSecond:1.5];
        }
        
    }
    
    if ([flagStr isEqualToString:@"1"]) {
        [self releaseClassTimeInfo];
    }

}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == _startMonthTextField1) {
        seletedTag = 100;
        [self setupDateView:DateTypeOfStart];
        
    }else if (textField == _endMonthTextField1) {
        seletedTag = 101;
        [self setupDateView:DateTypeOfEnd];
        
    }else if (textField == _startMonthTextField2) {
        seletedTag = 102;
        [self setupDateView:DateTypeOfStart];
        
    }else if (textField == _endMonthTextField2) {
        seletedTag = 103;
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
//    [_pikerView.datePickerView setMinimumDate:[NSDate date]];
    // 在今天之前的日期
    //    [_pikerView.datePickerView setMaximumDate:[NSDate date]];
    [self.view addSubview:_pikerView];
    
}

- (void)getSelectDate:(NSString *)date type:(DateType)type {
    
    switch (type) {
        case DateTypeOfStart:{
            NSArray *array = [date componentsSeparatedByString:@" "];
            if (seletedTag == 100) {
                _startMonthTextField1.text = [array[0] substringFromIndex:5];
            }else if (seletedTag == 102){
                _startMonthTextField2.text = [array[0] substringFromIndex:5];
            }
            break;
            
        }
        case DateTypeOfEnd:{
            NSArray *array = [date componentsSeparatedByString:@" "];
            if (seletedTag == 101) {
                _endMonthTextField1.text = [array[0]  substringFromIndex:5];
            }else if (seletedTag == 103){
                _endMonthTextField2.text = [array[0] substringFromIndex:5];
            }
            break;
            
        }
        default:
            break;
    }
}


- (void)releaseClassTimeInfo{
    XXEClassManagerSettingClassTimeApi *classManagerSettingClassTimeApi = [[XXEClassManagerSettingClassTimeApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:_schoolId position:_position term_start_tm_s:_startMonthTextField1.text term_end_tm_s:_endMonthTextField1.text term_start_tm_a:_startMonthTextField2.text term_end_tm_a:_endMonthTextField2.text];
    
    [classManagerSettingClassTimeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//            NSLog(@"2222---   %@", request.responseJSONObject);
        
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
