

//
//  XXERecipeAddViewController.m
//  teacher
//
//  Created by Mac on 16/8/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERecipeAddViewController.h"
#import "HZQDatePickerView.h"
#import "FSImagePickerView.h"
#import "YTKBatchRequest.h"
#import "XXERecipeAddTextApi.h"
#import "XXERecipeAddTextAndPicApi.h"



@interface XXERecipeAddViewController ()<HZQDatePickerViewDelegate,UITextFieldDelegate, UITextViewDelegate>
{
    
    HZQDatePickerView *_pikerView;
    //早
    FSImagePickerView *pickerView1;
    //中
    FSImagePickerView *pickerView2;
    //晚
    FSImagePickerView *pickerView3;
    //时间
    NSString *timeStr;
    //早餐
    NSString *breakfastStr;
    //午餐
    NSString *lunchStr;
    //晚餐
    NSString *dinnerStr;
    
    
}


@end

@implementation XXERecipeAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"上传食谱";
    
    [self createContent];
    
}


- (void)createContent{

    _timeTextField.delegate = self;
    _breakfastTextView.delegate = self;
    _lunchTextView.delegate = self;
    _dinnerTextView.delegate = self;
    
    //选择图片
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    pickerView1 = [[FSImagePickerView alloc] initWithFrame:CGRectMake(10, 10, kWidth - 10 * 2, 80) collectionViewLayout:layout1];
    pickerView1.showsHorizontalScrollIndicator = NO;
    pickerView1.backgroundColor = [UIColor whiteColor];
    pickerView1.controller = self;
    
    [_breakfastUpImageView addSubview:pickerView1];
    
    //选择图片
    UICollectionViewFlowLayout *layout2 = [[UICollectionViewFlowLayout alloc] init];
    layout2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    pickerView2 = [[FSImagePickerView alloc] initWithFrame:CGRectMake(10, 10, kWidth - 10 * 2, 80) collectionViewLayout:layout2];
    pickerView2.showsHorizontalScrollIndicator = NO;
    pickerView2.backgroundColor = [UIColor whiteColor];
    pickerView2.controller = self;
    
    [_lunchUpImageView addSubview:pickerView2];
    
    //选择图片
    UICollectionViewFlowLayout *layout3 = [[UICollectionViewFlowLayout alloc] init];
    layout3.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    pickerView3 = [[FSImagePickerView alloc] initWithFrame:CGRectMake(10, 10, kWidth - 10 * 2, 80) collectionViewLayout:layout3];
    pickerView3.showsHorizontalScrollIndicator = NO;
    pickerView3.backgroundColor = [UIColor whiteColor];
    pickerView3.controller = self;
    
    [_dinnerUpImageView addSubview:pickerView3];

}



- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == _timeTextField) {
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
    [_pikerView.datePickerView setMinimumDate:[NSDate date]];
    // 在今天之前的日期
    //    [_pikerView.datePickerView setMaximumDate:[NSDate date]];
    [self.view addSubview:_pikerView];
    
}

- (void)getSelectDate:(NSString *)date type:(DateType)type {
    
    switch (type) {
        case DateTypeOfStart:
        {
//            NSLog(@"时间  %@", date);2016-08-23 18:16:14
          NSArray *arr = [date componentsSeparatedByString:@" "];
          self.timeTextField.text = arr[0];
            break;
        }
        default:
            break;
    }
}


- (IBAction)certainButton:(UIButton *)sender {
    //必填 参数
    timeStr = _timeTextField.text;
    breakfastStr = _breakfastTextView.text;
    lunchStr = _lunchTextView.text;
    dinnerStr = _dinnerTextView.text;
    
    
    if (timeStr == nil) {
        [self showHudWithString:@"请完发布时间" forSecond:1.5];
    }else if (breakfastStr == nil){
        [self showHudWithString:@"请完善早餐内容" forSecond:1.5];
    }else if (lunchStr == nil){
        [self showHudWithString:@"请完善午餐内容" forSecond:1.5];
    }else if (dinnerStr == nil){
        [self showHudWithString:@"请完善晚餐内容" forSecond:1.5];
    }else{
        
        [self submitRecipeAddInfo];
        
    }
    
    
}

- (void)submitRecipeAddInfo{
    // pickerView.data  里面 有一张加号占位图,所有 个数最少有 1 张
    //如果 count == 1  -> 没有 上传 图片
    if (pickerView1.data.count == 1 && pickerView2.data.count == 1 && pickerView3.data.count == 1){
        [self submitRecipeAddTextInfo];
        
        //如果 count > 1 -> 有 上传 图片
    }else {
        
        [self submitRecipeAddTextAndPicInfo];
        
    }
    
}



//回复 只有  文字 的时候
- (void)submitRecipeAddTextInfo{
    
    XXERecipeAddTextApi *recipeAddTextApi = [[XXERecipeAddTextApi alloc] initWithXid:XID user_id:USER_ID user_type:USER_TYPE school_id:_schoolId position:@"4" date_tm:timeStr breakfast_name:breakfastStr lunch_name:lunchStr dinner_name:dinnerStr];

    [recipeAddTextApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        //               NSLog(@"2222---   %@", request.responseJSONObject);
        
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



- (void)submitRecipeAddTextAndPicInfo{
    //    NSLog(@"学校 %@ ---  班级%@ --- 标题%@ -- 内容 %@ -- 老师 %@ -- 截止时间 %@", _schoolId, _classId, _subjectStr, _contentStr, _teacherCourseStr, _timeStr);
    
    NSMutableArray *arr1 = [NSMutableArray array];
    
    for (int i = 0; i < pickerView1.data.count - 1; i++) {
        
        FSImageModel *mdoel = pickerView1.data[i];
        
        UIImage *image1 = [UIImage imageWithData:mdoel.data];
        [arr1 addObject:image1];
        
    }
    for (int i = 0; i < pickerView2.data.count - 1; i++) {
        
        FSImageModel *mdoel = pickerView2.data[i];
        
        UIImage *image1 = [UIImage imageWithData:mdoel.data];
        [arr1 addObject:image1];
        
    }
    for (int i = 0; i < pickerView3.data.count - 1; i++) {
        
        FSImageModel *mdoel = pickerView3.data[i];
        
        UIImage *image1 = [UIImage imageWithData:mdoel.data];
        [arr1 addObject:image1];
        
    }
    
    
    //    NSLog(@"上传 图片 %@", arr1);
    
    [self showHudWithString:@"正在上传......"];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i =0; i < arr1.count; i++) {
//        XXERecipeAddTextAndPicApi *homeworkIssueTextAndPicInfoApi = [[XXEHomeworkIssueTextAndPicInfoApi alloc]initWithXid:XID user_id:USER_ID user_type:USER_TYPE school_id:_schoolId class_id:_classId title:_subjectStr con:_contentStr teach_course:_teacherCourseStr date_end_tm:_timeStr upImage:arr1[i]];
//        [arr addObject:homeworkIssueTextAndPicInfoApi];
    }
    
    YTKBatchRequest *bathRequest = [[YTKBatchRequest alloc]initWithRequestArray:arr];
    [bathRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
        
        //        NSLog(@"hjshafka  ====   %@",bathRequest);
        
        [self hideHud];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(YTKBatchRequest *batchRequest) {
        [self showHudWithString:@"上传失败" forSecond:1.f];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
