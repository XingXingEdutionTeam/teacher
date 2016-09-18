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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
