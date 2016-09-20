
//
//  XXETeacherManagerClassInfoModel.m
//  teacher
//
//  Created by Mac on 16/9/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXETeacherManagerClassInfoModel.h"

@implementation XXETeacherManagerClassInfoModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXETeacherManagerClassInfoModel *model = [[XXETeacherManagerClassInfoModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}


@end
