//
//  XXEClassAddressHeadermasterAndManagerViewController.h
//  teacher
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXEClassAddressHeadermasterAndManagerViewController : XXEBaseViewController

@property (nonatomic, copy) NSString *schoolId;

@property (nonatomic, copy) NSString *schoolType;
/** 判断进入到是相册还是班级通讯录 */
@property (nonatomic, copy)NSString *headMasterAlbum;

/** 用户身份 */
@property (nonatomic, copy)NSString *homeUserIdentifier;

@property(nonatomic, copy) NSString *fromFlagStr;

@end
