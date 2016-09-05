//
//  XXEGoodUserModel.m
//  teacher
//
//  Created by codeDing on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEGoodUserModel.h"

@implementation XXEGoodUserModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"xid":@"goodXid",@"nickname":@"goodNickName"}];
}

@end
