//
//  XXESchoolTimetableCourseApi.h
//  teacher
//
//  Created by Mac on 16/11/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXESchoolTimetableCourseApi : YTKRequest

/*
 【课程表--单个课程详情(叠加的会有多个)】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Teacher/schedule_detail
 传参:
	week_date	//周(需要查询哪一周)
	parame_data	//传参集合,二维数组的json数据,按之前获取数据的结构
 */
- (id)initWithXid:(NSString *)xid  user_id:(NSString *)user_id week_date:(NSString *)week_date parame_data:(NSString *)parame_data;

@end
