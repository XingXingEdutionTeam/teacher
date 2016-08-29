//
//  XXESchoolPicApi.h
//  teacher
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXESchoolPicApi : YTKRequest

/*
 【学校相册->图片列表】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Global/school_album_list
 
 传参:
	school_id		//学校id
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id;

@end
