

//
//  XXEXingCommunityClassesTableViewCell.m
//  teacher
//
//  Created by Mac on 2016/12/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingCommunityClassesTableViewCell.h"

@implementation XXEXingCommunityClassesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //左边头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        _iconImageView.layer.cornerRadius = _iconImageView.frame.size.width / 2;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        
        //标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.frame.origin.x + _iconImageView.width + 10, 10, 150 * kWidth / 375, 20 )];
        _titleLabel.font = [UIFont systemFontOfSize:14 * kWidth / 375];
        [self.contentView addSubview:_titleLabel];
        
        //分割线 一
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y + _titleLabel.height + 10, 150 * kScreenRatioWidth, 1)];
        line1.backgroundColor = XXEBackgroundColor;
        [self.contentView addSubview:line1];
        
        //时间
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, line1.frame.origin.y + line1.height + 10, 150 * kScreenRatioWidth, 20)];
        [self.contentView addSubview:_timeLabel];
        
        //分割线
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(_timeLabel.frame.origin.x, _timeLabel.frame.origin.y + _timeLabel.height + 10, 150 * kScreenRatioWidth, 1)];
        line2.backgroundColor = XXEBackgroundColor;
        [self.contentView addSubview:line2];
        
        
    }
    
    return self;
}


@end
