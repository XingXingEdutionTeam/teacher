//
//  XXEAlbumShowViewController.h
//  teacher
//
//  Created by codeDing on 16/8/25.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXEAlbumShowViewController : XXEBaseViewController

/** 需要展示的图片的信息 */
@property (nonatomic, strong)NSMutableArray *showDatasource;
/** 展示的老师ID */
@property (nonatomic, copy)NSString *showAlbumXid;

//当前 图片 是 第几张图片
@property (nonatomic, assign) NSInteger currentIndex;

//判断 来源
@property (nonatomic, copy) NSString *flagStr;

@property (nonatomic, copy) NSString *origin_pageStr;

@property (nonatomic, copy) NSString *picUrlStr;


@end
