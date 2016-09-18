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

////学校 图片 名字
//@property (nonatomic,copy) NSString *schoolPicName;
//
////是否 选中 图标 名字
//@property (nonatomic, copy) NSString *checkImageName;
//
//@property (nonatomic, strong) UIImageView *checkImageView;
//
@property (nonatomic, strong) XXESchoolAlbumModel *model;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *schoolImageView;

@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;


@property (nonatomic) BOOL disabled;

@end
