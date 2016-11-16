
//
//  XXEStoreStoreViewController.m
//  teacher
//
//  Created by Mac on 16/11/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStoreStoreViewController.h"
#import "XXEStoreGoodDetailInfoViewController.h"
#import "XXEStoreListTableViewCell.h"
#import "ZQCountDownView.h"
#import "XXEStoreStoreApi.h"
#import "XXEStoreListModel.h"
//签到送猩币
#import "XXEXingCoinViewController.h"
//猩币转赠
#import "XXEStoreSentIconToOtherViewController.h"
//花篮专区
#import "XXEStoreBuyFlowerbasketViewController.h"
//购买
#import "XXEStorePerfectConsigneeAddressViewController.h"

#define Kmarg 6.0f
#define KLabelX 27.0f
#define KLabelW 62.0f
#define KLabelH 30.0f
#define KButtonW 40.0f
#define KButtonH 20.0f

@interface XXEStoreStoreViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    //整体 可 上下 滑动的 视图
    UIScrollView *bgScrollView;
    //头部 轮播图
    UIScrollView *browseScrollView;
    //轮播图 的 pageControl
    UIPageControl *browsePageControl;
    //轮播图 数量
    NSInteger browseCount;
    //限时抢购 按钮
    UIButton *timeLimitButton;
    //倒计时 视图
    ZQCountDownView *countdownView;
    // 创建一个用来引用计时器对象的属性
    NSTimer *timer;
    
    //本周推荐
    UIImageView *weekrecommend;
    
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    NSString *parameterXid;
    NSString *parameterUser_Id;
    //
    
    //灰色 分割条
    UIView *grayView1;

}



@end

@implementation XXEStoreStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商城";
    browseCount = 3;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    _dataSourceArray = [[NSMutableArray alloc] init];
    
    //获取 商城 数据
    [self fetchStoreNetData];
    
    //创建 最下层 bgScrollView
    [self createBgScrollView];
    
    //创建 上部 滚动视图
    [self createBrowseView];
    
    //创建 中部 倒计时
    [self createCountDownView];
    
    
    //创建 下部 tableView
    [self createTableView];
}

#pragma mark ============ 获取 商城 数据 ============
- (void)fetchStoreNetData{

    XXEStoreStoreApi *storeApi = [[XXEStoreStoreApi alloc] initWithXid:parameterXid user_id:parameterUser_Id classID:@"" search_words:@""];
    [storeApi  startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
//        NSLog(@"%@", request.responseJSONObject);
        
        NSString *codeStr = request.responseJSONObject[@"code"];
        if ([codeStr  integerValue] == 1) {
            NSArray *modelArray = [XXEStoreListModel parseResondsData:request.responseJSONObject[@"data"]];
            
            [_dataSourceArray addObjectsFromArray:modelArray];
        }
        
        [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"数据请求失败!" forSecond:1.5];
    }];

}

// 有数据 和 无数据 进行判断
- (void)customContent{
    
    if (_dataSourceArray.count == 0) {
        
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 1、无数据的时候
        UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth / 2 - myImageWidth / 2, (KScreenHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];
        
    }else{
        //2、有数据的时候
        [_myTableView reloadData];
        
    }
    [_myTableView reloadData];
}


#pragma mark ########### 创建 最下层 bgScrollView ###
- (void)createBgScrollView{
    bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    
    bgScrollView.pagingEnabled = NO;
    bgScrollView.bounces = NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    bgScrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:bgScrollView];

}


#pragma mark ************ 创建 上部 滚动视图 **********
- (void)createBrowseView{
    //初始化 计时器
    timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timer forMode:NSRunLoopCommonModes];
    
    //轮播图
    browseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
    browseScrollView.backgroundColor = [UIColor whiteColor];
    browseScrollView.delegate = self;
    [bgScrollView addSubview:browseScrollView];
    
    // 动态创建UIImageView添加到UIimgScrollView中
    CGFloat imgW = kWidth;
    CGFloat imgH = 150;
    CGFloat imgY = 0;
    for (int i = 0; i < browseCount; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        NSString *imgName = [NSString stringWithFormat:@"banner0%d.png", i + 1];
        imgView.image = [UIImage imageNamed:imgName];
        CGFloat imgX = i * imgW;
        imgView.frame = CGRectMake(imgX, imgY, imgW, imgH);
        [browseScrollView addSubview:imgView];
    }
    
    CGFloat maxW = browseScrollView.frame.size.width * browseCount;
    browseScrollView.contentSize = CGSizeMake(maxW, 0);
    
    browseScrollView.pagingEnabled = YES;
    browseScrollView.showsHorizontalScrollIndicator = NO;
    browsePageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((kWidth-80)/2, CGRectGetMaxY(browseScrollView.frame) - 60, 80, 80)];
    browsePageControl.numberOfPages = browseCount;
    browsePageControl.currentPageIndicatorTintColor= [UIColor whiteColor];
    //
    browsePageControl.pageIndicatorTintColor= [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    browsePageControl.currentPage=0;
    [bgScrollView addSubview:browsePageControl];
    
    grayView1 =[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(browseScrollView.frame), kWidth, 7)];
    grayView1.backgroundColor=UIColorFromRGB(229, 232, 233);
    [bgScrollView addSubview:grayView1];

}

