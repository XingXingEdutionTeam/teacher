//
//  XXEClassAlbumModel.h
//  teacher
//
//  Created by codeDing on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEClassAlbumModel : JSONModel

//进入该老师相册时使用该参数
@property (nonatomic, copy) NSString<Optional> *class_id;

/** 教师Id */
@property (nonatomic, copy)NSString <Optional>*teacher_id;
/** 教师姓名 */
@property (nonatomic, copy)NSString <Optional>*tname;
/** 图片 */
@property (nonatomic, copy)NSArray *pic_arr;

//该相册主人的身份
@property (nonatomic, copy)NSString <Optional>*otherTeacherPosition;
//该相册主人身份名称
@property (nonatomic, copy) NSString <Optional> *position_name;


@end
