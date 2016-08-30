//
//  UILabel+XXExtension.h
//  teacher
//
//  Created by codeDing on 16/8/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (XXExtension)

+ (UILabel *)setupMessageLabel:(NSString *)text;

+ (UILabel *)setupHomePageMessageLabel:(NSString *)text;

/** 注册页面4/4 */
+ (UILabel *)setupRegisterMessageLines:(NSUInteger)lines MessageLabel:(NSString *)text;

#pragma mark 创建UILable
+(UILabel *)createLabelWithFrame:(CGRect )frame Font:(int)font Text:(NSString *)text;


@end
