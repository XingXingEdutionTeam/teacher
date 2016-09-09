
//
//  XXEMyselfInfoCollectionLinkViewController.m
//  teacher
//
//  Created by Mac on 16/9/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoCollectionLinkViewController.h"

@interface XXEMyselfInfoCollectionLinkViewController ()
{
    UIWebView *myWebView;
    
}


@end

@implementation XXEMyselfInfoCollectionLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,kWidth,kHeight - 64 - 15)];
    NSURL *url = [NSURL URLWithString:@"http://www.xingxingedu.cn"];
    [myWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self.view addSubview:myWebView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
