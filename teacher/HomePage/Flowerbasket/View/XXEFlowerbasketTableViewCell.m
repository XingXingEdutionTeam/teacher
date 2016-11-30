

//
//  XXEFlowerbasketTableViewCell.m
//  teacher
//
//  Created by Mac on 16/8/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFlowerbasketTableViewCell.h"

@implementation XXEFlowerbasketTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
    CGSize size = self.contentLabel.size;
    size.width = KScreenWidth - 100 * kScreenRatioWidth;
    self.contentLabel.size = size;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
