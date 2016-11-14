

//
//  XXEStoreRootViewController.m
//  teacher
//
//  Created by Mac on 16/11/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStoreRootViewController.h"
#import "XXEStoreStoreViewController.h"
#import "XXEStoreCategoryViewController.h"
#import "XXEStoreMyselfViewController.h"


@interface XXEStoreRootViewController ()<UIScrollViewDelegate>
{
    UIButton *storeButton;
    
    UIButton *categoryButton;
    
    UIButton *myselfButton;
    
    NSString *flagStr;
    
}


@property (nonatomic, strong) XXEStoreStoreViewController *storeVC;
@property (nonatomic, strong) XXEStoreCategoryViewController *categoryVC;
@property (nonatomic, strong) XXEStoreMyselfViewController *myselfVC;


@end

@implementation XXEStoreRootViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = XXEColorFromRGB(0, 170, 42);
    self.navigationController.navigationBarHidden = NO;
    
    _storeVC = [[XXEStoreStoreViewController alloc] init];
    _categoryVC = [[XXEStoreCategoryViewController alloc] init];
    _myselfVC = [[XXEStoreMyselfViewController alloc] init];
    
    
    _childViews = [[NSMutableArray alloc] init];
    
//    self.navigationController.navigationBarHidden = YES;
    
    [self createBigScrollView];
    
    [self createBottomViewButton];
    
    storeButton.selected = YES;
    categoryButton.selected = NO;
    myselfButton.selected = NO;
    _myScrollView.contentOffset = CGPointMake(0, 0);
    
    self.navigationItem.title = @"商城";
    [self addChildViewController:self.storeVC];
    [self.myScrollView addSubview:self.storeVC.view];
    self.storeVC.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 49 - 64);
    
}


- (void)createBottomViewButton{
    
    UIImageView *bottomView= [[UIImageView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 49 - 64, KScreenWidth, 49)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    bottomView.userInteractionEnabled =YES;
    
    CGFloat itemWidth = KScreenWidth / 3;
    CGFloat itemHeight = 49;
    
    CGFloat buttonWidth = itemWidth;
    CGFloat buttonHeight = itemHeight;
    
    //----------------------------商城
    storeButton = [XXETool createButtonFrame:CGRectMake(buttonWidth / 2 * 0, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) unseletedImageName:@"tab0_selected（0）" seletedImageName:@"tab0_selected" title:@"商城" unseletedTitleColor:[UIColor lightGrayColor] seletedTitleColor:XXEColorFromRGB(0, 170, 42) font:[UIFont systemFontOfSize:10] target:self action:@selector(buttonClick:)];
    storeButton.tag = 10;
    //    [commentRequestButton setBackgroundColor:[UIColor redColor]];
    //设置 图片 位置
    storeButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 - 48 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    storeButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -storeButton.titleLabel.bounds.size.width-30, 0, 0);
    [bottomView addSubview:storeButton];
    
    //---------------------------分类
    categoryButton = [XXETool createButtonFrame:CGRectMake(buttonWidth, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) unseletedImageName:@"tab1_selected(1)" seletedImageName:@"tab1_selected" title:@"分类" unseletedTitleColor:[UIColor lightGrayColor] seletedTitleColor:XXEColorFromRGB(0, 170, 42) font:[UIFont systemFontOfSize:10] target:self action:@selector(buttonClick:)];
    categoryButton.tag = 11;
    //    [commentHistoryButton setBackgroundColor:[UIColor yellowColor]];
    //设置 图片 位置
    categoryButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 - 48 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    categoryButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -categoryButton.titleLabel.bounds.size.width-30, 0, 0);
    [bottomView addSubview:categoryButton];
    
    //-------------------------------我的
    myselfButton  = [XXETool createButtonFrame:CGRectMake(buttonWidth * 2, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) unseletedImageName:@"tab4_selected(4)" seletedImageName:@"tab4_selected" title:@"我的" unseletedTitleColor:[UIColor lightGrayColor] seletedTitleColor:XXEColorFromRGB(0, 170, 42) font:[UIFont systemFontOfSize:10] target:self action:@selector(buttonClick:)];
    myselfButton.tag = 12;
    //    [commentFlowerButton setBackgroundColor:[UIColor blueColor]];
    //设置 图片 位置
    myselfButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 - 48 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    myselfButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -myselfButton.titleLabel.bounds.size.width-30, 0, 0);
    
    [bottomView addSubview:myselfButton];
    
    _buttonArray = [[NSMutableArray alloc] initWithObjects:storeButton, categoryButton, myselfButton, nil];
}


- (void)buttonClick:(UIButton *)button{
    //    NSLog(@"button.tag  ---  %ld", button.tag);
    
    for (UIButton *btn in _buttonArray) {
        btn.selected = NO;
    }
    
    button.selected = YES;
    
    _myScrollView.contentOffset = CGPointMake(KScreenWidth * (button.tag - 10), 0);
    
    if (button == storeButton) {
        self.navigationItem.title = @"商城";
        
        [self addChildViewController:self.storeVC];
        [self.myScrollView addSubview:self.storeVC.view];
        self.storeVC.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 49 - 64);
        
    }else if (button == categoryButton){
        self.navigationItem.title = @"分类";
        
        [self addChildViewController:self.categoryVC];
        [self.myScrollView addSubview:self.categoryVC.view];
        self.categoryVC.view.frame = CGRectMake(KScreenWidth, 0, KScreenWidth, KScreenHeight - 49 - 64);
        
    }else if (button == myselfButton){
        self.navigationItem.title = @"我的";

        [self addChildViewController:self.myselfVC];
        [self.myScrollView addSubview:self.myselfVC.view];
        self.myselfVC.view.frame = CGRectMake(KScreenWidth * 2, 0, KScreenWidth, KScreenHeight - 49 - 64);
    }
    
}



- (void)createBigScrollView{
    
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 49)];
    _myScrollView.delegate = self;
    _myScrollView.backgroundColor = [UIColor whiteColor];
    _myScrollView.contentSize = CGSizeMake(KScreenWidth * 3, KScreenHeight - 64 - 49);
    //    _myScrollView.contentSize = CGSizeMake(kScreenWidth * 3, 3000);
    _myScrollView.pagingEnabled = YES;
    _myScrollView.bounces = NO;
    _myScrollView.scrollEnabled = NO;
    _myScrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview: _myScrollView];
    
}



-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //    NSLog(@"**********");
    //    NSLog(@"----%ld",scrollView.tag);
    
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
