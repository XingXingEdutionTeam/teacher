//
//  XXEAuditAndReleaseModel.h
//  teacher
//
//  Created by Mac on 16/9/14.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEAuditAndReleaseModel : JSONModel

/*
 (
 [id] => 10		//通知id,审核通过和驳回操作时用
 [type] => 1
 [school_id] => 1
 [class_id] => 1
 [date_tm] => 1473835092
 [title] => 啦啦啦 没有审核人的时候
 [con] => 南安安娜2
 [tid] => 1
 [examine_tid] => 0
 [other_id] => 0
 [condit] => 1	//0:未审核  1:已审核  2:驳回
 [school_logo] => app_upload/school_logo/2016/08/23/20160823113336_6542.jpg
 [school_name] => 上海桃园小学
 [tname] => 粱红水
 [class_name] => 一年级一班
 )
 */

@property (nonatomic, copy) NSString *notice_id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *date_tm;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *con;
@property (nonatomic, copy) NSString *tid;

@property (nonatomic, copy) NSString *examine_tid;
@property (nonatomic, copy) NSString *other_id;
@property (nonatomic, copy) NSString *condit;
@property (nonatomic, copy) NSString *tname;
@property (nonatomic, copy) NSString *class_name;
@property (nonatomic, copy) NSString *school_name;
@property (nonatomic, copy) NSString *school_logo;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end
