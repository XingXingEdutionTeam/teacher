//
//  SchoolModel.h
//  teacher
//
//  Created by codeDing on 16/12/7.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchoolModel : NSObject
@property(nonatomic ,copy, nullable) NSString *schoolId;
@property(nonatomic ,copy, nullable) NSString *schoolName;
@property(nonatomic ,copy, nullable) NSString *schoolType;
@property(nonatomic ,copy, nullable) NSString *province;
@property(nonatomic ,copy, nullable) NSString *city;
@property(nonatomic ,copy, nullable) NSString *district;
@property(nonatomic ,copy, nullable) NSString *address;
@property(nonatomic ,copy, nullable) NSString *tel;

+ (SchoolModel *)SchoolModelWithDictionary:(NSDictionary *)dic;

@end
