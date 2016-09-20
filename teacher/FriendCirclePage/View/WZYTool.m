



//
//  WZYTool.m
//  XingXingEdu
//
//  Created by Mac on 16/6/7.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "WZYTool.h"

@implementation WZYTool

+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr {
    //转化为Double
    double t = [timerStr doubleValue];
    //计算出距离1970的NSDate
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    //转化为 时间格式化字符串
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //转化为 时间字符串
    return [df stringFromDate:date];
}


@end
