
//
//  XXECourseOrderListModel.m
//  teacher
//
//  Created by Mac on 2016/11/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECourseOrderListModel.h"

@implementation XXECourseOrderListModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXECourseOrderListModel *model = [[XXECourseOrderListModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"course_order_Id"
                                                       }];
}


@end
