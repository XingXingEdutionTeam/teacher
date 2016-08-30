
//
//  XXEChiefAndTeacherModel.m
//  teacher
//
//  Created by Mac on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEChiefAndTeacherModel.h"

@implementation XXEChiefAndTeacherModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXEChiefAndTeacherModel *model = [[XXEChiefAndTeacherModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}



@end
