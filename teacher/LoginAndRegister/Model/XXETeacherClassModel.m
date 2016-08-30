//
//  XXETeacherClassModel.m
//  teacher
//
//  Created by codeDing on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXETeacherClassModel.h"

@implementation XXETeacherClassModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"class":@"className"}];
}

@end
