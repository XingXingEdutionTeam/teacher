
//
//  XXEXingClassRoomCourseDetailInfoApi.m
//  teacher
//
//  Created by Mac on 16/10/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingClassRoomCourseDetailInfoApi.h"

#define URL @"http://www.xingxingedu.cn/Global/xkt_course_detail"

@interface XXEXingClassRoomCourseDetailInfoApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *course_id;


@end

@implementation XXEXingClassRoomCourseDetailInfoApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id course_id:(NSString *)course_id{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _course_id = course_id;
        
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
             @"course_id":_course_id
             
             };
    
}


@end
