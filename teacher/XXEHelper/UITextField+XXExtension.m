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
    textField.font = [UIFont systemWithIphone6P:17 Iphone6:15 Iphone5:13 Iphone4:11];
    textField.textColor = [UIColor blackColor];
    textField.secureTextEntry = open;
    textField.placeholder = placeholderText;
    return textField;
}

#pragma mark 创建UITextField
+(UITextField *)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder passWord:(BOOL)yesOrNo leftImageView:(UIImageView *)imageView rightImageView:(UIImageView *)rightImageView Font:(float)font{
    UITextField *myField = [[UITextField alloc]initWithFrame:frame];//设置灰色的提示文字
    myField.textAlignment = NSTextAlignmentLeft;//文字的对齐方式
    myField.secureTextEntry = yesOrNo;//是否是密码
    //边框设置
    myField.borderStyle = UIKeyboardTypeDefault;//键盘的类型
    myField.autocapitalizationType = NO;//关闭首字母大写
    myField.clearButtonMode = YES;//清除按钮
    
    myField.leftView = imageView;//左边图片
    myField.leftViewMode = UITextFieldViewModeAlways;
    
    myField.rightView = rightImageView;
    myField.rightViewMode = UITextFieldViewModeWhileEditing;
    
    myField.font = [UIFont systemFontOfSize:font];//设置字号
    myField.textColor = [UIColor blackColor];//设置字体颜色
    
    myField.placeholder = placeholder;
    return myField;
}



@end
