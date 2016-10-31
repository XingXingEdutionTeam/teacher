
//
//  XXEDataManagerViewController.m
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEDataManagerViewController.h"
#import "XXEHomeLogoRootViewController.h"
#import "XXEDataManagerDataModel.h"
#import "XXEDataManagerApi.h"
#import "LewBarChart.h"
#import "KxMenu.h"


@interface XXEDataManagerViewController ()<UIScrollViewDelegate>
{
    UIView *upBgView;
    UIView *middleBgView;
    UIView *downBgView;
    
    //上面 部分 头像
    UIImageView *iconImageView;
    //上面 部分 今天 信息
    UILabel *numTodayLabel;
    UILabel *titleTodayLabel;
    //
    UIButton *selectBtn;
    
    
    //中间
    //本月 信息
    UILabel *numMonthLabel;
    UILabel *titleMonthLabel;
    
    //本年 信息
    UILabel *numYearLabel;
    UILabel *titleYearLabel;
    
    //累计 信息
    UILabel *numTotalLabel;
    UILabel *titleTotalLabel;
    
    //柱状图
    LewBarChart *barChart;
    UIScrollView *scrollBgView;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
    NSDictionary *dataDic;
    
    //每日 数据 模型 数组
    NSMutableArray *graphic_date_dataModelArray;
    //每月 数据 模型 数组
    NSMutableArray *graphic_month_dataModelArray;
    //每年 数据 模型 数组
    NSMutableArray *graphic_year_dataModelArray;
    
    NSString *selectionFlagStr;
    
}



@end

@implementation XXEDataManagerViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSLog(@"%@ ---- %@ --- %@", _schoolId, _schoolType, _classId);
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    graphic_date_dataModelArray = [[NSMutableArray alloc] init];
    graphic_month_dataModelArray = [[NSMutableArray alloc] init];
    graphic_year_dataModelArray = [[NSMutableArray alloc] init];
    selectionFlagStr = @"1";
    
    [self fetchNetData:@"1"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createContent];
//    [self fetchNetData:@"1"];
}

- (void)createContent{

    [self createUpContent];
    
    [self createMiddleContent];
}

- (void)createUpContent{
    upBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 150 * kScreenRatioHeight)];
    upBgView.backgroundColor = UIColorFromRGB(0, 170, 42);
    [self.view addSubview:upBgView];
    
    //头像
    iconImageView = [[UIImageView alloc] init];
    CGFloat iconWidth = 86 * kScreenRatioWidth;
    CGFloat iconHeight = iconWidth;
    
    [iconImageView setFrame:CGRectMake((KScreenWidth - iconWidth) / 2, 20 * kScreenRatioHeight, iconWidth, iconHeight)];
    iconImageView.image = [UIImage imageNamed:@"headplaceholder"];
    
    iconImageView.layer.cornerRadius =iconWidth / 2;
    iconImageView.layer.masksToBounds =YES;
    
    //点击 学校 头像 进入 学校详情
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editPortrait)];
    [iconImageView addGestureRecognizer:tap];
    iconImageView.userInteractionEnabled =YES;
    [upBgView addSubview:iconImageView];
    
    //右边 筛选 按钮
    selectBtn =[UIButton createButtonWithFrame:CGRectMake(KScreenWidth - 50, 10, 32, 32) backGruondImageName:@"manager_selection_icon44x44" Target:self Action:@selector(rightBar:) Title:@""];
    [upBgView addSubview:selectBtn];
    
    //今日 信息
    titleTodayLabel = [UILabel createLabelWithFrame:CGRectMake(100 * kScreenRatioWidth, iconImageView.frame.origin.y + iconImageView.height + 10, 100 * kScreenRatioWidth, 20) Font:14 Text:@""];
    titleTodayLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    titleTodayLabel.textAlignment = NSTextAlignmentCenter;
    titleTodayLabel.textColor = [UIColor whiteColor];
    [upBgView addSubview:titleTodayLabel];
    
    numTodayLabel = [UILabel createLabelWithFrame:CGRectMake(titleTodayLabel.frame.origin.x + titleTodayLabel.width + 5, titleTodayLabel.frame.origin.y, 50 * kScreenRatioWidth, 20) Font:14 Text:@""];
    numTodayLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    numTodayLabel.textColor = [UIColor whiteColor];
    [upBgView addSubview:numTodayLabel];
    
    
}

