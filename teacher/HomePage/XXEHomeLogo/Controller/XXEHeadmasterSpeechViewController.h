//
//  XXEHeadmasterSpeechViewController.h
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXEHeadmasterSpeechViewController : XXEBaseViewController

@property (nonatomic, strong) NSString *schoolId;
@property (nonatomic, strong) NSString *classId;
@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *school_type;

//校长致辞
@property (nonatomic, copy) NSString *pdt_speech;

//校长 头像
@property (nonatomic, copy) NSString *head_img;




@end
