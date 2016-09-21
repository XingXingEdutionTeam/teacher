//
//  XXECourseManagerModel.h
//  teacher
//
//  Created by Mac on 16/9/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXECourseManagerModel : JSONModel

/*
 (
 [id] => 21
 [course_name] => 钢琴周末班
 [need_num] => 3
 [now_num] => 0
 [original_price] => 2500
 [now_price] => 2200
 [coin] => 1
 [allow_return] => 1    //是否 允许 退课  1:允许  0:不允许
 [condit] => 2	//状态  0:待完善(草稿)  1:等待校长审核   2:等待官方审核  3:已上线(官方审核通过)  4:官方驳回
 [course_pic] =>
 [teacher_tname_group] => Array
 (
 [0] => 粱红水
 [1] => 杜晓晓
 )
 
 )
 */

@property (nonatomic, copy) NSString *course_id;
@property (nonatomic, copy) NSString *course_name;
@property (nonatomic, copy) NSString *need_num;
@property (nonatomic, copy) NSString *now_num;
@property (nonatomic, copy) NSString *original_price;
@property (nonatomic, copy) NSString *now_price;
@property (nonatomic, copy) NSString *coin;
@property (nonatomic, copy) NSString *allow_return;
@property (nonatomic, copy) NSString *condit;
@property (nonatomic, copy) NSString *course_pic;
@property (nonatomic, strong) NSArray *teacher_tname_group;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end
