//
//  XXEFlowerbasketApi.h
//  teacher
//
//  Created by Mac on 16/8/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//


#import <YTKNetwork/YTKRequest.h>

@interface XXEFlowerbasketApi : YTKRequest

- (instancetype)initWithUrlString:(NSString *)url appkey:(NSString *)appkey backtype:(NSString *)backtype xid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type page:(NSString *)page;

@end
