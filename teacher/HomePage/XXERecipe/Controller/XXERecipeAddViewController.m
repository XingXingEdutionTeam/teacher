

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
    
    //原始 所有图片 数组
    NSMutableArray *arr;
    //转化后的 图片 数组
    NSMutableArray *arr1;
    NSMutableArray *arr2;
    NSMutableArray *arr3;
    //upload_format	//上传格式, 传数字,1:单个上传  2:批量上传 (必须)
    NSString *upload_format;
    
    NSArray *breakfastArray;
    NSArray *lunchArray;
    NSArray *dinnerArray;
    
    NSString *breakfastPicStr;
    NSString *lunchPicStr;
    NSString *dinnerPicStr;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXERecipeAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arr1 = [NSMutableArray array];
    arr2 = [NSMutableArray array];
    arr3 = [NSMutableArray array];
    arr = [NSMutableArray array];
    
    breakfastArray = [[NSArray alloc] init];
    lunchArray = [[NSArray alloc] init];
    dinnerArray = [[NSArray alloc] init];
    
    breakfastStr = @"";
    lunchStr = @"";
    dinnerStr = @"";
    
    breakfastPicStr = @"";
    lunchPicStr = @"";
    dinnerPicStr = @"";
    

    self.title = @"上传食谱";
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
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
    pickerView1 = [[FSImagePickerView alloc] initWithFrame:CGRectMake(10, 5 * kScreenRatioHeight, kWidth - 10 * kScreenRatioWidth * 2, 80 * kScreenRatioHeight) collectionViewLayout:layout1];
    pickerView1.showsHorizontalScrollIndicator = NO;
    pickerView1.backgroundColor = [UIColor whiteColor];
    pickerView1.controller = self;
    
    [_breakfastUpImageView addSubview:pickerView1];
    
    //选择图片
    UICollectionViewFlowLayout *layout2 = [[UICollectionViewFlowLayout alloc] init];
    layout2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    pickerView2 = [[FSImagePickerView alloc] initWithFrame:CGRectMake(10, 5 * kScreenRatioHeight, kWidth - 10 * kScreenRatioWidth * 2, 80 * kScreenRatioHeight) collectionViewLayout:layout2];
    pickerView2.showsHorizontalScrollIndicator = NO;
    pickerView2.backgroundColor = [UIColor whiteColor];
    pickerView2.controller = self;
    
    [_lunchUpImageView addSubview:pickerView2];
    
    //选择图片
    UICollectionViewFlowLayout *layout3 = [[UICollectionViewFlowLayout alloc] init];
    layout3.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    pickerView3 = [[FSImagePickerView alloc] initWithFrame:CGRectMake(10, 5 * kScreenRatioHeight, kWidth - 10 * kScreenRatioWidth * 2, 80 * kScreenRatioHeight) collectionViewLayout:layout3];
    pickerView3.showsHorizontalScrollIndicator = NO;
    pickerView3.backgroundColor = [UIColor whiteColor];
    pickerView3.controller = self;
    
    [_dinnerUpImageView addSubview:pickerView3];

}



- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == _timeTextField) {
        
        [textField resignFirstResponder];
        [self setupDateView:DateTypeOfStart];
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
//            NSLog(@"时间  %@", date);
            //2016-08-23 18:16:14
          NSArray *array = [date componentsSeparatedByString:@" "];
          self.timeTextField.text = array[0];
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
    
//    if (![breakfastStr isEqualToString:@""] && ![lunchStr isEqualToString:@""] && ![dinnerStr isEqualToString:@""]) {
//        <#statements#>
//    }
    
    // pickerView.data  里面 有一张加号占位图,所有 个数最少有 1 张
    for (int i = 0; i < pickerView1.data.count - 1; i++) {
        FSImageModel *mdoel = pickerView1.data[i];
        UIImage *image1 = [UIImage imageWithData:mdoel.data];
        [arr1 addObject:image1];
    }
    
    [arr addObjectsFromArray:arr1];
    
    for (int i = 0; i < pickerView2.data.count - 1; i++) {
        FSImageModel *mdoel = pickerView2.data[i];
        UIImage *image1 = [UIImage imageWithData:mdoel.data];
        [arr2 addObject:image1];
    }
    
    [arr addObjectsFromArray:arr2];
    
    for (int i = 0; i < pickerView3.data.count - 1; i++) {
        FSImageModel *mdoel = pickerView3.data[i];
        UIImage *image1 = [UIImage imageWithData:mdoel.data];
        [arr3 addObject:image1];
    }
    
    [arr addObjectsFromArray:arr3];
    
    if ([timeStr isEqualToString:@""]) {
        [self showHudWithString:@"请完发布时间" forSecond:1.5];
    }else if ([breakfastStr isEqualToString:@""] && [lunchStr isEqualToString:@""] && [dinnerStr isEqualToString:@""] && arr.count == 0) {
        [self showHudWithString:@"请完善信息" forSecond:1.5];
    }else{
        [self showHudWithString:@"正在上传中......"];
        if (arr1.count != 0) {
            [self submitRecipeAddTextAndPicInfo1];
        }else if (arr2.count != 0){
            [self submitRecipeAddTextAndPicInfo2];
        }else if (arr3.count != 0) {
            [self submitRecipeAddTextAndPicInfo3];
        }else{
            [self submitRecipeAddTextInfo];
            
        }
    }
}


