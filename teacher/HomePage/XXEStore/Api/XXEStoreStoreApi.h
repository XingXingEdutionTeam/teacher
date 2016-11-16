//
//  XXEStoreStoreApi.h
//  teacher
//
//  Created by Mac on 16/11/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEStoreStoreApi : YTKRequest

/*
 【猩猩商城--猩币兑换的商品列表(通用于分类页面)】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Global/coin_goods
 传参:
	class		//类目,传类目id.如果是空,查询所有(分类页面用)
	search_words	//搜索关键词(分类页面用),当搜索的时候,app页面左边的分类不需要选中状态,列表顶部显示'搜索'两个字
 
 返回值案例:
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id classID:(NSString *)classID search_words:(NSString *)search_words;


@end
