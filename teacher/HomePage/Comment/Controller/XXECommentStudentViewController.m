



//
//  XXECommentStudentViewController.m
//  teacher
//
//  Created by Mac on 16/8/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECommentStudentViewController.h"
#import "XXEChiefAndTeacherViewController.h"
#import "XXEManagerAndHeadmasterViewController.h"
#import "DynamicScrollView.h"
#import "FSImagePickerView.h"
//#import "XXEInitiativeCommentCertainApi.h"
#import "YTKBatchRequest.h"
#import "FSImageModel.h"
//评论回复 只有 文字的时候 调用的接口
#import "XXECommentTextInfoApi.h"
//评论回复 既有 文字 又有 图片 的时候 调用的接口
#import "XXECommentTextAndPicInfoApi.h"

@interface XXECommentStudentViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextViewDelegate>
{
    DynamicScrollView *dynamicScrollView;
    NSMutableArray *didSelectBabyNameArray;//选中宝贝 名称  数组
    NSMutableArray *didSelectBabyIdArray;//选中宝贝 id  数组
    NSMutableArray *didSelectSchoolIdArray;//选中宝贝 学校 id  数组
    NSMutableArray *didSelectClassIdArray;//选中宝贝 班级 id  数组
    
    NSString *babyIdStr; //选中 的 宝贝 id
    NSString *jsonString;
    //添加 照片
    FSImagePickerView *pickerView;
    
    NSString *conStr;
    
    NSMutableArray *arr;
    NSString *url_groupStr;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@property (nonatomic, strong) NSMutableArray *selectedBabyInfoArray;


@end

@implementation XXECommentStudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    didSelectBabyNameArray = [[NSMutableArray alloc] init];
    didSelectBabyIdArray = [[NSMutableArray alloc] init];
    didSelectSchoolIdArray = [[NSMutableArray alloc] init];
    didSelectClassIdArray = [[NSMutableArray alloc] init];
    
    url_groupStr = @"";
    conStr = @"";
    
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
    
    //选中 宝贝 头像 / 名称
    //选取控件
    dynamicScrollView = [[DynamicScrollView alloc] initWithFrame:CGRectMake(80 * kScreenRatioWidth,10 * kScreenRatioHeight,WinWidth-80,70 * kScreenRatioHeight) withImages:nil];
    [self.view addSubview:dynamicScrollView];
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(removeSuccess:) name:@"TeacherNameRemoveSuccess" object:nil];
    
    //选择图片
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    pickerView = [[FSImagePickerView alloc] initWithFrame:CGRectMake(10, 40 * kScreenRatioHeight, kWidth - 10 * kScreenRatioWidth * 2, 80 * kScreenRatioHeight) collectionViewLayout:layout1];
    pickerView.backgroundColor = UIColorFromRGB(255, 255, 255);
    pickerView.showsHorizontalScrollIndicator = NO;
    pickerView.controller = self;
    
    [self.upPicImageView addSubview:pickerView];
    
    _contentTextField.delegate = self;
    
}


- (void)removeSuccess:(NSNotification *)notification
{
    NSString *indexStr=[[notification userInfo] valueForKey:@"index"];
    NSInteger index=[indexStr integerValue];
    [didSelectBabyNameArray removeObjectAtIndex:index];
    NSMutableString *labelStr=[NSMutableString string];
    for (NSString * str in didSelectBabyNameArray ) {
        [labelStr appendString:str];
        [labelStr appendString:@"  "];
    }
    self.nameLabel.text=labelStr;
    
    //宝贝 id
    [didSelectBabyIdArray removeObjectAtIndex:index];
    
    NSMutableString *tidStr = [NSMutableString string];
    
    for (int j = 0; j < didSelectBabyIdArray.count; j ++) {
        NSString *str = didSelectBabyIdArray[j];
        
        if (j != didSelectBabyIdArray.count - 1) {
            [tidStr appendFormat:@"%@,", str];
        }else{
            [tidStr appendFormat:@"%@", str];
        }
    }
    
    babyIdStr = tidStr;
    
//    NSLog(@"宝贝 id  ---  %@", babyIdStr);
    
}



- (IBAction)addButtonClick:(UIButton *)sender {
    
    //    //如果是 主任 或者 老师身份
//        XXEChiefAndTeacherViewController *chiefAndTeacherVC = [[XXEChiefAndTeacherViewController alloc] init];
//    
//        chiefAndTeacherVC.schoolId = _schoolId;
//        chiefAndTeacherVC.classId = _classId;
//    
//        [self.navigationController pushViewController:chiefAndTeacherVC animated:YES];
    
    //如果是管理员 或者 校长身份
    
    XXEManagerAndHeadmasterViewController *managerAndHeadmasterVC = [[XXEManagerAndHeadmasterViewController alloc] init];
    managerAndHeadmasterVC.schoolId = _schoolId;
    
    //返回 数组 头像、名称、id、课程
    [managerAndHeadmasterVC returnArray:^(NSMutableArray *selectedBabyInfoArray) {
        _selectedBabyInfoArray = [NSMutableArray arrayWithArray:selectedBabyInfoArray];

            //宝贝 头像
            [dynamicScrollView addImageView:[NSString stringWithFormat:@"%@%@",kXXEPicURL, selectedBabyInfoArray[0] ]];
            
            //宝贝 名字
            [didSelectBabyNameArray addObject:selectedBabyInfoArray[1]];
            NSMutableString *labelStr=[NSMutableString string];
            for (NSString * str in didSelectBabyNameArray ) {
                [labelStr appendString:str];
                [labelStr appendString:@"  "];
            }
            self.nameLabel.text=labelStr;
            
            //宝贝 id
            [didSelectBabyIdArray addObject:selectedBabyInfoArray[2]];
            NSMutableString *tidStr = [NSMutableString string];
            
            for (int j = 0; j < didSelectBabyIdArray.count; j ++) {
                NSString *str = didSelectBabyIdArray[j];
                
                if (j != didSelectBabyIdArray.count - 1) {
                    [tidStr appendFormat:@"%@,", str];
                }else{
                    [tidStr appendFormat:@"%@", str];
                }
            }
            
            babyIdStr = tidStr;
    }];
    
    [self.navigationController pushViewController:managerAndHeadmasterVC animated:YES];

    
}

- (IBAction)certenButtonClick:(UIButton *)sender {
    
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
        if ([conStr isEqualToString:@""]) {
            [self showHudWithString:@"请完善评论信息" forSecond:1.5];
        }else{
           [self submitReplyTextInfo];
        }
    }
}


//回复 只有  文字 的时候
- (void)submitReplyTextInfo{
    
    XXECommentTextInfoApi *commentTextInfoApi = [[XXECommentTextInfoApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE school_id:_schoolId class_id:_classId baby_id:babyIdStr com_con:conStr   url_group:url_groupStr];
    [commentTextInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//               NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"点评成功!" forSecond:1.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showHudWithString:@"点评失败!" forSecond:1.5];
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
//        NSLog(@"111111<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<%@",dict);
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
    if (textView == _contentTextField) {
//        self.contentNumLabel.text=[NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
        if (_contentTextField.text.length <= 200) {
            _contentNumLabel.text=[NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
        }else{
            [self showHudWithString:@"最多可输入200个字符"];
            _contentTextField.text = [_contentTextField.text substringToIndex:200];
        }
        conStr = _contentTextField.text;
    }
    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
