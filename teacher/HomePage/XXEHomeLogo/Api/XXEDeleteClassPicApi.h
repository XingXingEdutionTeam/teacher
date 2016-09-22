//
//  XXEDeleteClassPicApi.h
//  teacher
//
//  Created by codeDing on 16/9/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEDeleteClassPicApi : YTKRequest

- (id)initWithDeleteUserXid:(NSString *)userXid UserID:(NSString *)userId PicId:(NSString *)picId;

@end
