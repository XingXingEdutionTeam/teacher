//
//  XXEHomePageHeaderView.h
//  teacher
//
//  Created by codeDing on 16/8/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressView.h"

@class XXEHomePageModel;
@class XXEHomePageSchoolModel;
@class XXEHomePageClassModel;
@protocol XXEHomePageHeaderViewDelegate <NSObject>

@optional
//点击button相应事件
/** 点击学校图标进入学校详情页面 */
- (void)homePageLeftButtonClick;
/** 点击学校图标进入登录页面 */
- (void)homePageRightButtonClick;

@end

@interface XXEHomePageHeaderView : UIView

@property (nonatomic, weak)id <XXEHomePageHeaderViewDelegate>delegate;

@property (nonatomic, strong)XXEHomePageModel *homePageModel;
@property (nonatomic, strong)XXEHomePageSchoolModel *homePageSchoolModel;
@property (nonatomic, strong)XXEHomePageClassModel *homePageClassModel;

/** 首页顶部左边按钮 */
@property (nonatomic, strong)UIButton *homePageLeftButton;
/** 首页顶部右边边按钮 */
@property (nonatomic, strong)UIButton *homePageRightButton;
/** 下拉框 学校 */
@property (nonatomic, strong)UIView *homeSchoolView;
/** 下拉框 班级 */
@property (nonatomic, strong)UIView *homeClassView;
/** 用户头像 */
@property (nonatomic, strong)UIImageView *homeUserImageView;
/** 用户等级 */
@property (nonatomic, strong)UILabel *homeUserLVLabel;

/** 用户姓名 */
@property (nonatomic, strong)UILabel *homeUserLabel;
/** 用户年龄 */
@property (nonatomic, strong)UILabel *homeUserAgeLabel;
/** 用户签名 */
@property (nonatomic, strong)UILabel *homeUserSignatureLabel;
/** 滑动指示条 */
@property (nonatomic, strong)UIProgressView *homeProgressView;
/** 性别 */
@property (nonatomic, strong)UIImageView *homeGenderImageView;

/** 给视图添加数据 */
- (void)configCellWithInfo:(XXEHomePageModel *)homePageModel;

@end
