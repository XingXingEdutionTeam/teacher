//
//  XXEMessageHistoryCell.m
//  teacher
//
//  Created by codeDing on 16/9/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMessageHistoryCell.h"
#import "XXEMessageHistoryModel.h"

@implementation XXEMessageHistoryCell



- (void)layoutSubviews
{
    [super layoutSubviews];
    self.messageImageView.layer.cornerRadius = 50/2;
    self.messageImageView.layer.masksToBounds = YES;
}

- (void)configerGetCircleMessageHistory:(XXEMessageHistoryModel *)model
{
    NSString *imageStr = [NSString stringWithFormat:@"%@%@",kXXEPicURL,model.head_img];
    NSURL *url = [NSURL URLWithString:imageStr];
    [self.messageImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"register_user_icon"]];
    self.messageNickNameLabel.text = model.nickname;
    self.messageConLabel.text = model.con;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
