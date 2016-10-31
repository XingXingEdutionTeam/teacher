

//
//  XXECourseManagerCoursePicModel.m
//  teacher
//
//  Created by Mac on 16/9/26.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECourseManagerCoursePicModel.h"

@implementation XXECourseManagerCoursePicModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXECourseManagerCoursePicModel *model = [[XXECourseManagerCoursePicModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"course_pic_id"
                                                       }];
}


@end
