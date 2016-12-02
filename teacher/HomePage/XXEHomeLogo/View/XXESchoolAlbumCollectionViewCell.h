//
//  XXESchoolAlbumCollectionViewCell.h
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXESchoolAlbumModel.h"


@interface XXESchoolAlbumCollectionViewCell : UICollectionViewCell


@property (nonatomic, strong) XXESchoolAlbumModel *model;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *schoolImageView;

@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;


@property (nonatomic) BOOL disabled;

//判断右上角 编辑 按钮 是否 为选中状态,如果是选中状态,则可多选并显示绿点///否则 不显示 绿点且进入图片浏览模式





@end
