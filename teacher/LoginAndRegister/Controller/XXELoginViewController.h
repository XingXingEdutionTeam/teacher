//
//  XXELoginViewController.h
//  teacher
//
//  Created by codeDing on 16/8/4.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXELoginViewController : XXEBaseViewController
/** 登录QQToken */
@property (nonatomic, copy)NSString *loginThirdQQToken;
/** 登录微信Token */
@property (nonatomic, copy)NSString *loginThirdWeiXinToken;
/** 登录新浪Token */
@property (nonatomic, copy)NSString *loginThirdSinaToken;
/** 登录支付宝Token */
@property (nonatomic, copy)NSString *loginThirdAliPayToken;

@property (nonatomic, copy)NSString *loginThirdType;
@end
