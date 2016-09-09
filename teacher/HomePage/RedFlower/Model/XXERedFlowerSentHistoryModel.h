//
//  XXERedFlowerSentHistoryModel.h
//  teacher
//
//  Created by Mac on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXERedFlowerSentHistoryModel : JSONModel

/*
 
 id 小红花 这条数据 的 id
 [date_tm] => 1461900512
 [head_img] => app_upload/text/baby_head/baby_head1.jpg
 [tname] => 李小红
 [teach_course] => 语文,音乐
 [school_name] => 上海桃园小学
 [class_name] => 一年级一班
 [con] => 表现不错
 collect_condit  //1:是收藏过这个商品  2:未收藏过
 [pic_arr] => Array
 (
 [0] => app_upload/text/lesson2.jpg
 [1] => app_upload/text/lesson1.jpg
 )
 */


@property (nonatomic, copy) NSString *collectionId;
@property (nonatomic, copy) NSString *date_tm;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *tname;
@property (nonatomic, copy) NSString *teach_course;
@property (nonatomic, copy) NSString *school_name;
@property (nonatomic, copy) NSString *class_name;
@property (nonatomic, copy) NSString *con;
@property (nonatomic, copy) NSString *collect_condit;
@property (nonatomic, strong) NSMutableArray *pic_arr;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end
