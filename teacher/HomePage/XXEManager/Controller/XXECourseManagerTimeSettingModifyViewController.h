//
//  XXECourseManagerTimeSettingModifyViewController.h
//  teacher
//
//  Created by Mac on 16/9/27.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

typedef void(^ReturnArrayBlock) (NSArray *resultArray);

@interface XXECourseManagerTimeSettingModifyViewController : XXEBaseViewController

@property (nonatomic, copy) NSString *position;

//课程具体 时间 表
@property (nonatomic, strong) NSMutableArray *courseTimeOldArray;

//开始 日期
@property (nonatomic, copy) NSString *startDateStr;

//结束 日期
@property (nonatomic, copy) NSString *endDateStr;

//课程 时长
@property (nonatomic, copy) NSString *course_hour;

//每周 次数
@property (nonatomic, copy) NSString *week_times;

@property (nonatomic, copy) ReturnArrayBlock returnArrayBlock;

- (void)returnStr:(ReturnArrayBlock)block;


@end
