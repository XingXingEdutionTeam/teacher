
//
//  XXESentFlowerbasketToOtherModel.m
//  teacher
//
//  Created by Mac on 2016/11/15.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESentFlowerbasketToOtherModel.h"

@implementation XXESentFlowerbasketToOtherModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXESentFlowerbasketToOtherModel *model = [[XXESentFlowerbasketToOtherModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"other_id"
                                                       }];
}


@end
