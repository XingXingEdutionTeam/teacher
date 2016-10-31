//
//  XXEAllWeeksApi.h
//  teacher
//
//  Created by Mac on 16/10/31.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEAllWeeksApi : YTKRequest

/*
 【课程表--预加载20个周名(下拉)】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Teacher/schedule_week_date
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id;


@end
