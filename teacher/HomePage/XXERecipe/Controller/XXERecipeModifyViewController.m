

//
//  XXERecipeModifyViewController.m
//  teacher
//
//  Created by Mac on 16/8/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERecipeModifyViewController.h"
#import "FSImagePickerView.h"
#import "XXERecipePicModify.h"
#import "XXERecipeViewController.h"

@interface XXERecipeModifyViewController ()
{
    //图标
    NSString *iconStr;
    //meal_type	//餐类型,传数字(1:早餐  2:午餐  3:晚餐)
    NSString *meal_type;
    //添加 照片
    FSImagePickerView *pickerView;
    //
    NSMutableArray *arr;
    NSString *mealNameStr;
    
    NSString *url_groupStr;
    
    NSArray *modifyMealArray;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXERecipeModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

    _timeLabel.text = _dateStr;
    _contentTextView.text = _contentStr;
    modifyMealArray = [[NSArray alloc] init];
    
    
    if (_titleStr != nil) {
        _mealNameLabel.text = _titleStr;
        
        if ([_titleStr isEqualToString:@"早餐"]) {
            
            iconStr = @"home_recipe_breakfast_icon38x34";
            meal_type = @"1";
            
        }else if ([_titleStr isEqualToString:@"午餐"]) {
            
            iconStr = @"home_recipe_lunch_icon38x34";
            meal_type = @"2";
            
        }else if ([_titleStr isEqualToString:@"晚餐"]) {
            
            iconStr = @"home_recipe_dinner_icon38x34";
            meal_type = @"3";
            
        }
    }
    
    _mealIconImageView.image = [UIImage imageNamed:iconStr];
    
    //选择图片
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    pickerView = [[FSImagePickerView alloc] initWithFrame:CGRectMake(10, 10, kWidth - 10 * 2, 80) collectionViewLayout:layout1];
    pickerView.backgroundColor = UIColorFromRGB(255, 255, 255);
    pickerView.showsHorizontalScrollIndicator = NO;
    pickerView.controller = self;
    
    [self.upPicImageView addSubview:pickerView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}



- (IBAction)certainButton:(UIButton *)sender {
    
    mealNameStr = _contentTextView.text;
    
    if ([mealNameStr isEqualToString:@""]){
        [self showHudWithString:@"请完善晚餐内容" forSecond:1.5];
    }else{
        
        arr = [[NSMutableArray alloc] init];
        for (int i = 0; i < pickerView.data.count - 1; i++) {
            FSImageModel *mdoel = pickerView.data[i];
            UIImage *image1 = [UIImage imageWithData:mdoel.data];
            [arr addObject:image1];
        }
        
        if (arr.count != 0) {
            [self submitRecipeAddTextAndPicInfo];
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
        
        XXERecipePicModify *recipePicModify = [[XXERecipePicModify alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE school_id:_schoolId position:@"4" cookbook_id:_cookbook_idStr meal_type:meal_type meal_name:mealNameStr url_group:url_groupStr];
        
//            NSLog(@"_cookbook_idStr:%@ ---meal_type:%@ ----mealNameStr: %@ ---url_groupStr: %@", _cookbook_idStr, meal_type, mealNameStr, url_groupStr);
    
        [recipePicModify startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            
//            NSLog(@"2222---   %@", request.responseJSONObject);
            
            NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
            
            if ([codeStr isEqualToString:@"1"]) {
                
                [self showHudWithString:@"发布成功!" forSecond:1.5];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
//                    XXERecipeViewController *vc = [[XXERecipeViewController alloc] init];
//                    [self.navigationController popToViewController:vc animated:YES];
                });
                
            }else{
                
            }
            
        } failure:^(__kindof YTKBaseRequest *request) {
            
            [self showHudWithString:@"发布失败!" forSecond:1.5];
        }];
        
    }
    
    
- (void)submitRecipeAddTextAndPicInfo{
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
            
            for (int i = 0; i< arr.count; i++) {
                NSData *data = UIImageJPEGRepresentation(arr[i], 0.5);
                NSString *name = [NSString stringWithFormat:@"%d.jpeg",i];
                NSString *formKey = [NSString stringWithFormat:@"file%d",i];
                NSString *type = @"image/jpeg";
                [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
            }
            
            
        } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSDictionary *dict =responseObject;
//            NSLog(@"111111<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<%@",dict);
            if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
            {
                modifyMealArray = dict[@"data"];
                if (modifyMealArray.count == 1) {
                    url_groupStr = modifyMealArray[0];
                }else if (modifyMealArray.count > 1){
                    
                    NSMutableString *tidStr = [NSMutableString string];
                    
                    for (int j = 0; j < modifyMealArray.count; j ++) {
                        NSString *str = modifyMealArray[j];
                        
                        if (j != modifyMealArray.count - 1) {
                            [tidStr appendFormat:@"%@,", str];
                        }else{
                            [tidStr appendFormat:@"%@", str];
                        }
                    }
                    
                    url_groupStr = tidStr;
                }
                
                
//                NSLog(@"修改 图片 %@", url_groupStr);
            }

                [self submitRecipeAddTextInfo];
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
        
}
    
    
    
    
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
