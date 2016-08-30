//
//  XXEBabyInfoApi.h
//  teacher
//
//  Created by Mac on 16/8/30.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEBabyInfoApi : YTKRequest

/*
 【孩子个人中心首页】
 
 接口:
 http://www.xingxingedu.cn/Parent/my_baby_info
 
 传参:
 baby_id		//孩子id
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type baby_id:(NSString *)baby_id ;


@end
