//
//  XXEStudentModel.h
//  teacher
//
//  Created by Mac on 16/9/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "XXEStudentModel.h"


@protocol XXEStudentModel

@end


@interface XXEStudentModel : JSONModel

/*
 {
 "baby_id" = 10;
 "date_tm" = 1458884982;
 "head_img" = "app_upload/text/baby_head/baby_head10.jpg";
 "sch_type" = 2;
 tname = "\U90d1\U6653\U660e";
 }
 */

@property (nonatomic, copy) NSString *date_tm;
@property (nonatomic, copy) NSString *baby_id;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *tname;
@property (nonatomic, copy) NSString *sch_type;

+ (NSArray*)parseResondsData:(id)respondObject;

@end
