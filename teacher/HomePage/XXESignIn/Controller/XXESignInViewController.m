//
//  XXESignInViewController.m
//  teacher
//
//  Created by Mac on 16/8/31.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESignInViewController.h"
#import "QHNavSliderMenu.h"


@interface XXESignInViewController ()<QHNavSliderMenuDelegate,UIScrollViewDelegate>{
    QHNavSliderMenu *navSliderMenu;
    NSMutableDictionary  *listVCQueue;
    UIScrollView *contentScrollView;
    int menuCount;
}


@end

@implementation XXESignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = XXEColorFromRGB(0, 170, 42);
    self.navigationController.navigationBarHidden = NO;
    
    self.title = @"签到";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
