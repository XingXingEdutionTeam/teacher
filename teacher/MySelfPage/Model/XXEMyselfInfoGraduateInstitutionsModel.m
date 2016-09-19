
//
//  XXEMyselfInfoGraduateInstitutionsModel.m
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoGraduateInstitutionsModel.h"

@implementation XXEMyselfInfoGraduateInstitutionsModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXEMyselfInfoGraduateInstitutionsModel *model = [[XXEMyselfInfoGraduateInstitutionsModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"graduateInstitutionId",
                                                       }];
}

@end
