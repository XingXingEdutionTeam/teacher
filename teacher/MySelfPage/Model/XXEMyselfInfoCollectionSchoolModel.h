//
//  XXEMyselfInfoCollectionSchoolModel.h
//  teacher
//
//  Created by Mac on 16/9/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEMyselfInfoCollectionSchoolModel : JSONModel

/*
 (
 [id] => 7
 [name] => 猩猩教室
 [logo] => app_upload/text/school_logo/7.jpg
 [date_tm] => 1462857972
 )
 */

@property (nonatomic, copy) NSString *collectionId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *date_tm;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end
