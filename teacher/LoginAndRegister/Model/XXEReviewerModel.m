//
//  XXEReviewerModel.m
//  teacher
//
//  Created by codeDing on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEReviewerModel.h"

@implementation XXEReviewerModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"reviewerId",
                                 @"tname":@"reviewerName"}];
}

@end
