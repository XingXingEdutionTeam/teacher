


//
//  XXEHeadmasterSpeechViewController.m
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEHeadmasterSpeechViewController.h"

@interface XXEHeadmasterSpeechViewController ()

@end

@implementation XXEHeadmasterSpeechViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    
//    NSLog(@"%@", _head_img);
    
    
    [self createContentImageView];

}


- (void)createContentImageView{
    UIImageView *contentView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10 * kWidth / 375 + 5, kWidth - 20, kHeight - 10)];
    contentView.userInteractionEnabled = YES;
    contentView.backgroundColor = [UIColor whiteColor];
    CGFloat contentViewWidth = contentView.frame.size.width;
    CGFloat contentViewHeight = contentView.frame.size.height;
    
    //校长头像
    
    UIImageView *headmasterIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - 60 / 2,15, 60, 60)];
    
    headmasterIconImageView.layer.cornerRadius = headmasterIconImageView.frame.size.width / 2;
    headmasterIconImageView.layer.masksToBounds = YES;
    
    [headmasterIconImageView sd_setImageWithURL:[NSURL URLWithString:_head_img] placeholderImage:[UIImage imageNamed:@"home_logo_headermaster_icon118x118"]];
    [contentView addSubview:headmasterIconImageView];
    
    //文字
    UITextView *myTextView = [[UITextView alloc] initWithFrame:CGRectMake(0,15 + 59 +10, kWidth - 10 * 2, contentViewHeight - 59 - 200)];
    myTextView.text = _pdt_speech;
    //    myTextView.scrollEnabled = YES;
    myTextView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:myTextView];
    
    [self.view addSubview:contentView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
