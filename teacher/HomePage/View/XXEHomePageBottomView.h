//
//  XXEHomePageBottomView.h
//  teacher
//
//  Created by codeDing on 16/8/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XXEHomePageBottomViewDelegate <NSObject>

@optional
/** 点击对应的按钮相应方法 */
- (void)homeClassOneButtonClick:(NSInteger)tag;

@end

@interface XXEHomePageBottomView : UIView

@property (nonatomic, weak)id<XXEHomePageBottomViewDelegate>delegate;

@end
