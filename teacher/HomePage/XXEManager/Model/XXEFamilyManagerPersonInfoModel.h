//
//  XXEFamilyManagerPersonInfoModel.h
//  teacher
//
//  Created by Mac on 16/9/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "XXEFamilyManagerPersonInfoModel.h"


@protocol XXEFamilyManagerPersonInfoModel

@end

@interface XXEFamilyManagerPersonInfoModel : JSONModel

/*
 (
 [id] => 1	//审核通知id,用于后面的同意删除等操作
 [date_tm] => 1468481153
 [head_img] => app_upload/text/p_head4.jpg
 [head_img_type] => 0
 [baby_id] => 3
 [baby_tname] => 宋佳佳
 [relation_name] => 其他亲戚
 [parent_id] => 4
 [condit] => 0 	 //0:待审核 1:审核通过
 tname  => 家人名称
 )
 */
@property (nonatomic, copy) NSString *examine_id;
@property (nonatomic, copy) NSString *date_tm;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *head_img_type;
@property (nonatomic, copy) NSString *baby_id;
@property (nonatomic, copy) NSString *baby_tname;
@property (nonatomic, copy) NSString *relation_name;
@property (nonatomic, copy) NSString *parent_id;
@property (nonatomic, copy) NSString *condit;
@property (nonatomic, copy) NSString *tname;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end
