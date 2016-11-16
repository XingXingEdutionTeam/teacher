//
//  XXESotreGoodsCollectionModel.h
//  teacher
//
//  Created by Mac on 2016/11/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXESotreGoodsCollectionModel : JSONModel

/*
 (
 [id] => 1
 [date_tm] => 1459330258
 [type] => 1
 [class] => 玩具
 [title] => 朱迪毛绒玩具
 [price] => 35.00
 [exchange_price] => 0.00
 [exchange_coin] => 1000
 [goods_num] => 200
 [sale_num] => 39
 [con] => 电影疯狂动物城主角,可爱的朱迪,兔警官
 [col_num] => 0
 [pic] => app_upload/goods_img/demo/zhudi1.jpg
 [collect_tm] => 1462857846
 )
 */
@property (nonatomic, copy) NSString<Optional> *good_id;
@property (nonatomic, copy) NSString<Optional> *date_tm;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, copy) NSString<Optional> *classStr;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *price;
@property (nonatomic, copy) NSString<Optional> *exchange_price;
@property (nonatomic, copy) NSString<Optional> *exchange_coin;
@property (nonatomic, copy) NSString<Optional> *goods_num;
@property (nonatomic, copy) NSString<Optional> *sale_num;
@property (nonatomic, copy) NSString<Optional> *con;
@property (nonatomic, copy) NSString<Optional> *col_num;
@property (nonatomic, copy) NSString<Optional> *pic;
@property (nonatomic, copy) NSString<Optional> *collect_tm;


+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end
