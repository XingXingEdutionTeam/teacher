

//
//  XXEReplyTextAndPicInfoApi.m
//  teacher
//
//  Created by Mac on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEReplyTextAndPicInfoApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/request_comment_action"


@interface XXEReplyTextAndPicInfoApi(){
    NSString *_xid;
    NSString *_user_id;
    NSString *_user_type;
    NSString *_class_id;
    NSString *_comment_id;
    NSString *_com_con;
    UIImage *_upImage;

}

//@property (nonatomic, copy) NSString *xid;
//@property (nonatomic, copy) NSString *user_id;
//@property (nonatomic, copy) NSString *user_type;
//
//@property (nonatomic, copy) NSString *class_id;
//@property (nonatomic, copy) NSString *comment_id;
//@property (nonatomic, copy) NSString *com_con;
//@property (nonatomic, strong) UIImage *upImage;


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
    
    return [NSString stringWithFormat:@"%@", URL];
    
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPost;
    
}

-(AFConstructingBlock)constructingBodyBlock
{
    return ^(id<AFMultipartFormData> formData){
    
        NSData *data = UIImageJPEGRepresentation(_upImage, 0.5);
        NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str =[formatter stringFromDate:[NSDate date]];
//        NSString *fileName =[NSString stringWithFormat:@"%@.png", str];
        NSString *name = [NSString stringWithFormat:@"%@.jpeg",str];
        NSString *formKey = [NSString stringWithFormat:@"file%@",name];
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
             @"com_con":_com_con
             };
    
}

- (NSString *)responseImageId {
    NSDictionary *dict = self.responseJSONObject;
    return dict[@"imageId"];
}

@end
