//
//  XXEMySelfInfoApi.h
//  teacher
//
//  Created by Mac on 16/9/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEMySelfInfoApi : YTKRequest

/*
 ================= 【个人资料 start】 =================
 【我的资料详情】
 ★注: 资质名称这行暂时注释掉,以后考虑周全二期再弄 20160818与樊总沟通
 ★注: 个人相册缺少删除图片功能,最好可以批量删除的,老师详情页的老师个人风采中并没有图片收藏和点赞功能,所以老师资料页的相册里把收藏和点赞暂时屏蔽掉吧
 ★注: 显示缺少个性签名,毕业院校,所学专业
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Teacher/my_info
 传参:
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type;



@end