- (void)rightBar:(UIBarButtonItem*)sender{
    NSArray *menuItems;
    if ([_schoolType integerValue] == 4) {
        //私立  校长
        menuItems =
        @[
          
          [KxMenuItem menuItem:@"浏览次数"
                         image:[UIImage imageNamed:@"manager_browsing_icon36x46"]
                        target:self
                        action:@selector(pushMenuItem:)],
          
          [KxMenuItem menuItem:@"收藏次数"
                         image:[UIImage imageNamed:@"manager_collection_icon36x46"]
                        target:self
                        action:@selector(pushMenuItem:)],
          
          [KxMenuItem menuItem:@"报名人数"
                         image:[UIImage imageNamed:@"manager_sign_icon36x46"]
                        target:self
                        action:@selector(pushMenuItem:)],
          
          [KxMenuItem menuItem:@"报名收入"
                         image:[UIImage imageNamed:@"manager_money_icon36x46"]
                        target:self
                        action:@selector(pushMenuItem:)],
          
          [KxMenuItem menuItem:@"机构评分"
                         image:[UIImage imageNamed:@"manager_score_icon36x46"]
                        target:self
                        action:@selector(pushMenuItem:)]
          ];
    }else{
    
        menuItems =
        @[
          [KxMenuItem menuItem:@"浏览次数"
                         image:[UIImage imageNamed:@"manager_browsing_icon36x46"]
                        target:self
                        action:@selector(pushMenuItem:)],
          
          [KxMenuItem menuItem:@"收藏次数"
                         image:[UIImage imageNamed:@"manager_collection_icon36x46"]
                        target:self
                        action:@selector(pushMenuItem:)]];

    }
    
    
    
    [KxMenu setTitleFont:[UIFont systemFontOfSize:14]];
    
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(kWidth - 10, - 90, 50, 100)
                 menuItems:menuItems];
    
}
- (void) pushMenuItem:(KxMenuItem*)sender
{
    if ([sender.title isEqualToString:@"浏览次数"]) {
        selectionFlagStr = @"1";
        [self fetchNetData:@"1"];
        
        [self updateBrowsingInfo];
    }
    else if ([sender.title isEqualToString:@"收藏次数"]){
        [self fetchNetData:@"2"];
        selectionFlagStr = @"2";
        
        [self updateCollectionInfo];
        
    }
    else if ([sender.title isEqualToString:@"报名人数"]){
        [self fetchNetData:@"3"];
        selectionFlagStr = @"3";
        
        [self updateSignInfo];

        
    }
    else if ([sender.title isEqualToString:@"报名收入"]){
        [self fetchNetData:@"4"];
        selectionFlagStr = @"4";
        
        [self updateMoneyInfo];

    }
    else{
        [self fetchNetData:@"5"];
        selectionFlagStr = @"5";
        
        [self updateScoreInfo];

    }
    
}

- (void)updateBrowsingInfo{
    titleTodayLabel.text = @"今日浏览:";
    titleMonthLabel.text =@"本月浏览";
    titleYearLabel.text =@"本年浏览";
    titleTotalLabel.text =@"累计浏览";

//    NSLog(@"ppp == %@", graphic_date_dataModelArray);
    [self createDownContent:graphic_date_dataModelArray];
    
    //&&&&&&&&&&&&&&&  测试  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
//    double mult = 5 * 1000.f;
//    NSMutableArray *testArray = [[NSMutableArray alloc] init];
//    for (int i = 0 ; i < 30; i++) {
//        double val = (double) (arc4random_uniform(mult) + 3.0);
//        [testArray addObject:@(val)];
//    }
//    [self createDownContent:testArray];
}



- (void)updateCollectionInfo{
    titleTodayLabel.text = @"今日收藏:";
    titleMonthLabel.text =@"本月收藏";
    titleYearLabel.text =@"本年收藏";
    titleTotalLabel.text =@"累计收藏";
    [self createDownContent:graphic_date_dataModelArray];
}

- (void)updateSignInfo{
    titleTodayLabel.text = @"今日报名:";
    titleMonthLabel.text =@"本月报名";
    titleYearLabel.text =@"本年报名";
    titleTotalLabel.text =@"累计报名";
    [self createDownContent:graphic_date_dataModelArray];
}

