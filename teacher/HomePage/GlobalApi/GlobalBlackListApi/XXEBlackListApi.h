//
//  XXEBlackListApi.h
//  teacher
//
//  Created by Mac on 16/9/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEBlackListApi : YTKRequest

/*
 【黑名单--黑名单列表】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Global/black_user_list
 
 传参:

 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id;



@end
