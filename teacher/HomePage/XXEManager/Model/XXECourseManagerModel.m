
//
//  XXECourseManagerModel.m
//  teacher
//
//  Created by Mac on 16/9/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECourseManagerModel.h"

@implementation XXECourseManagerModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXECourseManagerModel *model = [[XXECourseManagerModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"course_id"
                                                       }];
}

@end