//回复 只有  文字 的时候
- (void)submitRecipeAddTextInfo{
    
    /*
     【食谱->发布】
     接口类型:2
     接口:
     http://www.xingxingedu.cn/Teacher/school_cookbook_publish
     传参:
     school_id	//学校id
     position	//身份,传数字(1教师/2班主任/3管理/4校长)
     date_tm		//日期(格式:2016-08-02 ,注:没有时分秒)
     breakfast_name	//早餐名
     lunch_name	//午餐名
     dinner_name	//晚餐
     breakfast_url	//早餐图片(url集合,多个逗号隔开)
     lunch_url	//午餐图片(url集合,多个逗号隔开)
     dinner_url	//晚餐图片(url集合,多个逗号隔开)
     */
    
    XXERecipeAddTextApi *recipeAddTextApi = [[XXERecipeAddTextApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE school_id:_schoolId position:_position date_tm:timeStr breakfast_name:breakfastStr lunch_name:lunchStr dinner_name:dinnerStr breakfast_url:breakfastPicStr lunch_url:lunchPicStr dinner_url:dinnerPicStr];
    
    NSLog(@"早餐--- %@ 午餐 --- %@ 晚餐 -- %@", breakfastStr, lunchPicStr, dinnerPicStr);
    
    [recipeAddTextApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"发布成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else if([codeStr isEqualToString:@"7"]){
            [self showHudWithString:@"该日期已存在,不能重复上传"];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showHudWithString:@"发布失败!" forSecond:1.5];
    }];
    
}


