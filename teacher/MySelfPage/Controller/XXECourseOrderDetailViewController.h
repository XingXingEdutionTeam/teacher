//
//  XXECourseOrderDetailViewController.h
//  teacher
//
//  Created by Mac on 2016/11/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXECourseOrderDetailViewController : XXEBaseViewController

//订单 id
@property (nonatomic, copy) NSString *order_id;
//订单 状态 是否 支付
@property(nonatomic, copy) NSString *stateFlagStr;


@end
