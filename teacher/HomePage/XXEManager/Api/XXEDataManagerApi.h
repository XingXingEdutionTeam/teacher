//
//  XXEDataManagerApi.h
//  teacher
//
//  Created by Mac on 16/10/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEDataManagerApi : YTKRequest
/*
 【数据管理】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Teacher/manage_data
 
 
 传参:
	school_id	//学校id
	school_type	//学校类型
	data_type	//数据类型 1:流量  2:收藏   3:报名人数  4:报名收入  5:机构评分
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id school_id:(NSString *)school_id school_type:(NSString *)school_type data_type:(NSString *)data_type;



@end
