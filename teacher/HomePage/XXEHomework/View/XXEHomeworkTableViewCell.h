//
//  XXEHomeworkTableViewCell.h
//  teacher
//
//  Created by Mac on 16/8/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXEHomeworkTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *courseLabel;

@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;

@property (weak, nonatomic) IBOutlet UILabel *gradeAndClassLabel;


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;



@end
