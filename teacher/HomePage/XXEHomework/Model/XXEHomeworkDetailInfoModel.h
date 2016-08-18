//
//  XXEHomeworkDetailInfoModel.h
//  teacher
//
//  Created by Mac on 16/8/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEHomeworkDetailInfoModel : JSONModel



@property (nonatomic, copy) NSString *homeworkId;
@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *date_tm;
@property (nonatomic, copy) NSString *date_end_tm;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *teach_course;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *con;
@property (nonatomic, copy) NSString *tname;
@property (nonatomic, strong) NSMutableArray *pic_group;

+ (NSDictionary*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end
