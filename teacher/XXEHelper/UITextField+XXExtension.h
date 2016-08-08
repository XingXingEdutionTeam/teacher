//
//  UITextField+XXExtension.h
//  teacher
//
//  Created by codeDing on 16/8/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (XXExtension)

+ (UITextField *)createTextFieldWithIsOpen:(BOOL)open textPlaceholder:(NSString *)placeholderText;

@end
