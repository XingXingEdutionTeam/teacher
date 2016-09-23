//
//  XXEManagerTeacherViewController.m
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEManagerTeacherViewController.h"
#import "XXEStudentManagerViewController1.h"
#import "XXEFamilyManagerViewController1.h"

@interface XXEManagerTeacherViewController ()<QHNavSliderMenuDelegate, UIScrollViewDelegate, UISearchBarDelegate>
{
    QHNavSliderMenu *navSliderMenu;
    NSMutableDictionary *listVCQueue;
    UIScrollView *contentScrollView;
    UISearchBar *searchBar;
    UISearchController *searchController;
    int menuCount;
}


@end

@implementation XXEManagerTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = XXEColorFromRGB(0, 170, 42);
    self.navigationController.navigationBarHidden = NO;
    self.title = @"管理";
    self.view.backgroundColor = XXEBackgroundColor;
    
    menuCount =2;
    [self initView];
    [self addListVCWithIndex:0];
    
}

- (void)initView{
    QHNavSliderMenuStyleModel *model = [QHNavSliderMenuStyleModel new];
    NSMutableArray *titles = [[NSMutableArray alloc] initWithObjects:@"学生管理",@"家长管理",nil];
    model.menuTitles = [titles copy];
    model.menuWidth=screenWidth / 2.f;
    model.sliderMenuTextColorForNormal = QHRGB(120, 120, 120);
    model.sliderMenuTextColorForSelect = QHRGB(0, 170, 42);
    model.titleLableFont               = defaultFont(16);
    model.menuHorizontalSpacing = 1;
    model.donotScrollTapViewWhileScroll = YES;
    navSliderMenu = [[QHNavSliderMenu alloc] initWithFrame:(CGRect){0,0,KScreenWidth,50 * kScreenRatioHeight} andStyleModel:model andDelegate:self showType:self.menuType];
    navSliderMenu.backgroundColor = UIColorFromRGB(229, 232, 233);
    [self.view addSubview:navSliderMenu];

    //example 用于滑动的滚动视图
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navSliderMenu.bottom, KScreenWidth, KScreenHeight-navSliderMenu.bottom)];
    contentScrollView.contentSize = (CGSize){KScreenWidth*menuCount,contentScrollView.contentSize.height};
    contentScrollView.pagingEnabled = YES;
    contentScrollView.delegate      = self;
    contentScrollView.scrollsToTop  = NO;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:contentScrollView];
    
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
    //@"学生管理",@"家长管理"
    //@"学生管理"
    if (index == 0) {
        
        XXEStudentManagerViewController1 *studentManagerVC =[[XXEStudentManagerViewController1 alloc]init];
        
        studentManagerVC.view.left = 0* screenWidth;
        studentManagerVC.view.top=0;
        studentManagerVC.schoolId = _schoolId;
        studentManagerVC.schoolType = _schoolType;
        studentManagerVC.classId = _classId;
        studentManagerVC.position = _position;
        
        [self addChildViewController:studentManagerVC];

        [contentScrollView addSubview:studentManagerVC.view];
        [listVCQueue setObject:studentManagerVC forKey:@(0)];
    }else if (index == 1){
        //@"家长管理"
        XXEFamilyManagerViewController1 *familyManagerVC = [[XXEFamilyManagerViewController1 alloc]init];
        familyManagerVC.view.left =1*screenWidth;
        familyManagerVC.view.top=0;
        familyManagerVC.schoolId = _schoolId;
        familyManagerVC.schoolType = _schoolType;
        familyManagerVC.classId = _classId;
        familyManagerVC.position = _position;
        [self addChildViewController:familyManagerVC];

        [contentScrollView addSubview:familyManagerVC.view];
        [listVCQueue setObject:familyManagerVC forKey:@(1)];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
