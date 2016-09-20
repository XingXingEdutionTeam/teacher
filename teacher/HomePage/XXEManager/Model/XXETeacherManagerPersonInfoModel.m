

//
//  XXETeacherManagerPersonInfoModel.m
//  teacher
//
//  Created by Mac on 16/9/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXETeacherManagerPersonInfoModel.h"

@implementation XXETeacherManagerPersonInfoModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXETeacherManagerPersonInfoModel *model = [[XXETeacherManagerPersonInfoModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"examine_id"
                                                       }];
}


@end
