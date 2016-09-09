//
//  XXEMyselfInfoCollectionCourseModel.h
//  teacher
//
//  Created by Mac on 16/9/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEMyselfInfoCollectionCourseModel : JSONModel

/*
 [id] => 6
 [course_name] => 艺术字
 [now_price] => 1800		//现价
 [pic] => app_upload/text/course/lesson5.jpg
 [date_tm] => 1462857972
 )
 */

@property (nonatomic, copy) NSString *collectionId;
@property (nonatomic, copy) NSString *course_name;
@property (nonatomic, copy) NSString *now_price;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *date_tm;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end
