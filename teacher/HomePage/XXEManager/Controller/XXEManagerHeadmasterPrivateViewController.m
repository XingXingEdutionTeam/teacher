

//
//  XXEManagerHeadmasterPrivateViewController.m
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEManagerHeadmasterPrivateViewController.h"
#import "XXEStudentManagerViewController2.h"
#import "XXEFamilyManagerViewController2.h"
#import "XXETeacherManagerViewController.h"
#import "XXECourseManagerViewController1.h"
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
//    model.titleLableFont               = defaultFont(16);
    model.titleLableFont = [UIFont systemWithIphone6P:18 Iphone6:16 Iphone5:14 Iphone4:12];
    model.menuHorizontalSpacing = 1;
    model.donotScrollTapViewWhileScroll = YES;
    navSliderMenu = [[QHNavSliderMenu alloc] initWithFrame:(CGRect){0,0,KScreenWidth,50 * kScreenRatioHeight} andStyleModel:model andDelegate:self showType:self.menuType];
    navSliderMenu.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:navSliderMenu];
    
    //如果只需要一个菜单 下面这些都可以不要  以下是个添加page视图的例子
    //example 用于滑动的滚动视图
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navSliderMenu.bottom, KScreenWidth, KScreenHeight-navSliderMenu.bottom)];
    contentScrollView.contentSize = (CGSize){KScreenWidth*menuCount,contentScrollView.contentSize.height};
    contentScrollView.pagingEnabled = NO;
    contentScrollView.delegate      = self;
    contentScrollView.scrollsToTop  = NO;
    contentScrollView.scrollEnabled = NO;
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
        XXEFamilyManagerViewController2 *familyManagerVC = [[XXEFamilyManagerViewController2 alloc]init];
        
        familyManagerVC.view.left =1*screenWidth;
        familyManagerVC.view.top=0;
        familyManagerVC.schoolId = _schoolId;
        familyManagerVC.schoolType = _schoolType;
        familyManagerVC.classId = _classId;
        familyManagerVC.position = _position;
        
        [self addChildViewController:familyManagerVC];

        [contentScrollView addSubview:familyManagerVC.view];
        [listVCQueue setObject:familyManagerVC forKey:@(1)];
        
    }else if (index == 2){
        //@"教师管理"
        XXETeacherManagerViewController *teacherManagerVC = [[XXETeacherManagerViewController alloc]init];
        
        teacherManagerVC.view.left =2*screenWidth;
        teacherManagerVC.view.top=0;
        teacherManagerVC.schoolId = _schoolId;
        teacherManagerVC.schoolType = _schoolType;
        teacherManagerVC.classId = _classId;
        teacherManagerVC.position = _position;
        
        [self addChildViewController:teacherManagerVC];

        [contentScrollView addSubview:teacherManagerVC.view];
        [listVCQueue setObject:teacherManagerVC forKey:@(2)];
        
    }else if (index == 3){
        //@"课程管理"
        XXECourseManagerViewController1 *courseManagerVC = [[XXECourseManagerViewController1 alloc]init];
        
        courseManagerVC.view.left =3*screenWidth;
        courseManagerVC.view.top=0;
        courseManagerVC.schoolId = _schoolId;
        courseManagerVC.schoolType = _schoolType;
        courseManagerVC.classId = _classId;
        courseManagerVC.position = _position;
        
        [self addChildViewController:courseManagerVC];

        [contentScrollView addSubview:courseManagerVC.view];
        [listVCQueue setObject:courseManagerVC forKey:@(3)];
        
    }else if (index == 4){
        //@"数据管理"
        XXEDataManagerViewController *dataManagerVC = [[XXEDataManagerViewController alloc]init];
        
        dataManagerVC.view.left =4*screenWidth;
        dataManagerVC.view.top=0;
        dataManagerVC.schoolId = _schoolId;
        dataManagerVC.schoolType = _schoolType;
        dataManagerVC.classId = _classId;
        dataManagerVC.position = _position;
        
        [self addChildViewController:dataManagerVC];

        [contentScrollView addSubview:dataManagerVC.view];
        [listVCQueue setObject:dataManagerVC forKey:@(4)];
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
