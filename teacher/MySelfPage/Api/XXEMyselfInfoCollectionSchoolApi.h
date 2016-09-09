//
//  XXEMyselfInfoCollectionSchoolApi.h
//  teacher
//
//  Created by Mac on 16/9/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEMyselfInfoCollectionSchoolApi : YTKRequest

/*
 【我的收藏---学校】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Global/col_school_list
 
 传参:
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id page:(NSString *)page;

@end
