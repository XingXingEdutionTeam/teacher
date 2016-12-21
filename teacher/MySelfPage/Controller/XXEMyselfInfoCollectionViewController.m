

//
//  XXEMyselfInfoCollectionViewController.m
//  teacher
//
//  Created by Mac on 16/9/6.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoCollectionViewController.h"
#import "XXEMyselfInfoCollectionRedFlowerViewController.h"
#import "XXEMyselfInfoCollectionUsersViewController.h"
#import "XXEMyselfInfoCollectionCommentViewController.h"
#import "XXEMyselfInfoCollectionPicViewController.h"
#import "XXEMyselfInfoCollectionLinkViewController.h"
#import "XXEMyselfInfoCollectionSchoolViewController.h"
#import "XXEMyselfInfoCollectionCourseViewController.h"

@interface XXEMyselfInfoCollectionViewController ()<QHNavSliderMenuDelegate, UIScrollViewDelegate, UISearchBarDelegate>
{
    QHNavSliderMenu *navSliderMenu;
    NSMutableDictionary *listVCQueue;
    UIScrollView *contentScrollView;
    UISearchBar *searchBar;
    UISearchController *searchController;
    int menuCount;
}


@end

@implementation XXEMyselfInfoCollectionViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    self.view.backgroundColor = XXEBackgroundColor;
    
    menuCount =7;
    [self initView];
    [self createRightBar];
    [self addListVCWithIndex:0];
    
}

- (void)initView{
    QHNavSliderMenuStyleModel *model = [QHNavSliderMenuStyleModel new];
    NSMutableArray *titles = [[NSMutableArray alloc] initWithObjects:@"小红花",@"用户",@"点评",@"图片",@"链接",@"学校",@"课程",nil];
    model.menuTitles = [titles copy];
    model.menuHorizontalSpacing = 1;
    model.donotScrollTapViewWhileScroll = YES;
    navSliderMenu = [[QHNavSliderMenu alloc] initWithFrame:(CGRect){0,0,KScreenWidth,50 * kScreenRatioHeight} andStyleModel:model andDelegate:self showType:self.menuType];
    navSliderMenu.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:navSliderMenu];
    
    ///如果只需要一个菜单 下面这些都可以不要  以下是个添加page视图的例子
    
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
    
    //用scrollView的滑动大小与屏幕宽度取整数 得到滑动的页数
    [navSliderMenu selectAtRow:(int)((contentScrollView.contentOffset.x+screenWidth/2.f)/screenWidth) andDelegate:NO];
    //根据页数添加相应的视图
    [self addListVCWithIndex:(int)(contentScrollView.contentOffset.x/screenWidth)];
}


