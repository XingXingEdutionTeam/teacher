
//
//  XXESchoolRegisterTeacherInfoModel.m
//  teacher
//
//  Created by Mac on 16/8/31.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolRegisterTeacherInfoModel.h"

@implementation XXESchoolRegisterTeacherInfoModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXESchoolRegisterTeacherInfoModel *model = [[XXESchoolRegisterTeacherInfoModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"registerTeacherId"
                                                       }];
}

@end
