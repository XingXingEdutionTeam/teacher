//
//  XXETeacherManagerPersonInfoModel.h
//  teacher
//
//  Created by Mac on 16/9/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "XXETeacherManagerPersonInfoModel.h"


@protocol XXETeacherManagerPersonInfoModel

@end
@interface XXETeacherManagerPersonInfoModel : JSONModel

/*
 (
 [id] => 21		//审核通知id,用于后面的同意删除等操作
 [date_tm] => 1468481153
 [tname] => 李小川
 [head_img] => app_upload/text/teacher/2.jpg
 [head_img_type] => 0
 [teach_course] => 英语
 [condit] => 0		//0:待审核 1:审核通过
 user_id
 )
 */

@property (nonatomic, copy) NSString<Optional> *examine_id;
@property (nonatomic, copy) NSString<Optional> *date_tm;
@property (nonatomic, copy) NSString<Optional> *head_img;
@property (nonatomic, copy) NSString<Optional> *head_img_type;
@property (nonatomic, copy) NSString<Optional> *teach_course;
@property (nonatomic, copy) NSString<Optional> *condit;
@property (nonatomic, copy) NSString<Optional> *tname;
@property (nonatomic, copy) NSString<Optional> *user_id;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end
