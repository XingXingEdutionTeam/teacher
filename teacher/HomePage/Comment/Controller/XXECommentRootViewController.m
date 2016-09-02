


//
//  XXECommentRootViewController.m
//  teacher
//
//  Created by Mac on 16/8/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECommentRootViewController.h"
#import "XXECommentRequestViewController.h"
#import "XXECommentHistoryViewController.h"
#import "XXERedFlowerSentHistoryViewController.h"

#import "XXESentToPeopleViewController.h"
#import "XXECommentStudentViewController.h"


@interface XXECommentRootViewController ()<UIScrollViewDelegate>
{
    UIButton *commentRequestButton;
    
    UIButton *commentHistoryButton;

    UIButton *commentFlowerButton;
    
    NSString *flagStr;
    
}


@property (nonatomic, strong) XXECommentRequestViewController *commentRequestVC;
@property (nonatomic, strong) XXECommentHistoryViewController *commentHistoryVC;
@property (nonatomic, strong) XXERedFlowerSentHistoryViewController *RedFlowerSentHistoryVC;

@end

@implementation XXECommentRootViewController

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _commentRequestVC = [[XXECommentRequestViewController alloc] init];
    _commentHistoryVC = [[XXECommentHistoryViewController alloc] init];
    _RedFlowerSentHistoryVC = [[XXERedFlowerSentHistoryViewController alloc] init];
    
    self.commentRequestVC.classId = _classId;
    self.commentHistoryVC.classId = _classId;
    self.RedFlowerSentHistoryVC.classId = _classId;
    
    _childViews = [[NSMutableArray alloc] init];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self createBigScrollView];
    
    [self createBottomViewButton];
    
    commentFlowerButton.selected = NO;
    commentHistoryButton.selected = NO;
    commentRequestButton.selected = YES;
    _myScrollView.contentOffset = CGPointMake(0, 0);
    
    self.navigationItem.title = @"点评请求";
    UIButton *sentBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 22, 22) backGruondImageName:@"comment_request_icon" Target:self Action:@selector(request:) Title:@""];
    UIBarButtonItem *requestItem =[[UIBarButtonItem alloc]initWithCustomView:sentBtn];
    self.navigationItem.rightBarButtonItem =requestItem;
    
    [self addChildViewController:self.commentRequestVC];
    [self.myScrollView addSubview:self.commentRequestVC.view];
    self.commentRequestVC.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 49 - 64);

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
    
    //----------------------------请求 点评
    commentRequestButton = [self createButtonFrame:CGRectMake(buttonWidth / 2 * 0, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) unseletedImageName:@"comment_tabbar_request_unseleted_icon" seletedImageName:@"comment_tabbar_request_seleted_icon" title:@"请求点评" unseletedTitleColor:[UIColor lightGrayColor] seletedTitleColor:XXEColorFromRGB(0, 170, 42) font:[UIFont systemFontOfSize:10] target:self action:@selector(commentButtonClick:)];
    commentRequestButton.tag = 10;
//    [commentRequestButton setBackgroundColor:[UIColor redColor]];
    //设置 图片 位置
    commentRequestButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 - 30 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    commentRequestButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -commentRequestButton.titleLabel.bounds.size.width-30, 0, 0);
    [bottomView addSubview:commentRequestButton];
    
    //---------------------------点评 历史
    commentHistoryButton = [self createButtonFrame:CGRectMake(buttonWidth, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) unseletedImageName:@"comment_tabbar_history_unseleted_icon" seletedImageName:@"comment_tabbar_history_seleted_icon" title:@"点评历史" unseletedTitleColor:[UIColor lightGrayColor] seletedTitleColor:XXEColorFromRGB(0, 170, 42) font:[UIFont systemFontOfSize:10] target:self action:@selector(commentButtonClick:)];
    commentHistoryButton.tag = 11;
//    [commentHistoryButton setBackgroundColor:[UIColor yellowColor]];
    //设置 图片 位置
    commentHistoryButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 - 30 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    commentHistoryButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -commentHistoryButton.titleLabel.bounds.size.width-30, 0, 0);
    [bottomView addSubview:commentHistoryButton];
    
    //--------------------------------小红花
   commentFlowerButton  = [self createButtonFrame:CGRectMake(buttonWidth * 2, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) unseletedImageName:@"comment_tabbar_flower_unseleted_icon" seletedImageName:@"comment_tabbar_flower_seleted_icon" title:@"小红花" unseletedTitleColor:[UIColor lightGrayColor] seletedTitleColor:XXEColorFromRGB(0, 170, 42) font:[UIFont systemFontOfSize:10] target:self action:@selector(commentButtonClick:)];
    commentFlowerButton.tag = 12;
