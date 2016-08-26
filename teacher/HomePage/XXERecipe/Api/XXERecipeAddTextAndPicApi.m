
//
//  XXERecipeAddTextAndPicApi.m
//  teacher
//
//  Created by Mac on 16/8/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERecipeAddTextAndPicApi.h"


#define URL @"http://www.xingxingedu.cn/Global/uploadFile"

@interface XXERecipeAddTextAndPicApi()

/*
    breakfast_file	//早餐图片(批量上传图片)
	lunch_file	//午餐图片(批量上传图片)
	dinner_file	//晚餐图片(批量上传图片)
 */

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *file_type;
@property (nonatomic, copy) NSString *page_origin;
@property (nonatomic, copy) NSString *upload_format;
@property (nonatomic, strong) UIImage *upImage;


@end


@implementation XXERecipeAddTextAndPicApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type file_type:(NSString *)file_type page_origin:(NSString *)page_origin upload_format:(NSString *)upload_format upImage:(UIImage *)upImage{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        
        _file_type = file_type;
        _page_origin = page_origin;
        _upload_format = upload_format;
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
        
        NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str =[formatter stringFromDate:[NSDate date]];
        NSData *data = UIImageJPEGRepresentation(_upImage, 0.5);
//        NSString *name = [NSString stringWithFormat:@"%@.jpeg",str];
        NSString *formKey = [NSString stringWithFormat:@"file%@",str];
        NSString *type = @"image/jpeg";
        
//        [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
        [formData appendPartWithFileData:data name:formKey fileName:@"file" mimeType:type];
//        NSLog(@"%@ ----  %@ ----- %@ ---- %@", _upImage, name, @"", formData);
    };
}

- (id)requestArgument{
    
    return @{@"url":URL,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":_user_type,
             @"file_type":_file_type,
             @"page_origin":_page_origin,
             @"upload_format":_upload_format
             };
    
    
}


@end
