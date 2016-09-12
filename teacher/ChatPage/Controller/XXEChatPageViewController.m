//
//  XXECharPageViewController.m
//  teacher
//
//  Created by codeDing on 16/8/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEChatPageViewController.h"

@interface XXEChatPageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UISegmentedControl *segentControl;


@end

@implementation XXEChatPageViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = XXEBackgroundColor;
    //导航栏的按钮
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(-10,0,22,22)];
    [rightButton setImage:[UIImage imageNamed:@"search_icon"]  forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    UIView *changeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    changeView.backgroundColor = [UIColor redColor];
    [self.view addSubview:changeView];
    
}

/** 这两个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UISegmentedControl *)segentControl
{
    if (!_segentControl) {
        _segentControl = [[UISegmentedControl alloc]initWithFrame:CGRectMake(70.0f, 5.0f, 180.0f, 34.0f)];
        [_segentControl insertSegmentWithTitle:@"老师" atIndex:0 animated:YES];
        [_segentControl insertSegmentWithTitle:@"课堂" atIndex:1 animated:YES];
        [_segentControl insertSegmentWithTitle:@"机构" atIndex:2 animated:YES];
        _segentControl.momentary = NO;
        _segentControl.multipleTouchEnabled = NO;
        _segentControl.selectedSegmentIndex = 0;
        _segentControl.tintColor = [UIColor whiteColor];
        [_segentControl addTarget:self action:@selector(segentControlClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _segentControl;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.segentControl;
    
    NSLog(@"猩课堂");
}

#pragma mark - actionSegment
- (void)segentControlClick:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex == 0) {
        NSLog(@"老师");
        
    }else if (segment.selectedSegmentIndex == 1){
        NSLog(@"课堂");
    
    }else if (segment.selectedSegmentIndex == 2){
        NSLog(@"机构");
    }
}

- (void)searchButtonClick:(UIButton *)sender
{
    NSLog(@"搜索");
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
