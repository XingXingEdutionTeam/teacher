//
//  XXEFlowerbasketModel.h
//  teacher
//
//  Created by Mac on 16/8/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEFlowerbasketModel : JSONModel

/*
 [id] => 16
 [date_tm] => 1464315681
 [pid] => 1
 [tid] => 1
 [num] => 1
 [con] => 谢谢
 [tname] => 李少伟
 [head_img] => app_upload/head_img/2016/06/21/20160621172448_8123.png
 [head_img_type] => 0
 */

@property(nonatomic, copy)NSString *idStr;
@property(nonatomic, copy)NSString *date_tm;
@property(nonatomic, copy)NSString *pid;
@property(nonatomic, copy)NSString *tid;
@property(nonatomic, copy)NSString *num;
@property(nonatomic, copy)NSString *con;
@property(nonatomic, copy)NSString *tname;
@property(nonatomic, copy)NSString *head_img;
@property(nonatomic, copy)NSString *head_img_type;


+ (NSArray*)parseResondsData:(id)respondObject;


+(JSONKeyMapper*)keyMapper;

@end