- (void)updateMoneyInfo{
    titleTodayLabel.text = @"今日报名收入:";
    titleMonthLabel.text =@"本月报名收入";
    titleYearLabel.text =@"本年报名收入";
    titleTotalLabel.text =@"累计报名收入";
    [self createDownContent:graphic_date_dataModelArray];
}

- (void)updateScoreInfo{
    titleTodayLabel.text = @"今日机构评分:";
    titleMonthLabel.text =@"本月机构评分";
    titleYearLabel.text =@"本年机构评分";
    titleTotalLabel.text =@"累计机构评分";
    [self createDownContent:graphic_date_dataModelArray];
}

- (void)editPortrait{
    //logo
    XXEHomeLogoRootViewController *homeLogoRootVC = [[XXEHomeLogoRootViewController alloc] init];
    
    homeLogoRootVC.schoolId = _schoolId;
    homeLogoRootVC.classId = _classId;
    homeLogoRootVC.position = _position;
    
    [self.navigationController pushViewController:homeLogoRootVC animated:NO];

}

- (void)createMiddleContent{
    middleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, upBgView.frame.origin.y + upBgView.height, KScreenWidth, 50 * kScreenRatioHeight)];
    middleBgView.backgroundColor = UIColorFromRGB(0, 153, 38);
    [self.view addSubview:middleBgView];
    
//    //分割线
//    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth / 3, 0, 1, middleBgView.height)];
//    lineView1.backgroundColor = [UIColor lightGrayColor];
//    [middleBgView addSubview:lineView1];
//    
//    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth / 3 * 2, 0, 1, middleBgView.height)];
//    lineView2.backgroundColor = [UIColor lightGrayColor];
//    [middleBgView addSubview:lineView2];
    
    //本月 信息
    numMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, KScreenWidth / 3, 20)];
    numMonthLabel.textAlignment = NSTextAlignmentCenter;
    numMonthLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    numMonthLabel.textColor = [UIColor whiteColor];
    [middleBgView addSubview:numMonthLabel];
    
    titleMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,numMonthLabel.frame.origin.y + numMonthLabel.height,  KScreenWidth / 3, 20)];
    titleMonthLabel.textAlignment = NSTextAlignmentCenter;
    titleMonthLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    titleMonthLabel.textColor = [UIColor whiteColor];
    [middleBgView addSubview:titleMonthLabel];
    
    //本年 信息
    numYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth / 3, 5, KScreenWidth / 3, 20)];
    numYearLabel.textAlignment = NSTextAlignmentCenter;
    numYearLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    numYearLabel.textColor = [UIColor whiteColor];
    [middleBgView addSubview:numYearLabel];
    
    titleYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth / 3,numYearLabel.frame.origin.y + numYearLabel.height,  KScreenWidth / 3, 20)];
    titleYearLabel.textAlignment = NSTextAlignmentCenter;
    titleYearLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    titleYearLabel.textColor = [UIColor whiteColor];
    [middleBgView addSubview:titleYearLabel];
    
    //累计 信息
    numTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth / 3 * 2, 5, KScreenWidth / 3, 20)];
    numTotalLabel.textAlignment = NSTextAlignmentCenter;
    numTotalLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    numTotalLabel.textColor = [UIColor whiteColor];
    [middleBgView addSubview:numTotalLabel];
    
    titleTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth / 3 * 2, numTotalLabel.frame.origin.y + numTotalLabel.height, KScreenWidth / 3, 20)];
    titleTotalLabel.textAlignment = NSTextAlignmentCenter;
    titleTotalLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    titleTotalLabel.textColor = [UIColor whiteColor];
    [middleBgView addSubview:titleTotalLabel];
    
}


- (void)createDownContent:(NSArray *)modelArray{
    downBgView = [[UIView alloc] initWithFrame:CGRectMake(0, middleBgView.frame.origin.y + middleBgView.height, KScreenWidth, KScreenHeight - middleBgView.frame.origin.y - middleBgView.height)];
    downBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:downBgView];
    
    //创建 柱状图
    [self createBarChart:modelArray];

    //创建三个按钮
    [self createButton];
}


