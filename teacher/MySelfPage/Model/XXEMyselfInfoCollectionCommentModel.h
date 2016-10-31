//
//  XXEMyselfInfoCollectionCommentModel.h
//  teacher
//
//  Created by Mac on 16/9/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEMyselfInfoCollectionCommentModel : JSONModel

/*
 (
 [id] => 4
 [school_id] => 1
 [class_id] => 1
 [type] => 2
 [condit] => 1
 [baby_id] => 3
 [puser_id] => 1
 [ask_tm] => 1461814398
 [ask_con] => 我的孩子最近表现怎么样?
 [tuser_id] => 1
 [teach_course] => 语文
 [com_tm] => 1461729971
 [com_con] => 表现很好
 [com_pic] =>
 [p_delete] => 0
 [t_delete] => 0
 [tname] => 粱红水
 [head_img] => app_upload/text/teacher/1.jpg
 [head_img_type] => 0
 
 baby_tname
 )
 */
@property (nonatomic, copy) NSString *collectionId;
@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *condit;
@property (nonatomic, copy) NSString *baby_id;
@property (nonatomic, copy) NSString *baby_tname;

@property (nonatomic, copy) NSString *puser_id;
@property (nonatomic, copy) NSString *ask_tm;
@property (nonatomic, copy) NSString *ask_con;
@property (nonatomic, copy) NSString *tuser_id;
@property (nonatomic, copy) NSString *teach_course;

@property (nonatomic, copy) NSString *com_tm;
@property (nonatomic, copy) NSString *com_con;
@property (nonatomic, copy) NSString *com_pic;
@property (nonatomic, copy) NSString *p_delete;
@property (nonatomic, copy) NSString *t_delete;
@property (nonatomic, copy) NSString *tname;

@property (nonatomic, copy) NSString *head_img_type;
@property (nonatomic, copy) NSString *head_img;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end
