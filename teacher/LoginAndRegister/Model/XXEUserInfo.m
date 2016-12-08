//
//  XXEUserInfo.m
//  XMPPDemo
//
//  Created by codeDing on 16/7/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEUserInfo.h"
#import "YTKKeyValueStore.h"

@interface XXEUserInfo ()

@end

static XXEUserInfo *user = nil;
static NSString *tableName = @"teacher_table";
static NSString *userInfo_key = @"teacherInfo";

@implementation XXEUserInfo

+ (instancetype)user
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[super allocWithZone:nil]init];
    });
    return user;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self user];
}

- (instancetype)init
{
    if (user) {
        return user;
    }
    self = [super init];
    if (self) {
        YTKKeyValueStore *store = [[YTKKeyValueStore alloc]initDBWithName:@"data.db"];
        NSDictionary *userInfo = [store getObjectById:userInfo_key fromTable:tableName];
        if (userInfo) {
            [self setupUserInfoWithUserInfo:userInfo];
        }
        else {
            _account = nil;
            _user_head_img = nil;
            _nickname = nil;
            _user_type = nil;
            _passWord = nil;
            _user_id = nil;
            _token = nil;
            _xid = nil;
            _qqNumberToken = nil;
            _weixinToken = nil;
            _sinaNumberToken = nil;
            _zhifubaoToken = nil;
            _login_times = nil;
            _appkey = @"U3k8Dgj7e934bh5Y";
            _login_type = nil;
            
        }
    }
    return self;
}


- (void)setupUserInfoWithUserInfo:(NSDictionary *)userInfo
{
    _account = userInfo[@"phone"];
    
    _user_head_img = userInfo[@"user_head_img"];
    _nickname = userInfo[@"nickname"];
    _user_id = userInfo[@"user_id"];
    _user_type = userInfo[@"user_type"];
    _qqNumberToken = userInfo[@"qqNumberToken"];
    _sinaNumberToken = userInfo[@"sinaNumberToken"];
    _weixinToken = userInfo[@"weixinToken"];
    _zhifubaoToken = userInfo[@"zhifubaoToken"];
    _passWord = userInfo[@"passWord"];
    _token = userInfo[@"token"];
    _xid = userInfo[@"xid"];
    _login_type = userInfo[@"login_type"];
    _login = [userInfo[@"loginStatus"] boolValue]?:NO;
    _login_times = userInfo[@"login_times"];
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc]initDBWithName:@"data.db"];
    [store createTableWithName:tableName];
    [store putObject:userInfo withId:userInfo_key intoTable:tableName];
}

- (void)synchronizeDefaultsInfo
{
    if (self.xid) {
        NSDictionary *userInfo = @{
                                   @"account":self.account,
                                   @"user_head_img":self.user_head_img,
                                   @"nickname":self.nickname,
                                   @"user_type":self.user_type,
                                   @"token":self.token,
                                   @"xid":self.xid,
                                   @"user_id":self.user_id,
                                   @"login_type":self.login_type,
                                   @"qqNumberToken":self.qqNumberToken,
                                   @"weixinToken":self.weixinToken?self.weixinToken:@"",
                                   @"sinaNumberToken":self.sinaNumberToken?self.sinaNumberToken:@"",
                                   @"password":self.passWord?self.passWord:@"",
                                   @"zhifubaoToken":self.zhifubaoToken?self.zhifubaoToken:@"",
                                   @"loginStatus":[NSNumber numberWithBool:self.login],
                                   @"login_times":self.login_times
                                   };
        YTKKeyValueStore *store = [[YTKKeyValueStore alloc]initDBWithName:@"data.db"];
        [store putObject:userInfo withId:userInfo_key intoTable:tableName];
    }
}

- (void)cleanUserInfo
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc]initDBWithName:@"data.db"];
    [store clearTable:tableName];
}

@end
