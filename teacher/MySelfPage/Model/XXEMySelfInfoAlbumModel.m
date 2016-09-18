
//
//  XXEMySelfInfoAlbumModel.m
//  teacher
//
//  Created by Mac on 16/9/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMySelfInfoAlbumModel.h"

@implementation XXEMySelfInfoAlbumModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXEMySelfInfoAlbumModel *model = [[XXEMySelfInfoAlbumModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"myselfPicId",
                                                       }];
}

@end
