



//
//  XXERedFlowerSentHistoryModel.m
//  teacher
//
//  Created by Mac on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERedFlowerSentHistoryModel.h"

@implementation XXERedFlowerSentHistoryModel


+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXERedFlowerSentHistoryModel *model = [[XXERedFlowerSentHistoryModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}



@end
