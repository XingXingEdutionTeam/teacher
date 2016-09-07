//
//  XXESearchUniversityController.h
//  teacher
//
//  Created by codeDing on 16/9/7.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"
@class XXESearchUNModel;
@protocol XXESearchSchoolNUMessageDelegate <NSObject>

@optional
- (void)searchSchoolNUMessage:(XXESearchUNModel *)model;

@end
typedef void(^ReturnArrayBlock)(NSMutableArray *mArr);

@interface XXESearchUniversityController : XXEBaseViewController

@property (nonatomic, copy) ReturnArrayBlock returnArrayBlock;

@property (nonatomic, weak)id<XXESearchSchoolNUMessageDelegate>delegate;

@property (nonatomic) BOOL WZYSearchFlagStr;

- (void)returnArray:(ReturnArrayBlock)block;
@end
