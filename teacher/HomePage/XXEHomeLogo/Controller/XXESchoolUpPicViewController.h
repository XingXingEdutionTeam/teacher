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

@property (nonatomic, assign)NSInteger t;

@property (nonatomic, strong) UIActionSheet *actionSheet;
//判断 来源 (即判断 上传 的是 什么照片 或者 视频)
@property (nonatomic, copy) NSString *flagStr;


@end
