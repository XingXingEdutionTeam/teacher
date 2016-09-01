//
//  XXEStudentSignInViewController.h
//  teacher
//
//  Created by Mac on 16/9/1.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXEStudentSignInViewController : XXEBaseViewController


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *chooseTimeBtn;

@property (weak, nonatomic) IBOutlet UIButton *unRegisterNumBtn;

@property (weak, nonatomic) IBOutlet UIButton *registerNumBtn;

@property (weak, nonatomic) IBOutlet UIButton *allRegisterBtn;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) NSString *schoolId;

@property (nonatomic, strong) NSString *classId;


@end
