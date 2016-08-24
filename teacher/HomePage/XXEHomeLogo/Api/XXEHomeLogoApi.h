//
//  XXEHomeLogoApi.h
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEHomeLogoApi : YTKRequest

/*
 【猩课堂--学校详情】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Global/xkt_school_detail
 
 传参:
	school_id		//学校id
 */


- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id;


@end
