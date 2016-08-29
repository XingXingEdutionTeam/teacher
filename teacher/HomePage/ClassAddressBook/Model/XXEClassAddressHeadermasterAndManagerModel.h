//
//  XXEClassAddressHeadermasterAndManagerModel.h
//  teacher
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEClassAddressHeadermasterAndManagerModel : JSONModel

/*
 {
 "class_id" = 33;
 "class_name" = "\U516d\U5e74\U7ea7\U4e94\U73ed";
 }
 */

@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *class_name;


+ (NSArray*)parseResondsData:(id)respondObject;
@end
