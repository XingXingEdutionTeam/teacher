



//
//  XXESchoolNotificationDetailViewController.m
//  teacher
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolNotificationDetailViewController.h"

@interface XXESchoolNotificationDetailViewController ()

@end

@implementation XXESchoolNotificationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _nameLabel.text = _name;
    _scopeLabel.text = _scope;
    _timeLabel.text = _time;
    _contentTextView.text = _content;
    
    
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
