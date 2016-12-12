//
// SettingPersonInfoViewController.h
//  Created by codeDing on 16/1/16.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "XXEBaseViewController.h"
#import <Availability.h>

@interface SettingPersonInfoViewController : XXEBaseViewController 
@property(nonatomic,strong) NSArray *relationArray;//与学生关系
@property (nonatomic,strong) UIView *comBackView;

@property(nonatomic,strong) NSArray *parentsIDCardArray;//家长身份证号
@property (nonatomic,strong) UIView *parentsIDCardComBackView;

@property(nonatomic,strong) NSArray *studentIDCardArray;//学生身份证号
@property (nonatomic,strong) UIView *studentIDCardComBackView;


@property(nonatomic ,copy)NSString * phone;
@property(nonatomic ,copy)NSString * pwd;

/** 用户的电话号码 */
@property (nonatomic, copy)NSString *userSettingPhoneNum;
/** 用户的密码 */
@property (nonatomic, copy)NSString *userSettingPassWord;
/** 登录类型 */
@property (nonatomic, copy)NSString *login_type;

//第三方的话会有昵称 头像 唯一的token
/** 第三方的昵称 */
@property (nonatomic, copy)NSString *nickName;
/** 第三方头像 */
@property (nonatomic, copy)NSString *t_head_img;
/** QQToken */
@property (nonatomic, copy)NSString *QQToken;
/** 微信Token */
@property (nonatomic, copy)NSString *weixinToken;
/** 微博Token */
@property (nonatomic, copy)NSString *sinaToken;
/** 支付宝Token */
@property (nonatomic, copy)NSString *aliPayToken;

@property(nonatomic ,strong)NSString *whereFromController;
@end
