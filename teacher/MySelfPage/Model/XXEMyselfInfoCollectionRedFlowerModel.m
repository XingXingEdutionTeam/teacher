
//
//  XXEMyselfInfoCollectionRedFlowerModel.m
//  teacher
//
//  Created by Mac on 16/9/6.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoCollectionRedFlowerModel.h"

@implementation XXEMyselfInfoCollectionRedFlowerModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXEMyselfInfoCollectionRedFlowerModel *model = [[XXEMyselfInfoCollectionRedFlowerModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"collectionId"
                                                       }];
}


@end
