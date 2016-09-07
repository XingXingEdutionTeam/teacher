


//
//  XXEXingCoinHistoryTableViewCell.m
//  teacher
//
//  Created by Mac on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingCoinHistoryTableViewCell.h"

@implementation XXEXingCoinHistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //icon
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * kScreenRatioWidth, 10 * kScreenRatioWidth, 60 * kScreenRatioWidth, 60 * kScreenRatioWidth)];
        [self.contentView addSubview:_iconImageView];
        
        
        //时间 label
        _timeLabel = [UILabel createLabelWithFrame:CGRectMake(80 * kScreenRatioWidth, 10 * kScreenRatioHeight, 135 * kScreenRatioWidth, 60 * kScreenRatioHeight) Font:14 * kScreenRatioWidth Text:@""];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_timeLabel];
        
        //用途 label
        _useLabel = [UILabel createLabelWithFrame:CGRectMake(215 * kScreenRatioWidth, 10 * kScreenRatioHeight, 80 * kScreenRatioWidth, 60 * kScreenRatioHeight) Font:14 * kScreenRatioWidth Text:@""];
        _useLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_useLabel];
    
        //钱
        _moneyLabel = [UILabel createLabelWithFrame:CGRectMake(295 * kScreenRatioWidth, 10 * kScreenRatioHeight, 80 * kScreenRatioWidth, 60 * kScreenRatioHeight) Font:14 * kScreenRatioWidth Text:@""];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_moneyLabel];
        
    }
    return self;
}


@end
