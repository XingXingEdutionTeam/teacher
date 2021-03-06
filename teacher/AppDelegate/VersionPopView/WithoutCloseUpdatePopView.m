//
//  WithoutCloseUpdatePopView.m
//  teacher
//
//  Created by codeDing on 16/12/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "WithoutCloseUpdatePopView.h"

@implementation WithoutCloseUpdatePopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmispopView)];
//    [self addGestureRecognizer:tap];
    
    UIImage *backImg = [UIImage imageNamed:@"versionbeijing01"];
    
    CGFloat backImg_w = backImg.size.width * kScreenRatioWidth;
    CGFloat backImg_h = backImg.size.height * kScreenRatioWidth;
    
    UIImageView *IV = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth/ 2 - backImg_w/2, KScreenHeight/2 - backImg_w/2, backImg_w, backImg_h)];
    IV.userInteractionEnabled = YES;
    IV.image = backImg;
    [self addSubview:IV];
    
    self.versionLbl = [[UILabel alloc] initWithFrame:CGRectMake(19 * kScreenRatioWidth, 158*kScreenRatioWidth, backImg_w - 38 * kScreenRatioWidth, 20 * kScreenRatioWidth)];
    self.versionLbl.font = [UIFont systemFontOfSize:14];
    self.versionLbl.textColor = UIColorFromHex(000);
    [IV addSubview:self.versionLbl];
    
    self.updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.updateBtn.frame = CGRectMake(12 * kScreenRatioWidth, backImg_h - 50 *kScreenRatioWidth, backImg_w - 24 * kScreenRatioWidth , 40 * kScreenRatioWidth);
    self.updateBtn.userInteractionEnabled = YES;
    self.updateBtn.layer.cornerRadius = 4;
    self.updateBtn.layer.masksToBounds = YES;
    self.updateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.updateBtn setTitle:@"立即更新" forState:UIControlStateNormal];
    [self.updateBtn setTitleColor:UIColorFromHex(0x000000) forState:0];
    self.updateBtn.backgroundColor = UIColorFromHex(0x36d82a);
    [IV addSubview:self.updateBtn];
}

+ (WithoutCloseUpdatePopView *)convenicenWithTitle:(NSString *)versionText {
    WithoutCloseUpdatePopView *withoutPopView = [[WithoutCloseUpdatePopView alloc] init];
    NSMutableString *str = [NSMutableString stringWithString:versionText];
    [str insertString:@"." atIndex:1];
    [str insertString:@"." atIndex:3];
    withoutPopView.versionLbl.text = [NSString stringWithFormat:@"更新版本: V%@", str];
    return withoutPopView;
}

- (void)clickUpdateBtn:(UpdateClickAction)block {
    self.updateClickAction = block;
    [self.updateBtn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.updateBtn addTarget:self action:@selector(clickDown) forControlEvents:UIControlEventTouchDown];
}

- (void)clickAction {
    self.updateBtn.backgroundColor = UIColorFromHex(0x36d82a);
    self.updateClickAction();
}

- (void)clickDown {
    self.updateBtn.backgroundColor = UIColorFromHex(0x29bd1e);
}

//- (void)dissmispopView {
//    [UIView animateWithDuration:0.5 animations:^{
//        self.alpha = 0;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
//}

@end
