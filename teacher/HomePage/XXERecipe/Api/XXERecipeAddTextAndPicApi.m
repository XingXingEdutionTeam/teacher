
//
//  XXERecipeAddTextAndPicApi.m
//  teacher
//
//  Created by Mac on 16/8/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERecipeAddTextAndPicApi.h"


#define URL @"http://www.xingxingedu.cn/Teacher/school_cookbook_publish"

@interface XXERecipeAddTextAndPicApi()

/*
    breakfast_file	//早餐图片(批量上传图片)
	lunch_file	//午餐图片(批量上传图片)
	dinner_file	//晚餐图片(批量上传图片)
 */

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *date_tm;
@property (nonatomic, copy) NSString *breakfast_name;
@property (nonatomic, copy) NSString *lunch_name;
@property (nonatomic, copy) NSString *dinner_name;
@property (nonatomic, strong) UIImage *breakfast_file;
@property (nonatomic, strong) UIImage *lunch_file;
@property (nonatomic, strong) UIImage *dinner_file;


@end


@implementation XXERecipeAddTextAndPicApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id position:(NSString *)position date_tm:(NSString *)date_tm breakfast_name:(NSString *)breakfast_name lunch_name:(NSString *)lunch_name dinner_name:(NSString *)dinner_name breakfast_file:(UIImage *)breakfast_file lunch_file:(UIImage *)lunch_file dinner_file:(UIImage *)dinner_file{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        
        _school_id = school_id;
        _position = position;
        _date_tm = date_tm;
        _breakfast_name = breakfast_name;
        _lunch_name = lunch_name;
        _dinner_name = dinner_name;
        
        _breakfast_file = breakfast_file;
        _lunch_file = lunch_file;
        _dinner_file = dinner_file;
    }
    return self;
}


- (NSString *)requestUrl{
    
    return URL;
    
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPost;
    
}

//-(AFConstructingBlock)constructingBodyBlock
//{
//    return ^(id<AFMultipartFormData> formData){
//        int i = 1;
//        NSData *data = UIImageJPEGRepresentation(_upImage, 0.5);
//        //        NSString *name = [NSString stringWithFormat:@"%d.jpeg",i];
//        NSString *name = [NSString stringWithFormat:@"%d.jpg",i];
//        NSString *formKey = [NSString stringWithFormat:@"file%d",i];
//        NSString *type = @"image/jpg";
//        [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
//    };
//}

- (id)requestArgument{
    
    return @{@"url":URL,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":_user_type,
             @"school_id":_school_id,
             @"position":_position,
             @"date_tm":_date_tm,
             @"breakfast_name":_breakfast_name,
             @"lunch_name":_lunch_name,
             @"dinner_name":_dinner_name,
             @"breakfast_file":_breakfast_file,
             @"lunch_file":_lunch_file,
             @"dinner_file":_dinner_file
             };
    
    
}


@end
