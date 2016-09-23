//
//  XXESignInViewController.m
//  teacher
//
//  Created by Mac on 16/8/31.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESignInViewController.h"
#import "XXEStudentSignInViewController.h"
#import "XXEStudentSignInManagerAndHeadmasterViewController.h"
#import "QHNavSliderMenu.h"


@interface XXESignInViewController ()<QHNavSliderMenuDelegate,UIScrollViewDelegate>{
    QHNavSliderMenu *navSliderMenu;
    NSMutableDictionary  *listVCQueue;
    UIScrollView *contentScrollView;
    int menuCount;
}


@end

@implementation XXESignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = XXEColorFromRGB(0, 170, 42);
    self.navigationController.navigationBarHidden = NO;
    
    self.title = @"签到";
    
    menuCount = 1;
    
//    NSLog(@"%@  ***   %@", _schoolId, _classId);
    
    [self customContent];
    
}

- (void)customContent{

    ///第一个子视图为scrollView或者其子类的时候 会自动设置 inset为64 这样navSliderMenu会被下移 所以最好设置automaticallyAdjustsScrollViewInsets为no 或者[self.view addSubview:[UIView new]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    QHNavSliderMenuStyleModel *model = [QHNavSliderMenuStyleModel new];

    NSMutableArray *titles = [[NSMutableArray alloc] initWithObjects:@"学生签到", nil];
    model.menuTitles = [titles copy];
    model.menuWidth=screenWidth /1.f;
    //>>>>>>>>>>>如果是image和title类型的 则传入对应的图片数组

    model.sliderMenuTextColorForNormal = QHRGB(120, 120, 120);
    model.sliderMenuTextColorForSelect = QHRGB(0, 170, 42);
    model.titleLableFont               = defaultFont(16);
    
    //>>>>>>>>>>>下面的几个都可以不设置也可以定制
    //    model.sliderMenuTextColorForNormal = QHRGB(140, 140, 140);
    //    model.sliderMenuTextColorForSelect = QHRGB(226, 12, 12);
    //    model.titleLableFont               = defaultFont(12);
    //    model.menuWidth                    = QHScreenWidth /4.f;
    //    model.menuHorizontalSpacing        = 0.f;
    //>>>>>>>>>>>
    
    navSliderMenu = [[QHNavSliderMenu alloc] initWithFrame:(CGRect){0,0,screenWidth,50} andStyleModel:model andDelegate:self showType:self.menuType];
    
    navSliderMenu.backgroundColor = UIColorFromRGB(229, 232, 233);
    [self.view addSubview:navSliderMenu];
    
    ///如果只需要一个菜单 下面这些都可以不要  以下是个添加page视图的例子
    //example 用于滑动的滚动视图
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navSliderMenu.bottom, screenWidth, screenHeight-navSliderMenu.bottom)];
    contentScrollView.contentSize = (CGSize){screenWidth*menuCount,contentScrollView.contentSize.height};
    contentScrollView.pagingEnabled = YES;
    contentScrollView.delegate      = self;
    contentScrollView.scrollsToTop  = NO;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:contentScrollView];
    
    [self addListVCWithIndex:0];
    
}



#pragma mark -QHNavSliderMenuDelegate
- (void)navSliderMenuDidSelectAtRow:(NSInteger)row {
    //让scrollview滚到相应的位置
    [contentScrollView setContentOffset:CGPointMake(row*screenWidth, contentScrollView.contentOffset.y)  animated:NO];
}

#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //用scrollView的滑动大小与屏幕宽度取整数 得到滑动的页数
    [navSliderMenu selectAtRow:(int)((scrollView.contentOffset.x+screenWidth/2.f)/screenWidth) andDelegate:NO];
    //根据页数添加相应的视图
    [self addListVCWithIndex:(int)(scrollView.contentOffset.x/screenWidth)];
    
}

#pragma mark -addVC

- (void)addListVCWithIndex:(NSInteger)index {
    if (!listVCQueue) {
        listVCQueue=[[NSMutableDictionary alloc] init];
    }
    if (index<0||index>=menuCount) {
        return;
    }
    //根据页数添加相对应的视图 并存入数组
    
    if ([self.position isEqualToString:@"1"] || [self.position isEqualToString:@"2"]) {
        //如果 是 班主任 身份的话
     XXEStudentSignInViewController * vc0 = [[XXEStudentSignInViewController alloc]init];
        
        vc0.schoolId = _schoolId;
        vc0.classId = _classId;
        vc0.schoolType = _schoolType;
        vc0.position = _position;
        vc0.view.left = 0*screenWidth;
        vc0.view.top  = 0;
        
        [self addChildViewController:vc0];
        
        [contentScrollView addSubview:vc0.view];
        [listVCQueue setObject:vc0 forKey:@(0)];
    }else if ([self.position isEqualToString:@"3"] || [self.position isEqualToString:@"4"]){
        //如果 是 校长或者 管理人员
        XXEStudentSignInManagerAndHeadmasterViewController *vc0 = [[XXEStudentSignInManagerAndHeadmasterViewController alloc] init];
        
        vc0.schoolId = _schoolId;
        vc0.classId = _classId;
        vc0.schoolType = _schoolType;
        vc0.position = _position;
        vc0.view.left = 0*screenWidth;
        vc0.view.top  = 0;

        [self addChildViewController:vc0];
        
        [contentScrollView addSubview:vc0.view];
        [listVCQueue setObject:vc0 forKey:@(0)];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
