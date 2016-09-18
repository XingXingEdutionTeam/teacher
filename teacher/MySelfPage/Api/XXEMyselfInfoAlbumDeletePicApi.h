//
//  XXEMyselfInfoAlbumDeletePicApi.h
//  teacher
//
//  Created by Mac on 16/9/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEMyselfInfoAlbumDeletePicApi : YTKRequest

/*
 【删除个人相册中的图片(可以批量)】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Teacher/delete_teacher_pic
 传参:
 	pic_id		//图片id,多个逗号隔开
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id pic_id:(NSString *)pic_id;


@end
