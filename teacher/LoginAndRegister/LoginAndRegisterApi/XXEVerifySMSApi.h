//
//  XXEVerifySMSApi.h
//  teacher
//
//  Created by codeDing on 16/8/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEVerifySMSApi : YTKRequest

- (id)initWithVerifySMSPhoneNum:(NSString *)phoneNum VerifyNum:(NSString *)verifyNum;

@end
