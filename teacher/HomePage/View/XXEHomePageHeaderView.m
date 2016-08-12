//
//  XXEHomePageHeaderView.m
//  teacher
//
//  Created by codeDing on 16/8/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEHomePageHeaderView.h"
#import "XXEHomePageModel.h"
#import "XXEHomePageSchoolModel.h"
#import "XXEHomePageClassModel.h"

@interface XXEHomePageHeaderView ()

@property (nonatomic, strong)NSMutableArray *schoolDatasource;
@property (nonatomic, strong)NSMutableArray *classDatasource;

@end

@implementation XXEHomePageHeaderView

- (NSMutableArray *)schoolDatasource
{
    if (!_schoolDatasource) {
        _schoolDatasource = [NSMutableArray array];
    }
    return _schoolDatasource;
}

- (NSMutableArray *)classDatasource
{
    if (!_classDatasource) {
        _classDatasource = [NSMutableArray array];
    }
    return _classDatasource;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)configCellWithInfo:(XXEHomePageModel *)homePageModel
{
    _homePageModel = homePageModel;
    [self.homePageLeftButton setImage:[UIImage imageNamed:homePageModel.school_logo] forState:UIControlStateNormal];
    NSString *stringImage = [NSString stringWithFormat:@"%@%@",kXXEPicURL,homePageModel.head_img];
    self.homeUserImageView.image = [UIImage imageNamed:stringImage];
    [self.homeUserImageView sd_setImageWithURL:[NSURL URLWithString:stringImage] placeholderImage:[UIImage imageNamed:@"register_user_icon"]];
    self.homeUserLabel.text = homePageModel.tname;
    self.homeUserLVLabel.text = [NSString stringWithFormat:@"LV:%@",homePageModel.lv];
    self.homeUserAgeLabel.text = [NSString stringWithFormat:@"年龄:%@",homePageModel.age];
    self.homeUserSignatureLabel.text = [NSString stringWithFormat:@"个性签名:%@",homePageModel.personal_sign];
    if ([homePageModel.sex isEqualToString:@"女"]) {
        self.homeGenderImageView.image = [UIImage imageNamed:@"home_women_sex"];
    }else {
        self.homeGenderImageView.image = [UIImage imageNamed:@"home_men_sex"];
    }
    CGFloat a = [homePageModel.coin_total floatValue];
    CGFloat b = [homePageModel.next_grade_coin floatValue];
    NSLog(@"%f",a/b);
    
    [self.homeProgressView setProgress:0.3f animated:YES];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = XXEGreenColor;
    
    self.homePageLeftButton = [UIButton creatSchoolIconImage:@"home_logo" target:self action:@selector(homePageLeftButtonClick:) floats:36*kScreenRatioWidth];
    [self addSubview:self.homePageLeftButton];
    __weak typeof(self)weakSelf = self;
    [self.homePageLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(14);
        make.top.equalTo(weakSelf.mas_top).offset(40*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(36*kScreenRatioWidth, 36*kScreenRatioWidth));
    }];
    
    self.homeSchoolView = [[UIView alloc]init];
    self.homeSchoolView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.homeSchoolView];
    [self.homeSchoolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.homePageLeftButton.mas_right).offset(2);
        make.centerY.equalTo(weakSelf.homePageLeftButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(132*kScreenRatioWidth, 36*kScreenRatioHeight));
    }];
    
    self.homeClassView = [[UIView alloc]init];
    self.homeClassView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.homeClassView];
    [self.homeClassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.homeSchoolView.mas_right).offset(2);
        make.centerY.equalTo(weakSelf.homePageLeftButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(132*kScreenRatioWidth, 36*kScreenRatioHeight));
    }];
    
    self.homePageRightButton = [UIButton creatSchoolIconImage:@"home_login_icon" target:self action:@selector(homePageRightButtonClick:) floats:1];
    [self addSubview:self.homePageRightButton];
    [self.homePageRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-14);
        make.top.equalTo(weakSelf.mas_top).offset(40*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(36*kScreenRatioWidth, 36*kScreenRatioWidth));
    }];
    
    //用户信息
    self.homeUserImageView = [[UIImageView alloc]init];
    self.homeUserImageView.layer.masksToBounds = YES;
    self.homeUserImageView.layer.cornerRadius = 120*kScreenRatioWidth/2;
    self.homeUserImageView.image = [UIImage imageNamed:@"register_user_icon"];
    [self addSubview:self.homeUserImageView];
    [self.homeUserImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(38*kScreenRatioWidth);
        make.top.equalTo(weakSelf.homeSchoolView.mas_bottom).offset(36);
        make.size.mas_equalTo(CGSizeMake(120*kScreenRatioWidth, 120*kScreenRatioWidth));
    }];
    
    self.homeGenderImageView = [[UIImageView alloc]init];
    [self.homeUserImageView addSubview:self.homeGenderImageView];
    [self.homeGenderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.homeUserImageView.mas_centerX);
        make.bottom.equalTo(weakSelf.homeUserImageView.mas_bottom).offset(-15);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    self.homeUserLabel = [UILabel setupHomePageMessageLabel:@"某某某"];
    [self addSubview:self.homeUserLabel];
    
    [self.homeUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.homeUserImageView.mas_right).offset(22*kScreenRatioWidth);
        make.top.equalTo(weakSelf.homeClassView.mas_bottom).offset(36*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(159*kScreenRatioWidth, 30*kScreenRatioHeight));
    }];
    
    
    self.homeUserLVLabel = [[UILabel alloc]init];
    self.homeUserLVLabel.backgroundColor = XXEColorFromRGB(255, 255, 255);
    self.homeUserLVLabel.layer.masksToBounds = YES;
    self.homeUserLVLabel.layer.cornerRadius = 5.f;
    self.homeUserLVLabel.textAlignment = NSTextAlignmentCenter;
    self.homeUserLVLabel.textColor = XXEGreenColor;
    [self addSubview:self.homeUserLVLabel];
    [self.homeUserLVLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.homeUserLabel.mas_right).offset(-100*kScreenRatioWidth);
        make.top.equalTo(weakSelf.homeClassView.mas_bottom).offset(36*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(45*kScreenRatioWidth, 25*kScreenRatioHeight));
    }];
    
    self.homeUserAgeLabel = [UILabel setupHomePageMessageLabel:@"学生年龄:"];
    [self addSubview:self.homeUserAgeLabel];
    [self.homeUserAgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.homeUserImageView.mas_right).offset(22*kScreenRatioWidth);
        make.top.equalTo(weakSelf.homeUserLabel.mas_bottom).offset(5*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(159*kScreenRatioWidth, 30*kScreenRatioHeight));
    }];
    
    self.homeUserSignatureLabel = [UILabel setupHomePageMessageLabel:@"好好学习天天说上相"];
    [self addSubview:self.homeUserSignatureLabel];
    [self.homeUserSignatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.homeUserImageView.mas_right).offset(22*kScreenRatioWidth);
        make.top.equalTo(weakSelf.homeUserAgeLabel.mas_bottom).offset(5*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(159*kScreenRatioWidth, 40*kScreenRatioHeight));
    }];
    
    self.homeProgressView = [[UIProgressView alloc]init];
    self.homeProgressView.progressTintColor = [UIColor whiteColor];
    [self addSubview:self.homeProgressView];
    [self.homeProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.homeUserImageView.mas_right).offset(22*kScreenRatioWidth);
        make.top.equalTo(weakSelf.homeUserSignatureLabel.mas_bottom).offset(5*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(159*kScreenRatioWidth, 3));
    }];
}

#pragma mark - 点击按钮相应对应的事件
- (void)homePageLeftButtonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(homePageLeftButtonClick)]) {
        [self.delegate homePageLeftButtonClick];
    }
}

- (void)homePageRightButtonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(homePageLeftButtonClick)]) {
        [self.delegate homePageRightButtonClick];
    }
}



@end
