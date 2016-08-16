//
//  LoginRegisterApi.h
//  teacher
//
//  Created by codeDing on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#ifndef LoginRegisterApi_h
#define LoginRegisterApi_h

//注册
/** 注册中检查手机号有没有注册过 */
#define XXERegisterCheckUrl @"http://www.xingxingedu.cn/teacher/register_check_phone"

/** 验证码 1注册  2修改密码  3更换手机号 */
#define XXEVerifyNumUrl @"http://www.xingxingedu.cn/Global/limit_phone_verify"


//登录
#define XXELoginUrl @"http://www.xingxingedu.cn/Teacher/login"


#endif /* LoginRegisterApi_h */