- (void)submitRecipeAddTextAndPicInfo1{
    /*
     【上传文件】
     
     接口:
     http://www.xingxingedu.cn/Global/uploadFile
     ★注: 默认传参只要appkey和backtype
     接口类型:2
     传参
     file_type	//文件类型,1图片,2视频 			  (必须)
     page_origin	//页面来源,传数字 			  (必须)
    11//学校食谱
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
                                @"page_origin":@"11",
                                @"upload_format":@"2"
                                };

    AFHTTPRequestOperationManager *mgr =[AFHTTPRequestOperationManager manager];
    [mgr POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        for (int i = 0; i< arr1.count; i++) {
            NSData *data = UIImageJPEGRepresentation(arr1[i], 0.5);
            NSString *name = [NSString stringWithFormat:@"%d.jpeg",i];
            NSString *formKey = [NSString stringWithFormat:@"file%d",i];
            NSString *type = @"image/jpeg";
            [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
        }
        

    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict =responseObject;
//          NSLog(@"111111<<<<<<<<<<<<<<<<<<<%@",dict);
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            breakfastArray = dict[@"data"];
                if (breakfastArray.count == 1) {
                    breakfastPicStr = breakfastArray[0];
                }else if (breakfastArray.count > 1){
                
                    NSMutableString *tidStr = [NSMutableString string];
                    
                    for (int j = 0; j < breakfastArray.count; j ++) {
                        NSString *str = breakfastArray[j];
                        
                        if (j != breakfastArray.count - 1) {
                            [tidStr appendFormat:@"%@,", str];
                        }else{
                            [tidStr appendFormat:@"%@", str];
                        }
                    }
                    
                    breakfastPicStr = tidStr;
                }

            
//            NSLog(@"早餐  图片  -- 字符串 %@", breakfastPicStr);
        }
        
        if (arr2.count != 0) {
            [self submitRecipeAddTextAndPicInfo2];
        }else if (arr3.count != 0) {
            [self submitRecipeAddTextAndPicInfo3];
        }else{
  
        [self submitRecipeAddTextInfo];

        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
          NSLog(@"%@", error);
    }];

}

- (void)submitRecipeAddTextAndPicInfo2{

    NSString *url = @"http://www.xingxingedu.cn/Global/uploadFile";
    
    NSDictionary *parameter = @{
                                @"appkey":APPKEY,
                                @"backtype":BACKTYPE,
                                @"xid":parameterXid,
                                @"user_id":parameterUser_Id,
                                @"user_type":USER_TYPE,
                                @"file_type":@"1",
                                @"page_origin":@"11",
                                @"upload_format":@"2"
                                };
    //    NSLog(@"传参 --  %@", parameter);
    
    AFHTTPRequestOperationManager *mgr =[AFHTTPRequestOperationManager manager];
    [mgr POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i< arr2.count; i++) {
            NSData *data = UIImageJPEGRepresentation(arr2[i], 0.5);
            NSString *name = [NSString stringWithFormat:@"%d.jpeg",i];
            NSString *formKey = [NSString stringWithFormat:@"file%d",i];
            NSString *type = @"image/jpeg";
            [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
        }
        
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict =responseObject;
//        NSLog(@"午餐  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<%@",dict);
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            lunchArray = dict[@"data"];
                if (lunchArray.count == 1) {
                    lunchPicStr = lunchArray[0];
                }else if (lunchArray.count > 1){
                    
                    NSMutableString *tidStr = [NSMutableString string];
                    
                    for (int j = 0; j < lunchArray.count; j ++) {
                        NSString *str = lunchArray[j];
                        
                        if (j != lunchArray.count - 1) {
                            [tidStr appendFormat:@"%@,", str];
                        }else{
                            [tidStr appendFormat:@"%@", str];
                        }
                    }
                    
                    lunchPicStr = tidStr;
                }
            
//            NSLog(@"午餐  图片  -- 字符串 %@", lunchPicStr);
            
        }
        if (arr3.count != 0) {
            [self submitRecipeAddTextAndPicInfo3];
        }else{
       
        [self submitRecipeAddTextInfo];

        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)submitRecipeAddTextAndPicInfo3{

    NSString *url = @"http://www.xingxingedu.cn/Global/uploadFile";
    
    NSDictionary *parameter = @{
                                @"appkey":APPKEY,
                                @"backtype":BACKTYPE,
                                @"xid":parameterXid,
                                @"user_id":parameterUser_Id,
                                @"user_type":USER_TYPE,
                                @"file_type":@"1",
                                @"page_origin":@"11",
                                @"upload_format":@"2"
                                };
    //    NSLog(@"传参 --  %@", parameter);
    
    AFHTTPRequestOperationManager *mgr =[AFHTTPRequestOperationManager manager];
    [mgr POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i< arr3.count; i++) {
            NSData *data = UIImageJPEGRepresentation(arr3[i], 0.5);
            NSString *name = [NSString stringWithFormat:@"%d.jpeg",i];
            NSString *formKey = [NSString stringWithFormat:@"file%d",i];
            NSString *type = @"image/jpeg";
            [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
        }
        
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict =responseObject;
//        NSLog(@"晚餐<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<%@",dict);
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            dinnerArray = dict[@"data"];
        
                if (dinnerArray.count == 1) {
                    dinnerPicStr = dinnerArray[0];
                }else if (dinnerArray.count > 1){
                    
                    NSMutableString *tidStr = [NSMutableString string];
                    
                    for (int j = 0; j < dinnerArray.count; j ++) {
                        NSString *str = dinnerArray[j];
                        
                        if (j != dinnerArray.count - 1) {
                            [tidStr appendFormat:@"%@,", str];
                        }else{
                            [tidStr appendFormat:@"%@", str];
                        }
                    }
                    
                    dinnerPicStr = tidStr;
                }
            
//            NSLog(@"晚餐  图片  -- 字符串 %@", dinnerPicStr);
            
        }

        [self submitRecipeAddTextInfo];
      } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}


- (void)textViewDidChange:(UITextView *)textView{
    if (textView == _breakfastTextView || textView == _lunchTextView || textView == _dinnerTextView) {
        
        if (textView.text.length <= 50) {
//            numLabel.text=[NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
        }else{
            [self showHudWithString:@"最多可输入50个字符"];
            textView.text = [textView.text substringToIndex:50];
        }
//        conStr = textView.text;
    }
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView{

    return [textView resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
