//
//  XXERCReturnToken.m
//  teacher
//
//  Created by codeDing on 16/11/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERCReturnToken.h"

#define URL @"http://api.cn.ronghub.com/user/getToken."

@interface XXERCReturnToken()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *portraitUri;

@end

@implementation XXERCReturnToken
- (instancetype)initWithXid:(NSString *)xid nickName:(NSString *)nickName portraitUri:(NSString *)portraitUri{
    
    if (self = [super init]) {
        _xid = xid;
        _nickName = nickName;
        _portraitUri = portraitUri;
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
    
    return @{@"userId":self.xid,
             @"name":self.nickName,
             @"portraitUri":self.portraitUri
             };
    
}
@end
