
//
//  XXESystemNotificationModel.m
//  teacher
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESystemNotificationModel.h"

@implementation XXESystemNotificationModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXESystemNotificationModel *model = [[XXESystemNotificationModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"notice_id"
                                                       }];
}


@end