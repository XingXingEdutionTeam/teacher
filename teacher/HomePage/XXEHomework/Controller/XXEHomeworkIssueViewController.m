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
    NSMutableArray *arr;
    NSString *url_groupStr;
    NSString *parameterXid;
    NSString *parameterUser_Id;
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
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    _schoolId = @"";
    _classId = @"";
    _subjectStr = @"";
    _contentStr = @"";
    _timeStr = @"";
    _teacherCourseStr = @"";
    url_groupStr = @"";
    
    [self getCourseInfo];

}


- (void)viewDidLoad {
    [super viewDidLoad];

    _submitTextField.tag = 1000;
    _submitTextField.delegate = self;
    _contentTextView.delegate = self;
    

    [self createContent];

}

- (void)getCourseInfo{

    XXEHomeworkGetCourseApi *homeworkGetCourseApi = [[XXEHomeworkGetCourseApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE];
    [homeworkGetCourseApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//        NSLog(@"2222---   %@", request.responseJSONObject);
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
    
    
    if ([_teacherCourseStr isEqualToString:@""]) {
        [self showHudWithString:@"请完善作业科目" forSecond:1.5];
    }else if ([_subjectStr isEqualToString:@""]) {
        [self showHudWithString:@"请完善作业主题" forSecond:1.5];
    }else if ([_contentStr isEqualToString:@""]){
        [self showHudWithString:@"请完善作业内容" forSecond:1.5];
    }else if ([_timeStr isEqualToString:@""]){
        [self showHudWithString:@"请完善交作业时间" forSecond:1.5];
    }else{
    
        [self submitHomeworkInfo];
    
    }

    
}


- (void)submitHomeworkInfo{
    // pickerView.data  里面 有一张加号占位图,所有 个数最少有 1 张
    //如果 count == 1  -> 没有 上传 图片
    arr = [[NSMutableArray alloc] init];
    
    if (pickerView.data.count > 1) {
        for (int i = 0; i < pickerView.data.count - 1; i++) {
            FSImageModel *mdoel = pickerView.data[i];
            UIImage *image1 = [UIImage imageWithData:mdoel.data];
            [arr addObject:image1];
        }
        [self submitIssueTextAndPicInfo];
    }else{
        [self submitIssueTextInfo];
    }

}



//回复 只有  文字 的时候
- (void)submitIssueTextInfo{
    
//    NSLog(@"_schoolId:%@ --- _classId:%@ ",_schoolId, _classId);
    
    XXEHomeworkIssueTextInfoApi *homeworkIssueTextInfoApi = [[XXEHomeworkIssueTextInfoApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE school_id:_schoolId class_id:_classId title:_subjectStr con:_contentStr teach_course:_teacherCourseStr date_end_tm:_timeStr url_group:url_groupStr];
    
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
    /*
     【上传文件】
     
     接口:
     http://www.xingxingedu.cn/Global/uploadFile
     ★注: 默认传参只要appkey和backtype
     接口类型:2
     传参
     file_type	//文件类型,1图片,2视频 			  (必须)
     page_origin	//页面来源,传数字 			  (必须)
     17	//班级作业
     upload_format	//上传格式, 传数字,1:单个上传  2:批量上传 (必须)
     file		//文件数据的数组名 			  (必须)
     */
    NSString *url = @"http://www.xingxingedu.cn/Global/uploadFile";
    
    NSDictionary *parameter = @{
                                @"appkey":APPKEY,
                                @"backtype":BACKTYPE,
                                @"xid":parameterXid,
                                @"user_id":parameterUser_Id,
                                @"user_type":USER_TYPE,
                                @"file_type":@"1",
                                @"page_origin":@"17",
                                @"upload_format":@"2"
                                };
    
    AFHTTPRequestOperationManager *mgr =[AFHTTPRequestOperationManager manager];
    [mgr POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i< arr.count; i++) {
            NSData *data = UIImageJPEGRepresentation(arr[i], 0.5);
            NSString *name = [NSString stringWithFormat:@"%d.jpeg",i];
            NSString *formKey = [NSString stringWithFormat:@"file%d",i];
            NSString *type = @"image/jpeg";
            [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
        }
        
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict =responseObject;
        NSLog(@"111111<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<%@",dict);
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            
            NSArray *homeworkPicArray = [[NSArray alloc] init];
            homeworkPicArray = dict[@"data"];
            if (homeworkPicArray.count == 1) {
                url_groupStr = homeworkPicArray[0];
            }else if (homeworkPicArray.count > 1){
                
                NSMutableString *tidStr = [NSMutableString string];
                
                for (int j = 0; j < homeworkPicArray.count; j ++) {
                    NSString *str = homeworkPicArray[j];
                    
                    if (j != homeworkPicArray.count - 1) {
                        [tidStr appendFormat:@"%@,", str];
                    }else{
                        [tidStr appendFormat:@"%@", str];
                    }
                }
                
                url_groupStr = tidStr;
            }
                            NSLog(@"修改 图片 %@", url_groupStr);
        }
        
        [self submitIssueTextInfo];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
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
