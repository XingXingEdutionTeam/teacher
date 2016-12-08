//
//  XXEForgetPassApi.h
//  teacher
//
//  Created by codeDing on 16/9/1.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEForgetPassApi : YTKRequest

- (id)initWithForgetPassWordUserType:(NSString *)user_type Phone:(NSString *)phone NewPass:(NSString *)newPass actionType:(NSString*)actionType;

@end
