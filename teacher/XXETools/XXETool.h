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

+ (UIImage*)createImageWithColor:(UIColor*)color size:(CGSize)imageSize;

@end
