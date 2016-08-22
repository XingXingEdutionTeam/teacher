//
//  XXEHomeworkIssueViewController.m
//  teacher
//
//  Created by Mac on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEHomeworkIssueViewController.h"
#import "XXEHomeworkIssueTextInfoApi.h"
#import "XXEHomeworkIssueTextAndPicInfoApi.h"
#import "XXEHomeworkGetCourseApi.h"
#import "HZQDatePickerView.h"
#import "FSImagePickerView.h"
#import "YTKBatchRequest.h"


@interface XXEHomeworkIssueViewController ()<HZQDatePickerViewDelegate,UITextFieldDelegate, UITextViewDelegate>
{

   HZQDatePickerView *_pikerView;
    FSImagePickerView *pickerView;
}

@property(nonatomic,strong)WJCommboxView *courseCombox;
@property(nonatomic,strong)UIView *courseBgView;
//科目
@property(nonatomic,strong)NSArray *teach_course_groupArray;
@property(nonatomic, copy) NSString *teacherCourseStr;


@end

@implementation XXEHomeworkIssueViewController


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    _teach_course_groupArray = [[NSArray alloc]init];
    [self getCourseInfo];

}


- (void)viewDidLoad {
    [super viewDidLoad];

    _submitTextField.tag = 1000;
    _submitTextField.delegate = self;
    
    _contentTextView.delegate = self;
    
//    _teacherCourseStr = @"";
    
    [self createContent];

}

- (void)getCourseInfo{

    XXEHomeworkGetCourseApi *homeworkGetCourseApi = [[XXEHomeworkGetCourseApi alloc] initWithXid:XID user_id:USER_ID user_type:USER_TYPE];
    [homeworkGetCourseApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//        NSLog(@"2222---   %@", request.responseJSONObject);
        /*
         2222---   {
         code = 1;
         data =     (
         "\U8bed\U6587",
         "\U97f3\U4e50"
         );
         msg = "Success!";
         }
         */
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
           _teach_course_groupArray = request.responseJSONObject[@"data"];

        }else{
            
        }
        if (_teach_course_groupArray.count != 0) {
            self.courseCombox.dataArray = _teach_course_groupArray;
            [self.courseCombox.listTableView reloadData];
            
        }
//        [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];


}


- (void)createContent{
    //----------------------科目 下拉框
    self.courseCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(104, 8, 263, 30)];
    self.courseCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    self.courseCombox.textField.placeholder = @"科目";
    self.courseCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.courseCombox.textField.tag = 1001;
//    [_subjectBgView addSubview:self.courseCombox];
    [self.view addSubview:self.courseCombox];
    
    self.courseBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kWidth,kHeight+300)];
    self.courseBgView.backgroundColor = [UIColor clearColor];
    self.courseBgView.alpha = 0.5;
    
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden)];
    [self.courseBgView addGestureRecognizer:singleTouch];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    
    //选择图片
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    pickerView = [[FSImagePickerView alloc] initWithFrame:CGRectMake(10, 30, kWidth - 10 * 2, 80) collectionViewLayout:layout1];
    pickerView.backgroundColor = UIColorFromRGB(255, 255, 255);
    pickerView.showsHorizontalScrollIndicator = NO;
    pickerView.controller = self;
    
    [self.upImageView addSubview:pickerView];
    
    
}

- (void)commboxAction:(NSNotification *)notif{

   [self.courseCombox removeFromSuperview];
            
   [self.view addSubview:self.courseBgView];
   [self.view addSubview:self.courseCombox];

    
}


- (void)commboxHidden{
    
    [self.courseBgView removeFromSuperview];
    [self.courseCombox setShowList:NO];
    self.courseCombox.listTableView.hidden = YES;
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{

    if (textField == _submitTextField) {
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
            self.submitTextField.text = [NSString stringWithFormat:@"%@", date];
            
            break;
            
        default:
            break;
    }
}



- (IBAction)certainButton:(id)sender {
    
//    NSLog(@"确定");
    _subjectStr = _subjectTextField.text;
    _contentStr = _contentTextView.text;
    _timeStr = _submitTextField.text;
    _teacherCourseStr = self.courseCombox.textField.text;
    
    if (_subjectStr == nil) {
        [self showHudWithString:@"请完善作业主题" forSecond:1.5];
    }else if (_contentStr == nil){
        [self showHudWithString:@"请完善作业内容" forSecond:1.5];
    }else if (_timeStr == nil){
        [self showHudWithString:@"请完善交作业时间" forSecond:1.5];
    }else{
    
        [self submitHomeworkInfo];
    
    }

    
}


- (void)submitHomeworkInfo{
    // pickerView.data  里面 有一张加号占位图,所有 个数最少有 1 张
    //如果 count == 1  -> 没有 上传 图片
    if (pickerView.data.count == 1){
        [self submitIssueTextInfo];
        
        //如果 count > 1 -> 有 上传 图片
    }else if (pickerView.data.count > 1){
        
        [self submitIssueTextAndPicInfo];
        
    }

}



//回复 只有  文字 的时候
- (void)submitIssueTextInfo{
    
    XXEHomeworkIssueTextInfoApi *homeworkIssueTextInfoApi = [[XXEHomeworkIssueTextInfoApi alloc] initWithXid:XID user_id:USER_ID user_type:USER_TYPE school_id:_schoolId class_id:_classId title:_subjectStr con:_contentStr teach_course:_teacherCourseStr date_end_tm:_timeStr];
    
    
    [homeworkIssueTextInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
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



- (void)submitIssueTextAndPicInfo{
//    NSLog(@"学校 %@ ---  班级%@ --- 标题%@ -- 内容 %@ -- 老师 %@ -- 截止时间 %@", _schoolId, _classId, _subjectStr, _contentStr, _teacherCourseStr, _timeStr);
    
    NSMutableArray *arr1 = [NSMutableArray array];
    
    for (int i = 0; i < pickerView.data.count - 1; i++) {
        
        FSImageModel *mdoel = pickerView.data[i];
        
        UIImage *image1 = [UIImage imageWithData:mdoel.data];
        [arr1 addObject:image1];
        
    }
    //    NSLog(@"上传 图片 %@", arr1);
    
    [self showHudWithString:@"正在上传......"];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i =0; i < arr1.count; i++) {
        XXEHomeworkIssueTextAndPicInfoApi *homeworkIssueTextAndPicInfoApi = [[XXEHomeworkIssueTextAndPicInfoApi alloc]initWithXid:XID user_id:USER_ID user_type:USER_TYPE school_id:_schoolId class_id:_classId title:_subjectStr con:_contentStr teach_course:_teacherCourseStr date_end_tm:_timeStr upImage:arr1[i]];
        [arr addObject:homeworkIssueTextAndPicInfoApi];
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



- (void)textViewDidChange:(UITextView *)textView{
    if (textView == _contentTextView) {
        self.numLabel.text=[NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
        _contentStr = textView.text;
    }
    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)dealloc{

[[NSNotificationCenter defaultCenter]removeObserver:self];

}


@end
