//
//  XXEStudentUnsignInListViewController.h
//  teacher
//
//  Created by Mac on 16/9/7.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXEStudentUnsignInListViewController : XXEBaseViewController

@property (nonatomic, strong) NSString *schoolId;

@property (nonatomic, strong) NSString *classId;

@property (nonatomic, copy) NSString *schoolType;

@property (nonatomic, copy) NSString *timeStr;

//sign_type	//1:已签到  2:未签到
@property (nonatomic, copy) NSString *sign_type;

@end
