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





#endif /* MacroDefine_h */