#pragma mark scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
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
    //@"小红花",@"用户",@"点评",@"图片",@"链接",@"学校",@"课程"
    //@"小红花"
    if (index == 0) {
        XXEMyselfInfoCollectionRedFlowerViewController *myselfInfoCollectionRedFlowerVC =[[XXEMyselfInfoCollectionRedFlowerViewController alloc]init];
        [self addChildViewController:myselfInfoCollectionRedFlowerVC];
        myselfInfoCollectionRedFlowerVC.view.left = 0* screenWidth;
        myselfInfoCollectionRedFlowerVC.view.top=0;
        
        [contentScrollView addSubview:myselfInfoCollectionRedFlowerVC.view];
        [listVCQueue setObject:myselfInfoCollectionRedFlowerVC forKey:@(0)];
    }else if (index == 1){
        //@"用户"
        XXEMyselfInfoCollectionUsersViewController *myselfInfoCollectionUsersVC = [[XXEMyselfInfoCollectionUsersViewController alloc]init];
        [self addChildViewController:myselfInfoCollectionUsersVC];
        myselfInfoCollectionUsersVC.view.left =1*screenWidth;
        myselfInfoCollectionUsersVC.view.top=0;
        [contentScrollView addSubview:myselfInfoCollectionUsersVC.view];
        [listVCQueue setObject:myselfInfoCollectionUsersVC forKey:@(1)];
        
    }else if (index == 2){
        //@"点评"
        XXEMyselfInfoCollectionCommentViewController *myselfInfoCollectionCommentVC =[[XXEMyselfInfoCollectionCommentViewController alloc]init];
        [self addChildViewController:myselfInfoCollectionCommentVC];
        myselfInfoCollectionCommentVC.view.left =2*screenWidth;
        myselfInfoCollectionCommentVC.view.top =0;
        [contentScrollView addSubview:myselfInfoCollectionCommentVC.view];
        [listVCQueue setObject:myselfInfoCollectionCommentVC forKey:@(2)];
        
    }else if (index == 3){
        //@"图片"
        XXEMyselfInfoCollectionPicViewController *myselfInfoCollectionPicVC = [[XXEMyselfInfoCollectionPicViewController alloc]init];
        [self addChildViewController:myselfInfoCollectionPicVC];
        myselfInfoCollectionPicVC.view.left =3*screenWidth;
        myselfInfoCollectionPicVC.view.top =0;
        [contentScrollView addSubview:myselfInfoCollectionPicVC.view];
        [listVCQueue setObject:myselfInfoCollectionPicVC forKey:@(3)];
        
    }else if (index == 4){
        //@"链接"
        XXEMyselfInfoCollectionLinkViewController *myselfInfoCollectionLinkVC = [[XXEMyselfInfoCollectionLinkViewController alloc]init];
        [self addChildViewController:myselfInfoCollectionLinkVC];
        myselfInfoCollectionLinkVC.view.left =4*screenWidth;
        myselfInfoCollectionLinkVC.view.top =0;
        [contentScrollView addSubview:myselfInfoCollectionLinkVC.view];
        [listVCQueue setObject:myselfInfoCollectionLinkVC forKey:@(4)];
        
    }else if (index == 5){
        //@"学校"
        XXEMyselfInfoCollectionSchoolViewController *myselfInfoCollectionSchoolVC =[[XXEMyselfInfoCollectionSchoolViewController alloc]init];
        [self addChildViewController:myselfInfoCollectionSchoolVC];
        myselfInfoCollectionSchoolVC.view.left =5*screenWidth;
        myselfInfoCollectionSchoolVC.view.top =0;
        [contentScrollView addSubview:myselfInfoCollectionSchoolVC.view];
        [listVCQueue setObject:myselfInfoCollectionSchoolVC forKey:@(5)];
        
    }else if (index == 6){
        //@"课程"
        XXEMyselfInfoCollectionCourseViewController *myselfInfoCollectionCourseVC = [[XXEMyselfInfoCollectionCourseViewController alloc]init];
        [self addChildViewController:myselfInfoCollectionCourseVC];
        myselfInfoCollectionCourseVC.view.left =6*screenWidth;
        myselfInfoCollectionCourseVC.view.top =0;
        [contentScrollView addSubview:myselfInfoCollectionCourseVC.view];
        [listVCQueue setObject:myselfInfoCollectionCourseVC forKey:@(6)];
        
    }
    
    
}



- (void)createRightBar{
    //searchBar
    UIBarButtonItem *searchBa = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"NavBarIconSearch_blue@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(searchB:)];
    self.navigationItem.rightBarButtonItem =searchBa;
    
    
}
- (void)searchB:(UIBarButtonItem*)btn{
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,20, kWidth, 44)];
    UIImage *backgroundImg = [XXETool createImageWithColor:UIColorFromHex(0xf0eaf3) size:searchBar.frame.size];
    [searchBar setBackgroundImage:backgroundImg];
    searchBar.placeholder =@"请输入您想要查询的收藏内容";
    searchBar.tintColor = [UIColor blackColor];
    searchBar.delegate =self;
    searchController = [[UISearchController alloc]initWithSearchResultsController:self];
    [self.navigationItem.titleView sizeToFit];
    [self.navigationController.view addSubview:searchBar];
    searchBar.showsCancelButton =YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    //搜尋結束後，恢復原狀
    return YES;
}
#pragma mark - search bar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchB{
    searchB.showsCancelButton = YES;
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchB{
    
    searchB.showsCancelButton = NO;
    [searchB resignFirstResponder];
    [searchB removeFromSuperview];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [searchBar endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
