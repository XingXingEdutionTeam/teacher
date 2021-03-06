
//
//  XXESchoolTimetableViewController.m
//  teacher
//
//  Created by Mac on 16/10/31.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolTimetableViewController.h"
#import "XXESchoolTimetableAddCourseViewController.h"
#import "XXESchoolTimetableCourseViewController.h"
#import "XXESchoolTimetableTraditionApi.h"
#import "XXESchoolTimetableTimeLineApi.h"
#import "XXESchoolTimetableModel.h"
#import "XXEAllWeeksApi.h"

//横向 周几 label 宽/高
#define weekLabelWidth (kWidth - 26 - 7 * 1)/7
#define weekLabelHeight 25

//竖向 几节课
#define timeLabelWidth 26
#define timeLabelHeight 40
//具体课程 label 宽/高
#define  cellWidth  (kWidth - 26 - 7 * 1)/7
#define  cellHeight  25



@interface XXESchoolTimetableViewController ()<UIScrollViewDelegate>
{
    //假 navigationBar
    UIView *navigationBarView;
    
    WJCommboxView *titleCommbox;
    UIView *titleCommboxBgView;
    
    //左键 返回键
    UIButton *leftButton;
    //右键 切换键
    UIButton *rightButton;
    //一共几周
    NSMutableArray *weeksArray;
    //一共几个月
    NSMutableArray *monthArray;
    NSMutableArray *dayArray;
    NSDictionary *weekMonthDic;
    //下面的 scrollview
    UIScrollView *bgScrollView;
    //创建行数
    NSInteger courseRow;
    //竖向 标题 背景 vertical
    UIView *verticalBgiew;
    //横向 标题 背景 horizontal
    UIView *horizontalBgView;
    
    //传统 数据 数组
    NSMutableArray *courseTraditionArray;
    //时间轴 数据 数组
    NSMutableArray *courseTimeArray;
    //
//    NSMutableArray *courseModelArray;
    //原始 时间戳数组
    NSMutableArray *originalTimeArray;
    
    //切换 模式 按钮 标志位
    NSString *flagStr;
    
    //scrollView 是第几页
    NSInteger page;
    
    UICollectionView *courseCollectionView;
//    NSMutableArray *courseDataArray;
    
    //空白 占位图
    UIImageView *placeholderImageView;
    UIButton * addCourseButton;
    
    //
    UIView *courseButtonBgView;
    
    //判断当前 是 星期几
    NSInteger weekFlag;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}
@end

@implementation XXESchoolTimetableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    //获取 传统 模式 数据  不传值 默认 本周
//    [self fetchCourseInfoTraditionStyle:@""];
    
//    NSLog(@"page ==== %ld", page);
    
    if (rightButton.selected == NO) {
                NSLog(@"11111111 === 传统 模式");
        if (originalTimeArray.count != 0) {
            [self fetchCourseInfoTraditionStyle:originalTimeArray[page]];
        }
    }else{
                NSLog(@"222222 ---- 时间轴 模式");
        if (originalTimeArray.count != 0) {
            [self fetchCourseInfoTimeLineStyle:originalTimeArray[page]];
        }
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(116,205, 169);;

    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    weeksArray = [[NSMutableArray alloc] init];
    monthArray = [[NSMutableArray alloc] init];
    dayArray = [[NSMutableArray alloc] init];
    weekMonthDic = [[NSMutableDictionary alloc] init];
    courseTraditionArray = [[NSMutableArray alloc] init];
    courseTimeArray = [[NSMutableArray alloc] init];
//    courseModelArray = [[NSMutableArray alloc] init];
    originalTimeArray = [[NSMutableArray alloc] init];
    courseRow = 0;
    page = 0;
//    flagStr = @"";
    
    weekFlag = [XXETool queryWeekday];
    weekFlag = ((weekFlag - 1) == 0 ? 7 : (weekFlag - 1));
    
    for (int i = 0; i < 20; i++) {
        if (i == 0) {
            [weeksArray addObject:@"本周"];
        }else{
            NSString *str = [NSString stringWithFormat:@"第%d周",i+1];
            [weeksArray addObject:str];
        }
    }

    //获取一共几周 数据
    [self fetchAllWeeks];
//    //获取 传统 模式 数据  不传值 默认 本周
    [self fetchCourseInfoTraditionStyle:@""];
    
    //创建 假navigationBar
    [self createNavigationBar];
    //左键
    [self createLeftButton];
    //标题 下拉框
    [self createTitleView];
    //创建  右键 切换模式
    [self createRightButton];
    
    [self createScrollView];
    
    
}

