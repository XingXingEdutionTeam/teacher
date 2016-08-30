//
//  XXEMyselfAblumAddApi.h
//  teacher
//
//  Created by codeDing on 16/8/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEMyselfAblumAddApi : YTKRequest

- (id)initWithAddMyselfAblumSchoolId:(NSString *)schoolId ClassId:(NSString *)classId AlbumName:(NSString *)albumname;

@end
