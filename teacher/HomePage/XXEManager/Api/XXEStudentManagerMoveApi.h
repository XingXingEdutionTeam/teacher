//
//  XXEStudentManagerMoveApi.h
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEStudentManagerMoveApi : YTKRequest

/*
 【学生管理->移动学生】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Teacher/manage_baby_move
 传参:
	school_id	//学校id
	class_id	//所选孩子 当前 所在的 班级id
	baby_id		//孩子id
	move_class_id	//需要移动到哪个班级(id)
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id school_id:(NSString *)school_id class_id:(NSString *)class_id baby_id:(NSString *)baby_id move_class_id:(NSString *)move_class_id;

@end
