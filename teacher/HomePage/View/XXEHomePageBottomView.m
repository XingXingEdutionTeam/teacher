//
//  XXEHomePageBottomView.m
//  teacher
//
//  Created by codeDing on 16/8/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEHomePageBottomView.h"
#import <RongIMKit/RongIMKit.h>

@interface XXEHomePageBottomView ()

@property (nonatomic, strong)UIButton *button;

@end

@implementation XXEHomePageBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)configBottomViewButton:(NSString *)position
{
    if ([position isEqualToString:@"1"]||[position isEqualToString:@"2"]) {
        
        [self setupButtonNum:12];
        
    }else if ([position isEqualToString:@"3"]){
        [self setupButtonNum:11];
    }else if ([position isEqualToString:@"4"]){
        [self setupButtonNum:10];
    }else if (position == nil) {
        [self setupButtonNum:10];
    }
}


- (void)setupButtonNum:(int )num
{
    int buttonCount;
    switch ([GlobalVariable shareInstance].appleVerify) {
        case AppleVerifyHave:
            buttonCount = num - 1;
            break;
        default:
            buttonCount = num ;
            break;
    }

    //创建 十二宫格  三行、四列
    int totalLine = 4;
    
    int margin = 1;
    
    CGFloat buttonWidth = (KScreenWidth - 3 * margin) / 4;
    CGFloat buttonHeight = (self.frame.size.height  - 2 * margin)/ 3;
    for (int i = 0; i < buttonCount; i++) {
        //行
        int buttonRow = i / totalLine;
        //列
        int buttonLine = i % totalLine;
        CGFloat buttonX = (buttonWidth + margin) * buttonLine;
        CGFloat buttonY = (buttonHeight + margin) * buttonRow;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button = button;
        
        switch ([GlobalVariable shareInstance].appleVerify) {
            case AppleVerifyHave:
                if (i < 7) {
                    button.tag = i;
                }else {
                    button.tag = i+1;
                }
                break;
            default:
                button.tag = i;
                break;
        }
        
        
        button.backgroundColor = [UIColor whiteColor];
        button.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
        NSString *string;
        
        if (i == 4) {
            self.chatBadgeView = [[UIView alloc] init];
            self.chatBadgeView.layer.cornerRadius = 4;
            self.chatBadgeView.layer.masksToBounds = YES;
            self.chatBadgeView.backgroundColor = [UIColor redColor];
            [button addSubview:self.chatBadgeView];
            [self.chatBadgeView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(button).offset(2.5 + 2);
                make.trailing.equalTo(button).offset(-2.5 - 7);
                make.width.mas_equalTo(8);
                make.height.mas_equalTo(8);
            }];
            self.chatBadgeView.hidden = YES;
            
            if ([RCIMClient sharedRCIMClient] != nil) {
                if ([RCIMClient sharedRCIMClient].getTotalUnreadCount == 0) {
                    self.chatBadgeView.hidden = YES;
                }else {
                    self.chatBadgeView.hidden = NO;
                }
                
                if (![XXEUserInfo user].login){
                    self.chatBadgeView.hidden = YES;
                }
            }
            
            
        }
        
        switch ([GlobalVariable shareInstance].appleVerify) {
            case AppleVerifyHave:
                if (num == 12) {
                    
                    if (i<7) {
                        string = [NSString stringWithFormat:@"home_%d_click",i+1];
                    }else {
                        string = [NSString stringWithFormat:@"home_%d_click",i+2];
                    }
                    
                }else if (num == 11){
                    if (i<7) {
                        string = [NSString stringWithFormat:@"home_%d_click",i+1];
                    }else {
                        string = [NSString stringWithFormat:@"home_%d_click",i+2];
                    }
                }else{
                    if (i<7) {
                        string = [NSString stringWithFormat:@"home_%d_click",i+1];
                    }else {
                        string = [NSString stringWithFormat:@"home_%d_click",i+2];
                    }
                }
                
                break;
            default:
                if (num == 12) {
                    string = [NSString stringWithFormat:@"home_%d_click",i+1];
                }else if (num == 11){
                    string = [NSString stringWithFormat:@"home_1_%d_click",i+1];
                }else{
                    string = [NSString stringWithFormat:@"home_2_%d_click",i+1];
                }
                break;
        }
        
        
        [button setImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(homeClassButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
    }
}

#pragma mark - 点击按钮
- (void)homeClassButtonClick:(UIButton *)sender
{
    
    
    switch (sender.tag) {
        case 0:
            if ([self.delegate respondsToSelector:@selector(homeClassOneButtonClick:)]) {
                [self.delegate homeClassOneButtonClick:sender.tag];
            }
            break;
        case 1:
            if ([self.delegate respondsToSelector:@selector(homeClassOneButtonClick:)]) {
                [self.delegate homeClassOneButtonClick:sender.tag];
            }
            break;
        case 2:
            if ([self.delegate respondsToSelector:@selector(homeClassOneButtonClick:)]) {
                [self.delegate homeClassOneButtonClick:sender.tag];
            }
            break;
        case 3:
            if ([self.delegate respondsToSelector:@selector(homeClassOneButtonClick:)]) {
                [self.delegate homeClassOneButtonClick:sender.tag];
            }
            break;
        case 4:
            if ([self.delegate respondsToSelector:@selector(homeClassOneButtonClick:)]) {
                [self.delegate homeClassOneButtonClick:sender.tag];
            }
            break;
        case 5:
            if ([self.delegate respondsToSelector:@selector(homeClassOneButtonClick:)]) {
                [self.delegate homeClassOneButtonClick:sender.tag];
            }
            break;
        case 6:
            if ([self.delegate respondsToSelector:@selector(homeClassOneButtonClick:)]) {
                [self.delegate homeClassOneButtonClick:sender.tag];
            }
            break;
        case 7:
            if ([self.delegate respondsToSelector:@selector(homeClassOneButtonClick:)]) {
                [self.delegate homeClassOneButtonClick:sender.tag];
            }
            break;
        case 8:
            if ([self.delegate respondsToSelector:@selector(homeClassOneButtonClick:)]) {
                [self.delegate homeClassOneButtonClick:sender.tag];
            }
            break;
        case 9:
            if ([self.delegate respondsToSelector:@selector(homeClassOneButtonClick:)]) {
                [self.delegate homeClassOneButtonClick:sender.tag];
            }
            break;
        case 10:
            if ([self.delegate respondsToSelector:@selector(homeClassOneButtonClick:)]) {
                [self.delegate homeClassOneButtonClick:sender.tag];
            }
            break;
        case 11:
            if ([self.delegate respondsToSelector:@selector(homeClassOneButtonClick:)]) {
                [self.delegate homeClassOneButtonClick:sender.tag];
            }
            break;
        default:
            break;
    }
}

@end
