//
//  XXEClassManagerClassDetailInfoViewController.h
//  teacher
//
//  Created by Mac on 16/9/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXEClassManagerClassDetailInfoViewController : XXEBaseViewController


@property (nonatomic, strong) NSString *schoolId;

@property (nonatomic, strong) NSString *classId;

@property (nonatomic, copy) NSString *schoolType;

@property (nonatomic, copy) NSString *position;

//[condit] => 1		//0:待审核  1:审核通过  2:驳回
@property (nonatomic, copy) NSString *condit;

@property (nonatomic, copy) NSString *classNameStr;
@property (nonatomic, copy) NSString *classNumStr;
@property (nonatomic, copy) NSString *teacherStr;


@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *classNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;


@property (weak, nonatomic) IBOutlet UIButton *supportButton;

@property (weak, nonatomic) IBOutlet UIButton *refuseButton;





@end
