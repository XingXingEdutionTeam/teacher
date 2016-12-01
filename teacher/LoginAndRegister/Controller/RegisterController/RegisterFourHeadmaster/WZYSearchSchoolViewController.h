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

typedef void(^ReturnModelBlock)(XXETeacherModel *teacherModel);

@interface WZYSearchSchoolViewController : XXEBaseViewController

@property (nonatomic, copy) ReturnModelBlock returnModelBlock;

@property (nonatomic, weak)id<XXESearchSchoolMessageDelegate>delegate;
//判断注册身份,如果是管理员或者校长,返回学校名称/学校类型/详细地址/电话等;如果是授课老师或班主任,返回 学校名称/学校类型
@property (nonatomic, copy) NSString *WZYSearchFlagStr;



- (void)returnModel:(ReturnModelBlock)block;

@end
