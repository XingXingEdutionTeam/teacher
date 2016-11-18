//
//  XXEXingClassRoomCourseListApi.h
//  teacher
//
//  Created by Mac on 16/10/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEXingClassRoomCourseListApi : YTKRequest

/*
 
 【猩课堂--课程列表】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Global/xkt_course
 传参说明:user_lng和user_lat是必须参数,其他是可选参数,可选参数可以是无,也可以填空
 传参:
	page		//页码,当此参数不存在或者空或者传值1,都代表第1页,
 测试期间每次加载5条数据(APP上线后30条数据)
 举例:传值1:获取到第1~第5条数据,传值2:获取到第6~第10条数据
	user_lng	//用户当前经度
	user_lat	//用户当前纬度
	filter_distance	//距离筛选,单位km
	appoint_order	//指定排序,0:离我最近,1:价格最低,2:价格最高,3:最新发布,4:人气最高 ,5:近期开课
	class_str	//类目,3级,逗号隔开,值是中文
	search_words	//关键字搜索(点击热门搜索,也用参数)
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id page:(NSInteger)page user_lng:(NSString *)user_lng user_lat:(NSString *)user_lat filter_distance:(NSString *)filter_distance appoint_order:(NSInteger)appoint_order class_str:(NSString *)class_str search_words:(NSString *)search_words;

@end