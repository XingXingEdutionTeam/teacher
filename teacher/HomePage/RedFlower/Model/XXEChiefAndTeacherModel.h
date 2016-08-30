//
//  XXEChiefAndTeacherModel.h
//  teacher
//
//  Created by Mac on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEChiefAndTeacherModel : JSONModel

/*
 [baby_id] => 3
 [tname] => 宋佳佳
 [head_img] => app_upload/head_img/2016/06/28/20160628171327_9913.png
 [school_id] => 1
 [class_id] => 1
 */
@property(nonatomic, copy) NSString *baby_id;
@property(nonatomic, copy) NSString *tname;
@property(nonatomic, copy) NSString *head_img;
@property(nonatomic, copy) NSString *school_id;
@property(nonatomic, copy) NSString *class_id;

+ (NSArray*)parseResondsData:(id)respondObject;

@end
