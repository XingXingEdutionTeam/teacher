//
//  UILabel+XXExtension.m
//  teacher
//
//  Created by codeDing on 16/8/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "UILabel+XXExtension.h"

@implementation UILabel (XXExtension)

+ (UILabel *)setupMessageLabel:(NSString *)text
{
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = text;
//    nameLabel.backgroundColor = [UIColor redColor];
    nameLabel.font = [UIFont systemWithIphone6P:16 Iphone6:15 Iphone5:13 Iphone4:12];
    nameLabel.textColor = XXEColorFromRGB(51, 51, 51);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    return nameLabel;
}

+ (UILabel *)setupHomePageMessageLabel:(NSString *)text
{
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = text;
    nameLabel.numberOfLines = 0;
    nameLabel.font = [UIFont systemWithIphone6P:17 Iphone6:15 Iphone5:12 Iphone4:10];
    nameLabel.textColor = XXEColorFromRGB(255, 255, 255);
    nameLabel.textAlignment = NSTextAlignmentLeft;
    return nameLabel;
}

+ (UILabel *)setupRegisterMessageLines:(NSUInteger)lines MessageLabel:(NSString *)text
{
    UILabel *messageLabel = [[UILabel alloc]init];
    messageLabel.text = text;
    messageLabel.numberOfLines = 2;
    messageLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    messageLabel.textColor = XXEColorFromRGB(51, 51, 51);
    messageLabel.textAlignment = NSTextAlignmentLeft;
    return messageLabel;
}





#pragma mark 创建UILable
+(UILabel *)createLabelWithFrame:(CGRect )frame Font:(int)font Text:(NSString *)text{
    UILabel *myLabel = [[UILabel alloc]initWithFrame:frame];
    myLabel.numberOfLines = 0;//限制行数
    myLabel.textAlignment = NSTextAlignmentLeft;//对齐的方式
    myLabel.backgroundColor = [UIColor clearColor];//背景色
    myLabel.font = [UIFont systemFontOfSize:font];//字号
    myLabel.textColor = [UIColor blackColor];//颜色默认是白色，现在默认是黑色
    //NSLineBreakByCharWrapping以单词为单位换行，以单词为阶段换行
    // NSLineBreakByCharWrapping
    myLabel.lineBreakMode = NSLineBreakByCharWrapping;
    /*
     UIBaselineAdjustmentAlignBaselines文本最上端和label的中线对齐
     UIBaselineAdjustmentAlignCenters 文本中线和label中线对齐
     UIBaselineAdjustmentNone  文本最下端和label中线对齐
     */
    myLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    myLabel.text = text;
    return myLabel;
    
}


@end
