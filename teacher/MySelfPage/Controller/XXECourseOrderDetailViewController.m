

//
//  XXECourseOrderDetailViewController.m
//  teacher
//
//  Created by Mac on 2016/11/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECourseOrderDetailViewController.h"

@interface XXECourseOrderDetailViewController ()
{
    //上部分 bgView
    UIView *upBgView;
    //下部分 bgView
    UIView *downBgView;
    
    //头像 数组
    NSMutableArray *iconArray;
    //标题 数组
    NSMutableArray *titleArray;
    
    //订单详情结果 字典
    NSDictionary *detailInfoDict;
    
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXECourseOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = XXEBackgroundColor;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

    iconArray = [[NSMutableArray alloc] initWithObjects:@"dingdan", @"time", @"zhuangtai", nil];
    titleArray = [[NSMutableArray alloc] initWithObjects:@"订单号:", @"下单时间:", @"订单状态:", nil];
    detailInfoDict = [[NSDictionary alloc] init];
    
    //获取 数据
    [self fetchCourseOrderDetailInfo];
    
}

- (void)fetchCourseOrderDetailInfo{
/*
 【猩课堂--课程订单详情】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Global/course_order_detail
 传参:
	order_id		//订单id
 */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/course_order_detail";
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"order_id":_order_id                            };
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
        
//        NSLog(@"uuu%@", responseObj);
        
        if ([responseObj[@"code"] integerValue] == 1) {
            detailInfoDict = responseObj[@"data"];
        }
        
         [self createContent];
        
    } failure:^(NSError *error) {
        //
        [self showString:@"获取数据失败!" forSecond:1.5];
    }];
    
}

- (void)createContent{
    //创建 上部分 内容
    [self createUpContent];
    
    //创建 下部分 内容
    [self createDownContent];
}

#pragma mark ======= 创建 上部分 内容 ======
- (void)createUpContent{

    upBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 260)];
    upBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:upBgView];
    
    NSString *state = @"";
    if ([_stateFlagStr integerValue] == 0) {
        state = @"已支付";
    }else if ([_stateFlagStr integerValue] == 1) {
        state = @"待支付";
    }else if ([_stateFlagStr integerValue] == 2) {
        state = @"已评价";
    }else if ([_stateFlagStr integerValue] == 3) {
        state = @"待评价";
    }

    
    NSMutableArray *textArray = [[NSMutableArray alloc] initWithObjects:detailInfoDict[@"order_index"], [XXETool dateStringFromNumberTimer:detailInfoDict[@"date_tm"]], state, nil];
    
    for (int i = 0; i < 3; i++) {
        //icon
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10 + 40 * i, 18, 20)];
        iconImageView.image = [UIImage imageNamed:iconArray[i]];
        [upBgView addSubview:iconImageView];
        
        //title
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10 + 40 * i, 70, 20)];
        titleLabel.text = titleArray[i];
        if (i == 0) {
            titleLabel.font = [UIFont systemFontOfSize:16 * kScreenRatioWidth];
        }else{
        titleLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
        }
        [upBgView addSubview:titleLabel];
        
        //text
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 10 + 40 * i, KScreenWidth - 130, 20)];
        textLabel.text = textArray[i];

        textLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];

        if (i == 2) {
            if ([_stateFlagStr integerValue] == 0 || [_stateFlagStr integerValue] == 2){
                textLabel.textColor = [UIColor lightGrayColor];
            }else if ([_stateFlagStr integerValue] == 1 || [_stateFlagStr integerValue] == 3){
                textLabel.textColor = [UIColor redColor];
            }
        }
        
        [upBgView addSubview:textLabel];
        
    }
    
    //分割线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 135, KScreenWidth - 20, 1)];
    lineView1.backgroundColor = XXEBackgroundColor;
    [upBgView addSubview:lineView1];
    
    //课程图片
    UIImageView *coursePic = [[UIImageView alloc] initWithFrame:CGRectMake(10, lineView1.frame.origin.y + 10, 70, 70)];
    //course_pic
    [coursePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, detailInfoDict[@"course_pic"]]] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    [upBgView addSubview:coursePic];
    
    //课程名称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, coursePic.frame.origin.y, KScreenWidth - 100, 20)];
    nameLabel.text = detailInfoDict[@"course_name"];
    nameLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    [upBgView addSubview:nameLabel];
    
    //课程价格
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, nameLabel.frame.origin.y + nameLabel.height + 10, KScreenWidth - 100, 20)];
    priceLabel.text = [NSString stringWithFormat:@"¥:%@",detailInfoDict[@"original_price"]];
    priceLabel.textColor = [UIColor redColor];
    priceLabel.font = [UIFont systemFontOfSize:12 * kScreenRatioWidth];
    [upBgView addSubview:priceLabel];
    
    //分割线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(10, coursePic.frame.origin.y + coursePic.height + 10, KScreenWidth - 20, 1)];
    lineView2.backgroundColor = XXEBackgroundColor;
    [upBgView addSubview:lineView2];

   //购买数量
    NSString *numStr = [NSString stringWithFormat:@"购买数量:%@", detailInfoDict[@"buy_num"]];
    //实付金额
    NSString *priceStr = [NSString stringWithFormat:@"实付:%@元", detailInfoDict[@"pay_price"]];
    //猩币抵扣
    NSString *deductionStr = [NSString stringWithFormat:@"猩币抵扣:%@元", detailInfoDict[@"deduct_price"]];

    NSMutableArray *priceArray = [[NSMutableArray alloc] initWithObjects:numStr, priceStr, deductionStr, nil];
    CGFloat labelW = KScreenWidth / 3;
    CGFloat labelH = 20;

    for (int j = 0; j < 3; j++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(j * labelW, lineView2.frame.origin.y + 10, labelW, labelH)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = priceArray[j];
        label.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
        [upBgView addSubview: label];
    }
}

#pragma mark ========= 创建 下部分 内容 =======
- (void)createDownContent{
    downBgView = [[UIView alloc] initWithFrame:CGRectMake(0, upBgView.frame.origin.y + upBgView.height + 5, KScreenWidth, 120)];
    downBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:downBgView];
    
    //title
    NSMutableArray *textArray = [[NSMutableArray alloc] initWithObjects:@"购买人:", @"上课学生:", @"联系方式:", nil];
    //content
    //购买人
    NSString *buyer = [NSString stringWithFormat:@"%@", detailInfoDict[@"bought_tname"]];
    //上课学生
    NSString *student = [NSString stringWithFormat:@"%@", detailInfoDict[@"baby_name"]];
    //电话
    NSString *phone = [NSString stringWithFormat:@"%@", detailInfoDict[@"phone"]];
    
    
    NSMutableArray *contentArray = [[NSMutableArray alloc] initWithObjects:buyer, student , phone, nil];
    for (int k = 0; k < 3; k ++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5 + 40 * k, 70, 20)];
        titleLabel.text = textArray[k];
        titleLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
        [downBgView addSubview:titleLabel];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 5 + 40 * k, KScreenWidth - 100, 20)];
        contentLabel.text = contentArray[k];
        contentLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
        [downBgView addSubview:contentLabel];
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
