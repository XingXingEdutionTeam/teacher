

//
//  XXEStoreBuyFlowerbasketViewController.m
//  teacher
//
//  Created by Mac on 2016/11/15.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStoreBuyFlowerbasketViewController.h"
#import "XXEStoreSentFlowerbasketToOtherViewController.h"
#import "UMSocial.h"

@interface XXEStoreBuyFlowerbasketViewController ()
{
    //上部 花篮 图片
    UIImageView *upPicImageView;
    
    //中间 价格 描述
    UIView *priceBgView;
    
    //购买数量
    UIView *buyNumBgView;
    UILabel *numLabel;
    
    //底部 按钮
    UIButton *talkButton;
    UIButton *shareButton;
    UIButton *buyButton;
    
    NSDictionary *goodDetailInfoDic;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;

}


@end

@implementation XXEStoreBuyFlowerbasketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XXEBackgroundColor;
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    goodDetailInfoDic = [[NSDictionary alloc] init];
    
    UIButton *sentBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 22, 22) backGruondImageName:@"home_redflower_sent" Target:self Action:@selector(sent:) Title:@""];
    UIBarButtonItem *sentItem =[[UIBarButtonItem alloc]initWithCustomView:sentBtn];
    self.navigationItem.rightBarButtonItem =sentItem;
    
    
    //获取 花篮 信息
    [self fetchGoodDetailInfo];
    
    //创建底部按钮
    [self createBottomButtons];
}

- (void)sent:(UIButton *)button{

    XXEStoreSentFlowerbasketToOtherViewController *sentFlowerbasketToOtherVC = [[XXEStoreSentFlowerbasketToOtherViewController alloc] init];
    
    [self.navigationController pushViewController:sentFlowerbasketToOtherVC animated:YES];
}


#pragma mark =========== 获取 花篮 具体 信息 ==========
- (void)fetchGoodDetailInfo{
    /*
     【猩猩商城--花篮详情】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Global/flowers_basket_info
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/flowers_basket_info";
    
    //    NSLog(@"self.orderNum  %@", self.orderNum);
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE
                             };
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
            NSLog(@"hualan  %@", responseObj);
        
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
    //创建 上部 视图
    [self createUpPicImageView];
    
    //创建 下部 文字 按钮 等
    [self createDownContent];
}

#pragma mark ************ 创建 上部 视图 **********
- (void)createUpPicImageView{
    upPicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight / 2)];
    upPicImageView.backgroundColor = [UIColor whiteColor];
    
    
    [upPicImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, goodDetailInfoDic[@"pic"]]]];
    [self.view addSubview:upPicImageView];
    
}

#pragma mark ========= 创建 下部 文字 按钮 等 ========
- (void)createDownContent{
    //价格 描述
    priceBgView = [[UIView alloc] initWithFrame:CGRectMake(0, upPicImageView.frame.origin.y + upPicImageView.height + 10, KScreenWidth, KScreenHeight / 6)];
    priceBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:priceBgView];
    
    //title
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100 * kScreenRatioWidth, 20)];
    titleLabel1.text = goodDetailInfoDic[@"title"];
    titleLabel1.font = [UIFont systemWithIphone6P:20 Iphone6:18 Iphone5:16 Iphone4:14];
    [priceBgView addSubview:titleLabel1];
    
    //价格
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLabel1.frame.origin.y + titleLabel1.height + 10, 100 * kScreenRatioWidth, 20)];
    priceLabel.text = [NSString stringWithFormat:@"￥%@元", goodDetailInfoDic[@"exchange_price"]];
    priceLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    priceLabel.textColor = UIColorFromRGB(244, 52, 139);
    [priceBgView addSubview:priceLabel];
    
    //已售
    UILabel *saledLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, priceLabel.frame.origin.y + priceLabel.height + 10, 100 * kScreenRatioWidth, 20)];
    //sale_num
    saledLabel.text = [NSString stringWithFormat:@"已售%@件", goodDetailInfoDic[@"sale_num"]];
    saledLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    [priceBgView addSubview:saledLabel];
    
    //描述
    UITextView *descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(120 * kScreenRatioWidth, 0, KScreenWidth - 130 * kScreenRatioWidth, priceBgView.height)];
    descriptionTextView.backgroundColor = [UIColor whiteColor];
    descriptionTextView.text = goodDetailInfoDic[@"con"];
    descriptionTextView.editable = NO;
    [priceBgView addSubview:descriptionTextView];
    
    
    //购买数量
    buyNumBgView = [[UIView alloc] initWithFrame:CGRectMake(0, priceBgView.frame.origin.y + priceBgView.height + 10, KScreenWidth, KScreenHeight / 8)];
    buyNumBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buyNumBgView];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 150 * kScreenRatioWidth, 20)];
    titleLabel.text = @"购买数量";
    titleLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    [buyNumBgView addSubview:titleLabel];
    
    //减号
    UIButton *reduceButton = [UIButton createButtonWithFrame:CGRectMake(KScreenWidth / 3 * 2 - 20, 15, 40, 40) backGruondImageName:nil Target:self Action:@selector(reduceButtonClick) Title:@"一"];
    [reduceButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    reduceButton.titleLabel.font = [UIFont systemWithIphone6P:20 Iphone6:18 Iphone5:16 Iphone4:14];
    reduceButton.backgroundColor = XXEBackgroundColor;
    [buyNumBgView addSubview:reduceButton];
    
    //数量
    numLabel = [[UILabel alloc] initWithFrame:CGRectMake(reduceButton.frame.origin.x + reduceButton.width + 2, 15, 50 * kScreenRatioWidth, 40)];
    numLabel.text = @"1";
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.backgroundColor = XXEBackgroundColor;
    [buyNumBgView addSubview:numLabel];
    
    //加号
    UIButton *addButton = [UIButton createButtonWithFrame:CGRectMake(numLabel.frame.origin.x + numLabel.width + 2, 15, 40, 40) backGruondImageName:nil Target:self Action:@selector(addButtonClick) Title:@"十"];
    [addButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemWithIphone6P:20 Iphone6:18 Iphone5:16 Iphone4:14];
    addButton.backgroundColor = XXEBackgroundColor;
    [buyNumBgView addSubview:addButton];
}

- (void)reduceButtonClick{

    NSInteger num = [numLabel.text integerValue];
    if (num > 1) {
        num--;
        numLabel.text = [NSString stringWithFormat:@"%ld", num];
    }

}

- (void)addButtonClick{
    NSInteger num = [numLabel.text integerValue];
    num ++;
    numLabel.text = [NSString stringWithFormat:@"%ld", num];
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
    talkButton = [UIButton createButtonWithFrame:CGRectMake(0, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) backGruondImageName:nil Target:self Action:@selector(talkButtonClick) Title:@"咨询"];
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

//咨询
- (void)talkButtonClick{


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
    
    
    NSLog(@"7777");
    
//    XXEStorePerfectConsigneeAddressViewController *storePerfectConsigneeAddressVC = [[XXEStorePerfectConsigneeAddressViewController alloc] init];
//    
//    [self.navigationController pushViewController:storePerfectConsigneeAddressVC animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
