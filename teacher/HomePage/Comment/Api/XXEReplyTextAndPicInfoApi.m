

//
//  XXEReplyTextAndPicInfoApi.m
//  teacher
//
//  Created by Mac on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEReplyTextAndPicInfoApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/request_comment_action"


@interface XXEReplyTextAndPicInfoApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *comment_id;
@property (nonatomic, copy) NSString *com_con;
@property (nonatomic, strong) UIImage *upImage;


@end


@implementation XXEReplyTextAndPicInfoApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type class_id:(NSString *)class_id comment_id:(NSString *)comment_id com_con:(NSString *)com_con upImage:(UIImage *)upImage{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        
        _class_id = class_id;
        _comment_id = comment_id;
        _com_con = com_con;
        _upImage = upImage;
    }
    return self;
}


- (NSString *)requestUrl{
    
    return URL;
    
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPost;
    
}

-(AFConstructingBlock)constructingBodyBlock
{
    return ^(id<AFMultipartFormData> formData){
        int i = 1;
        NSData *data = UIImageJPEGRepresentation(_upImage, 0.5);
        NSString *name = [NSString stringWithFormat:@"%d.jpeg",i];
        NSString *formKey = [NSString stringWithFormat:@"file%d",i];
        NSString *type = @"image/jpeg";
        [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
    };
}


- (id)requestArgument{
    
    return @{@"url":URL,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":_user_type,
             @"class_id":_class_id,
             @"comment_id":_comment_id,
             @"com_con":_com_con,
             @"file":_upImage
             };
    
}

@end
