//
//  XXEMyselfInfoAlbumUploadPicApi.h
//  teacher
//
//  Created by Mac on 16/9/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEMyselfInfoAlbumUploadPicApi : YTKRequest

/*【个人相册->上传图片】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Teacher/upload_personal_pic
 传参:
	file		//批量上传图片*/

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id upImage:(UIImage *)upImage;

@end
