//
//  XXEUpdataImageViewController.h
//  teacher
//
//  Created by codeDing on 16/8/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"


@interface XXEUpdataImageViewController : XXEBaseViewController
@property (nonatomic,strong)NSMutableArray *datasource;
/** 学校Id */
@property (nonatomic, copy)NSString *myAlbumUpSchoolId;
/** 班级id */
@property (nonatomic, copy)NSString *myAlbumUpClassId;

/** 身份 */
@property (nonatomic, copy)NSString *userIdentifier;


@end
