//
//  XXEAlbumDetailsModel.m
//  teacher
//
//  Created by codeDing on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEAlbumDetailsModel.h"

@implementation XXEAlbumDetailsModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"photoId"}];
}

@end
