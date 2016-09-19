//
//  XXEMyselfInfoGraduateInstitutionsApi.h
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEMyselfInfoGraduateInstitutionsApi : YTKRequest
/*
 【获取大学(第一次登陆完善资料需要)】
  接口类型:1
  接口:
 http://www.xingxingedu.cn/Teacher/get_university
 传参:
 	province	//省
	city		//市
	district	//区
	search_words	//搜索关键词
  注:每个参数都是可选的
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id province:(NSString *)province city:(NSString *)city district:(NSString *)district search_words:(NSString *)search_words;

@end
