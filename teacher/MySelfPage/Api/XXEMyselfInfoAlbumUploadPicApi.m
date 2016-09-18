


//
//  XXEMyselfInfoAlbumUploadPicApi.m
//  teacher
//
//  Created by Mac on 16/9/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoAlbumUploadPicApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/upload_personal_pic"

@interface XXEMyselfInfoAlbumUploadPicApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, strong) UIImage *upImage;


@end

@implementation XXEMyselfInfoAlbumUploadPicApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id upImage:(UIImage *)upImage{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;

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
             @"user_type":USER_TYPE,
             @"file":_upImage
             };
    
}

- (NSString *)responseImageId {
    NSDictionary *dict = self.responseJSONObject;
    return dict[@"imageId"];
}


@end
