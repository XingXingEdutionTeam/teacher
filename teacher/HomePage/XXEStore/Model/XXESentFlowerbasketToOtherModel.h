//
//  XXESentFlowerbasketToOtherModel.h
//  teacher
//
//  Created by Mac on 2016/11/15.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXESentFlowerbasketToOtherModel : JSONModel

/*
 (
 [id] => 1
 [date_tm] => 1464262407
 [pid] => 1
 [tid] => 1
 [num] => 1
 [con] => 谢谢照顾我的孩子
 [head_img] => app_upload/text/teacher/1.jpg
 [head_img_type] => 0
 [tname] => 梁红水
 )
 */

@property (nonatomic, copy) NSString <Optional>*other_id;
@property (nonatomic, copy) NSString <Optional>*date_tm;
@property (nonatomic, copy) NSString <Optional>*pid;
@property (nonatomic, copy) NSString <Optional>*tid;
@property (nonatomic, copy) NSString <Optional>*num;
@property (nonatomic, copy) NSString <Optional>*con;
@property (nonatomic, copy) NSString <Optional>*head_img;
@property (nonatomic, copy) NSString <Optional>*head_img_type;
@property (nonatomic, copy) NSString <Optional>*tname;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end
