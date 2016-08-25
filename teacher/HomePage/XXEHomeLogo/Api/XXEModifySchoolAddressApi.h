//
//  XXEModifySchoolAddressApi.h
//  teacher
//
//  Created by Mac on 16/8/25.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEModifySchoolAddressApi : YTKRequest


/*
 province		//省
	city			//市
	district		//区
	address			//详细地址
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id position:(NSString *)position province:(NSString *)province city:(NSString *)city district:(NSString *)district address:(NSString *)address;



@end
