

//
//  XXESchoolCertificateModifyViewController.m
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolCertificateModifyViewController.h"
#import "FSImagePickerView.h"
#import "YTKBatchRequest.h"
#import "XXEModifyCertificateApi.h"

@interface XXESchoolCertificateModifyViewController ()
{
    //添加 照片
    FSImagePickerView *pickerView;
}


@end

@implementation XXESchoolCertificateModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"资  质";
    
    [self createContent];
    
}

- (void)createContent{

    //选择图片
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    pickerView = [[FSImagePickerView alloc] initWithFrame:CGRectMake(10, 10, kWidth - 10 * 2, 80) collectionViewLayout:layout1];
    pickerView.backgroundColor = UIColorFromRGB(255, 255, 255);
    pickerView.showsHorizontalScrollIndicator = NO;
    pickerView.controller = self;
    
    [self.upPicBgView addSubview:pickerView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)submitButton:(UIButton *)sender {
    
    //点评  既有文字 又有 图片 时候
    
    if (pickerView.data.count > 1){
    
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
            XXEModifyCertificateApi *modifyCertificateApi = [[XXEModifyCertificateApi alloc] initWithXid:XID user_id:USER_ID user_type:USER_TYPE school_id:_schoolId position:@"4" upImage:arr1[i]];
            [arr addObject:modifyCertificateApi];
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

}




@end
