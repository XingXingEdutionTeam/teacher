

//
//  XXESchoolCertificateModifyViewController.m
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolCertificateModifyViewController.h"
#import "FSImagePickerView.h"


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
}
@end
