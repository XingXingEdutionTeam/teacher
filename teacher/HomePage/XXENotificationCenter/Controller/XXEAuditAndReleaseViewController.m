

//
//  XXEAuditAndReleaseViewController.m
//  teacher
//
//  Created by Mac on 16/9/14.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEAuditAndReleaseViewController.h"
#import "XXEReleaseViewController.h"
#import "SystemNotificationVerifyListViewController.h"
#import "SystemNotificationPubilshListViewContorllor.h"

@interface XXEAuditAndReleaseViewController (){
    UISegmentedControl *segementedControl;
    //审核 a=0; 发布 a=1;
//    NSInteger a;
    NSString *condit;
    //数据请求参数
    NSString *parameterXid;
    NSString *parameterUser_Id;

}
@property(nonatomic ,strong)SystemNotificationVerifyListViewController *verifyListVC;
@property(nonatomic ,strong)SystemNotificationPubilshListViewContorllor *publishListVC;
@property(nonatomic, strong)UIViewController *currentController;
@end

@implementation XXEAuditAndReleaseViewController

-(SystemNotificationVerifyListViewController *)verifyListVC{
    if (!_verifyListVC) {
        _verifyListVC = [[SystemNotificationVerifyListViewController alloc] init];
        _verifyListVC.classId = self.classId;
        _verifyListVC.schoolId = self.schoolId;
        _verifyListVC.position = self.position;
    }
    
    return _verifyListVC;
}

-(SystemNotificationPubilshListViewContorllor *)publishListVC {
    if (!_publishListVC) {
        _publishListVC = [[SystemNotificationPubilshListViewContorllor alloc] init];
        _publishListVC.classId = self.classId;
        _publishListVC.schoolId = self.schoolId;
        _publishListVC.position = self.position;
    }
    
    return _publishListVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XXEBackgroundColor;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    
    condit = @"0";
    UIButton *rightBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 22, 22) backGruondImageName:@"comment_request_icon" Target:self Action:@selector(rightBtnClick:) Title:@""];
    UIBarButtonItem *sentItem =[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem =sentItem;
    
    [self createSegementControl];
    
}

- (void)rightBtnClick:(UIButton *)button{
    XXEReleaseViewController *releaseVC = [[XXEReleaseViewController alloc] init];
    releaseVC.schoolId = _schoolId;
    releaseVC.classId = _classId;
    
    [self.navigationController pushViewController:releaseVC animated:YES];
}


- (void)createSegementControl{
    
    CGFloat segWidth = 100 * kScreenRatioWidth;
    CGFloat segHeight = 30 * kScreenRatioHeight;
    
    segementedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake((KScreenWidth - segWidth)/2, (49 - segHeight)/2, segWidth, segHeight)];
    [segementedControl insertSegmentWithTitle:@"审核" atIndex:0 animated:NO];
    [segementedControl insertSegmentWithTitle:@"发布" atIndex:1 animated:NO];
    self.navigationItem.titleView = segementedControl;
    segementedControl.tintColor = [UIColor whiteColor];
    segementedControl.selectedSegmentIndex = 0;
    [segementedControl addTarget:self action:@selector(controlPressed:) forControlEvents:UIControlEventValueChanged];
    
    [self addChildViewController:self.verifyListVC];
    [self addChildViewController:self.publishListVC];
    [self.view addSubview:self.verifyListVC.view];
    self.currentController = self.verifyListVC;
}

- (void)controlPressed:(UISegmentedControl *)segment{
    
    condit = [NSString stringWithFormat:@"%ld", segment.selectedSegmentIndex];
    if ([condit integerValue] == 0) {
        
        [self transitionFromViewController:self.currentController toViewController:self.verifyListVC duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        }  completion:^(BOOL finished) {
            //......
        }];
        self.currentController=self.verifyListVC;
    }else if ([condit integerValue] == 1){
        [self transitionFromViewController:self.currentController toViewController:self.publishListVC duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        }  completion:^(BOOL finished) {
            //......
        }];
        self.currentController=self.publishListVC;
        //        a = 1;
        //        [self fetchSystemNetData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
