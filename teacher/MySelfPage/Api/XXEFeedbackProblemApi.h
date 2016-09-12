//
//  XXEFeedbackProblemApi.h
//  teacher
//
//  Created by Mac on 16/9/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEFeedbackProblemApi : YTKRequest
/*
 【意见反馈(两端通用)】
 
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Global/suggestion_sub
 
 传参:
	con	//反馈内容
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id con:(NSString *)con;

@end
