


//
//  XXEStoreGoodDetailInfoViewController.m
//  teacher
//
//  Created by Mac on 16/11/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStoreGoodDetailInfoViewController.h"
#import "XXEStorePerfectConsigneeAddressViewController.h"
#import "UMSocial.h"

@interface XXEStoreGoodDetailInfoViewController ()<UIScrollViewDelegate>
{

    //头部 轮播图
    UIScrollView *browseScrollView;
    //轮播图 的 pageControl
    UIPageControl *browsePageControl;
    //轮播图 数量
    NSInteger browseCount;
    // 创建一个用来引用计时器对象的属性
    NSTimer *timer;
    //图片数组
    NSMutableArray *picArray;
    
    //咨询 按钮
    UIButton *talkButton;
    //分享 按钮
    UIButton *shareButton;
    //购买 按钮
    UIButton *buyButton;
    
    NSDictionary *goodDetailInfoDic;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@end

@implementation XXEStoreGoodDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    goodDetailInfoDic = [[NSDictionary alloc] init];
    picArray = [[NSMutableArray alloc] init];
    
    CGFloat buttonWidth = KScreenWidth / 3;
    CGFloat buttonHeight = 49;
    
//    browseCount = 3;
    
    
    //获取 商品 具体 信息
    [self fetchGoodDetailInfo];
    

    //创建 底部 按钮
    [self createBottomButtons];

}

#pragma mark =========== 获取 商品 具体 信息 ==========
- (void)fetchGoodDetailInfo{

    NSString *urlStr = @"http://www.xingxingedu.cn/Global/coin_goods_detailed";
    
//    NSLog(@"self.orderNum  %@", self.orderNum);
    NSDictionary *params = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"goods_id":self.orderNum,
                           
                           };
[WZYHttpTool post:urlStr params:params success:^(id responseObj) {
    //
//    NSLog(@"hh %@", responseObj);
    
    NSString *codeStr = responseObj[@"code"];
    if ([codeStr integerValue] == 1) {
        goodDetailInfoDic = responseObj[@"data"];
    }

    [self createContent];
    
} failure:^(NSError *error) {
    //
    [self showHudWithString:@"数据获取失败!" forSecond:1.5];
}];

}

- (void)createContent{
    //创建 上部 滚动视图
    [self createBrowseView];
    
    //创建 下部 文字 按钮 等
    [self createDownContent];
}

#pragma mark ************ 创建 上部 滚动视图 **********
- (void)createBrowseView{
    //初始化 计时器
    timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timer forMode:NSRunLoopCommonModes];
    
    //轮播图
    browseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight / 2)];
    browseScrollView.backgroundColor = [UIColor whiteColor];
    browseScrollView.delegate = self;
    [self.view addSubview:browseScrollView];
    
    // 动态创建UIImageView添加到UIimgScrollView中
    CGFloat imgW = KScreenWidth;
    CGFloat imgH = KScreenHeight * 0.5;
    CGFloat imgY = 0;
    //
    picArray = goodDetailInfoDic[@"pic_arr"];
    
    browseCount = picArray.count;
    for (int i = 0; i < browseCount; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        NSString *imgName = [NSString stringWithFormat:@"%@%@", kXXEPicURL, picArray[i]];
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgName]];
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
    browsePageControl.pageIndicatorTintColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    browsePageControl.currentPage=0;
    [self.view addSubview:browsePageControl];
    
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

#pragma mark ============== 创建 下部 文字 按钮 等 =============
- (void)createDownContent{
    //现价
    UILabel *nowPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, KScreenHeight / 2 + 10 * kScreenRatioHeight, KScreenWidth / 3, 20)];
    nowPriceLabel.text = [NSString stringWithFormat:@"￥ %@", goodDetailInfoDic[@"exchange_price"]];
    nowPriceLabel.textColor = UIColorFromRGB(244, 52, 139);
    nowPriceLabel.font = [UIFont systemWithIphone6P:22 Iphone6:20 Iphone5:18 Iphone4:16];
    nowPriceLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nowPriceLabel];
    
    //原价
    UILabel *oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, KScreenHeight / 2 + 40 * kScreenRatioHeight, KScreenWidth / 3, 20)];
    oldPriceLabel.text = [NSString stringWithFormat:@"原价:￥ %@", goodDetailInfoDic[@"price"]];
    oldPriceLabel.textColor = UIColorFromRGB(244, 52, 139);
    oldPriceLabel.textAlignment = NSTextAlignmentCenter;
    oldPriceLabel.font = [UIFont systemWithIphone6P:14 Iphone6:12 Iphone5:10 Iphone4:8];
    [self.view addSubview:oldPriceLabel];
    
    //原价删除线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(20, oldPriceLabel.height / 2, oldPriceLabel.width - 30, 1)];
    lineView1.backgroundColor = UIColorFromRGB(244, 52, 139);
    [oldPriceLabel addSubview:lineView1];
    
    //title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth / 2 - 10, KScreenHeight / 2 + 10 * kScreenRatioHeight, KScreenWidth / 2, 20)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = goodDetailInfoDic[@"title"];
    titleLabel.font = [UIFont systemWithIphone6P:18 Iphone6:16 Iphone5:14 Iphone4:12];
    [self.view addSubview:titleLabel];
    
    //分割线
    UIView *line4 =[[UIView alloc] initWithFrame:CGRectMake(10, oldPriceLabel.frame.origin.y + oldPriceLabel.height + 10, KScreenWidth - 20, 1)];
    line4.backgroundColor = XXEBackgroundColor;
    [self.view addSubview:line4];
    
    //详情 title
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, line4.frame.origin.y + 1 + 10, 60, 20)];
    detailLabel.text = @"商品详情";
    detailLabel.font = [UIFont systemWithIphone6P:14 Iphone6:12 Iphone5:10 Iphone4:8];
    [self.view addSubview:detailLabel];
    
    
    //详情
    UITextView *detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(detailLabel.frame.origin.x + detailLabel.width, detailLabel.frame.origin.y - 3, KScreenWidth - 80, 70)];
    detailTextView.font = [UIFont systemWithIphone6P:14 Iphone6:12 Iphone5:10 Iphone4:8];
    detailTextView.editable = NO;
    detailTextView.text = goodDetailInfoDic[@"con"];
