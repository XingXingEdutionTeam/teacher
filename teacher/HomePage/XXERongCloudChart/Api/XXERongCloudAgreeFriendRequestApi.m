
//
//  XXERongCloudAgreeFriendRequestApi.m
//  teacher
//
//  Created by Mac on 16/10/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERongCloudAgreeFriendRequestApi.h"

#define URL @"http://www.xingxingedu.cn/Global/agree_friend_request"


@interface XXERongCloudAgreeFriendRequestApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *request_id;


@end


@implementation XXERongCloudAgreeFriendRequestApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id request_id:(NSString *)request_id{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _request_id = request_id;
    }
    return self;
}


- (NSString *)requestUrl{
    
    return URL;
    
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPost;
    
}



- (id)requestArgument{
    
    return @{@"url":URL,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":USER_TYPE,
             @"request_id":_request_id
             };
    
}

@end