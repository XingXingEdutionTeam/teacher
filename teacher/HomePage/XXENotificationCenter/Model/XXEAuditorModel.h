//
//  XXEAuditorModel.h
//  teacher
//
//  Created by Mac on 16/9/14.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEAuditorModel : JSONModel
/*
 (
 [id] => 4		//审核人id,发布接口需要的传参
 [tname] => 姜莉莉
 )
 */

@property (nonatomic, copy) NSString *auditorId;
@property (nonatomic, copy) NSString *tname;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end
