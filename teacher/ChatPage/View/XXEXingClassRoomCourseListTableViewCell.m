
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
    
    _nameLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    
    _courseLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    
    _totalLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    
    _priceLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    
    _distanceLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    
    _leftLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
