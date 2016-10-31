
//
//  XXERongCloudFriendRequestListModel.m
//  teacher
//
//  Created by Mac on 16/10/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERongCloudFriendRequestListModel.h"

@implementation XXERongCloudFriendRequestListModel

+ (NSArray*)parseResondsData:(id)respondObject
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic  in respondObject) {
        XXERongCloudFriendRequestListModel *model = [[XXERongCloudFriendRequestListModel alloc]initWithDictionary:dic error:nil];
        [modelArray addObject:model];
    }
    return modelArray;
}

+(JSONKeyMapper*)keyMapper
{
return [[JSONKeyMapper alloc] initWithDictionary:@{
                                    @"id": @"agree_friend_request_id"
                                                       }];
}


@end
