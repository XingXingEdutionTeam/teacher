//
//  XXEMyselfPrivacySettingApi.h
//  teacher
//
//  Created by Mac on 16/9/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEMyselfPrivacySettingApi : YTKRequest

/*
 【隐私--设置】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Global/secret_set
 传参
 
 show_phone => 1		//注释见上面
 show_tname => 1
 search_phone => 0
 search_xid => 0
 search_nearby => 0
 add_friend_set => 0
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id  show_tname:(NSString *)show_tname show_phone:(NSString *)show_phone search_nearby:(NSString *)search_nearby search_xid:(NSString *)search_xid     search_phone:(NSString *)search_phone add_friend_set:(NSString *)add_friend_set;


@end