- (void)fetchAllWeeks{

    XXEAllWeeksApi *allWeeksApi = [[XXEAllWeeksApi alloc] initWithXid:parameterXid user_id:parameterUser_Id];
    [allWeeksApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//        NSLog(@"%@", request.responseJSONObject);
        NSDictionary *dict = request.responseJSONObject;
        if ([dict[@"code"] integerValue] == 1) {
            if ([dict[@"data"] count] != 0) {
                originalTimeArray = dict[@"data"];
                for (int i = 0; i < [originalTimeArray count]; i++) {
                    NSString *str = [XXETool dateStringFromNumberTimer:originalTimeArray[i]];
                    NSArray *arr = [str componentsSeparatedByString:@"-"];
                    [dayArray addObject:str];
                    [monthArray addObject:arr[1]];
                }
            }
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"获取数据失败!" forSecond:1.5];
    }];
}


#pragma mark =========== fetchCourseInfoTraditionStyle====
- (void)fetchCourseInfoTraditionStyle:(NSString *)timeString{

    XXESchoolTimetableTraditionApi *schoolTimetableTraditionApi = [[XXESchoolTimetableTraditionApi alloc] initWithXid:parameterXid user_id:parameterUser_Id week_date:timeString];
    [schoolTimetableTraditionApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
//        NSLog(@"kk课程表==  %@", request.responseJSONObject);
        
        NSString *codeStr = request.responseJSONObject[@"code"];
        
        if ([codeStr integerValue] == 1) {
            [self removePlaceholderImageView];
            
            courseTraditionArray = request.responseJSONObject[@"data"];
            courseRow = [courseTraditionArray count];
            
            [self createScrollViewTitlesLabel2];
            [self createScrollViewTitlesLabel1];
            [self createCourseButtons1];
            
        }else if ([codeStr integerValue] == 3){
//            [self showHudWithString:@"暂无数据!" forSecond:1.5];
            [self createPlaceholderView];
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"获取数据失败!" forSecond:1.5];
    }];
}



//没有 数据 时,创建 占位图
- (void)createPlaceholderView{
    // 1、无数据的时候
    UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
    CGFloat myImageWidth = myImage.size.width;
    CGFloat myImageHeight = myImage.size.height;
    
    placeholderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (KScreenHeight - 20 - myImageHeight) / 2 + page * KScreenHeight, myImageWidth, myImageHeight)];
    placeholderImageView.image = myImage;
    [bgScrollView addSubview:placeholderImageView];
    
    addCourseButton = [UIButton createButtonWithFrame:CGRectMake(0, (KScreenHeight - 49 - 64) + KScreenHeight *page , KScreenWidth, 49)  backGruondImageName:nil Target:self Action:@selector(addCourseButtonClick) Title:@"添加课程"];
    
    [addCourseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addCourseButton.backgroundColor = UIColorFromRGB(0, 170, 42);
    [bgScrollView addSubview:addCourseButton];
    bgScrollView.userInteractionEnabled = YES;
    
}

//去除 占位图
- (void)removePlaceholderImageView{
    if (placeholderImageView != nil) {
        [placeholderImageView removeFromSuperview];
    }
    
    if (addCourseButton) {
        [addCourseButton removeFromSuperview];
    }
}

- (void)addCourseButtonClick{
//    NSLog(@"mmmmm" );
    if ([XXEUserInfo user].login) {
        XXESchoolTimetableAddCourseViewController *schoolTimetableAddCourseVC = [[XXESchoolTimetableAddCourseViewController alloc] init];
        
        
        [self.navigationController pushViewController:schoolTimetableAddCourseVC animated:YES];
    }else{
        [self showString:@"请用账号登录后查看" forSecond:1.5];
    }


}


