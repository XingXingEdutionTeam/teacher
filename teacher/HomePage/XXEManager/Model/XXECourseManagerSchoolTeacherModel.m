

//
//  XXECourseManagerSchoolTeacherModel.m
//  teacher
//
//  Created by Mac on 16/9/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECourseManagerSchoolTeacherModel.h"

@implementation XXECourseManagerSchoolTeacherModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXECourseManagerSchoolTeacherModel *model = [[XXECourseManagerSchoolTeacherModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"teacherId"
                                                       }];
}

@end
