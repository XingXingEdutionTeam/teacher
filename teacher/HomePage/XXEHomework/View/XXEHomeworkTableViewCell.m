



//
//  XXEHomeworkTableViewCell.m
//  teacher
//
//  Created by Mac on 16/8/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEHomeworkTableViewCell.h"

@implementation XXEHomeworkTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //左边头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 75, 75)];
        [self.contentView addSubview:_iconImageView];
        
        //右边 三条分割线
        //发布人 title
        _titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(95 * kScreenRatioWidth, 10, 50 * kScreenRatioWidth, 20 )];
        [self.contentView addSubview:_titleLabel1];
        //发布人 name
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel1.frame.origin.x + _titleLabel1.size.width, 10, 100 * kScreenRatioWidth, 20)];
        [self.contentView addSubview:_nameLabel];
        
        //科目 title
        _titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x + _nameLabel.size.width, 10, 50 * kScreenRatioWidth, 20)];
        [self.contentView addSubview:_titleLabel2];
        //科目 name
        _courseLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel2.frame.origin.x + _titleLabel2.size.width, 10, 150 * kScreenRatioWidth, 20)];
        [self.contentView addSubview:_courseLabel];
        
        //作业主题 title
        _titleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(95 * kScreenRatioWidth, _titleLabel1.frame.origin.y + _titleLabel1.size.height + 5, 50 * kScreenRatioWidth, 20)];
        [self.contentView addSubview:_titleLabel3];
        //作业主题 name
        _subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel3.frame.origin.x + _titleLabel3.frame.origin.y, 10, 200 * kScreenRatioWidth, 20)];
        [self.contentView addSubview:_subjectLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(95 * kScreenRatioWidth, _titleLabel3.frame.origin.y + _titleLabel3.size.height + 5, KScreenWidth - 100, 20)];
        [self.contentView addSubview:_timeLabel];
        
        
        _nameLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
        _courseLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
        _subjectLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
        _titleLabel1.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
        _titleLabel2.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
        _titleLabel3.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
        _timeLabel.font = [UIFont systemWithIphone6P:14 Iphone6:12 Iphone5:10 Iphone4:8];
        
    }
    
    return self;
}


@end
