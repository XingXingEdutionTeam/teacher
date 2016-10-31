
//
//  XXEClassManagerClassListModel.m
//  teacher
//
//  Created by Mac on 16/9/28.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEClassManagerClassListModel.h"

@implementation XXEClassManagerClassListModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXEClassManagerClassListModel *model = [[XXEClassManagerClassListModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"class_id",
                                            @"class":@"classNum"
                                                       }];
}


@end
