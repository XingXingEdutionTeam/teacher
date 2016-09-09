//
//  XXEMyselfInfoCollectionPicApi.h
//  teacher
//
//  Created by Mac on 16/9/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEMyselfInfoCollectionPicApi : YTKRequest

/*
 【我的收藏---图片】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Global/col_pic_list
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id page:(NSString *)page;


@end
