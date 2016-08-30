//
//  XXERegisterPicApi.h
//  teacher
//
//  Created by codeDing on 16/8/30.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXERegisterPicApi : YTKRequest

- (id)initUpLoadRegisterPicFileType:(NSString *)fileTYpe PageOrigin:(NSString *)pageOrigin UploadFormat:(NSString *)uploadFormatc UIImageHead:(UIImage *)imageHead;

@end
