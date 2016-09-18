//
//  XXEReleaseDetailInfoViewController.m
//  teacher
//
//  Created by Mac on 16/9/14.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEReleaseDetailInfoViewController.h"

@interface XXEReleaseDetailInfoViewController ()

@end

@implementation XXEReleaseDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _subjectLabel.text = _subjectStr;
    _contentTextView.text = _contentStr;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
