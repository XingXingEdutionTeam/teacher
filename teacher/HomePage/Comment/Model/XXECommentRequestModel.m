


//
//  XXECommentRequestModel.m
//  teacher
//
//  Created by Mac on 16/8/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECommentRequestModel.h"

@implementation XXECommentRequestModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXECommentRequestModel *model = [[XXECommentRequestModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"commentId"
                                                       }];
}

@end