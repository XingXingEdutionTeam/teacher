//
//  XXEReviewerModel.h
//  teacher
//
//  Created by codeDing on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEReviewerModel : JSONModel

/** 审核人的Id */
@property (nonatomic, copy)NSString <Optional>*reviewerId;
/** 审核人的真实姓名 */
@property (nonatomic,copy)NSString <Optional>*reviewerName;

@end
