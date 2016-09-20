
//
//  XXEFamilyManagerClassInfoModel.m
//  teacher
//
//  Created by Mac on 16/9/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFamilyManagerClassInfoModel.h"

@implementation XXEFamilyManagerClassInfoModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXEFamilyManagerClassInfoModel *model = [[XXEFamilyManagerClassInfoModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

@end
