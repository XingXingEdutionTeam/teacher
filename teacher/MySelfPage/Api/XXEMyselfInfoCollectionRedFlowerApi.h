//
//  XXEMyselfInfoCollectionRedFlowerApi.h
//  teacher
//
//  Created by Mac on 16/9/6.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEMyselfInfoCollectionRedFlowerApi : YTKRequest


/*
 【我的收藏---小红花】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Global/col_flower_list (详情页数据也在这里)
 return_param_all  1
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id page:(NSString *)page return_param_all:(NSString *)return_param_all;

@end
