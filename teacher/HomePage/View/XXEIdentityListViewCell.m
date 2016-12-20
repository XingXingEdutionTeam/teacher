//
//  XXEIdentityListViewCell.m
//  teacher
//
//  Created by codeDing on 16/9/1.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEIdentityListViewCell.h"
#import "XXEIdentityListModel.h"

@implementation XXEIdentityListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)identityListMessage:(XXEIdentityListModel *)model
{
    
    
    NSString *schoolPic = [NSString stringWithFormat:@"%@%@",kXXEPicURL,model.school_logo];

    [self.identitySchoolImageView sd_setImageWithURL:[NSURL URLWithString:schoolPic] placeholderImage:[UIImage imageNamed:@"school_logo"]];
    
    self.identitySchoolNameLabel.text = model.school_name;
    self.identityClassNameLabel.text = model.class_name;
    self.identityTeacheCourseLabel.text = model.teach_course;
    if ([model.condit isEqualToString:@"0"]) {
        self.identityReviewImageView.image = [UIImage imageNamed:@"daishenghe"];
    }else if ([model.condit isEqualToString:@"1"]){
        self.identityReviewImageView.image = [UIImage imageNamed:@"yishenghe"];
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
