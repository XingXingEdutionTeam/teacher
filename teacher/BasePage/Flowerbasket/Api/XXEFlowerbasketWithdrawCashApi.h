//
//  XXEFlowerbasketWithdrawCashApi.h
//  teacher
//
//  Created by Mac on 16/8/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>


@interface XXEFlowerbasketWithdrawCashApi : YTKRequest


- (instancetype)initWithUrlString:(NSString *)url appkey:(NSString *)appkey backtype:(NSString *)backtype xid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type;

@end
