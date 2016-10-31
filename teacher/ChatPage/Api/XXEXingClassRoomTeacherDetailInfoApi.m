

//
//  XXEXingClassRoomTeacherDetailInfoApi.m
//  teacher
//
//  Created by Mac on 16/10/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingClassRoomTeacherDetailInfoApi.h"

#define URL @"http://www.xingxingedu.cn/Global/xkt_teacher_detail"

@interface XXEXingClassRoomTeacherDetailInfoApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *teacher_id;


@end
@implementation XXEXingClassRoomTeacherDetailInfoApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id teacher_id:(NSString *)teacher_id{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _teacher_id = teacher_id;
        
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
             @"teacher_id":_teacher_id
             
             };
    
}


@end
