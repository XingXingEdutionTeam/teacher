//
//  XXESelectMessageView.h
//  TWCitySelectView
//
//  Created by codeDing on 16/8/18.
//  Copyright © 2016年 Raykin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXESelectMessageView : UIView


-(instancetype)initWithTWFrame:(CGRect)rect TWselectCityTitle:(NSString*)title MessageArray:(NSMutableArray *)messageArray;

/**
 *  显示
 */
-(void)showCityView:(void(^)(NSString *proviceStr))selectStr;


@end