//    [commentFlowerButton setBackgroundColor:[UIColor blueColor]];
    //设置 图片 位置
    commentFlowerButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 - 30 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    commentFlowerButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -commentFlowerButton.titleLabel.bounds.size.width-20, 0, 0);
    
    [bottomView addSubview:commentFlowerButton];

    _buttonArray = [[NSMutableArray alloc] initWithObjects:commentRequestButton, commentHistoryButton, commentFlowerButton, nil];
}


- (void)commentButtonClick:(UIButton *)button{
//    NSLog(@"button.tag  ---  %ld", button.tag);
    
    for (UIButton *btn in _buttonArray) {
        btn.selected = NO;
    }
    
    button.selected = YES;
    
    _myScrollView.contentOffset = CGPointMake(KScreenWidth * (button.tag - 10), 0);
    
    if (button == commentRequestButton) {
       self.navigationItem.title = @"点评请求";
        
        UIButton *sentBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 22, 22) backGruondImageName:@"comment_request_icon" Target:self Action:@selector(request:) Title:@""];
        UIBarButtonItem *requestItem =[[UIBarButtonItem alloc]initWithCustomView:sentBtn];
        self.navigationItem.rightBarButtonItem =requestItem;
        
    [self addChildViewController:self.commentRequestVC];
    [self.myScrollView addSubview:self.commentRequestVC.view];
    self.commentRequestVC.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 49 - 64);
        
    }else if (button == commentHistoryButton){
        self.navigationItem.title = @"点评历史";
        self.navigationItem.rightBarButtonItem = nil;
        
        
    [self addChildViewController:self.commentHistoryVC];
    [self.myScrollView addSubview:self.commentHistoryVC.view];
    self.commentHistoryVC.view.frame = CGRectMake(KScreenWidth, 0, KScreenWidth, KScreenHeight - 49 - 64);
        
    }else if (button == commentFlowerButton){
        self.navigationItem.title = @"小红花";
        
        UIButton *sentBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 22, 22) backGruondImageName:@"home_redflower_sent" Target:self Action:@selector(sent:) Title:@""];
        UIBarButtonItem *sentItem =[[UIBarButtonItem alloc]initWithCustomView:sentBtn];
        self.navigationItem.rightBarButtonItem =sentItem;
        
        
    [self addChildViewController:self.RedFlowerSentHistoryVC];
    [self.myScrollView addSubview:self.RedFlowerSentHistoryVC.view];
    self.RedFlowerSentHistoryVC.view.frame = CGRectMake(KScreenWidth * 2, 0, KScreenWidth, KScreenHeight - 49 - 64);
    }
    

}

- (void)request:(UINavigationItem *)item{

//    NSLog(@"点评 请求");
    
    XXECommentStudentViewController *commentStudentVC = [[XXECommentStudentViewController alloc] init];
    
    commentStudentVC.schoolId = _schoolId;
    commentStudentVC.classId = _classId;
    
    [self.navigationController pushViewController:commentStudentVC animated:YES];
}

- (void)sent:(UIButton *)button{
    
//    NSLog(@"小红花");
    
    XXESentToPeopleViewController *sentToPeopleVC = [[XXESentToPeopleViewController alloc] init];
    
    sentToPeopleVC.schoolId = _schoolId;
    sentToPeopleVC.classId = _classId;
//    sentToPeopleVC.basketNumStr = _RedFlowerSentHistoryVC.flower_able;
    
    [self.navigationController pushViewController:sentToPeopleVC animated:YES];
    
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
    NSLog(@"**********");
    NSLog(@"----%ld",scrollView.tag);
    
}



-(UIButton *)createButtonFrame:(CGRect)frame unseletedImageName:(NSString *)unseletedImageName seletedImageName:(NSString *)seletedImageName title:(NSString *)title unseletedTitleColor:(UIColor *)unseletedTitleColor seletedTitleColor:(UIColor *)seletedTitleColor font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    //未选中 时 图片
    if (unseletedImageName)
    {
        [btn setImage:[UIImage imageNamed:unseletedImageName] forState:UIControlStateNormal];
    }
    //选中 时 图片
    if (seletedImageName)
    {
        UIImage *commentSeletedImage = [UIImage imageNamed:seletedImageName];
        commentSeletedImage = [commentSeletedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [btn setImage:commentSeletedImage forState:UIControlStateSelected];
    }
    if (font)
    {
        btn.titleLabel.font=font;
    }
    
    if (title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    //未选中 时 标题 颜色
    if (unseletedTitleColor)
    {
        [btn setTitleColor:unseletedTitleColor forState:UIControlStateNormal];
    }
    //选中 时 标题 颜色
    if (seletedTitleColor)
    {
        [btn setTitleColor:seletedTitleColor forState:UIControlStateSelected];
    }
    if (target&&action)
    {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}


@end
