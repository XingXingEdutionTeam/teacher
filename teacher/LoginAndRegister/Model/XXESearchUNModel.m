//
//  XXESearchUNModel.m
//  teacher
//
//  Created by codeDing on 16/9/7.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESearchUNModel.h"

@implementation XXESearchUNModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"schoolId",
                                                      @"name":@"schoolName",
                                                      @"province":@"schoolProvince",
                                                      @"city":@"schoolCity",
                                                      @"district":@"schoolDistrict"
                                                      }];
}

@end
