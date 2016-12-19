//
//  XXETeacherTableViewCell.m
//  teacher
//
//  Created by codeDing on 16/8/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXETeacherTableViewCell.h"

@implementation XXETeacherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.commboxView = [[WJCommboxView alloc] initWithFrame:CGRectMake(95, 10, 192, 23)];
    self.commboxView.textField.borderStyle = UITextBorderStyleNone;
    self.commboxView.textField.placeholder = @"请选择审核人员";
    self.commboxView.textField.rightView = nil;
    self.commboxView.showList = NO;
    self.commboxView.hidden = YES;
    [self.contentView addSubview:self.commboxView];
    [self.commboxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(95);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(192);
        make.height.mas_equalTo(30);
    }];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
