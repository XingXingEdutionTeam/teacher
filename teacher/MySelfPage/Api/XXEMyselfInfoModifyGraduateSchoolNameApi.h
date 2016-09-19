//
//  XXEMyselfInfoModifyGraduateSchoolNameApi.h
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEMyselfInfoModifyGraduateSchoolNameApi : YTKRequest

/*
 graduate_sch_id		//毕业院校id (从大学接口获取)
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id graduate_sch_id:(NSString *)graduate_sch_id;

@end
