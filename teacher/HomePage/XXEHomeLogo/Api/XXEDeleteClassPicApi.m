//
//  XXEDeleteClassPicApi.m
//  teacher
//
//  Created by codeDing on 16/9/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEDeleteClassPicApi.h"

@implementation XXEDeleteClassPicApi
{
    NSString *_userXid;
    NSString *_userId;
    NSString *_pic_id;
}
//【班级相册->删除图片】
//
//接口类型:2
//
//接口:
//http://www.xingxingedu.cn/Teacher/class_pic_delete

- (id)initWithDeleteUserXid:(NSString *)userXid UserID:(NSString *)userId PicId:(NSString *)picId
{
    self = [super init];
    if (self) {
        _userXid = userXid;
        _userId = userId;
        _pic_id = picId;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"http://www.xingxingedu.cn/Teacher/class_pic_delete"];
}

- (id)requestArgument
{
    return @{@"pic_id":_pic_id,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_userXid,
             @"user_id":_userId,
             @"user_type":USER_TYPE};
}

@end