- (void)createBarChart:(NSArray *)modelArray{
    
    if (barChart) {
        [barChart removeFromSuperview];
    }
    
    CGFloat maxWidth = modelArray.count * 30 > KScreenWidth ? modelArray.count * 30 : KScreenWidth;
    scrollBgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 250 * kScreenRatioHeight)];
    scrollBgView.contentSize = CGSizeMake(maxWidth, 250 * kScreenRatioHeight);
    scrollBgView.delegate = self;
//    scrollBgView.backgroundColor = [UIColor yellowColor];
    [downBgView addSubview:scrollBgView];
    
    barChart = [[LewBarChart alloc]initWithFrame:CGRectMake(0, 50 * kScreenRatioHeight, maxWidth, 200 * kScreenRatioHeight)];
//    barChart.backgroundColor = [UIColor purpleColor];
    [scrollBgView addSubview:barChart];
    
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < modelArray.count; i++){
        XXEDataManagerDataModel *model = modelArray[i];
        [yVals1 addObject:[NSNumber numberWithInteger:[model.num integerValue]]];
    }
    
    //&&&&&&  测试  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
//    [yVals1 addObjectsFromArray:modelArray];
    
    LewBarChartDataSet *set1 = [[LewBarChartDataSet alloc] initWithYValues:yVals1 label:@""];
    [set1 setBarColor:[UIColor colorWithRed:77.0 / 255.0 green:186.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f]];
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    LewBarChartData *data = [[LewBarChartData alloc] initWithDataSets:dataSets];
    
    NSMutableArray *titleArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < modelArray.count; i++){
        XXEDataManagerDataModel *model = modelArray[i];
        [titleArray addObject:model.tm_name];
    }
    
    //&&&&&   测试  &&&&&&&&&&&&&&&&&&&&&&&&&&&
//    for (int i = 0; i < modelArray.count; i++){
//        [titleArray addObject:[NSString stringWithFormat:@"%d", i]];
//    }
    
    data.xLabels = titleArray;
    data.groupSpace = 10;
    data.itemSpace = 5;
    barChart.data = data;
    barChart.displayAnimated = YES;
    
    barChart.chartMargin = UIEdgeInsetsMake(15, 15, 30, 15);
    barChart.showYAxis = NO;
    barChart.showNumber = YES;
    barChart.legendView.alignment = LegendAlignmentHorizontal;
    
    CGPoint legendCenter = CGPointMake(kWidth-barChart.legendView.bounds.size.width/2, -18);
    barChart.legendView.center = legendCenter;
    
    
    [barChart show];
}

- (void)createButton{
    CGFloat buttonWidth = 100 * kScreenRatioWidth;
    CGFloat buttonHeight = 40 * kScreenRatioHeight;
    
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton createButtonWithFrame:CGRectMake((KScreenWidth - buttonWidth * 3) / 4 * (i + 1) + buttonWidth * i, barChart.frame.origin.y + barChart.height, buttonWidth, buttonHeight) backGruondImageName:nil Target:self Action:@selector(buttonClick:) Title:@""];
        
        btn.backgroundColor = UIColorFromRGB(0, 170, 42);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        btn.titleLabel.font = [UIFont systemWithIphone6P:14 Iphone6:12 Iphone5:10 Iphone4:8];
        
        if ([selectionFlagStr isEqualToString:@"1"]) {
          if (i == 0) {
            [btn setTitle:@"每日浏览次数" forState:UIControlStateNormal];
          }else if (i == 1) {
            [btn setTitle:@"每月浏览次数" forState:UIControlStateNormal];
          }else if (i == 2) {
            [btn setTitle:@"每年浏览次数" forState:UIControlStateNormal];
          }
        }else if ([selectionFlagStr isEqualToString:@"2"]) {
            if (i == 0) {
                [btn setTitle:@"每日收藏次数" forState:UIControlStateNormal];
            }else if (i == 1) {
                [btn setTitle:@"每月收藏次数" forState:UIControlStateNormal];
            }else if (i == 2) {
                [btn setTitle:@"每年收藏次数" forState:UIControlStateNormal];
            }
        }else if ([selectionFlagStr isEqualToString:@"3"]) {
            if (i == 0) {
                [btn setTitle:@"每日报名人数" forState:UIControlStateNormal];
            }else if (i == 1) {
                [btn setTitle:@"每月报名人数" forState:UIControlStateNormal];
            }else if (i == 2) {
                [btn setTitle:@"每年报名人数" forState:UIControlStateNormal];
            }
        }else if ([selectionFlagStr isEqualToString:@"4"]) {
            if (i == 0) {
                [btn setTitle:@"每日报名收入" forState:UIControlStateNormal];
            }else if (i == 1) {
                [btn setTitle:@"每月报名收入" forState:UIControlStateNormal];
            }else if (i == 2) {
                [btn setTitle:@"每年报名收入" forState:UIControlStateNormal];
            }
        }else if ([selectionFlagStr isEqualToString:@"5"]) {
            if (i == 0) {
                [btn setTitle:@"每日机构评分" forState:UIControlStateNormal];
            }else if (i == 1) {
                [btn setTitle:@"每月机构评分" forState:UIControlStateNormal];
            }else if (i == 2) {
                [btn setTitle:@"每年机构评分" forState:UIControlStateNormal];
            }
        }
        [downBgView addSubview:btn];
    }

}