#pragma mark =========== fetchCourseInfoTimeLineStyle====
- (void)fetchCourseInfoTimeLineStyle:(NSString *)timeString{
    
    XXESchoolTimetableTimeLineApi *schoolTimetableTimeLineApi = [[XXESchoolTimetableTimeLineApi alloc] initWithXid:parameterXid user_id:parameterUser_Id week_date:timeString];
    [schoolTimetableTimeLineApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
//                NSLog(@"kk %@", request.responseJSONObject);
        
        NSString *codeStr = request.responseJSONObject[@"code"];
        
        if ([codeStr integerValue] == 1) {
            [self removePlaceholderImageView];
            
            courseTimeArray = request.responseJSONObject[@"data"];
            courseRow = [courseTimeArray count];

            [self createScrollViewTitlesLabel2];
            [self createScrollViewTitlesLabel3];
            [self createCourseButtons2];
            
        }else if ([codeStr integerValue] == 3){
            [self createPlaceholderView];
            [self showHudWithString:@"暂无数据!" forSecond:1.5];
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"获取数据失败!" forSecond:1.5];
    }];
}

- (void)createNavigationBar{
    navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    navigationBarView.backgroundColor = UIColorFromRGB(0, 170, 42);
    navigationBarView.userInteractionEnabled = YES;
    [self.view addSubview:navigationBarView];
    [self.view bringSubviewToFront:navigationBarView];
}

- (void)createLeftButton{
//
    leftButton = [UIButton createButtonWithFrame:CGRectMake(10, 34, 45, 19) backGruondImageName:@"back_icon90x38" Target:self Action:@selector(leftButtonClick) Title:@""];
    [navigationBarView addSubview:leftButton];
}

- (void)leftButtonClick{

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)createTitleView{
    //----------------------周几 下拉框
    titleCommbox = [[WJCommboxView alloc] initWithFrame:CGRectMake((KScreenWidth - 90) / 2, 30 , 90, 30)];
    titleCommbox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
//    titleCommbox.textField.placeholder = @"本周";
    titleCommbox.textField.text = weeksArray[0];
    titleCommbox.dataArray = weeksArray;
    titleCommbox.textField.textAlignment = NSTextAlignmentCenter;
    titleCommbox.textField.tag = 1001;
    
    [navigationBarView addSubview:titleCommbox];
    
    //监听
    [titleCommbox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"1"];
    
    titleCommboxBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kWidth,kHeight+300)];
    titleCommboxBgView.backgroundColor = [UIColor clearColor];
    titleCommboxBgView.alpha = 0.5;
    
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden)];
    [titleCommboxBgView addGestureRecognizer:singleTouch];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    
}

