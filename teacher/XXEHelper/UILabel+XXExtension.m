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
    nameLabel.backgroundColor = [UIColor redColor];
    nameLabel.font = [UIFont systemWithIphone6P:19 Iphone6:17 Iphone5:14 Iphone4:3];
    nameLabel.textColor = XXEColorFromRGB(51, 51, 51);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    return nameLabel;
}

@end
