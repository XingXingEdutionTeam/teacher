//
//  XXEStudentSignInModel.h
//  teacher
//
//  Created by Mac on 16/9/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEStudentSignInModel : JSONModel

/*
 {
 "head_img" = "app_upload/text/baby_head/baby_head4.jpg";
 id = 2;
 "sign_in_condit" = 2;  //签到状态, 1: 已签到  2:未签到
 tname = "\U59dc\U8d56\U8d56";
 }
 */

@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *babyId;
@property (nonatomic, copy) NSString *sign_in_condit;
@property (nonatomic, copy) NSString *tname;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end
