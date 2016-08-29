//
//  XXEClassAddressStudentInfoModel.h
//  teacher
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEClassAddressStudentInfoModel : JSONModel

/*
 {
 age = 10;
 "head_img" = "app_upload/text/baby_head/baby_head9.jpg";
 id = 9;
 "parent_list" =                 (
 {
 id = 10;
 lv = 1;
 "relation_name" = "\U5988\U5988";
 tname = "\U674e\U6653\U6653";
 xid = 18886372;
 }
 );
 tname = "\U5434\U5ae3\U513f";
 }
 */

@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *baby_id;
@property (nonatomic, copy) NSString *tname;
@property (nonatomic, strong) NSArray *parent_list;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end
