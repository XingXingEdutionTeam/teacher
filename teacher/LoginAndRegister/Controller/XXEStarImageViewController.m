//
//  XXEStarImageViewController.m
//  teacher
//
//  Created by codeDing on 16/8/5.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStarImageViewController.h"
#import "XXELoginViewController.h"

@interface XXEStarImageViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGR;
@property (nonatomic, strong) UIButton *starButton;
@end

@implementation XXEStarImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    NSLog(@"----启动图片----");
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = self.view.frame;
    scrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    //添加图片到ScrollView
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    NSInteger imageIndex = 7;
    if (scrollH < 500) {
        imageIndex = 4;
    }
    if (scrollH > 500 && scrollH < 600) {
        imageIndex = 5;
    }
    if (scrollH > 600 && scrollH < 700) {
        imageIndex = 6;
    }
    for (int i = 0; i < 4; i ++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = i * scrollW;
        //显示图片
        NSString *name = [NSString stringWithFormat:@"qqq_%i_%ld",i+1,(long)imageIndex];
        NSLog(@"%@",name);
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        //如果是最后一个ImageView,就往里面加入左划手势
        if (i == 4-1) {
            [self setupLastImageView:imageView];
        }
    }
    scrollView.contentSize = CGSizeMake(4 * scrollW, 0);
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
}

- (void)setupLastImageView:(UIImageView *)imageView
{
    //开启交互
    imageView.userInteractionEnabled = YES;
    UIButton *startButton = [[UIButton alloc]initWithFrame:imageView.bounds];
    [startButton addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startButton];
    
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)startClick:(UIButton *)sender
{
    NSLog(@"-----进入主页------");
    XXELoginViewController *loginVC = [[XXELoginViewController alloc]init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = loginVC;
    [self.view removeFromSuperview];
    
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
