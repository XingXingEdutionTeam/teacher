//
//  XXEAlbumContentViewController.h
//  teacher
//
//  Created by codeDing on 16/8/15.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"
#import "XXEMySelfAlbumModel.h"

@interface XXEAlbumContentViewController : XXEBaseViewController
@property (nonatomic, strong)XXEMySelfAlbumModel *contentModel;
@property (nonatomic, copy)NSString *albumTeacherXID;

/** 学校Id */
@property (nonatomic, copy)NSString *myAlbumUpSchoolId;
/** 班级id */
@property (nonatomic, copy)NSString *myAlbumUpClassId;

@property (nonatomic,strong)NSMutableArray *datasource;


@end
