//
//  XXETextFieldHelp.h
//  teacher
//
//  Created by codeDing on 16/8/4.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XXETextFieldHelp : NSObject

/** 创建登录UITextField */
+(UITextField *)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder passWord:(BOOL)yesOrNo leftImageView:(UIImageView *)imageView rightImageView:(UIImageView *)rightImageView Font:(float)font;

@end
