//
//  XXEClassAlbumApi.h
//  teacher
//
//  Created by codeDing on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEClassAlbumApi : YTKRequest

- (id)initWithClassAlbumSchoolID:(NSString *)schoolId classID:(NSString *)classId UserXId:(NSString *)userXid UserID:(NSString *)userId position:(NSString *)position;

@end
