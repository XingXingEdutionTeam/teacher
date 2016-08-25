

//
//  XXESchoolEmailModiyfViewController.m
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolEmailModiyfViewController.h"

@interface XXESchoolEmailModiyfViewController ()

@end

@implementation XXESchoolEmailModiyfViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"更换邮箱";
    
    [_submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)checkCodeButton:(UIButton *)sender {
}

- (void)submitButtonClick{
    
    
    
}

@end
