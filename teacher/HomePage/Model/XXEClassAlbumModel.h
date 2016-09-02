//
//  XXEClassAlbumModel.h
//  teacher
//
//  Created by codeDing on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEClassAlbumModel : JSONModel
/** 教师Id */
@property (nonatomic, copy)NSString <Optional>*teacher_id;
/** 教师姓名 */
@property (nonatomic, copy)NSString <Optional>*tname;
/** 图片 */
@property (nonatomic, copy)NSArray *pic_arr;
@end
