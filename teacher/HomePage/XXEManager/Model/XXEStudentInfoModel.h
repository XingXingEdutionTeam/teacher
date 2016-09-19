//
//  XXEStudentInfoModel.h
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "XXEStudentInfoModel.h"


@protocol XXEStudentInfoModel

@end

@interface XXEStudentInfoModel : JSONModel
/*
 (
 [date_tm] => 1458884982
 [id] => 1
 [tname] => 李小红
 [head_img] => app_upload/text/baby_head/baby_head1.jpg
 )
 */

@property (nonatomic, copy) NSString *date_tm;
@property (nonatomic, copy) NSString *babyId;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *tname;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end
