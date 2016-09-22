//
//  XXECourseManagerCourseCategoryApi.h
//  teacher
//
//  Created by Mac on 16/9/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXECourseManagerCourseCategoryApi : YTKRequest

/*
 【猩课堂--获取类目】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Global/xkt_category
 传参:
 返回值案例:
 ★注:三级类目,每一级是一个数组, 二级的每个元素键名是一级类目id,三级的每个元素键名是二级类目id
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id;

@end
