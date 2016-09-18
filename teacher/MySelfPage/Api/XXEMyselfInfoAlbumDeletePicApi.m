


//
//  XXEMyselfInfoAlbumDeletePicApi.m
//  teacher
//
//  Created by Mac on 16/9/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoAlbumDeletePicApi.h"


#define URL @"http://www.xingxingedu.cn/Teacher/delete_teacher_pic"

@interface XXEMyselfInfoAlbumDeletePicApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *pic_id;

@end

@implementation XXEMyselfInfoAlbumDeletePicApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id pic_id:(NSString *)pic_id{
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _pic_id = pic_id;
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
             @"pic_id":_pic_id
             };
    
}


@end
