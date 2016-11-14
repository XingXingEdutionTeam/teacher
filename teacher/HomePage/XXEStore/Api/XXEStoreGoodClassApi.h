//
//  XXEStoreGoodClassApi.h
//  teacher
//
//  Created by Mac on 16/11/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEStoreGoodClassApi : YTKRequest

/*
 【猩猩商城--猩币兑换的商品类目】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Global/coin_goods_class
 传参:
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id;

@end
