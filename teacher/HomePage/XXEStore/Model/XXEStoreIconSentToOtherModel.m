

//
//  XXEStoreIconSentToOtherModel.m
//  teacher
//
//  Created by Mac on 2016/11/15.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStoreIconSentToOtherModel.h"

@implementation XXEStoreIconSentToOtherModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXEStoreIconSentToOtherModel *model = [[XXEStoreIconSentToOtherModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

@end
