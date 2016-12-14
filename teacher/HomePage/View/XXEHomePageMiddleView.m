//
//  XXEHomePageMiddleView.m
//  teacher
//
//  Created by codeDing on 16/8/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEHomePageMiddleView.h"
#import "XXEHomePageModel.h"

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
    self.homeMiddleFirstButton.titleLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    [self addSubview:self.homeMiddleFirstButton];
    [self.homeMiddleFirstButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(15);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.mas_equalTo(86.25 *kScreenRatioWidth);
    }];
    
    self.homeMiddleTwoButton = [UIButton creatHomePageImage:@"home_redflower" title:@":  12" target:self action:@selector(homeMiddleTwoButtonClick:)];
    self.homeMiddleTwoButton.titleLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    [self addSubview:self.homeMiddleTwoButton];
    [self.homeMiddleTwoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.homeMiddleFirstButton.mas_right).offset(0);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.mas_equalTo(86.25 *kScreenRatioWidth);
    }];
    
    self.homeMiddleThreeButton = [UIButton creatHomePageImage:@"home_xid" title:@":  14" target:self action:@selector(homeMiddleThreeButtonClick:)];
    self.homeMiddleThreeButton.titleLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    [self addSubview:self.homeMiddleThreeButton];
    [self.homeMiddleThreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.homeMiddleTwoButton.mas_right).offset(5);
        make.centerY.equalTo(weakSelf.mas_centerY);
       make.width.mas_equalTo(96.25 *kScreenRatioWidth);
    }];
    
    UIImage *notificationIcon = [UIImage imageNamed:@"home_tongzhi"];
    self.homeMiddleFourButton = [UIButton creatHomePageImage:@"home_tongzhi" title:@"" target:self action:@selector(homeMiddleFourButtonClick:)];
    [self addSubview:self.homeMiddleFourButton];
    [self.homeMiddleFourButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.homeMiddleThreeButton.mas_right).offset(0);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.mas_equalTo(76.25 *kScreenRatioWidth);
    }];
    
    self.systemNotificationBadgeView = [[UIView alloc] init];
    self.systemNotificationBadgeView.backgroundColor = [UIColor redColor];
    self.systemNotificationBadgeView.layer.cornerRadius = 4;
    self.systemNotificationBadgeView.layer.masksToBounds = YES;
    [self addSubview:self.systemNotificationBadgeView];
    [self.systemNotificationBadgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.homeMiddleFourButton).offset(notificationIcon.size.width / 2 + 6);
        make.centerY.equalTo(self.homeMiddleFourButton).offset(-notificationIcon.size.height/2);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(8);
    }];
    self.systemNotificationBadgeView.hidden = YES;
    
}

#pragma mark - 给视图赋值
- (void)configCellMiddleWithInfo:(XXEHomePageModel *)homeModel
{
    if (homeModel.coin_able.length == 4) {
        float coin = [homeModel.coin_able floatValue]/1000;
        NSLog(@"%@",homeModel.coin_able);
        [self.homeMiddleThreeButton setTitle:[NSString stringWithFormat:@":  %.1f千",coin] forState:UIControlStateNormal];
    }else if (homeModel.coin_able.length == 5){
        float coin = [homeModel.coin_able floatValue]/10000;
        
        [self.homeMiddleThreeButton setTitle:[NSString stringWithFormat:@":  %.1f万",coin] forState:UIControlStateNormal];
    }else{
         [self.homeMiddleThreeButton setTitle:[NSString stringWithFormat:@":  %@",homeModel.coin_able] forState:UIControlStateNormal];
    }
    [self.homeMiddleFirstButton setTitle:[NSString stringWithFormat:@":  %@",homeModel.fbasket_able] forState:UIControlStateNormal];
    [self.homeMiddleTwoButton setTitle:[NSString stringWithFormat:@":  %@",homeModel.flower_able] forState:UIControlStateNormal];
    
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
//    NSLog(@"----通知点击相应通知------");
    if ([self.delegate respondsToSelector:@selector(homeMiddleFourButtonClick)]) {
        [self.delegate homeMiddleFourButtonClick];
    }
}

@end
