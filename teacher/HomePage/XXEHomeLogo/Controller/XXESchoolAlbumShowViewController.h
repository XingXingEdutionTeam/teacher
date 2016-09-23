//
//  XXESchoolAlbumShowViewController.h
//  teacher
//
//  Created by Mac on 16/9/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXESchoolAlbumShowViewController : XXEBaseViewController

//图片 URL 的数组
@property (nonatomic, strong) NSArray *imageUrlArray;

//图片 模型 数组
@property (nonatomic, strong) NSMutableArray *imageModelArray;
//当前 图片 是 第几张图片
@property (nonatomic, assign) NSInteger currentIndex;

//举报 图片 来源
@property (nonatomic, copy) NSString *origin_pageStr;


@end
