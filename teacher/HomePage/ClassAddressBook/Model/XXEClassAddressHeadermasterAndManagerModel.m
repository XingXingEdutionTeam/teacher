

//
//  XXEClassAddressHeadermasterAndManagerModel.m
//  teacher
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEClassAddressHeadermasterAndManagerModel.h"

@implementation XXEClassAddressHeadermasterAndManagerModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXEClassAddressHeadermasterAndManagerModel *model = [[XXEClassAddressHeadermasterAndManagerModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

@end
