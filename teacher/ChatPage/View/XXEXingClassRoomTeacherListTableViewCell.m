

//
//  XXEXingClassRoomTeacherListTableViewCell.m
//  teacher
//
//  Created by Mac on 16/10/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingClassRoomTeacherListTableViewCell.h"

@implementation XXEXingClassRoomTeacherListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    //separateLine
    UIImage *backGroungImage =[UIImage imageNamed:@"separateLine"];
    [backGroungImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [_lineImageView1 setImage:backGroungImage];
    [_lineImageView2 setImage:backGroungImage];
    
    _lineImageView1.frame = CGRectMake(0,0,250,2);
    _lineImageView2.frame = CGRectMake(0,0,250,2);
    
    _distanceLabel.textColor = [UIColor redColor];
    
    _nameLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    
    _ageLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    
    _scoreLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    
    _courseLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    
    _teachTimeLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
