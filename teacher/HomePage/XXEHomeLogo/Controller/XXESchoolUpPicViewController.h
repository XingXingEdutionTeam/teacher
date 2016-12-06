//
//  XXESchoolUpPicViewController.h
//  teacher
//
//  Created by Mac on 16/8/28.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXESchoolUpPicViewController : XXEBaseViewController

@property (nonatomic, strong) NSString *schoolId;
@property (nonatomic, strong) NSString *classId;
//@property (nonatomic, copy) NSString *position;


@property (nonatomic, assign)NSInteger t;

@property (nonatomic, strong) UIActionSheet *actionSheet;
//判断 来源 (即判断 上传 的是 什么照片 或者 视频)
@property (nonatomic, copy) NSString *flagStr;

/** 上传首页班级相册 时候 会用到   相册ID */
@property (nonatomic, strong)NSString *albumID;



@end
