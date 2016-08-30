//
//  XXEMySelfAlbumModel.h
//  teacher
//
//  Created by codeDing on 16/8/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEMySelfAlbumModel : JSONModel

/** 个人相册的ID */
@property (nonatomic, copy)NSString <Optional>*album_id;
/** 相册的名称 */
@property (nonatomic, copy)NSString <Optional>*album_name;
/** 相册创建的时间 */
@property (nonatomic, copy)NSString <Optional>*date_tm;
/** 相册内的照片数量 */
@property (nonatomic, copy)NSString <Optional>*pic_num;
/** 相册封面 */
@property (nonatomic, copy)NSString <Optional>*album_pic;


@end
