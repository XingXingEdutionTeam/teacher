//
//  XXEGoodUserModel.h
//  teacher
//
//  Created by codeDing on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol  XXEGoodUserModel
@end

@interface XXEGoodUserModel : JSONModel

/** 点赞的xid */
@property (nonatomic, copy)NSString <Optional>*xid;
/** 点赞人的昵称 */
@property (nonatomic, copy)NSString <Optional>*nickname;

@end