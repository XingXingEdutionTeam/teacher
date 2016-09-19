//
//  XXEMyselfInfoGetSchoolProviceApi.h
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEMyselfInfoGetSchoolProviceApi : YTKRequest
/*
 【获取省,城市,区】
  接口:
 http://www.xingxingedu.cn/Global/provinces_city_area
 传参:
 action_type	//执行类型 1:获取省 , 2:获取城市, 3:获取区
 fatherID	//父级id, 获取市和区需要, 获取省不需要
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id action_type:(NSString *)action_type fatherID:(NSString *)fatherID;


@end
