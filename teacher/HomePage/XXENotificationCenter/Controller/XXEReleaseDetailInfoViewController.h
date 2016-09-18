//
//  XXEReleaseDetailInfoViewController.h
//  teacher
//
//  Created by Mac on 16/9/14.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXEReleaseDetailInfoViewController : XXEBaseViewController

@property (nonatomic, copy) NSString *subjectStr;
@property (nonatomic, copy) NSString *contentStr;

@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;



@end
