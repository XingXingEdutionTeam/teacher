//
//  SchoolInfoManager.m
//  teacher
//
//  Created by codeDing on 16/12/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "SchoolInfoManager.h"
static SchoolInfoManager *single = nil;
@implementation SchoolInfoManager
+ (SchoolInfoManager *)shareInstance {
    static dispatch_once_t OnceToken;
    dispatch_once(&OnceToken, ^{
        if (single == nil) {
            single = [[SchoolInfoManager alloc] init];
        }
    });
    return single;
}

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.classArr =[[NSMutableArray alloc] initWithCapacity:0];
//    }
//    return self;
//}

- (void)configureWithSchoolId:(NSString*)school_id classId:(NSString*)class_id schoolArr_length:(NSInteger)schoolArr_length schoolArr_index:(NSInteger)schoolArr_index classArr_length:(NSInteger)classArr_length classArr_index:(NSInteger)classArr_index {
    self.school_id = school_id;
    self.class_id = class_id;
    self.schoolArr_length = schoolArr_length;
    self.schoolArr_index = schoolArr_index;
    self.classArr_length = classArr_length;
    self.classArr_index = classArr_index;
}

@end
