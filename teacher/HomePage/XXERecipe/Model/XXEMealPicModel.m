
//
//  XXEMealPicModel.m
//  teacher
//
//  Created by Mac on 16/8/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMealPicModel.h"

@implementation XXEMealPicModel


+ (JSONKeyMapper *)keyMapper{

    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"picIdStr"
                                                       }];
}


@end
