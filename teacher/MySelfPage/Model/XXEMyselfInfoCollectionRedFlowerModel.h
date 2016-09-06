//
//  XXEMyselfInfoCollectionRedFlowerModel.h
//  teacher
//
//  Created by Mac on 16/9/6.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEMyselfInfoCollectionRedFlowerModel : JSONModel

/*
 (
 [id] => 2
 [date_tm] => 1461900517
 [tid] => 1
 [position] => 1
 [baby_id] => 3
 [con] => 很好很棒很OK
 [school_id] => 1
 [school_type] => 2
 [school_name] => 上海桃园小学
 [class_id] => 1
 [class_name] => 一年级一班
 [num] => 1
 [pic] => app_upload/text/lesson2.jpg
 [tname] => 粱红水
 [head_img] => app_upload/text/teacher/1.jpg
 [head_img_type] => 0
 [teach_course] => 语文,音乐
 )
 */
@property (nonatomic, copy) NSString *collectionId;
@property (nonatomic, copy) NSString *date_tm;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *baby_id;
@property (nonatomic, copy) NSString *con;
@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *school_type;
@property (nonatomic, copy) NSString *school_name;
@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *class_name;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *tname;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *head_img_type;
@property (nonatomic, copy) NSString *teach_course;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end
