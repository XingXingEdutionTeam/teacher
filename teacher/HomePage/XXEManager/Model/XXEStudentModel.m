
//
//  XXEStudentModel.m
//  teacher
//
//  Created by Mac on 16/9/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStudentModel.h"

@implementation XXEStudentModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXEStudentModel *model = [[XXEStudentModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

@end
