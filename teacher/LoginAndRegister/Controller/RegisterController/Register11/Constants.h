//
//  Constants.h
//  XingXingEdu
//
//  Created by keenteam on 16/1/14.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#ifndef Constants_h
#define Constants_h
//屏幕宽度
#define kWidth [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define kHeight [UIScreen mainScreen].bounds.size.height
//rgb颜色转换
#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
//16>10
#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]
//rgb颜色转换
#define is_IOS_7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height
#define W(x) WinWidth*(x)/375.0
#define H(y) WinHeight*(y)/667.0

#define XID  @"18884982"
#define APPKEY  @"U3k8Dgj7e934bh5Y"
#define BACKTYPE @"json"
#define USER_ID  @"1"
#define USER_TYPE @"1"
#import "WZYHttpTool.h"
//图片地址
#import "WMUtil.h"
#define picURL    @"http://www.xingxingedu.cn/Public/"
#endif /* Constants_h */
