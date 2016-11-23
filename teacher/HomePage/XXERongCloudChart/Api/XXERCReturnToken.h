//
//  XXERCReturnToken.h
//  teacher
//
//  Created by codeDing on 16/11/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXERCReturnToken : YTKRequest

// MARK: 获取token
- (instancetype)initWithXid:(NSString *)xid nickName:(NSString *)nickName portraitUri:(NSString *)portraitUri;
@end
