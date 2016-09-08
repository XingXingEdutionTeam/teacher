//
//  XXEMyselfInfoCollectionCommentApi.h
//  teacher
//
//  Created by Mac on 16/9/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEMyselfInfoCollectionCommentApi : YTKRequest

/*
 【我的收藏---点评】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Global/col_tea_com_list (详情页数据也在这里)
 
 传参:
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id page:(NSString *)page;

@end
