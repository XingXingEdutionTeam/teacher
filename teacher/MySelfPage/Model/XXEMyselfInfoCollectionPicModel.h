//
//  XXEMyselfInfoCollectionPicModel.h
//  teacher
//
//  Created by Mac on 16/9/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEMyselfInfoCollectionPicModel : JSONModel

/*
 (
 [id] => 1
 [pic] => app_upload/text/class/class_c1.jpg
 [date_tm] => 1464689283
 )
 */

@property (nonatomic, copy) NSString *collectionId;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *date_tm;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end
