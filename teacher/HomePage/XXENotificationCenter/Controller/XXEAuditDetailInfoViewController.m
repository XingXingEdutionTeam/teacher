
//
//  XXEAuditDetailInfoViewController.m
//  teacher
//
//  Created by Mac on 16/9/14.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEAuditDetailInfoViewController.h"

@interface XXEAuditDetailInfoViewController ()

@end

@implementation XXEAuditDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _subjectLabel.text = _subjectStr;
    _contentTextView.text = _contentStr;
    [_againstButton addTarget:self action:@selector(againstButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_supportButton addTarget:self action:@selector(supportButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)againstButtonClick:(UIButton *)button{


}

- (void)supportButtonClick:(UIButton *)button{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
