//
//  XXEStarRemarkModel.h
//  teacher
//
//  Created by Mac on 16/8/31.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEStarRemarkModel : JSONModel

/*
 {
 con = "\U86ee\U597d";
 "date_tm" = 1466705443;
 "head_img" = "app_upload/text/parent/p2.jpg";
 "head_img_type" = 0;
 id = 6;
 nickname = "\U5c0f\U997a\U5b50";
 "pic_arr" =             (
 );
 "school_score" = 4;
 }
 */

@property (nonatomic, copy) NSString *con;
@property (nonatomic, copy) NSString *date_tm;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *head_img_type;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *school_score;
@property (nonatomic, strong) NSArray *pic_arr;


+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end
