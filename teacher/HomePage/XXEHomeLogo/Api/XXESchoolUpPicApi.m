

//
//  XXESchoolUpPicApi.m
//  teacher
//
//  Created by Mac on 16/8/28.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolUpPicApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/upload_school_pic"

@interface XXESchoolUpPicApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, strong) UIImage *upImage;


@end

@implementation XXESchoolUpPicApi

/*
 【学校相册->上传图片】
 
 
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Teacher/upload_school_pic
 传参:
 
	school_id		//学校id(必须传参)
	position		//身份 (必须传参),只允许管理和校长才可以修改学校信息
	file			//批量上传图片
 */

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id position:(NSString *)position upImage:(UIImage *)upImage{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        _school_id = school_id;
        _position = position;
        _upImage = upImage;
        
    }
    return self;
}


- (NSString *)requestUrl{
    
    return [NSString stringWithFormat:@"%@", URL];
    
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPost;
    
}

-(AFConstructingBlock)constructingBodyBlock
{
    return ^(id<AFMultipartFormData> formData){
        
        NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str =[formatter stringFromDate:[NSDate date]];
        NSData *data = UIImageJPEGRepresentation(_upImage, 0.5);
        NSString *name = [NSString stringWithFormat:@"%@.jpeg",str];
        NSString *formKey = [NSString stringWithFormat:@"file%@",str];
        NSString *type = @"image/jpeg";
        
        [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
//        NSLog(@"%@ ----  %@ ----- %@ ---- %@", _upImage, name, formKey, formData);
    };
}


- (id)requestArgument{
    
    return @{@"url":URL,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":_user_type,
             @"school_id":_school_id,
             @"position":_position,
             @"file":_upImage
             };
    
}

- (NSString *)responseImageId {
    NSDictionary *dict = self.responseJSONObject;
    return dict[@"imageId"];
}




@end
