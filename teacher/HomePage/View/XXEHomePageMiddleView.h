//
//  XXEHomePageMiddleView.h
//  teacher
//
//  Created by codeDing on 16/8/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XXEHomePageModel;
@protocol XXEHomePageMiddleViewDelegate <NSObject>

@optional
/** 花篮点击相应事件 */
- (void)homeMiddleFirstButtonClick;
/** 小红花点击事件 */
- (void)homeMiddleTwoButtonClick;
/** 猩币点击事件 */
- (void)homeMiddleThreeButtonClick;

@end


@interface XXEHomePageMiddleView : UIView

@property (nonatomic, weak)id<XXEHomePageMiddleViewDelegate>delegate;

@property (nonatomic, strong)XXEHomePageModel *homePageModel;

/** 第一个花篮的按钮 */
@property (nonatomic, strong)UIButton *homeMiddleFirstButton;
/** 第二个小红花按钮 */
@property (nonatomic, strong)UIButton *homeMiddleTwoButton;
/** 第三个猩币按钮 */
@property (nonatomic, strong)UIButton *homeMiddleThreeButton;
/** 第四个通知按钮 */
@property (nonatomic, strong)UIButton *homeMiddleFourButton;
@end
