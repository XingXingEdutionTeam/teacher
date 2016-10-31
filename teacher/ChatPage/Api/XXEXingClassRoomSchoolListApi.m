

//
//  XXEXingClassRoomSchoolListApi.m
//  teacher
//
//  Created by Mac on 16/10/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingClassRoomSchoolListApi.h"


#define URL @"http://www.xingxingedu.cn/Global/xkt_school"

@interface XXEXingClassRoomSchoolListApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *user_lng;
@property (nonatomic, copy) NSString *user_lat;
@property (nonatomic, copy) NSString *filter_distance;
@property (nonatomic, assign) NSInteger appoint_order;
@property (nonatomic, copy) NSString *class_str;
@property (nonatomic, copy) NSString *search_words;


@end

@implementation XXEXingClassRoomSchoolListApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id page:(NSInteger)page user_lng:(NSString *)user_lng user_lat:(NSString *)user_lat filter_distance:(NSString *)filter_distance appoint_order:(NSInteger)appoint_order class_str:(NSString *)class_str search_words:(NSString *)search_words{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _page = page;
        _user_lng = user_lng;
        _user_lat = user_lat;
        _filter_distance = filter_distance;
        _appoint_order = appoint_order;
        _class_str = class_str;
        _search_words = search_words;
        
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
    
    return @{
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":USER_TYPE,
             @"page":[NSString stringWithFormat:@"%ld", _page],
             @"user_lng":_user_lng,
             @"user_lat":_user_lat,
             @"filter_distance":_filter_distance,
             @"appoint_order":[NSString stringWithFormat:@"%ld", _appoint_order],
             @"class_str":_class_str,
             @"search_words":_search_words
             };
    
}


@end
