//
//  XXEMyClassAlbumTableViewCell.h
//  teacher
//
//  Created by codeDing on 16/8/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXEMySelfAlbumModel.h"

@interface XXEMyClassAlbumTableViewCell : UITableViewCell
/** 相册封面 */
@property (weak, nonatomic) IBOutlet UIImageView *classAlubmImgeView;
/** 相册名称 */
@property (weak, nonatomic) IBOutlet UILabel *classAlubmNameLabel;
/** 相册个数 */
@property (weak, nonatomic) IBOutlet UILabel *classAlubmPageLabel;
/** 给单元格赋值 */
- (void)configerGetClassAlubmMessage:(XXEMySelfAlbumModel *)model;

@end