- (void)scrollImage{

    NSInteger page = browsePageControl.currentPage;
    if (page == browsePageControl.numberOfPages - 1) {
        page = 0;
    } else {
        page++;
    }
    CGFloat offsetX = page * browseScrollView.frame.size.width;
    [browseScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];

}

#pragma mark --scrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    offsetX = offsetX + (scrollView.frame.size.width * 0.5);
    int page = offsetX / scrollView.frame.size.width;
    browsePageControl.currentPage = page;
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [timer invalidate];
    timer = nil;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timer forMode:NSRunLoopCommonModes];
}




#pragma mark &&&&&&&&&&&&&& 创建 中部 倒计时 &&&&&&&&&&
- (void)createCountDownView{
    //时钟
    UIImageView *clockIcon = [[UIImageView alloc] initWithFrame:CGRectMake(Kmarg, CGRectGetMaxY(grayView1.frame) + Kmarg, 24, 24)];
    clockIcon.image = [UIImage imageNamed:@"home_redflower_timeIcon"];
    [bgScrollView addSubview:clockIcon];
    
    UILabel *countDown = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMaxX(clockIcon.frame) + Kmarg, CGRectGetMaxY(grayView1.frame) + Kmarg + 2, 50, KButtonH) Font:10 Text:@"抢购倒计时 "];
    [bgScrollView addSubview:countDown];
    
    //倒计时
    countdownView = [[ZQCountDownView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(countDown.frame), CGRectGetMaxY(grayView1.frame) + Kmarg + 2, 80, KButtonH)];
    [bgScrollView addSubview:countdownView];
    //计算出下次能签到的日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *now=[NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: now];
    NSDate *nowDate = [now dateByAddingTimeInterval: interval];
    
    NSDate *tomorrow = [NSDate dateWithTimeInterval:60 * 60*24  sinceDate:nowDate];
    NSString *tomorrowStr=[formatter stringFromDate:tomorrow];
    NSString *tomorrowten=[tomorrowStr stringByAppendingString:@" 10:00:00"];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *tomorrowtendate=[formatter2 dateFromString:tomorrowten];
    NSDate *todaytendate= [NSDate dateWithTimeInterval:-24*60*60 sinceDate:tomorrowtendate];
    NSDate *todayten= [NSDate dateWithTimeInterval:8*60*60 sinceDate:todaytendate];
    NSDate *nowten= [NSDate dateWithTimeInterval:8*60*60 sinceDate:now];
    NSDate *tomorrowten2= [NSDate dateWithTimeInterval:8*60*60 sinceDate:tomorrowtendate];
    
    
    NSTimeInterval spaceTime;
    if([nowten timeIntervalSinceDate:todayten]<0){
        spaceTime =[todayten timeIntervalSinceDate:nowten];
        
    }else{
        spaceTime=[tomorrowten2 timeIntervalSinceDate:nowten];
    }
    
    countdownView.themeColor = [UIColor whiteColor];
    countdownView.textColor = [UIColor darkGrayColor];
    countdownView.textFont = [UIFont boldSystemFontOfSize:10];
    countdownView.colonColor = [UIColor whiteColor];
    countdownView.countDownTimeInterval = spaceTime;
    
    //签到送猩币
    UIButton *checkinBtn = [UIButton createButtonWithFrame:CGRectMake(CGRectGetMaxX(countdownView.frame)+ Kmarg, CGRectGetMaxY(grayView1.frame) + Kmarg,(kWidth - CGRectGetMaxX(countdownView.frame))/3 - 10, KButtonH) backGruondImageName:nil Target:nil Action:@selector(checkInBtn) Title:@"签到送猩币"];
    checkinBtn.titleLabel.font = [UIFont systemWithIphone6P:12 Iphone6:10 Iphone5:8 Iphone4:6];
    [checkinBtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
    checkinBtn.layer.borderColor = UIColorFromRGB(0, 170, 42).CGColor;
    [checkinBtn.layer setBorderWidth:1];
    [checkinBtn.layer setMasksToBounds:YES];
    [bgScrollView addSubview:checkinBtn];
    
    //猩币转增
    UIButton *xingbizzBtn = [UIButton createButtonWithFrame:CGRectMake(CGRectGetMaxX(checkinBtn.frame) + Kmarg, CGRectGetMaxY(grayView1.frame) + Kmarg , (kWidth - CGRectGetMaxX(countdownView.frame))/3 - 10, KButtonH)backGruondImageName:nil Target:nil Action:@selector(moneyPresentBtn) Title:@"猩币转赠"];
     xingbizzBtn.titleLabel.font = [UIFont systemWithIphone6P:12 Iphone6:10 Iphone5:8 Iphone4:6];
    [xingbizzBtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
    xingbizzBtn.layer.borderColor = UIColorFromRGB(0, 170, 42).CGColor;
    [xingbizzBtn.layer setBorderWidth:1];
    [xingbizzBtn.layer setMasksToBounds:YES];
    [bgScrollView addSubview:xingbizzBtn];
    
    //花篮专区
    UIButton *flowerbtn = [UIButton createButtonWithFrame:CGRectMake(CGRectGetMaxX(xingbizzBtn.frame) + Kmarg, CGRectGetMaxY(grayView1.frame) + Kmarg, (kWidth - CGRectGetMaxX(countdownView.frame))/3 - 10, KButtonH) backGruondImageName:nil Target:nil Action:@selector(FlowersPrefecture) Title:@"花篮专区"];
    flowerbtn.titleLabel.font = [UIFont systemWithIphone6P:12 Iphone6:10 Iphone5:8 Iphone4:6];
    [flowerbtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
    flowerbtn.layer.borderColor = UIColorFromRGB(0, 170, 42).CGColor;
    [flowerbtn.layer setBorderWidth:1];
    [flowerbtn.layer setMasksToBounds:YES];
    [bgScrollView addSubview:flowerbtn];
    
    UIView *grayView2=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(xingbizzBtn.frame) + Kmarg, kWidth, 7)];
    grayView2.backgroundColor=UIColorFromRGB(229, 232, 233);
    [bgScrollView addSubview:grayView2];
    
    //本周推荐
    weekrecommend = [[UIImageView alloc] initWithFrame:CGRectMake(KLabelX, CGRectGetMaxY(grayView2.frame) + Kmarg *3, kWidth - KLabelX * 2, 14)];
    weekrecommend.image = [UIImage imageNamed:@"recommend_icon"];
    [bgScrollView addSubview:weekrecommend];

}

