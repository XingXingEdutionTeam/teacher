
//
//  XXECourseManagerCourseToAuditViewController.m
//  teacher
//
//  Created by Mac on 16/9/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECourseManagerCourseToAuditViewController.h"
#import "XXECourseManagerViewController.h"

@interface XXECourseManagerCourseToAuditViewController ()<QHNavSliderMenuDelegate, UIScrollViewDelegate, UISearchBarDelegate>
{
    QHNavSliderMenu *navSliderMenu;
    NSMutableDictionary *listVCQueue;
    UIScrollView *contentScrollView;
    UISearchBar *searchBar;
    UISearchController *searchController;
    int menuCount;
}

@end

@implementation XXECourseManagerCourseToAuditViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"待审核";
    self.view.backgroundColor = XXEBackgroundColor;
    
    menuCount =2;
    [self initView];
    [self addListVCWithIndex:0];
    
}

- (void)initView{
    QHNavSliderMenuStyleModel *model = [QHNavSliderMenuStyleModel new];
    NSMutableArray *titles = [[NSMutableArray alloc] initWithObjects:@"待校长审核",@"待平台审核",nil];
    model.menuTitles = [titles copy];
    model.menuWidth=screenWidth / 2.f;
    model.sliderMenuTextColorForNormal = QHRGB(120, 120, 120);
    model.sliderMenuTextColorForSelect = QHRGB(0, 170, 42);
    model.titleLableFont               = defaultFont(14);
    model.menuHorizontalSpacing = 1;
    model.donotScrollTapViewWhileScroll = YES;
    navSliderMenu = [[QHNavSliderMenu alloc] initWithFrame:(CGRect){0,0,KScreenWidth,30 * kScreenRatioHeight} andStyleModel:model andDelegate:self showType:self.menuType];
//    navSliderMenu.backgroundColor = UIColorFromRGB(229, 232, 233);
    navSliderMenu.backgroundColor = [UIColor whiteColor];
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
    //0:待完善(草稿)  1:等待校长审核   2:等待官方审核  3:已上线(官方审核通过)  4:校长驳回  5:官方驳回
    //@"待校长审核"
    if (index == 0) {
        
        XXECourseManagerViewController *vc0 =[[XXECourseManagerViewController alloc]init];
        
        vc0.view.left = 0* screenWidth;
        vc0.view.top=0;
        vc0.schoolId = _schoolId;
        vc0.schoolType = _schoolType;
        vc0.classId = _classId;
        vc0.condit = @"1";
        [self addChildViewController:vc0];
        
        [contentScrollView addSubview:vc0.view];
        [listVCQueue setObject:vc0 forKey:@(0)];
    }else if (index == 1){
        //@"待平台审核"
        XXECourseManagerViewController *vc1 = [[XXECourseManagerViewController alloc]init];
        vc1.view.left =1*screenWidth;
        vc1.view.top=0;
        vc1.schoolId = _schoolId;
        vc1.schoolType = _schoolType;
        vc1.classId = _classId;
        vc1.condit = @"2";
        [self addChildViewController:vc1];
        
        [contentScrollView addSubview:vc1.view];
        [listVCQueue setObject:vc1 forKey:@(1)];
        
    }
    
}




@end
