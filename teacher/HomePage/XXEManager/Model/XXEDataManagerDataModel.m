
//
//  XXEDataManagerDataModel.m
//  teacher
//
//  Created by Mac on 16/10/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEDataManagerDataModel.h"

@implementation XXEDataManagerDataModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXEDataManagerDataModel *model = [[XXEDataManagerDataModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

@end
