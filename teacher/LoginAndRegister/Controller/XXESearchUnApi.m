//
//  XXESearchUnApi.m
//  teacher
//
//  Created by codeDing on 16/9/7.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESearchUnApi.h"

@implementation XXESearchUnApi{
    NSString *_userXid;
    NSString *_userId;
    NSString *_province;
    NSString *_city;
    NSString *_district;
    NSString *_searchWords;
}

- (id)initWithUserXid:(NSString *)userXid UserId:(NSString *)userId Province:(NSString *)province City:(NSString *)city District:(NSString *)district SearchWords:(NSString *)searchWords
{
    self = [super init];
    if (self) {
        _userXid = userXid;
        _userId = userId;
        _province = province;
        _city = city;
        _district = district;
        _searchWords = searchWords;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"http://www.xingxingedu.cn/Teacher/get_university"];
}

- (id)requestArgument
{
    return @{@"xid":_userXid,
             @"user_id":_userId,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_type":USER_TYPE,
             @"province":_province,
             @"city":_city,
             @"district":_district,
             @"search_words":_searchWords
             };
}

@end
