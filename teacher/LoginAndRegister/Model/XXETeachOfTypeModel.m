//
//  XXETeachOfTypeModel.m
//  teacher
//
//  Created by codeDing on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXETeachOfTypeModel.h"

@implementation XXETeachOfTypeModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"teachTypeId",
                                   @"name":@"teachTypeName"}];
}

@end
