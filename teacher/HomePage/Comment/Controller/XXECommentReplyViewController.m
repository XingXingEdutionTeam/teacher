//
//  XXECommentReplyViewController.m
//  teacher
//
//  Created by Mac on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECommentReplyViewController.h"
#import "FSImagePickerView.h"
#import "YTKBatchRequest.h"
#import "FSImageModel.h"
//评论回复 只有 文字的时候 调用的接口
#import "XXEReplyTextInfoApi.h"
//评论回复 既有 文字 又有 图片 的时候 调用的接口
#import "XXEReplyTextAndPicInfoApi.h"


@interface XXECommentReplyViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextViewDelegate>

{
    NSString *replyStr;
    //添加 照片
    FSImagePickerView *pickerView;

}


@end

@implementation XXECommentReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self createContent];

}


- (void)createContent{

    _babyNameLabel.text = _babyName;
    
    _askContentTextView.text = _askContent;

    _askTimeLabel.text = [XXETool dateStringFromNumberTimer:_askTime];

    //选择图片
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    pickerView = [[FSImagePickerView alloc] initWithFrame:CGRectMake(10, 30, kWidth - 10 * 2, 80) collectionViewLayout:layout1];
    pickerView.backgroundColor = UIColorFromRGB(255, 255, 255);
    pickerView.showsHorizontalScrollIndicator = NO;
    pickerView.controller = self;
    
    [self.upImageView addSubview:pickerView];
    
    _replyTextField.delegate = self;

}


//确认 点评  分两种 情况:有照片 和 无 照片
- (IBAction)certainButton:(UIButton *)sender {
    // pickerView.data  里面 有一张加号占位图,所有 个数最少有 1 张
    //如果 count == 1  -> 没有 上传 图片
    if (pickerView.data.count == 1){
        [self submitReplyTextInfo];
        
        //如果 count > 1 -> 有 上传 图片
    }else if (pickerView.data.count > 1){
        
        [self submitReplyTextAndPicInfo];

    }
    
}

//回复 只有  文字 的时候
- (void)submitReplyTextInfo{

    XXEReplyTextInfoApi *replyTextInfoApi = [[XXEReplyTextInfoApi alloc] initWithXid:XID user_id:USER_ID user_type:USER_TYPE class_id:_classId comment_id:_comment_id com_con:replyStr];
    [replyTextInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//       NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"回复成功!" forSecond:1.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            
        }

    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showHudWithString:@"回复失败!" forSecond:1.5];
    }];
    
}


//- (void)submitReplyTextAndPicInfo{
//    /*
//     【点评->处理家长请求的点评】
//     
//     接口类型:2
//     
//     接口:
//     http://www.xingxingedu.cn/Teacher/request_comment_action
//     
//     
//     传参:
//     class_id	//班级id
//     comment_id	//评论id
//     com_con		//评论内容
//     file		//批量上传图片 ★现在的版本没有上传图片的,应该是之前遗漏了,请加上
//     */
//    NSMutableArray *arr1 = [NSMutableArray array];
//    for (int i = 0; i < pickerView.data.count - 1; i++) {
//        FSImageModel *mdoel = pickerView.data[i];
//        UIImage *image1 = [UIImage imageWithData:mdoel.data];
//        [arr1 addObject:image1];
//    }
//    //    NSLog(@"上传 图片 %@", arr1);
//    
//    //        [self showHudWithString:@"正在上传......"];
//    //        NSMutableArray *arr = [NSMutableArray array];
//    NSString *url = @"http://www.xingxingedu.cn/Teacher/request_comment_action";
//    
//    NSDictionary *parameter = @{
//                                @"appkey":APPKEY,
//                                @"backtype":BACKTYPE,
//                                @"xid":XID,
//                                @"user_id":USER_ID,
//                                @"user_type":USER_TYPE,
//                                @"class_id":_classId,
//                                @"comment_id":_comment_id,
//                                @"com_con":replyStr
//                                };
//    // @"file":_upImage
//    NSLog(@"传参 --  %@", parameter);
//    
//    NSLog(@"%@", arr1);
//
//    AFHTTPRequestOperationManager *mgr =[AFHTTPRequestOperationManager manager];
//    [mgr POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
////        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
//        for (int i = 0; i< arr1.count; i++) {
//            
//            //NSData *data =UIImagePNGRepresentation(arr1[i]);
//            // NSString *fileName =[NSString stringWithFormat:@"%d.png", i];
//            // [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
//            
//            NSData *data = UIImageJPEGRepresentation(arr1[i], 0.5);
//            NSString *name = [NSString stringWithFormat:@"%d.jpeg",i];
//            NSString *formKey = [NSString stringWithFormat:@"file%d",i];
//            NSString *type = @"image/jpeg";
//            [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
//            
//        }
//        
//    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSDictionary *dict =responseObject;
//          NSLog(@"111111<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<%@",dict);
//        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
//        {
//        
//           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.navigationController popViewControllerAnimated:YES];
//            });
//
//        }
//        
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        //  NSLog(@"EROOROROOREROOROROOREROOROROOREROOROROOREROOROROORE");
//        
//          NSLog(@"3333333%@", error);
//    }];
//    
//}


- (void)submitReplyTextAndPicInfo{

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
    XXEReplyTextAndPicInfoApi *replyTextAndPicInfoApi = [[XXEReplyTextAndPicInfoApi alloc] initWithXid:XID user_id:USER_ID user_type:USER_TYPE class_id:_classId comment_id:_comment_id com_con:replyStr upImage:arr1[i]];
        [arr addObject:replyTextAndPicInfoApi];
    }
    
    YTKBatchRequest *bathRequest = [[YTKBatchRequest alloc]initWithRequestArray:arr];
    [bathRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
        //        NSLog(@"%@",bathRequest);
        
        [self hideHud];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(YTKBatchRequest *batchRequest) {
        [self showHudWithString:@"上传失败" forSecond:1.f];
    }];
    

}


- (void)textViewDidChange:(UITextView *)textView{
    if (textView == _replyTextField) {
        self.replyNumLabel.text=[NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
        replyStr = textView.text;
    }
    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
