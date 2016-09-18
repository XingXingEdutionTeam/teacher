//
//  XXEAuditDetailInfoViewController.h
//  teacher
//
//  Created by Mac on 16/9/14.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXEAuditDetailInfoViewController : XXEBaseViewController


@property (nonatomic, copy) NSString *subjectStr;
@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, copy) NSString *notice_id;


@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (weak, nonatomic) IBOutlet UIButton *againstButton;

@property (weak, nonatomic) IBOutlet UIButton *supportButton;






@end
