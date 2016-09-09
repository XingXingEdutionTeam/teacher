
//
//  XXEMyselfBlackListModel.m
//  teacher
//
//  Created by Mac on 16/9/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfBlackListModel.h"

@implementation XXEMyselfBlackListModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXEMyselfBlackListModel *model = [[XXEMyselfBlackListModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

@end
