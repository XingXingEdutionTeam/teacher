//
//  XXEReviewerApi.h
//  teacher
//
//  Created by codeDing on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEReviewerApi : YTKRequest

- (id)initReviwerNameSchoolId:(NSString *)schoolId  classID:(NSString *)classID;

@end
