//
//  XXETeacherUserInfo.h
//  teacher
//
//  Created by codeDing on 16/8/15.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXETeacherUserInfo : JSONModel

@property (nonatomic, copy)NSString <Optional>*school_name;
@property (nonatomic, copy)NSString <Optional>*school_id;
@property (nonatomic, copy)NSString <Optional>*class_name;
@property (nonatomic, copy)NSString <Optional>*class_id;

@end
