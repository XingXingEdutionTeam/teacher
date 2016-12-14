

//
//  XXESchoolTimetableCourseTableViewCell.m
//  teacher
//
//  Created by Mac on 16/11/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolTimetableCourseTableViewCell.h"

@implementation XXESchoolTimetableCourseTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.courseNameLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    self.classLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    self.teacherNameLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    self.otherLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    self.startTimeLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
