//
//  XXEIdentityListViewCell.h
//  teacher
//
//  Created by codeDing on 16/9/1.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXEIdentityListModel;
@interface XXEIdentityListViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *identitySchoolImageView;
@property (weak, nonatomic) IBOutlet UILabel *identitySchoolNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *identityClassNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *identityTeacheCourseLabel;
@property (weak, nonatomic) IBOutlet UIImageView *identityReviewImageView;

- (void)identityListMessage:(XXEIdentityListModel *)model;


@end
