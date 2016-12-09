//
//  XXEMyselfInfoGraduateInstitutionsModel.h
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEMyselfInfoGraduateInstitutionsModel : JSONModel

/*
 {
 city = "\U4e0a\U6d77\U5e02";
 district = "\U5f90\U6c47\U533a";
 id = 5;
 name = "\U4e0a\U6d77\U4ea4\U901a\U5927\U5b66";
 province = "\U4e0a\U6d77\U5e02";
 }
 */
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *graduateInstitutionId;
@property (nonatomic, copy) NSString<Optional> *province;
@property (nonatomic, copy) NSString<Optional> *city;
@property (nonatomic, copy) NSString<Optional> *district;


+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end
