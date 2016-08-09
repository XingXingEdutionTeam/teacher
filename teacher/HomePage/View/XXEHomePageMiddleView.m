//
//  XXEHomePageMiddleView.m
//  teacher
//
//  Created by codeDing on 16/8/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEHomePageMiddleView.h"

@implementation XXEHomePageMiddleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews
{
    __weak typeof(self)weakSelf = self;
    
    self.homeMiddleFirstButton = [UIButton creatHomePageImage:@"home_flower" title:@":  15" target:self action:@selector(homeMiddleFirstButtonClick:)];
    [self addSubview:self.homeMiddleFirstButton];
    [self.homeMiddleFirstButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(15);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.mas_equalTo((KScreenWidth-30)/4);
    }];
    
    self.homeMiddleTwoButton = [UIButton creatHomePageImage:@"home_redflower" title:@":  12" target:self action:@selector(homeMiddleTwoButtonClick:)];
    [self addSubview:self.homeMiddleTwoButton];
    [self.homeMiddleTwoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.homeMiddleFirstButton.mas_right).offset(0);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.mas_equalTo((KScreenWidth-30)/4);
    }];
    
    self.homeMiddleThreeButton = [UIButton creatHomePageImage:@"home_xid" title:@":  14" target:self action:@selector(homeMiddleThreeButtonClick:)];
    [self addSubview:self.homeMiddleThreeButton];
    [self.homeMiddleThreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.homeMiddleTwoButton.mas_right).offset(0);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.mas_equalTo((KScreenWidth-30)/4);
    }];
    
    self.homeMiddleFourButton = [UIButton creatHomePageImage:@"home_tongzhi" title:@"" target:self action:@selector(homeMiddleFourButtonClick:)];
    [self addSubview:self.homeMiddleFourButton];
    [self.homeMiddleFourButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-15);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.mas_equalTo((KScreenWidth-30)/4);
    }];
    
}


#pragma mark - 点击相应事件
- (void)homeMiddleFirstButtonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(homeMiddleFirstButtonClick)]) {
        [self.delegate homeMiddleFirstButtonClick];
    }
}

- (void)homeMiddleTwoButtonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(homeMiddleTwoButtonClick)]) {
        [self.delegate homeMiddleTwoButtonClick];
    }
}


- (void)homeMiddleThreeButtonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(homeMiddleThreeButtonClick)]) {
        [self.delegate homeMiddleThreeButtonClick];
    }
}

- (void)homeMiddleFourButtonClick:(UIButton *)sender
{
    NSLog(@"----通知点击相应时间------");
}

@end
