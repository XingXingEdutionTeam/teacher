//
//  XXEXingClassRoomCourseListTableViewCell.h
//  teacher
//
//  Created by Mac on 16/10/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXEXingClassRoomCourseListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *courseLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *separate1;

@property (weak, nonatomic) IBOutlet UIImageView *separate2;

@property (weak, nonatomic) IBOutlet UIImageView *separate3;

@property (weak, nonatomic) IBOutlet UIButton *xingCoinBtn;

@property (weak, nonatomic) IBOutlet UIButton *quitBtn;

@property (weak, nonatomic) IBOutlet UIButton *fullBtn;


@end