- (void)buttonClick:(UIButton *)button{
    switch (button.tag - 100) {
        case 0:
        {
            [self createBarChart:graphic_date_dataModelArray];
            break;
        }
        case 1:
        {
            [self createBarChart:graphic_month_dataModelArray];
            break;
        }
        case 2:
        {
            [self createBarChart:graphic_year_dataModelArray];
            break;
        }
            
        default:
            break;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

}

- (void)fetchNetData:(NSString *)data_type{
//    NSLog(@"bbb-- %@", data_type);
    
    XXEDataManagerApi *dataManagerApi = [[XXEDataManagerApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:_schoolId school_type:_schoolType data_type:data_type];
    [dataManagerApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        dataDic = [[NSDictionary alloc] init];
        if (graphic_date_dataModelArray.count != 0) {
            [graphic_date_dataModelArray removeAllObjects];
        }
        if (graphic_month_dataModelArray.count != 0) {
            [graphic_month_dataModelArray removeAllObjects];
        }
        if (graphic_year_dataModelArray.count != 0) {
            [graphic_year_dataModelArray removeAllObjects];
        }
        
//        NSLog(@"111   %@", request.responseJSONObject);
        
        NSDictionary *dic = request.responseJSONObject;
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", dic[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            dataDic = dic;
            
            NSString *head_img = [kXXEPicURL stringByAppendingString:[NSString stringWithFormat:@"%@", dataDic[@"data"][@"school_logo"]]];
            [iconImageView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
            
            numTodayLabel.text = [NSString stringWithFormat:@"%ld", [dataDic[@"data"][@"date_num"] integerValue]];
            
            numMonthLabel.text = [NSString stringWithFormat:@"%ld", [dataDic[@"data"][@"month_num"] integerValue]];
            
            numYearLabel.text = [NSString stringWithFormat:@"%ld", [dataDic[@"data"][@"year_num"] integerValue]];
            
            numTotalLabel.text = [NSString stringWithFormat:@"%ld", [dataDic[@"data"][@"all_num"] integerValue]];
            
            NSArray *array1 = dataDic[@"data"][@"graphic_data"][@"graphic_date_data"];
            if (array1.count != 0) {
              NSArray *modelArray1 = [XXEDataManagerDataModel parseResondsData:array1];
             [graphic_date_dataModelArray addObjectsFromArray:modelArray1];
            }

            NSArray *array2 = dataDic[@"data"][@"graphic_data"][@"graphic_month_data"];
            if (array2.count != 0) {
                NSArray *modelArray2 = [XXEDataManagerDataModel parseResondsData:array2];
                [graphic_month_dataModelArray addObjectsFromArray:modelArray2];
            }
            
            NSArray *array3 = dataDic[@"data"][@"graphic_data"][@"graphic_year_data"];
            if (array3.count != 0) {
                NSArray *modelArray3 = [XXEDataManagerDataModel parseResondsData:array3];
                [graphic_year_dataModelArray addObjectsFromArray:modelArray3];
            }
            
            if ([data_type isEqualToString:@"1"]) {
                [self updateBrowsingInfo];
            }

        }else{
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"请求失败" forSecond:1.f];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
