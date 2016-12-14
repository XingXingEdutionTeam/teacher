
//
//  XXEXingClassRoomCourseListTableViewCell.m
//  teacher
//
//  Created by Mac on 16/10/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingClassRoomCourseListTableViewCell.h"

@implementation XXEXingClassRoomCourseListTableViewCell

- (void)awakeFromNib {

    UIImage *backGroungImage =[UIImage imageNamed:@"separateLine"];
    [backGroungImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [_separate1 setImage:backGroungImage];
    [_separate2 setImage:backGroungImage];
    [_separate3 setImage:backGroungImage];
    _separate1.frame = CGRectMake(0,0,250,2);
    _separate2.frame = CGRectMake(0,0,250,2);
    _separate3.frame = CGRectMake(0,0,250,2);
    
    _distanceLabel.textColor = [UIColor redColor];
    
    _nameLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    
    _courseLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    
    _totalLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    
    _priceLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    
    _distanceLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    
    _leftLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
