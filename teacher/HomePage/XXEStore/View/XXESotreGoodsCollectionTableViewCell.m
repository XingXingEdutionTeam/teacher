

//
//  XXESotreGoodsCollectionTableViewCell.m
//  teacher
//
//  Created by Mac on 2016/11/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESotreGoodsCollectionTableViewCell.h"

@implementation XXESotreGoodsCollectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _nameLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    
    _iconNumLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    
    _dateLabel.font = [UIFont systemFontOfSize:12 * kScreenRatioWidth];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
