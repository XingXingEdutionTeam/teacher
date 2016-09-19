

//
//  XXEManagerHeadmasterPrivateViewController.m
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEManagerHeadmasterPrivateViewController.h"
#import "XXEStudentManagerViewController2.h"
#import "XXEFamilyManagerViewController.h"
#import "XXETeacherManagerViewController.h"
#import "XXECourseManagerViewController.h"
#import "XXEDataManagerViewController.h"

@interface XXEManagerHeadmasterPrivateViewController ()<QHNavSliderMenuDelegate, UIScrollViewDelegate, UISearchBarDelegate>
{
    QHNavSliderMenu *navSliderMenu;
    NSMutableDictionary *listVCQueue;
    UIScrollView *contentScrollView;
    UISearchBar *searchBar;
    UISearchController *searchController;
    int menuCount;
}


@end

@implementation XXEManagerHeadmasterPrivateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = XXEColorFromRGB(0, 170, 42);
    self.navigationController.navigationBarHidden = NO;
    self.title = @"管理";
    self.view.backgroundColor = XXEBackgroundColor;
    
    menuCount =5;
    [self initView];
    [self addListVCWithIndex:0];
    
}

- (void)initView{
    QHNavSliderMenuStyleModel *model = [QHNavSliderMenuStyleModel new];
    NSMutableArray *titles = [[NSMutableArray alloc] initWithObjects:@"学生管理",@"家长管理", @"教师管理", @"课程管理", @"数据管理", nil];
    model.menuTitles = [titles copy];
    model.menuWidth=screenWidth / 5.f;
    model.sliderMenuTextColorForNormal = QHRGB(120, 120, 120);
    model.sliderMenuTextColorForSelect = QHRGB(0, 170, 42);
    model.titleLableFont               = defaultFont(16);
    model.menuHorizontalSpacing = 1;
    model.donotScrollTapViewWhileScroll = YES;
    navSliderMenu = [[QHNavSliderMenu alloc] initWithFrame:(CGRect){0,0,KScreenWidth,50 * kScreenRatioHeight} andStyleModel:model andDelegate:self showType:self.menuType];
    navSliderMenu.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:navSliderMenu];
    
    //如果只需要一个菜单 下面这些都可以不要  以下是个添加page视图的例子
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
    //@"学生管理",@"家长管理",@"教师管理", @"课程管理",@"数据管理"
    //@"学生管理"
    if (index == 0) {
        XXEStudentManagerViewController2 *studentManagerVC =[[XXEStudentManagerViewController2 alloc]init];
        [self addChildViewController:studentManagerVC];
        studentManagerVC.view.left = 0* screenWidth;
        studentManagerVC.view.top=0;
        
        [contentScrollView addSubview:studentManagerVC.view];
        [listVCQueue setObject:studentManagerVC forKey:@(0)];
    }else if (index == 1){
        //@"家长管理"
        XXEFamilyManagerViewController *familyManagerVC = [[XXEFamilyManagerViewController alloc]init];
        [self addChildViewController:familyManagerVC];
        familyManagerVC.view.left =1*screenWidth;
        familyManagerVC.view.top=0;
        [contentScrollView addSubview:familyManagerVC.view];
        [listVCQueue setObject:familyManagerVC forKey:@(1)];
        
    }else if (index == 2){
        //@"教师管理"
        XXETeacherManagerViewController *teacherManagerVC = [[XXETeacherManagerViewController alloc]init];
        [self addChildViewController:teacherManagerVC];
        teacherManagerVC.view.left =2*screenWidth;
        teacherManagerVC.view.top=0;
        [contentScrollView addSubview:teacherManagerVC.view];
        [listVCQueue setObject:teacherManagerVC forKey:@(2)];
        
    }else if (index == 3){
        //@"课程管理"
        XXECourseManagerViewController *courseManagerVC = [[XXECourseManagerViewController alloc]init];
        [self addChildViewController:courseManagerVC];
        courseManagerVC.view.left =3*screenWidth;
        courseManagerVC.view.top=0;
        [contentScrollView addSubview:courseManagerVC.view];
        [listVCQueue setObject:courseManagerVC forKey:@(3)];
        
    }else if (index == 4){
        //@"数据管理"
        XXEDataManagerViewController *dataManagerVC = [[XXEDataManagerViewController alloc]init];
        [self addChildViewController:dataManagerVC];
        dataManagerVC.view.left =4*screenWidth;
        dataManagerVC.view.top=0;
        [contentScrollView addSubview:dataManagerVC.view];
        [listVCQueue setObject:dataManagerVC forKey:@(4)];
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
