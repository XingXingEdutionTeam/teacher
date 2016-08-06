//
//  XXETextFieldHelp.m
//  teacher
//
//  Created by codeDing on 16/8/4.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXETextFieldHelp.h"

@implementation XXETextFieldHelp

+(UITextField *)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder passWord:(BOOL)yesOrNo leftImageView:(UIImageView *)imageView rightImageView:(UIImageView *)rightImageView Font:(float)font
{
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];//设置灰色的提示文字
    textField.textAlignment = NSTextAlignmentLeft;//文字的对齐方式
    textField.secureTextEntry = yesOrNo;//是否是密码
    //边框设置
    textField.borderStyle = UIKeyboardTypeDefault;//键盘的类型
    textField.autocapitalizationType = NO;//关闭首字母大写
    textField.clearButtonMode = YES;//清除按钮
    
    textField.leftView = imageView;//左边图片
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.rightView = rightImageView;
    textField.rightViewMode = UITextFieldViewModeWhileEditing;
    
    textField.font = [UIFont systemFontOfSize:font];//设置字号
    textField.textColor = [UIColor blackColor];//设置字体颜色
    
    textField.placeholder = placeholder;
    return textField;

}

@end






