#pragma mark -------------- 切换模式(传统模式/时间轴) =============
- (void)createRightButton{

    //切换模式(传统模式/时间轴)
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(KScreenWidth - 50, 20, 50, 44);
    [rightButton setImage:[UIImage imageNamed:@"change_icon"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(exchangeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [navigationBarView addSubview:rightButton];
}

- (void)exchangeBtn:(UIButton *)button{
    
    if ([XXEUserInfo user].login) {
        //    NSLog(@"课程表 切换 模式");
        if (button.selected == YES) {
            //        NSLog(@"11111111 === 传统 模式");
            if (originalTimeArray.count != 0) {
                [self fetchCourseInfoTraditionStyle:originalTimeArray[page]];
            }
        }else{
            //        NSLog(@"222222 ---- 时间轴 模式");
            if (originalTimeArray.count != 0) {
                [self fetchCourseInfoTimeLineStyle:originalTimeArray[page]];
            }
        }
        button.selected = !button.selected;
    }else{
        [self showString:@"请用账号登录后查看" forSecond:1.5];
    }
}

- (void)commboxAction:(NSNotification *)notif{
    switch ([notif.object integerValue]) {
        case 1001:
        {
            
            [titleCommbox removeFromSuperview];
            
            [self.view addSubview:titleCommboxBgView];
            [self.view addSubview:titleCommbox];
            
        }
            break;
        default:
            break;
    }
    
}


- (void)commboxHidden{
    
    [titleCommboxBgView removeFromSuperview];
    [titleCommbox setShowList:NO];
    titleCommbox.listTableView.hidden = YES;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    switch ([[NSString stringWithFormat:@"%@",context] integerValue]) {
        case 1:
        {
            if ([keyPath isEqualToString:@"text"]) {
                NSString * newName=[change objectForKey:@"new"];
                
                NSInteger index = [weeksArray indexOfObject:newName];
                bgScrollView.contentOffset = CGPointMake(0, KScreenHeight * index);
                page = bgScrollView.contentOffset.y / kHeight;
//                NSLog(@"page ---- %ld", page);
//
                if (rightButton.selected == NO) {
//                    NSLog(@"11111111 === 传统 模式");
                    if (originalTimeArray.count != 0) {
                        [self fetchCourseInfoTraditionStyle:originalTimeArray[page]];
                    }
                }else{
//                    NSLog(@"222222 ---- 时间轴 模式");
                    if (originalTimeArray.count != 0) {
                        [self fetchCourseInfoTimeLineStyle:originalTimeArray[page]];
                    }
                }

            }
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - ------------- createScrollView =============
- (void)createScrollView{
    bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight)];
    bgScrollView.pagingEnabled = YES;
    bgScrollView.contentSize = CGSizeMake(KScreenWidth, KScreenHeight * weeksArray.count);
    bgScrollView.delegate = self;
    bgScrollView.userInteractionEnabled = YES;
    [self.view addSubview:bgScrollView];
    
}
#pragma mark ------------ createScrollViewContent ==========
- (void)createScrollViewTitlesLabel1{
    //创建竖向 标题
    if (horizontalBgView) {
        [horizontalBgView removeFromSuperview];
    }
    
    horizontalBgView = [[UIView alloc] initWithFrame:CGRectMake(0, page * KScreenHeight, timeLabelWidth, KScreenHeight)];
    [bgScrollView addSubview:horizontalBgView];
   
    if (courseRow == 0) {
        if (monthArray.count != 0) {
            UILabel *monthLabel = [UILabel createLabelWithFrame:CGRectMake(0, page * KScreenHeight, timeLabelWidth, timeLabelHeight) Font:14 Text:[NSString stringWithFormat:@"%@月", monthArray[page]]];
            monthLabel.backgroundColor = UIColorFromRGB(195, 239, 251);
            monthLabel.textAlignment = NSTextAlignmentCenter;
            [bgScrollView addSubview:monthLabel];
        }
    }else{
        for (int i = 0; i <= courseRow; i++) {
            if (i == 0) {
                
                NSString *str = @"";
                if (monthArray.count != 0) {
                 str = [NSString stringWithFormat:@"%@月", monthArray[page]];
                }
                UILabel *monthLabel = [UILabel createLabelWithFrame:CGRectMake(0, 0, timeLabelWidth, timeLabelHeight) Font:14 Text:str];
                monthLabel.backgroundColor = UIColorFromRGB(195, 239, 251);
                monthLabel.textAlignment = NSTextAlignmentCenter;
                [horizontalBgView addSubview:monthLabel];
            }else{
                UILabel *monthLabel = [UILabel createLabelWithFrame:CGRectMake(0, (timeLabelHeight + 1) * i, timeLabelWidth, timeLabelHeight) Font:10 Text:[NSString stringWithFormat:@"%d", i]];
                monthLabel.backgroundColor = UIColorFromRGB(195, 239, 251);
                monthLabel.textAlignment = NSTextAlignmentCenter;
                [horizontalBgView addSubview:monthLabel];
            
            }
        }
    
    }
}

//横向 titleLabel
- (void)createScrollViewTitlesLabel2{
    //创建水平 周一~周日
    if (verticalBgiew) {
        [verticalBgiew removeFromSuperview];
    }
    verticalBgiew = [[UIView alloc] initWithFrame:CGRectMake(timeLabelWidth + 1, page * KScreenHeight, KScreenWidth - (timeLabelWidth + 1), timeLabelHeight)];
    [bgScrollView addSubview:verticalBgiew];
    
//    NSLog(@"dayArray --- %@", dayArray[page]);
    
    NSMutableArray *dayArr = [[NSMutableArray alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //字符串 @"yyyy-MM-dd HH:mm:ss" -> 转化为 NSDate yyyy-MM-dd HH:mm:ss
    if ([dayArray count] != 0) {
        NSDate *mondayDate = [formatter dateFromString:dayArray[page]];
        
        for (int i = 0; i < 7; i++) {
            NSTimeInterval  interval = 24 * 60 * 60 * i ;
            NSDate *newDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:mondayDate];
            //NSDate yyyy-MM-dd HH:mm:ss -> 转化为 字符串 @"yyyy-MM-dd HH:mm:ss"
            NSString *str = [formatter stringFromDate:newDate];
            NSRange range = NSMakeRange(5, 5);
            NSString *newString = [str substringWithRange:range];
            [dayArr addObject:newString];
        }
    }
    
    if (dayArr.count == 0) {
        return;
    }
//    NSLog(@"dayArr === %@", dayArr);
    if ([dayArr count] == 0) {
        return;
    }
    
    NSArray *weekArr = [[NSArray alloc] initWithObjects:@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日", nil];
    
        for (int j = 0; j < 7; j ++) {
            UILabel *weekLabel = [UILabel createLabelWithFrame:CGRectMake( j * (weekLabelWidth + 1), 0, weekLabelWidth, weekLabelHeight) Font:12 Text:weekArr[j]];
            weekLabel.backgroundColor = UIColorFromRGB(195, 239, 251);
            weekLabel.textAlignment = NSTextAlignmentCenter;
            [verticalBgiew addSubview:weekLabel];
            
            UILabel *dayLabel = [UILabel createLabelWithFrame:CGRectMake( j * (weekLabelWidth + 1), weekLabel.height, weekLabelWidth, 15) Font:10 Text:dayArr[j]];
            dayLabel.backgroundColor = UIColorFromRGB(195, 239, 251);
            dayLabel.textColor = [UIColor lightGrayColor];
            dayLabel.textAlignment = NSTextAlignmentCenter;
            [verticalBgiew addSubview:dayLabel];
        }
}

//时间轴 竖向 标题
- (void)createScrollViewTitlesLabel3{
    //创建竖向 标题
    if (horizontalBgView) {
        [horizontalBgView removeFromSuperview];
    }
    horizontalBgView = [[UIView alloc] initWithFrame:CGRectMake(0, page * KScreenHeight, timeLabelWidth, KScreenHeight)];
    [bgScrollView addSubview:horizontalBgView];
    
    
    if (courseRow == 0) {
        if (monthArray.count != 0) {
            UILabel *monthLabel = [UILabel createLabelWithFrame:CGRectMake(0, 0, timeLabelWidth, timeLabelHeight) Font:14 Text:[NSString stringWithFormat:@"%@月", monthArray[page]]];
            monthLabel.backgroundColor = UIColorFromRGB(195, 239, 251);
            monthLabel.textAlignment = NSTextAlignmentCenter;
            [horizontalBgView addSubview:monthLabel];
        }
    }else{
        for (int i = 0; i <= courseRow; i++) {
            if (i == 0) {
                
                NSString *str = @"";
                if (monthArray.count != 0) {
                    str = [NSString stringWithFormat:@"%@月", monthArray[page]];
                }
                UILabel *monthLabel = [UILabel createLabelWithFrame:CGRectMake(0, 0, timeLabelWidth, timeLabelHeight) Font:14 Text:str];
                monthLabel.backgroundColor = UIColorFromRGB(195, 239, 251);
                monthLabel.textAlignment = NSTextAlignmentCenter;
                [horizontalBgView addSubview:monthLabel];
            }else{
                
                NSString *timeStr = courseTimeArray[i - 1][@"tm"];
                
                UILabel *monthLabel = [UILabel createLabelWithFrame:CGRectMake(0,  1 +(timeLabelHeight + 1) * i, timeLabelWidth, timeLabelHeight) Font:8 Text:timeStr];
                monthLabel.backgroundColor = UIColorFromRGB(195, 239, 251);
                monthLabel.textAlignment = NSTextAlignmentCenter;
                [horizontalBgView addSubview:monthLabel];
                
            }
        }
        
    }
}


- (void)createCourseButtons1{
    
//    //所有
//    NSLog(@"%@", courseTraditionArray);
//    
//    //第一行
//    if (courseTraditionArray.count != 0) {
//         NSLog(@"%@", courseTraditionArray[0]);
//    }
//    
//    if ([courseTraditionArray[0] count] != 0) {
//        //第一行 第一个(仍然是数组)
//        NSLog(@"%@", courseTraditionArray[0][0]);
//    }
//    if ([courseTraditionArray[0][0] count] != 0) {
//        //第一行 第一个 第一个课程
//        NSLog(@"%@", courseTraditionArray[0][0][0]);
// 
//    }
    
    if (courseButtonBgView) {
        [courseButtonBgView removeFromSuperview];
    }
    
    courseButtonBgView = [[UIView alloc] initWithFrame:CGRectMake(timeLabelWidth, timeLabelHeight + 1 + page * KScreenHeight, KScreenWidth - timeLabelWidth, KScreenHeight - weekLabelHeight)];
    
    courseButtonBgView.backgroundColor = [UIColor clearColor];
    [bgScrollView addSubview:courseButtonBgView];

    
    for (int i = 0; i < courseRow * 7; i++) {
        
        //行
        int buttonRow = i / 7;
        
        //列
        int buttonLine = i % 7;
        
        CGFloat buttonX = 1 + (cellWidth + 0.5) * buttonLine;
        CGFloat buttonY = (timeLabelHeight - cellHeight) / 2 + buttonRow * (timeLabelHeight + 1);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, buttonY, cellWidth, cellHeight);
        button.tag = 1 + i;
        
        if (weekFlag == buttonLine + 1) {
            button.backgroundColor = UIColorFromRGB(0, 170, 42);
        }else{
            button.backgroundColor = UIColorFromRGB(193, 193, 193);
        }
    
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        [courseButtonBgView addSubview:button];
        
        //            NSLog(@"i ==== %@", courseTraditionArray[i]);
        //            NSLog(@"i -- j ===%@", courseTraditionArray[i][j]);
        
                    if ([courseTraditionArray[buttonRow][buttonLine] count] != 0) {
            //  NSLog(@"i -- j === 0 ==%@", courseTraditionArray[i][j][0]);
                        [button setTitle:courseTraditionArray[buttonRow][buttonLine][0][@"name"] forState:UIControlStateNormal];
                        if ([courseTraditionArray[buttonRow][buttonLine] count] > 1) {
        
                          NSString *numStr = [NSString stringWithFormat:@"%ld", [courseTraditionArray[buttonRow][buttonLine] count]];
                            UILabel *numLabel = [self createLabelFrame:CGRectMake(button.frame.origin.x + cellWidth - 10, button.frame.origin.y - 3, 12, 12) text:numStr];
        
                            [courseButtonBgView addSubview:numLabel];
                            [courseButtonBgView bringSubviewToFront:numLabel];
                            
                }

         }
  }
}


- (void)createCourseButtons2{
        //所有
//        NSLog(@"时间轴 模式 %@", courseTimeArray);
    
    if (courseButtonBgView) {
        [courseButtonBgView removeFromSuperview];
    }
    
    courseButtonBgView = [[UIView alloc] initWithFrame:CGRectMake(timeLabelWidth, timeLabelHeight + 1 + page * KScreenHeight, KScreenWidth - timeLabelWidth, KScreenHeight - weekLabelHeight)];
    
    courseButtonBgView.backgroundColor = [UIColor clearColor];
    [bgScrollView addSubview:courseButtonBgView];
    
    
    for (int i = 0; i < courseRow * 7; i++) {
        
        //行
        int buttonRow = i / 7;
        
        //列
        int buttonLine = i % 7;
        
        CGFloat buttonX = 1 + (cellWidth + 0.5) * buttonLine;
        CGFloat buttonY = (timeLabelHeight - cellHeight) / 2 + buttonRow * (timeLabelHeight + 1);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, buttonY, cellWidth, cellHeight);
        button.tag = 1 + i;
        
        if (weekFlag == buttonLine + 1) {
            button.backgroundColor = UIColorFromRGB(0, 170, 42);
        }else{
            button.backgroundColor = UIColorFromRGB(193, 193, 193);
        }
        
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        [courseButtonBgView addSubview:button];

//        NSLog(@"mmm %@", courseTimeArray[buttonRow]);
        
//        NSLog(@"ppp %@", courseTimeArray[buttonRow][@"con"]);
        
        if (buttonLine == 0) {
            //星期一
            NSArray *arr = [[NSArray alloc] init];
            arr = courseTimeArray[buttonRow][@"con"][@"monday"];
            
            if (arr.count != 0) {
                [button setTitle:arr[0][@"name"] forState:UIControlStateNormal];
                
                if (arr.count > 1) {
                    NSString *numStr = [NSString stringWithFormat:@"%ld", arr.count];
                    UILabel *numLabel = [self createLabelFrame:CGRectMake(button.frame.origin.x + cellWidth - 10, button.frame.origin.y - 3, 12, 12) text:numStr];
                    [courseButtonBgView addSubview:numLabel];
                    [courseButtonBgView bringSubviewToFront:numLabel];
                }
            }
        }else if (buttonLine == 1) {
            //星期二
            
            NSArray *arr = [[NSArray alloc] init];
            arr = courseTimeArray[buttonRow][@"con"][@"tuesday"];
            
            if (arr.count != 0) {
                [button setTitle:arr[0][@"name"] forState:UIControlStateNormal];
                
                if (arr.count > 1) {
                    NSString *numStr = [NSString stringWithFormat:@"%ld", arr.count];
                    UILabel *numLabel = [self createLabelFrame:CGRectMake(button.frame.origin.x + cellWidth - 10, button.frame.origin.y - 3, 12, 12) text:numStr];
                    [courseButtonBgView addSubview:numLabel];
                    [courseButtonBgView bringSubviewToFront:numLabel];
                }
            }
        }else if (buttonLine == 2) {
            //星期三
            NSArray *arr = [[NSArray alloc] init];
            arr = courseTimeArray[buttonRow][@"con"][@"wednesday"];
            
            if (arr.count != 0) {
                [button setTitle:arr[0][@"name"] forState:UIControlStateNormal];
                
                if (arr.count > 1) {
                    NSString *numStr = [NSString stringWithFormat:@"%ld", arr.count];
                    UILabel *numLabel = [self createLabelFrame:CGRectMake(button.frame.origin.x + cellWidth - 10, button.frame.origin.y - 3, 12, 12) text:numStr];
                    [courseButtonBgView addSubview:numLabel];
                    [courseButtonBgView bringSubviewToFront:numLabel];
                }
            }
        }else if (buttonLine == 3) {
            //星期四
            
            NSArray *arr = [[NSArray alloc] init];
            arr = courseTimeArray[buttonRow][@"con"][@"thursday"];
            
            if (arr.count != 0) {
                [button setTitle:arr[0][@"name"] forState:UIControlStateNormal];
                
                if (arr.count > 1) {
                    NSString *numStr = [NSString stringWithFormat:@"%ld", arr.count];
                    UILabel *numLabel = [self createLabelFrame:CGRectMake(button.frame.origin.x + cellWidth - 10, button.frame.origin.y - 3, 12, 12) text:numStr];
                    [courseButtonBgView addSubview:numLabel];
                    [courseButtonBgView bringSubviewToFront:numLabel];
                }
            }
        }else if (buttonLine == 4) {
            //星期五
            
            NSArray *arr = [[NSArray alloc] init];
            arr = courseTimeArray[buttonRow][@"con"][@"friday"];
            
            if (arr.count != 0) {
                [button setTitle:arr[0][@"name"] forState:UIControlStateNormal];
                
                if (arr.count > 1) {
                    NSString *numStr = [NSString stringWithFormat:@"%ld", arr.count];
                    UILabel *numLabel = [self createLabelFrame:CGRectMake(button.frame.origin.x + cellWidth - 10, button.frame.origin.y - 3, 12, 12) text:numStr];
                    [courseButtonBgView addSubview:numLabel];
                    [courseButtonBgView bringSubviewToFront:numLabel];
                }
            }
            
            
        }else if (buttonLine == 5) {
            //星期六
            
            NSArray *arr = [[NSArray alloc] init];
            arr = courseTimeArray[buttonRow][@"con"][@"saturday"];
            
            if (arr.count != 0) {
                [button setTitle:arr[0][@"name"] forState:UIControlStateNormal];
                
                if (arr.count > 1) {
                    NSString *numStr = [NSString stringWithFormat:@"%ld", arr.count];
                    UILabel *numLabel = [self createLabelFrame:CGRectMake(button.frame.origin.x + cellWidth - 10, button.frame.origin.y - 3, 12, 12) text:numStr];
                    [courseButtonBgView addSubview:numLabel];
                    [courseButtonBgView bringSubviewToFront:numLabel];
                }
            }
            
            
        }else if (buttonLine == 6) {
            //星期日
            
            NSArray *arr = [[NSArray alloc] init];
            arr = courseTimeArray[buttonRow][@"con"][@"sunday"];
            
            if (arr.count != 0) {
                [button setTitle:arr[0][@"name"] forState:UIControlStateNormal];
                
                if (arr.count > 1) {
                    NSString *numStr = [NSString stringWithFormat:@"%ld", arr.count];
                    UILabel *numLabel = [self createLabelFrame:CGRectMake(button.frame.origin.x + cellWidth - 10, button.frame.origin.y - 3, 12, 12) text:numStr];
                    [courseButtonBgView addSubview:numLabel];
                    [courseButtonBgView bringSubviewToFront:numLabel];
                }
            }
        }
    }
}



- (void)buttonClick:(UIButton *)button{
    
    if ([XXEUserInfo user].login) {
        //    NSLog(@"%ld", button.tag);
        
        NSInteger i = button.tag - 1;
        
        //注意 列 均是从 0 开始
        //行
        NSInteger buttonRow = i / 7;
        
        //列
        NSInteger buttonLine = i % 7;
        
        //    NSLog(@"行 %ld  --- 列 %ld ", buttonRow, buttonLine);
        
        XXESchoolTimetableCourseViewController *schoolTimetableCourseVC = [[XXESchoolTimetableCourseViewController alloc] init];
        
        schoolTimetableCourseVC.week_date = originalTimeArray[page];
        
        if (rightButton.selected == NO) {
            //传统 模式
            NSLog(@"courseTraditionArray === %@", courseTraditionArray);
            
            schoolTimetableCourseVC.courseDataArray = courseTraditionArray[buttonRow][buttonLine];
        }else if (rightButton.selected == YES){
            //时间轴 模式
            if (buttonLine == 0) {
                schoolTimetableCourseVC.courseDataArray = courseTimeArray[buttonRow][@"con"][@"monday"];
            }else if (buttonLine == 1){
                schoolTimetableCourseVC.courseDataArray = courseTimeArray[buttonRow][@"con"][@"tuesday"];
            }else if (buttonLine == 2){
                schoolTimetableCourseVC.courseDataArray = courseTimeArray[buttonRow][@"con"][@"wednesday"];
            }else if (buttonLine == 3){
                schoolTimetableCourseVC.courseDataArray = courseTimeArray[buttonRow][@"con"][@"thursday"];
            }else if (buttonLine == 4){
                schoolTimetableCourseVC.courseDataArray = courseTimeArray[buttonRow][@"con"][@"friday"];
            }else if (buttonLine == 5){
                schoolTimetableCourseVC.courseDataArray = courseTimeArray[buttonRow][@"con"][@"saturday"];
            }else if (buttonLine == 6){
                schoolTimetableCourseVC.courseDataArray = courseTimeArray[buttonRow][@"con"][@"sunday"];
            }
            
        }
        
        
        [self.navigationController pushViewController:schoolTimetableCourseVC animated:YES];   
    }else{
        [self showString:@"请用账号登录后查看" forSecond:1.5];
    }
    

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    page = bgScrollView.contentOffset.y / kHeight;
//    NSLog(@"page ---- %ld", page);
    
    titleCommbox.textField.text = weeksArray[page];
    
//    if (originalTimeArray.count != 0) {
//        [self fetchCourseInfoTraditionStyle:originalTimeArray[page]];
//    }
    if (rightButton.selected == NO) {
        NSLog(@"11111111 === 传统 模式");
        if (originalTimeArray.count != 0) {
            [self fetchCourseInfoTraditionStyle:originalTimeArray[page]];
        }
    }else{
        NSLog(@"222222 ---- 时间轴 模式");
        if (originalTimeArray.count != 0) {
            [self fetchCourseInfoTimeLineStyle:originalTimeArray[page]];
        }
    }
    
}

-(UILabel *)createLabelFrame:(CGRect)frame text:(NSString *)text
{
    UILabel *label=[[UILabel alloc] init];
    label.frame=frame;
    label.text = text;
    label.backgroundColor = [UIColor whiteColor];
    label.layer.cornerRadius = 6;
    label.layer.masksToBounds = YES;
    label.layer.borderColor = [UIColor redColor].CGColor;
    label.layer.borderWidth = 1;
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor redColor];
    return label;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [titleCommbox.textField removeObserver:self forKeyPath:@"text" context:@"1"];

}
@end
