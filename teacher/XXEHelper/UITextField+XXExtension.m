//
//  UITextField+XXExtension.m
//  teacher
//
//  Created by codeDing on 16/8/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "UITextField+XXExtension.h"

@implementation UITextField (XXExtension)

+ (UITextField *)createTextFieldWithIsOpen:(BOOL)open textPlaceholder:(NSString *)placeholderText
{
    UITextField *textField = [[UITextField alloc]init];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    textField.textColor = [UIColor blackColor];
    textField.secureTextEntry = open;
    textField.placeholder = placeholderText;
    return textField;
}

@end
