


//
//  XXEAboutMyselfInfoViewController.m
//  teacher
//
//  Created by Mac on 16/9/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEAboutMyselfInfoViewController.h"

@interface XXEAboutMyselfInfoViewController ()

@end

@implementation XXEAboutMyselfInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"关于我们";
    
    _contentTextView.text = @"          猩猩教室为国内首个专注于青少年教育培训和管理，以及幼儿教育培训和管理的O2O教育品牌。品牌以移动互联技术为基础，用互联网+思维建设运营，力图用自主研发的三方平台（包括pc端和移动端平台）结合线下教育培训机构的方式，给客户带来极致便利的体验，重塑目前混乱，低效，无规模，无标准的青少年教育培训和幼儿教育培训市场。 公司下设研发部、教研部和市场部等多个部门，聚集了一群年轻的小伙伴共同努力，力争在3-5年内将猩猩教室品牌做到细分市场的领导者。";
    
    _phoneNumLabel.text = @"021-60548858";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
