

//
//  XXECourseManagerCourseDetailInfoModel.m
//  teacher
//
//  Created by Mac on 16/9/26.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECourseManagerCourseDetailInfoModel.h"

@implementation XXECourseManagerCourseDetailInfoModel

//+ (NSArray*)parseResondsData:(id)respondObject
//{
//    NSMutableArray *modelArray = [NSMutableArray array];
//    for (NSDictionary *dic  in respondObject) {
//        XXECourseManagerCourseDetailInfoModel *model = [[XXECourseManagerCourseDetailInfoModel alloc]initWithDictionary:dic error:nil];
//        [modelArray addObject:model];
//    }
//    return modelArray;
//}

+ (XXECourseManagerCourseDetailInfoModel *)parseResondsData:(id)respondObject{
    return [[XXECourseManagerCourseDetailInfoModel alloc] initWithDictionary:respondObject error:nil];
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"course_id"
                                                       }];
}

@end
