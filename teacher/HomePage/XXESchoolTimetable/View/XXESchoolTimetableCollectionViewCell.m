//
//  XXESchoolTimetableCollectionViewCell.m
//  teacher
//
//  Created by Mac on 16/10/31.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolTimetableCollectionViewCell.h"

#define  cellWidth  (kWidth - 26 - 7 * 1)/7
#define  cellHeight  25


@implementation XXESchoolTimetableCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

-(void)createSubViews{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
    
    label.font = [UIFont systemWithIphone6P:12 Iphone6:10 Iphone5:8 Iphone4:6];
    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor blueColor];
    label.backgroundColor = [UIColor orangeColor];
    
    label.tag = 10;
    
    [self.contentView addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, label.frame.size.height, self.frame.size.width, self.frame.size.height - label.frame.size.height)];
    imageView.tag = 11;
    
    [self.contentView addSubview:imageView];
}

- (void)setCourseName:(NSString *)courseName{


}

- (void)setCourseNumStr:(NSString *)courseNumStr{


}

//-(void)setTitle:(NSString *)title{
//    _courseName = title;
//    UILabel *label = (UILabel *)[self viewWithTag:10];
//    label.text = _courseName;
//}
//
//
//-(void)setImageName:(NSString *)imageName{
//    _courseNumStr = _courseNumStr;
//    
//    UIImageView *imageView = (UIImageView *)[self viewWithTag:11];
//    imageView.image = [UIImage imageNamed:_imageName];
//}


@end
