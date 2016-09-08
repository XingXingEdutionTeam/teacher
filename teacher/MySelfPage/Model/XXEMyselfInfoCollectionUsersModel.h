//
//  XXEMyselfInfoCollectionUsersModel.h
//  teacher
//
//  Created by Mac on 16/9/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEMyselfInfoCollectionUsersModel : JSONModel

/*
 (
 [id] => 2
 [xid] => 18886064
 [nickname] => 大熊猫
 [head_img] => app_upload/text/aisi3.jpg
 [head_img_type] => 0
 [date_tm] => 1462857972
 [user_type] => 1		//1:家长,2:老师
 )
 */

@property (nonatomic, copy) NSString *collectionId;
@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *head_img_type;
@property (nonatomic, copy) NSString *date_tm;
@property (nonatomic, copy) NSString *user_type;


+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end
