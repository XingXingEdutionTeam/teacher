//
//  XXERecipeApi.h
//  teacher
//
//  Created by Mac on 16/8/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXERecipeApi : YTKRequest

/*
 【学校食谱】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Parent/school_cookbook
 
 传参:
	school_id	//学校id (测试值:1)
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id;


@end
