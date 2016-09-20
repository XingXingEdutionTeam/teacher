//
//  XXEInfomationViewController.h
//  teacher
//
//  Created by codeDing on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@class XXECircleModel;

@protocol  XXEInfomationViewControllerDelegate<NSObject>

- (void)onLike;
- (void)onComment;

@end

@interface XXEInfomationViewController : XXEBaseViewController
@property (nonatomic, assign)long ts;
@property (nonatomic,copy) NSString *itemId;
@property (nonatomic,copy) NSString *conText;
@property (nonatomic, copy) NSString *imagesArr;
@property (nonatomic, strong) NSArray *goodArr;
@property (nonatomic, weak) id<XXEInfomationViewControllerDelegate> delegate;


/** 直接传每一个说说的Model */
@property (nonatomic, strong)XXECircleModel *infoCircleModel;

@end
