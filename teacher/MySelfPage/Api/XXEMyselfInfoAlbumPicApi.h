//
//  XXEMyselfInfoAlbumPicApi.h
//  teacher
//
//  Created by Mac on 16/9/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEMyselfInfoAlbumPicApi : YTKRequest
/*
 【老师个人风采照片】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Teacher/teacher_pic
 传参:
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id;


@end
