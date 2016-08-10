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

@implementation XXEHomePageHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //创建视图
        [self creatHomeHeaderView];
    }
    return self;
}

- (void)configCellWithInfo:(XXEHomePageModel *)homePageModel
{
    _homePageModel = homePageModel;
    [self.homePageLeftButton setImage:[UIImage imageNamed:homePageModel.school_logo] forState:UIControlStateNormal];
    NSString *stringImage = [NSString stringWithFormat:@"%@%@",kXXEPicURL,homePageModel.head_img];
    self.homeUserImageView.image = [UIImage imageNamed:stringImage];
    self.homeUserLabel.text = homePageModel.tname;
    self.homeUserLVLabel.text = homePageModel.lv;
    self.homeUserAgeLabel.text = homePageModel.age;
    self.homeUserSignatureLabel.text = homePageModel.personal_sign;
    self.homeSchoolView.dataArray = homePageModel.school_info;
    if ([homePageModel.sex isEqualToString:@"女"]) {
        self.homeGenderImageView.image = [UIImage imageNamed:@""];
    }else {
        self.homeGenderImageView.image = [UIImage imageNamed:@""];
    }
    
    
    
}

- (void)configCellWithInfo1:(XXEHomePageSchoolModel *)homePageSchoolModel
{
    NSLog(@"班级是什么 %@",homePageSchoolModel.school_name);
    
}



//- (void)setHomePageSchoolModel:(XXEHomePageSchoolModel *)homePageSchoolModel
//{
//    _homePageSchoolModel = homePageSchoolModel;
//    self.homeClassView.dataArray = homePageSchoolModel.class_info;
//}



- (void)creatHomeHeaderView
{
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = XXEGreenColor;
    
    self.homePageLeftButton = [UIButton creatSchoolIconImage:@"QQ_click" target:self action:@selector(homePageLeftButtonClick:) floats:36];
    [self addSubview:self.homePageLeftButton];
    __weak typeof(self)weakSelf = self;
    [self.homePageLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(14);
        make.top.equalTo(weakSelf.mas_top).offset(40*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(36*kScreenRatioWidth, 36*kScreenRatioWidth));
    }];
    
    self.homeSchoolView = [[WJCommboxView alloc]init];
    self.homeSchoolView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.homeSchoolView];
    [self.homeSchoolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.homePageLeftButton.mas_right).offset(2);
        make.centerY.equalTo(weakSelf.homePageLeftButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(132*kScreenRatioWidth, 36*kScreenRatioHeight));
    }];
    
    self.homeClassView = [[WJCommboxView alloc]init];
    self.homeClassView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.homeClassView];
    [self.homeClassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.homeSchoolView.mas_right).offset(2);
        make.centerY.equalTo(weakSelf.homePageLeftButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(132*kScreenRatioWidth, 36*kScreenRatioHeight));
    }];
    
    self.homePageRightButton = [UIButton creatSchoolIconImage:@"QQ_click" target:self action:@selector(homePageRightButtonClick:) floats:1];
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
    
    self.homeUserLabel = [UILabel setupHomePageMessageLabel:@"李晓红"];
    [self addSubview:self.homeUserLabel];
    
    [self.homeUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.homeUserImageView.mas_right).offset(22*kScreenRatioWidth);
        make.top.equalTo(weakSelf.homeClassView.mas_bottom).offset(36*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(159*kScreenRatioWidth, 30*kScreenRatioHeight));
    }];
    
    self.homeUserAgeLabel = [UILabel setupHomePageMessageLabel:@"学生年龄:"];
    [self addSubview:self.homeUserAgeLabel];
    [self.homeUserAgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.homeUserImageView.mas_right).offset(22*kScreenRatioWidth);
        make.top.equalTo(weakSelf.homeUserLabel.mas_bottom).offset(5*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(159*kScreenRatioWidth, 30*kScreenRatioHeight));
    }];
    
    self.homeUserSignatureLabel = [UILabel setupHomePageMessageLabel:@"好好学习天天说上相00djsajdk00000"];
    [self addSubview:self.homeUserSignatureLabel];
    [self.homeUserSignatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.homeUserImageView.mas_right).offset(22*kScreenRatioWidth);
        make.top.equalTo(weakSelf.homeUserAgeLabel.mas_bottom).offset(5*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(159*kScreenRatioWidth, 40*kScreenRatioHeight));
    }];
    
    self.homeProgressView = [[ProgressView alloc]init];
    self.homeProgressView.layer.borderWidth = 1.f;
    self.homeProgressView.layerColor = [UIColor whiteColor];
    self.homeProgressView.progress = 59.f;
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
