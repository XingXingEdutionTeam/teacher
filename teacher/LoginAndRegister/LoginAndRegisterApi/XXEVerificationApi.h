//
//  XXEVerificationApi.h
//  teacher
//
//  Created by codeDing on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEVerificationApi : YTKRequest

- (id)initWithVerificationCodeActionPage:(NSString *)actionPage phoneNum:(NSString *)phoneNum;

@end
