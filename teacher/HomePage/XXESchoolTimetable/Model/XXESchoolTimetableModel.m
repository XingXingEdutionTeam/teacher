

//
//  XXESchoolTimetableModel.m
//  teacher
//
//  Created by Mac on 16/11/1.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolTimetableModel.h"

@implementation XXESchoolTimetableModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXESchoolTimetableModel *model = [[XXESchoolTimetableModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"schedule_id"
                                                       }];
}


@end
