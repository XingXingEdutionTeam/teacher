//
//  XXERedFlowerSentHistoryApi.h
//  teacher
//
//  Created by Mac on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXERedFlowerSentHistoryApi : YTKRequest

/*
 【小红花->赠送记录列表】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Teacher/give_flower_msg
 
 传参:
 
 page	//页码(加载更多,默认1)
 */


- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type page:(NSString *)page;


@end
