//
//  XXERegisterSecondViewController.h
//  teacher
//
//  Created by codeDing on 16/8/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXERegisterSecondViewController : XXEBaseViewController

/** 用户的电话号码 */
@property (nonatomic, strong)NSString *userPhoneNum;
/** 登录类型 */
@property (nonatomic, copy)NSString *login_type;

@end