
//
//  XXECourseManagerCourseTimeModel.m
//  teacher
//
//  Created by Mac on 16/9/26.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECourseManagerCourseTimeModel.h"

@implementation XXECourseManagerCourseTimeModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXECourseManagerCourseTimeModel *model = [[XXECourseManagerCourseTimeModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"course_time_id"
                                                       }];
}


@end
