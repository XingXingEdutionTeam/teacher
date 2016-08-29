
//
//  XXESchoolAlbumModel.m
//  teacher
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolAlbumModel.h"

@implementation XXESchoolAlbumModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXESchoolAlbumModel *model = [[XXESchoolAlbumModel alloc]initWithDictionary:dic error:nil];
        
//        NSLog(@"ppp == %@", model);
    
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"schoolPicId"
                                                       }];
}


@end
