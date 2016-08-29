//
//  XXEClassAddressEveryclassInfoApi.h
//  teacher
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEClassAddressEveryclassInfoApi : YTKRequest

/*
 【班级通讯录】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Global/class_contact_book
 
 传参:
 
	school_id	//学校id
	class_id	//班级id
	search_words	//搜索关键字,搜索的返回的结构与之前一模一样
 
 测试:3个传参都填1
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id class_id:(NSString *)class_id search_words:(NSString *)search_words;


@end
