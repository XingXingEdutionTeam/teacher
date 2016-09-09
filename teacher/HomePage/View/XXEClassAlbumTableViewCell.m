//
//  XXEClassAlbumTableViewCell.m
//  teacher
//
//  Created by codeDing on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEClassAlbumTableViewCell.h"


@implementation XXEClassAlbumTableViewCell

- (UIImageView *)LeftImageView
{
    if (!_LeftImageView) {
        _LeftImageView = [[UIImageView alloc]init];
        _LeftImageView.backgroundColor = [UIColor clearColor];
    }
    return _LeftImageView;
}

- (UIImageView *)MiddleImageView
{
    if (!_MiddleImageView) {
        _MiddleImageView = [[UIImageView alloc]init];
        _MiddleImageView.backgroundColor = [UIColor clearColor];
    }
    return _MiddleImageView;
}

- (UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]init];
        _rightImageView.backgroundColor = [UIColor clearColor];
    }
    return _rightImageView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    __weak typeof(self)weakSelf = self;
    [self addSubview:self.LeftImageView];
    [self.LeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(20);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(90*kScreenRatioWidth, 90*kScreenRatioWidth));
    }];
    
    [self addSubview:self.MiddleImageView];
    [self.MiddleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.LeftImageView.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(90*kScreenRatioWidth, 90*kScreenRatioWidth));
    }];
    [self addSubview:self.rightImageView];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.MiddleImageView.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(90*kScreenRatioWidth, 90*kScreenRatioWidth));
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = XXEGreenColor;
    self.titleLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    self.titleLabel.text = @"新";
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.rightImageView.mas_right).offset(6);
        make.top.equalTo(weakSelf.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
}

- (void)getTheImageViewData:(NSArray *)model
{
    if (model.count != 0) {
        self.titleLabel.text = @"新";
        [self.LeftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kXXEPicURL,model[0]]] placeholderImage:[UIImage imageNamed:@"album_icon"]];
//        [self.MiddleImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kXXEPicURL,model[1]]] placeholderImage:[UIImage imageNamed:@"album_icon"]];
//        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kXXEPicURL,model[2]]] placeholderImage:[UIImage imageNamed:@"album_icon"]];
//        [self.MiddleImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kXXEPicURL,model[1]]]];
//        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kXXEPicURL,model[2]]]];
    }else{
        self.titleLabel.text = @"";
        self.LeftImageView.image = [UIImage imageNamed:@"album_icon"];
        self.MiddleImageView.image = [UIImage imageNamed:@"album_icon"];
        self.rightImageView.image = [UIImage imageNamed:@"album_icon"];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
