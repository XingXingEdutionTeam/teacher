//
//  XXEAlbumShowViewController.m
//  teacher
//
//  Created by codeDing on 16/8/25.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEAlbumShowViewController.h"
#import "XXEAlbumDetailsModel.h"
#import "SDCycleScrollView.h"
#import "XXEVerticalButton.h"
#import "KTActionSheet.h"
#import "ReportPicViewController.h"

@interface XXEAlbumShowViewController ()<SDCycleScrollViewDelegate,KTActionSheetDelegate>

@property (nonatomic, strong)NSMutableArray *albumNameDatasource;

@end

@implementation XXEAlbumShowViewController

- (NSMutableArray *)showDatasource
{
    if (!_showDatasource) {
        _showDatasource = [NSMutableArray array];
    }
    return _showDatasource;
}

- (NSMutableArray *)albumNameDatasource
{
    if (!_albumNameDatasource) {
        _albumNameDatasource = [NSMutableArray array];
    }
    return _albumNameDatasource;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = NO;
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (XXEAlbumDetailsModel *model in self.showDatasource) {
        NSLog(@"%@",model.pic);
        NSString *albumUrl = [NSString stringWithFormat:@"%@%@",kXXEPicURL,model.pic];
        [self.albumNameDatasource addObject:albumUrl];
    }
    [self creatSDCycleScrollView];
    //创建点击按钮
    [self creatButtonView];
}

- (void)creatSDCycleScrollView
{
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 100, KScreenWidth, 300) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView.showPageControl = NO;
    cycleScrollView.autoScroll = NO;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    cycleScrollView.imageURLStringsGroup = self.albumNameDatasource;
    [self.view addSubview:cycleScrollView];
}

- (void)creatButtonView
{
    __weak typeof(self)weakSelf = self;
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = XXEColorFromRGB(255, 255, 255);
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, 44*kScreenRatioHeight));
    }];
    
    XXEVerticalButton *downButton = [self creatButtonTitle:@"下载" UIImage:@"album_down_icon_click" Select:@"album_down_icon" target:self action:@selector(downloadButton:)];
        [view addSubview:downButton];
    
    [downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(40);
        make.top.equalTo(view.mas_top).offset(2);
        make.size.mas_equalTo(CGSizeMake(24, 44*kScreenRatioHeight));
    }];
    
    XXEVerticalButton *shareButton = [self creatButtonTitle:@"分享" UIImage:@"album_share_icon_click" Select:@"album_share_icon" target:self action:@selector(shareButtonClick:)];
    [view addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.centerX.equalTo(view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(24, 44));
    }];
    
    XXEVerticalButton *goodButton = [self creatButtonTitle:@"点赞" UIImage:@"album_good_icon_click" Select:@"album_good_icon" target:self action:@selector(goodButtonClick:)];
    [view addSubview:goodButton];
    [goodButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-40);
        make.top.equalTo(view.mas_top).offset(2);
        make.size.mas_equalTo(CGSizeMake(24, 44*kScreenRatioHeight));
    }];
    
    
    
}

/** 图片滚动回调 */
#pragma mark -SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    NSLog(@"%ld",(long)index);
    
    
}

//点击回调图片
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    KTActionSheet *actionSheet = [[KTActionSheet alloc]initWithTitle:@"" itemTitles:@[@"收藏"]];
    actionSheet.tag = 1000;
    actionSheet.delegate = self;
}


#pragma mark- UIButtonClick 
- (void)downloadButton:(XXEVerticalButton *)sender
{
    NSLog(@"下载照片");
}

- (void)shareButtonClick:(XXEVerticalButton *)sender
{
    NSLog(@"分享");
    KTActionSheet *actionSheet1 = [[KTActionSheet alloc]initWithTitle:@"" itemTitles:@[@"分享",@"举报"]];
    actionSheet1.tag = 1001;
    actionSheet1.delegate = self;
}

- (void)goodButtonClick:(XXEVerticalButton *)sender
{
    NSLog(@"点赞");
}


#pragma mark - actionViewDelegate
- (void)sheetViewDidSelectIndex:(NSInteger)index title:(NSString *)title sender:(id)sender
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }
    KTActionSheet *action;
    action = sender;
        if (action.tag == 1000) {
            if (index == 0) {
                NSLog(@"收藏");
            }
        }else if (action.tag == 1001) {
            if (index  == 0) {
                NSLog(@"分享");
            }else {
                NSLog(@"举报");
                ReportPicViewController *reportVC = [[ReportPicViewController alloc]init];
                [self.navigationController pushViewController:reportVC animated:YES];
            }
        }
}



#pragma mark - 按钮的设置
- (XXEVerticalButton *)creatButtonTitle:(NSString *)title UIImage:(NSString *)uiimage Select:(NSString *)select target:(id)target action:(SEL)action
{
    XXEVerticalButton *button = [[XXEVerticalButton alloc]init];
    button.tag = 1000;
    button.selected = NO;
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:uiimage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:select] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
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
