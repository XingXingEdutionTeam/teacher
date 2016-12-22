//
//  SchoolInfoManager.h
//  teacher
//
//  Created by codeDing on 16/12/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#define kSchoolManagerInstance [SchoolInfoManager shareInstance]
#import <Foundation/Foundation.h>

@interface SchoolInfoManager : NSObject
+ (SchoolInfoManager *)shareInstance;

@property(nonatomic, copy)NSString *school_id;
@property(nonatomic, copy)NSString *class_id;
@property(nonatomic)NSInteger schoolArr_length;
@property(nonatomic)NSInteger schoolArr_index;
@property(nonatomic)NSInteger classArr_length;
@property(nonatomic)NSInteger classArr_index;


- (void)configureWithSchoolId:(NSString*)school_id classId:(NSString*)class_id schoolArr_length:(NSInteger)schoolArr_length schoolArr_index:(NSInteger)schoolArr_index classArr_length:(NSInteger)classArr_length classArr_index:(NSInteger)classArr_index;
@end
