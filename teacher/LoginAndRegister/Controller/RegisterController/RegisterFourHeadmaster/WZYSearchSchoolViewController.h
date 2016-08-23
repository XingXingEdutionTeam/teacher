//
//  WZYSearchSchoolViewController.h
//  XingXingEdu
//
//  Created by Mac on 16/7/7.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@class XXETeacherModel;
@protocol XXESearchSchoolMessageDelegate <NSObject>

@optional
- (void)searchSchoolMessage:(XXETeacherModel *)model;

@end

typedef void(^ReturnArrayBlock)(NSMutableArray *mArr);

@interface WZYSearchSchoolViewController : XXEBaseViewController

@property (nonatomic, copy) ReturnArrayBlock returnArrayBlock;

@property (nonatomic, weak)id<XXESearchSchoolMessageDelegate>delegate;

@property (nonatomic) BOOL WZYSearchFlagStr;



- (void)returnArray:(ReturnArrayBlock)block;

@end
