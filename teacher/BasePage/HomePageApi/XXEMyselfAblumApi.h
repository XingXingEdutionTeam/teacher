//
//  XXEMyselfAblumApi.h
//  teacher
//
//  Created by codeDing on 16/8/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEMyselfAblumApi : YTKRequest

- (id)initWithMyselfAblumSchoolId:(NSString *)schollId ClassId:(NSString *)classId TeacherId:(NSString *)teacherId AlbumXid:(NSString *)albumXid AlbumUserId:(NSString *)albumUserId;

@end
