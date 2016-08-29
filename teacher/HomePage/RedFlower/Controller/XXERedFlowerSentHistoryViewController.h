//
//  XXERedFlowerSentHistoryViewController.h
//  teacher
//
//  Created by Mac on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"
#import "XXETeacherUserInfo.h"

@interface XXERedFlowerSentHistoryViewController : XXEBaseViewController

@property (nonatomic, copy) NSString *schoolId;

@property (nonatomic, copy) NSString *classId;

 //已赠花篮数量
@property (nonatomic, copy) NSString *give_num;
 //剩余花篮数量
@property (nonatomic, copy) NSString *flower_able;


@end
