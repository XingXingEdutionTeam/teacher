//
//  XXEMyselfInfoModifyTeachingFeelingApi.h
//  teacher
//
//  Created by Mac on 16/9/6.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEMyselfInfoModifyTeachingFeelingApi : YTKRequest

/*
 【编辑我的资料】
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Teacher/edit_my_info
 
 传参:
	teach_feel		//感悟
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type teach_feel:(NSString *)teach_feel;

@end
