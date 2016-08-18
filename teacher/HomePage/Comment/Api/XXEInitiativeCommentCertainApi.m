
//
//  XXEInitiativeCommentCertainApi.m
//  teacher
//
//  Created by Mac on 16/8/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEInitiativeCommentCertainApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/teacher_comment_action"

@interface XXEInitiativeCommentCertainApi ()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *baby_id;
@property (nonatomic, copy) NSString *com_con;
@property (nonatomic, strong) UIImage *upImage;


@end



@implementation XXEInitiativeCommentCertainApi

/*
 
 【点评->主动点评】
 
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Teacher/teacher_comment_action
 
 
 传参:
	school_id	//学校id
	class_id	//班级id
	baby_id		//评论id
	com_con		//评论内容
	file		//批量上传图片 ★现在的版本没有上传图片的,应该是之前遗漏了,请加上
 */

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id class_id:(NSString *)class_id baby_id:(NSString *)baby_id com_con:(NSString *)com_con upImage:(UIImage *)upImage{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        
        _school_id = school_id;
        _class_id = class_id;
        _baby_id = baby_id;
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
             @"school_id":_class_id,
             @"class_id":_class_id,
             @"baby_id":_baby_id,
             @"com_con":_com_con,
             @"file":_upImage
             };
    
}




@end
