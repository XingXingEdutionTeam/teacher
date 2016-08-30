//
//  XXEAlbumDetailsModel.h
//  teacher
//
//  Created by codeDing on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEAlbumDetailsModel : JSONModel

/** 图片创建时间 */
@property (nonatomic, copy)NSString <Optional>*date_tm;
/** 图片点赞数 */
@property (nonatomic, copy)NSString <Optional>*good_num;

/** 图片Id */
@property (nonatomic, copy)NSString <Optional>*photoId;

/** 图片地址 */
@property (nonatomic, copy)NSString <Optional>*pic;

@end
