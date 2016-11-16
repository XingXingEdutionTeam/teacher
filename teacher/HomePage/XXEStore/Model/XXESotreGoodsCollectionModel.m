
//
//  XXESotreGoodsCollectionModel.m
//  teacher
//
//  Created by Mac on 2016/11/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESotreGoodsCollectionModel.h"

@implementation XXESotreGoodsCollectionModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXESotreGoodsCollectionModel *model = [[XXESotreGoodsCollectionModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"good_id",
                                                       @"class":@"classStr"
                                                       }];
}

@end