//立刻 签到
- (void)checkInBtn{
    //签到送猩币
    XXEXingCoinViewController *xingCoinVC = [[XXEXingCoinViewController alloc] init];
    
    [self.navigationController pushViewController:xingCoinVC animated:YES];
    
}


//猩币 转赠
- (void)moneyPresentBtn{
    XXEStoreSentIconToOtherViewController *storeSentIconToOtherVC = [[XXEStoreSentIconToOtherViewController alloc] init];
    
    [self.navigationController pushViewController:storeSentIconToOtherVC animated:YES];
}

//花篮 专区
- (void)FlowersPrefecture{
    XXEStoreBuyFlowerbasketViewController *storeBuyFlowerbasketVC = [[XXEStoreBuyFlowerbasketViewController alloc] init];
    
    [self.navigationController pushViewController:storeBuyFlowerbasketVC animated:YES];
}

#pragma mark $$$$$$$$$$$$ 创建 下部 tableView $$$$$$$$
- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 230 * kScreenRatioHeight, KScreenWidth, 360 * kScreenRatioHeight)];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [bgScrollView addSubview:_myTableView];

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSourceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"cell";
    XXEStoreListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEStoreListTableViewCell" owner:self options:nil]lastObject];
    }
    XXEStoreListModel *model = _dataSourceArray[indexPath.row];

//    NSLog(@"model%@", model);
    
    NSString *head_img = [kXXEPicURL stringByAppendingString:model.goods_pic];
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@" "]];
    
    //    NSLog(@"课程  %@", model.teach_course);
    cell.nameLabel.text = model.title;
    cell.nowPriceLabel.text = [NSString stringWithFormat:@"￥ %@", model.exchange_price];
    cell.oldPriceLabel.text = model.price;
    cell.xingbiLabel.text = [NSString stringWithFormat:@"猩币:%@", model.exchange_coin];
    cell.saleLabel.text = [NSString stringWithFormat:@"销量:%@", model.sale_num];
    [cell.buyButton addTarget:self action:@selector(buyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.buyButton.tag=indexPath.row+1000;
    
    return cell;
}

- (void)buyButtonClick:(UIButton *)button{
    
    XXEStoreListModel *model = _dataSourceArray[button.tag - 1000];
    
    XXEStorePerfectConsigneeAddressViewController *perfectConsigneeAddressVC = [[XXEStorePerfectConsigneeAddressViewController alloc] init];
    
    perfectConsigneeAddressVC.xingIconNum = model.exchange_coin;
    perfectConsigneeAddressVC.price = model.exchange_price;
    perfectConsigneeAddressVC.good_id = model.good_id;
    
    [self.navigationController pushViewController:perfectConsigneeAddressVC animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XXEStoreGoodDetailInfoViewController*storeGoodDetailInfoVC=  [[XXEStoreGoodDetailInfoViewController alloc]init];
    XXEStoreListModel *model = _dataSourceArray[indexPath.row];
    storeGoodDetailInfoVC.orderNum=model.good_id;
    [self.navigationController pushViewController:storeGoodDetailInfoVC animated:YES];
    
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
