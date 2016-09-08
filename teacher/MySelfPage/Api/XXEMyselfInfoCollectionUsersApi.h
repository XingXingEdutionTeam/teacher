//
//  XXEMyselfInfoCollectionUsersApi.h
//  teacher
//
//  Created by Mac on 16/9/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEMyselfInfoCollectionUsersApi : YTKRequest

/*
 【我的收藏---用户列表】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Global/col_user_list
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id page:(NSString *)page;

@end