//    detailTextView.backgroundColor =  [UIColor redColor];
    [self.view addSubview:detailTextView];
    
    //分割线
    UIView *line5 =[[UIView alloc] initWithFrame:CGRectMake(10, detailTextView.frame.origin.y + detailTextView.height + 10, KScreenWidth - 20, 1)];
    line5.backgroundColor = XXEBackgroundColor;
    [self.view addSubview:line5];
    
    //合计猩币 title
    UILabel *totalCoinLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, line5.frame.origin.y + 1 + 10, 70, 20)];
    totalCoinLabel.text = @"合计猩币:";
    totalCoinLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    [self.view addSubview:totalCoinLabel];
    
    //合计猩币 猩币 数
    UILabel *xingIconLabel = [[UILabel alloc] initWithFrame:CGRectMake(totalCoinLabel.frame.origin.x + totalCoinLabel.width, totalCoinLabel.frame.origin.y, 100, 20)];
    xingIconLabel.text = goodDetailInfoDic[@"exchange_coin"];
    xingIconLabel.textColor = UIColorFromRGB(244, 52, 139);;
    xingIconLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    [self.view addSubview:xingIconLabel];
    
    //已售 /
    UILabel *saledLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 190, totalCoinLabel.frame.origin.y, 90, 20)];
    saledLabel.textColor = [UIColor lightGrayColor];
    saledLabel.font = [UIFont systemWithIphone6P:14 Iphone6:12 Iphone5:10 Iphone4:8];
    saledLabel.text = [NSString stringWithFormat:@"已售%@件", goodDetailInfoDic[@"sale_num"]];
    saledLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:saledLabel];
    
    //分割线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(saledLabel.frame.origin.x + saledLabel.width , totalCoinLabel.frame.origin.y, 1, 20)];
    lineView2.backgroundColor = XXEBackgroundColor;
    [self.view addSubview:lineView2];
    
    //还剩
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineView2.frame.origin.x, totalCoinLabel.frame.origin.y, 90, 20)];
    leftLabel.textColor = [UIColor lightGrayColor];
    leftLabel.font = [UIFont systemWithIphone6P:14 Iphone6:12 Iphone5:10 Iphone4:8];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.text = [NSString stringWithFormat:@"还剩%ld件", [goodDetailInfoDic[@"goods_num"] integerValue] - [goodDetailInfoDic[@"sale_num"] integerValue]];
    [self.view addSubview:leftLabel];
    

}


#pragma mark ============ 创建 底部 按钮 ==========
- (void)createBottomButtons{

    UIImageView *bottomView= [[UIImageView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 49 - 64, KScreenWidth, 49)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    bottomView.userInteractionEnabled =YES;
    
    CGFloat buttonWidth = KScreenWidth / 3;
    CGFloat buttonHeight = 49;
    
    //咨询
    talkButton = [UIButton createButtonWithFrame:CGRectMake(0, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) backGruondImageName:nil Target:self Action:@selector(shareButtonClick) Title:@"咨询"];
    talkButton.titleLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    [talkButton setImage:[UIImage imageNamed:@"talk_icon"] forState:UIControlStateNormal];
    [talkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bottomView addSubview:talkButton];
    
    
    //---------------------- 分享 -------------
    shareButton = [UIButton createButtonWithFrame:CGRectMake(buttonWidth, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) backGruondImageName:nil Target:self Action:@selector(shareButtonClick) Title:@"分享"];
    shareButton.titleLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareButton.backgroundColor = UIColorFromRGB(251, 188, 26);
    [bottomView addSubview:shareButton];

    
    //---------------------- 立即购买 ----------
    buyButton = [UIButton createButtonWithFrame:CGRectMake(buttonWidth * 2, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) backGruondImageName:nil Target:self Action:@selector(buyButtonClick) Title:@"立即购买"];
    buyButton.titleLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
//    buyButton.titleLabel.textColor = [UIColor whiteColor];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyButton.backgroundColor = UIColorFromRGB(244, 52, 139);
    [bottomView addSubview:buyButton];
    
}

//分享
- (void)shareButtonClick{

    NSString *shareText = @"来自猩猩教室:";
    UIImage *shareImage = [UIImage imageNamed:@"xingxingjiaoshi_share_icon"];
    //    snsNames 你要分享到的sns平台类型，该NSArray值是`UMSocialSnsPlatformManager.h`定义的平台名的字符串常量，有UMShareToSina，UMShareToTencent，UMShareToRenren，UMShareToDouban，UMShareToQzone，UMShareToEmail，UMShareToSms等
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMSocialAppKey shareText:shareText shareImage:shareImage shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,nil] delegate:self];
}

//购买
- (void)buyButtonClick{

    XXEStorePerfectConsigneeAddressViewController *storePerfectConsigneeAddressVC = [[XXEStorePerfectConsigneeAddressViewController alloc] init];
    
    [self.navigationController pushViewController:storePerfectConsigneeAddressVC animated:YES];

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
