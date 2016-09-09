
//
//  XXEMyselfInfoCollectionPicModel.m
//  teacher
//
//  Created by Mac on 16/9/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoCollectionPicModel.h"

@implementation XXEMyselfInfoCollectionPicModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXEMyselfInfoCollectionPicModel *model = [[XXEMyselfInfoCollectionPicModel alloc]initWithDictionary:dic error:nil];
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
