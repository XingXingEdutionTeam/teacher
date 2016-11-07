//
//  XXETool.h
//  teacher
//
//  Created by Mac on 16/8/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXETool : NSObject

//@"yyyy-MM-dd HH:mm:ss";
+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr;
//@"yyyy-MM-dd";
+ (NSString *)dateAboutStringFromNumberTimer:(NSString *)timerStr;

+ (UIImage*)createImageWithColor:(UIColor*)color size:(CGSize)imageSize;

//判断 当前 是星期几
+ (int)queryWeekday;


@end
