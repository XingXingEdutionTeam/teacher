//
//  XXEStoreGoodClassModel.h
//  teacher
//
//  Created by Mac on 16/11/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEStoreGoodClassModel : JSONModel


/*
 {
	id = 2,
	name = 话费
 }
 */

@property (nonatomic, copy) NSString <Optional>*category_id;
@property (nonatomic, copy) NSString <Optional>*category_name;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end
