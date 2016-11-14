

//
//  XXEStoreGoodInfoModel.m
//  teacher
//
//  Created by Mac on 16/11/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStoreGoodInfoModel.h"

@implementation XXEStoreGoodInfoModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXEStoreGoodInfoModel *model = [[XXEStoreGoodInfoModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"good_id",
                                                       @"class":@"class_id"
                                                       }];
}


@end
