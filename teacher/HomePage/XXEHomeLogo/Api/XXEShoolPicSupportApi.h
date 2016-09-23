//
//  XXEShoolPicSupportApi.h
//  teacher
//
//  Created by Mac on 16/9/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEShoolPicSupportApi : YTKRequest

/*
 【猩课堂--对学校相册的图片点赞】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Global/school_album_good
 传参:
	pic_id		//图片id
 */


- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id pic_id:(NSString *)pic_id;


@end
