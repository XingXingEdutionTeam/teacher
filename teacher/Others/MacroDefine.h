//
//  MacroDefine.h
//  teacher
//
//  Created by codeDing on 16/8/5.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#ifndef MacroDefine_h
#define MacroDefine_h

// 判断手机型号
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

//rgb颜色转换
#define XXEColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

#define XXEBackgroundColor XXEColorFromRGB(229, 232, 233)
//猩猩绿色
#define XXEGreenColor XXEColorFromRGB(0, 170, 42)


#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#define kScreenRatioHeight  KScreenHeight/667
#define kScreenRatioWidth  KScreenWidth/375

//图片地址
#define kXXEPicURL    @"http://www.xingxingedu.cn/Public/"
//s测试

// 加入的测试
//==========
#define kWidth [UIScreen mainScreen].bounds.size.width

#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
//屏幕高度
#define kHeight [UIScreen mainScreen].bounds.size.height

//16>10
#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]
//rgb颜色转换
#define is_IOS_7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height
#define W(x) WinWidth*(x)/375.0
#define H(y) WinHeight*(y)/667.0

//融云
// iPhone 唯一Appkey为： 57c01a13f43e48118e000e55

//微博信息
//APP key 4148122833
//App Secret：0d5d368c2dbc60bd15c1b3f9c446a7a8

//微信
//AppID：wxed731a36270b5a4f

//QQ
//APP ID1105651422
//APP KEYk9FfqqGIWGNH6TDX

//沙盒 存储
#define DEFAULTS [NSUserDefaults standardUserDefaults]



#endif /* MacroDefine_h */
