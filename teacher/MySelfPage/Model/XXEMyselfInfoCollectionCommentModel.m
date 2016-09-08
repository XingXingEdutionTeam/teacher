//
//  XXEMyselfInfoCollectionCommentModel.m
//  teacher
//
//  Created by Mac on 16/9/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoCollectionCommentModel.h"

@implementation XXEMyselfInfoCollectionCommentModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXEMyselfInfoCollectionCommentModel *model = [[XXEMyselfInfoCollectionCommentModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"collectionId"
                                                       }];
}

@end
