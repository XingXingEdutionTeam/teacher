//
//  XXERongCloudSeeNearUserListApi.m
//  teacher
//
//  Created by Mac on 16/10/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERongCloudSeeNearUserListApi.h"


#define URL @"http://www.xingxingedu.cn/Global/search_nearby_user"


@interface XXERongCloudSeeNearUserListApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *page;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *lat;

@end

@implementation XXERongCloudSeeNearUserListApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id page:(NSString *)page lng:(NSString *)lng lat:(NSString *)lat{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _page = page;
        _lng = lng;
        _lat = lat;
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
             @"page":_page,
             @"lng":_lng,
             @"lat":_lat
             };
    
}


@end
