//
//  XXETeachSubjectModel.h
//  teacher
//
//  Created by Mac on 2016/11/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXETeachSubjectModel : JSONModel

/** 学校的ID */
@property (nonatomic, copy)NSString <Optional>*teachsubjectId;
/** 学校的名字 */
@property (nonatomic, copy)NSString <Optional>*name;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end
