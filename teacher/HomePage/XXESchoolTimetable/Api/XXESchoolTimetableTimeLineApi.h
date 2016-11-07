//
//  XXESchoolTimetableTimeLineApi.h
//  teacher
//
//  Created by Mac on 16/11/3.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXESchoolTimetableTimeLineApi : YTKRequest

/*
 【课程表--课程表时间轴】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Teacher/schedule_time
 传参:
	week_date	//周(需要查询哪一周),不传值默认本周
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id week_date:(NSString *)week_date;


@end
