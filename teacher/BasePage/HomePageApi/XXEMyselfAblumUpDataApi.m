//
//  XXEMyselfAblumUpDataApi.m
//  teacher
//
//  Created by codeDing on 16/8/15.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfAblumUpDataApi.h"

@implementation XXEMyselfAblumUpDataApi{
    NSString *_school_id;
    NSString *_class_id;
    NSString *_ablum_id;
    UIImage *_imageArray;
}

- (id)initWithAblumSchoolId:(NSString *)schoolId ClassId:(NSString *)classId AblumId:(NSString *)ablumId ImageArray:(UIImage *)imageArray
{
    self = [super init];
    if (self) {
        _school_id = schoolId;
        _class_id = classId;
        _ablum_id = ablumId;
        _imageArray = imageArray;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEAblumUpdataUrl];
}

-(AFConstructingBlock)constructingBodyBlock
{
    return ^(id<AFMultipartFormData> formData){
//        for (int i =0; i < _imageArray.count; i++) {
        int i = 1;
            NSData *data = UIImageJPEGRepresentation(_imageArray, 0.5);
            NSString *name = [NSString stringWithFormat:@"%d.jpeg",i];
            NSString *formKey = [NSString stringWithFormat:@"file%d",i];
            NSString *type = @"image/jpeg";
            [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
//        }
    };
}

- (id)requestArgument {
    return @{
             @"school_id":_school_id,
             @"class_id":_class_id,
             @"album_id":_ablum_id,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_id":USER_ID,
             @"user_type":USER_TYPE,
             @"xid":XID
             
             };
}

- (NSString *)responseImageId {
    NSDictionary *dict = self.responseJSONObject;
    return dict[@"imageId"];
}


@end
