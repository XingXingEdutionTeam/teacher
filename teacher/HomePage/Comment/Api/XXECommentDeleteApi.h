//
//  XXECommentDeleteApi.h
//  teacher
//
//  Created by Mac on 16/10/27.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXECommentDeleteApi : YTKRequest

/*
 【删除点评】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Teacher/delete_teacher_com
 传参:
	com_id		//点评id
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id com_id:(NSString *)com_id;



@end
