//
//  XXEDataManagerDataModel.h
//  teacher
//
//  Created by Mac on 16/10/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEDataManagerDataModel : JSONModel

/*
 {
 num = 0;
 "tm_name" = 8;
 }
 */

@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *tm_name;


+ (NSArray*)parseResondsData:(id)respondObject;

@end
