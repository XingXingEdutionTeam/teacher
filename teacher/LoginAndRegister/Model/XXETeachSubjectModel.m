//
//  XXETeachSubjectModel.m
//  teacher
//
//  Created by Mac on 2016/11/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXETeachSubjectModel.h"

@implementation XXETeachSubjectModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXETeachSubjectModel *model = [[XXETeachSubjectModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"teachsubjectId"                                                       }];
}

@end
