//
//  XXERegisterPicApi.m
//  teacher
//
//  Created by codeDing on 16/8/30.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERegisterPicApi.h"

@implementation XXERegisterPicApi{
    NSString * _file_type;
    NSString *_page_origin;
    NSString *_upload_format;
    UIImage *_imageHead;
}

- (id)initUpLoadRegisterPicFileType:(NSString *)fileTYpe PageOrigin:(NSString *)pageOrigin UploadFormat:(NSString *)uploadFormatc UIImageHead:(UIImage *)imageHead
{
    self = [super init];
    if (self) {
        _file_type = fileTYpe;
        _page_origin = pageOrigin;
        _upload_format = uploadFormatc;
        _imageHead = imageHead;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
   return  YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXERegisterUpLoadPicUrl];
}

-(AFConstructingBlock)constructingBodyBlock
{
    return ^(id<AFMultipartFormData> formData){
        int i = 1;
        NSData *data = UIImageJPEGRepresentation(_imageHead, 0.5);
        NSString *name = [NSString stringWithFormat:@"%d.jpeg",i];
        NSString *formKey = [NSString stringWithFormat:@"file"];
        NSString *type = @"image/jpeg";
        [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
    };
}


- (id)requestArgument
{
    return @{@"file_type":_file_type,
             @"page_origin":_page_origin,
             @"upload_format":_upload_format,
             @"appkey":APPKEY,
             @"user_type":USER_TYPE,
             @"backtype":BACKTYPE
             };
}

@end
