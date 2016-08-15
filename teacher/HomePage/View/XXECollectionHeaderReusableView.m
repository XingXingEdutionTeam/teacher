//
//  XXECollectionHeaderReusableView.m
//  teacher
//
//  Created by codeDing on 16/8/15.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECollectionHeaderReusableView.h"

@implementation XXECollectionHeaderReusableView



-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}
-(void)createSubViews{
    UILabel *label = [[UILabel alloc]initWithFrame:self.bounds];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    label.font = [UIFont systemWithIphone6P:14 Iphone6:12 Iphone5:10 Iphone4:8];
    label.tag = 10;
    [self addSubview:label];
}
-(void)setTitle:(NSString *)title{
    _title = title;
    UILabel *label = [self viewWithTag:10];
    label.text = _title;
}

@end
