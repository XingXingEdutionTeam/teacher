

//
//  XXEHomeworkIssueTextAndPicInfoApi.m
//  teacher
//
//  Created by Mac on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEHomeworkIssueTextAndPicInfoApi.h"


#define URL @"http://www.xingxingedu.cn/Teacher/teacher_comment_action"

@interface XXEHomeworkIssueTextAndPicInfoApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *con;
@property (nonatomic, copy) NSString *teach_course;
@property (nonatomic, copy) NSString *date_end_tm;
@property (nonatomic, strong) UIImage *upImage;

@end


@implementation XXEHomeworkIssueTextAndPicInfoApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id class_id:(NSString *)class_id title:(NSString *)title con:(NSString *)con teach_course:(NSString *)teach_course date_end_tm:(NSString *)date_end_tm upImage:(UIImage *)upImage{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        
        _school_id = school_id;
        _class_id = class_id;
        _title = title;
        _con = con;
        _teach_course = teach_course;
        _date_end_tm = date_end_tm;
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
        //        NSString *name = [NSString stringWithFormat:@"%d.jpeg",i];
        NSString *name = [NSString stringWithFormat:@"%d.jpg",i];
        NSString *formKey = [NSString stringWithFormat:@"file%d",i];
        NSString *type = @"image/jpg";
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
             @"school_id":_school_id,
             @"class_id":_class_id,
             @"title":_title,
             @"con":_con,
             @"teach_course":_teach_course,
             @"date_end_tm":_date_end_tm,
             @"file":_upImage
             };
    
}

@end
