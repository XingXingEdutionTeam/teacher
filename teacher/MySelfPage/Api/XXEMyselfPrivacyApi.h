//
//  XXEMyselfPrivacyApi.h
//  teacher
//
//  Created by Mac on 16/9/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEMyselfPrivacyApi : YTKRequest

/*
 【隐私--默认】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Global/secret_default
 传参
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id;

@end
