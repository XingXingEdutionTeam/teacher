//
//  XXEContentAlbumCollectionCell.h
//  teacher
//
//  Created by codeDing on 16/9/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXEAlbumDetailsModel.h"


@interface XXEContentAlbumCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;


@property (nonatomic, strong) XXEAlbumDetailsModel *model;
@property (nonatomic) BOOL disabled;

- (void)configterContentAblumCellPicURl:(NSString *)picUrl;


@end
