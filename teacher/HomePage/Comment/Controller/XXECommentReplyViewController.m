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
    NSMutableArray *arr;
    NSString *url_groupStr;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXECommentReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    url_groupStr = @"";
    replyStr = @"";
    
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
    arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < pickerView.data.count - 1; i++) {
        FSImageModel *mdoel = pickerView.data[i];
        UIImage *image1 = [UIImage imageWithData:mdoel.data];
        [arr addObject:image1];
    }
    
    if (arr.count != 0) {
        [self submitReplyTextAndPicInfo];
    }else{
        if ([replyStr isEqualToString:@""]) {
            [self showHudWithString:@"请完善回复信息" forSecond:1.5];
        }else{
            [self submitReplyTextInfo];
        }
        
    }
    
}

//回复 文字 的时候
- (void)submitReplyTextInfo{

    XXEReplyTextInfoApi *replyTextInfoApi = [[XXEReplyTextInfoApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE class_id:_classId comment_id:_comment_id com_con:replyStr url_group:url_groupStr];
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




- (void)submitReplyTextAndPicInfo{

    /*
     【上传文件】
     
     接口:
     http://www.xingxingedu.cn/Global/uploadFile
     ★注: 默认传参只要appkey和backtype
     接口类型:2
     传参
     file_type	//文件类型,1图片,2视频 			  (必须)
     page_origin	//页面来源,传数字 			  (必须)
     18//老师点评
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
                                @"page_origin":@"18",
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
//    NSLog(@"111111<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<%@",dict);
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            NSArray *commentArray = [[NSArray alloc] init];
            
            commentArray = dict[@"data"];
            if (commentArray.count == 1) {
                url_groupStr = commentArray[0];
            }else if (commentArray.count > 1){
                
                NSMutableString *tidStr = [NSMutableString string];
                
                for (int j = 0; j < commentArray.count; j ++) {
                    NSString *str = commentArray[j];
                    
                    if (j != commentArray.count - 1) {
                        [tidStr appendFormat:@"%@,", str];
                    }else{
                        [tidStr appendFormat:@"%@", str];
                    }
                }
                
                url_groupStr = tidStr;
            }
            //                NSLog(@"修改 图片 %@", url_groupStr);
        }
        
        [self submitReplyTextInfo];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
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
