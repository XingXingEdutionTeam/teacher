//


//
//  XXEHomeLogoRootViewController.m
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEHomeLogoRootViewController.h"
#import "XXESchoolIntroductionViewController.h"
#import "XXESchoolCourseViewController.h"
#import "XXEHeadmasterSpeechViewController.h"
#import "XXEStarRemarkViewController.h"
#import "XXEHomeLogoApi.h"


@interface XXEHomeLogoRootViewController ()<UIScrollViewDelegate>
{
    UIButton *introductionButton;
    
    UIButton *courseButton;
    
    UIButton *speechButton;
    //学校名称
    UILabel * titleLabel;
    //星级评分
    UIButton *starRankButton;
    //浏览
    UILabel *browseLabel;
    //收藏
    UILabel *collectionLabel;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@property (nonatomic, strong) XXESchoolIntroductionViewController *schoolIntroductionVC;
@property (nonatomic, strong) XXESchoolCourseViewController *schoolCourseVC;
@property (nonatomic, strong) XXEHeadmasterSpeechViewController *headmasterSpeechVC;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) NSMutableArray *contentArray;

//LOGO  图标
@property (nonatomic ,copy) NSString *logoIconStr;
//学校名称
@property (nonatomic, copy) NSString *schoolNameStr;
//学校地址
@property (nonatomic, copy) NSString *schoolAddressStr;
//评分
@property (nonatomic, copy) NSString *score_num;
//浏览
@property (nonatomic, copy) NSString *read_num;
//收藏
@property (nonatomic, copy) NSString *collect_num;

//简介
@property (nonatomic, copy) NSString *introduction;
//课程
@property (nonatomic, strong) NSMutableArray *course_groupArray;
//校长致辞
@property (nonatomic, copy) NSString *pdt_speech;
//校长 头像
@property (nonatomic, copy) NSString *head_img;

//相册
@property (nonatomic) NSMutableArray *school_pic_groupArray;
//视频
@property (nonatomic) NSMutableArray *school_video_groupArray;
//视频 标题
@property (nonatomic) NSMutableArray *school_video_group_titleArray;
//视频 时间
@property (nonatomic) NSMutableArray *school_video_group_timeArray;
//视频 URL
@property (nonatomic) NSMutableArray *school_video_group_urlArray;
//机构 是否 收藏
@property (nonatomic) BOOL isCollected;

@property (nonatomic, copy) NSString *schoolIdStr;

@property (nonatomic, strong) UIImage *saveImage;



@end

@implementation XXEHomeLogoRootViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _course_groupArray = [NSMutableArray array];
        _school_pic_groupArray = [NSMutableArray array];
        _school_video_groupArray = [NSMutableArray array];
        
        
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    [self fetchNetData];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
//    speechButton.selected = NO;
//    courseButton.selected = NO;
//
//    _myScrollView.contentOffset = CGPointMake(0, 0);
    
//    self.navigationItem.title = @"机构简介";
//    UIButton *sentBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 22, 22) backGruondImageName:@"" Target:self Action:@selector(request:) Title:@""];
//    UIBarButtonItem *requestItem =[[UIBarButtonItem alloc]initWithCustomView:sentBtn];
//    self.navigationItem.rightBarButtonItem =requestItem;
    

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    _schoolIntroductionVC = [[XXESchoolIntroductionViewController alloc] init];
    _schoolCourseVC = [[XXESchoolCourseViewController alloc] init];
    _headmasterSpeechVC = [[XXEHeadmasterSpeechViewController alloc] init];
    
    self.schoolIntroductionVC.classId = _classId;
    self.schoolCourseVC.classId = _classId;
    self.headmasterSpeechVC.classId = _classId;
    
    _childViews = [[NSMutableArray alloc] init];
    
    //    self.navigationController.navigationBar.backgroundColor = XXEColorFromRGB(0, 170, 42);
    self.navigationController.navigationBarHidden = YES;
    //    self.navigationController.navigationBar.hidden = YES;
    
    [self createBigScrollView];
    
    [self createImageView];
    
    [self createBottomViewButton];
    
}

- (void)fetchNetData{
    /*
     【猩课堂--学校详情】
     
     接口类型:1
     
     接口:
     http://www.xingxingedu.cn/Global/xkt_school_detail
     
     传参:
     school_id		//学校id*/
    
//    NSLog(@"%@", _schoolId);
    
    XXEHomeLogoApi *homeLogoApi = [[XXEHomeLogoApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE school_id:_schoolId];
    [homeLogoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        NSLog(@"2222---   %@", request.responseJSONObject);
        /*
         [province] => 上海市		//省
         [city] => 上海市			//城市
         [district] => 浦东新区		//区
         [address] => 巨峰路1058弄3号楼	//地址详细
         */
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSDictionary *dic = request.responseJSONObject[@"data"];
            /*
             [cheeck_collect] => 1		//是否收藏过 1:收藏过  2:未收藏过
             */
            if ([dic[@"cheeck_collect"] integerValue] == 1) {
                _isCollected = YES;
                _saveImage = [UIImage imageNamed:@"收藏(H)icon44x44"];
                
            }else if([dic[@"cheeck_collect"] integerValue] == 2){
                _isCollected = NO;
                _saveImage = [UIImage imageNamed:@"收藏icon44x44"];
            }
            [_saveButton setBackgroundImage:_saveImage forState:UIControlStateNormal];
            
            //LOGO 图标
            _logoIconStr = dic[@"logo"];
            //学校 名称
            _schoolNameStr = dic[@"name"];
            _schoolAddressStr = [NSString stringWithFormat:@"%@%@%@%@", dic[@"province"], dic[@"city"], dic[@"district"], dic[@"address"]];
            //评分
            _score_num = dic[@"score_num"];
            //浏览
            _read_num = dic[@"read_num"];
            //收藏
            _collect_num = dic[@"collect_num"];
            
            //资质
            NSString *examine = dic[@"examine"];
            //特点
            NSString *charact = dic[@"charact"];
            //注册教师
            NSString *teacher_num = dic[@"teacher_num"];
            //注册学生
            NSString *baby_num = dic[@"baby_num"];
            //电话
            NSString *tel = dic[@"tel"];
            //QQ
            NSString *qq = dic[@"qq"];
            //邮箱
            NSString *email = dic[@"email"];
            //简介
            _introduction = dic[@"introduction"];
            
            //课程
            _course_groupArray = dic[@"course_group"];
            
            
            //校长致辞
            _pdt_speech = dic[@"pdt_speech"];
            
            //校长 头像 类型
            NSString *head_img_type = dic[@"president_head_img_type"];
            
            //头像
            //判断是否是第三方头像
            //    0 :表示 自己 头像 ，需要添加 前缀
            //    1 :表示 第三方 头像 ，不需要 添加 前缀
            
            if([[NSString stringWithFormat:@"%@",head_img_type]isEqualToString:@"0"]){
                _head_img=[kXXEPicURL stringByAppendingString:dic[@"president_head_img"]];
            }else{
                _head_img=dic[@"president_head_img"];
            }
            
            //相册  是在 相册界面 单独 调的接口

            //视频
            _school_video_groupArray = dic[@"school_video_group"];
            
            if ([dic[@"school_video_group"] count] != 0) {
                
                for (NSDictionary *dicItem in dic[@"school_video_group"]) {
                    
                    NSString *videoUrl = [NSString stringWithFormat:@"%@%@", kXXEPicURL, dicItem[@"url"]];
                    [_school_video_group_urlArray addObject:videoUrl];
                    
                    NSString *titleStr = dicItem[@"title"];
                    [_school_video_group_titleArray addObject:titleStr];
                    
                    NSString *timeStr = dicItem[@"date_tm"];
                    [_school_video_group_timeArray addObject:timeStr];
                    
                }
            }
        
            
            //学校名称/学校地址/注册学生/注册老师/电话/QQ/邮箱/资质/特点/简介/相册/视频
            self.contentArray = [[NSMutableArray alloc] initWithObjects:  _schoolNameStr, _schoolAddressStr,baby_num, teacher_num, tel, qq, email, examine, charact, @"", @"", @"", nil];
           
        }else{
            
        }
        
        [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}


// 数据 更新
- (void)customContent{
  //学校logo
  [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kXXEPicURL, _logoIconStr]] placeholderImage:[UIImage imageNamed:@"头像174x174"]];
    //学校名称
    titleLabel.text = _schoolNameStr;
    
    //星级评分
    NSString *str1 = _score_num;
    [starRankButton setTitle:[NSString stringWithFormat:@"星级评分:%.2f", str1.floatValue] forState:UIControlStateNormal];
    //浏览
    NSString *str2 = _read_num;
    browseLabel.text = [NSString stringWithFormat:@"浏览:%@", str2];
    
    //收藏
    NSString *str3 = _collect_num;
    collectionLabel.text = [NSString stringWithFormat:@"收藏:%@", str3];
    
    introductionButton.selected = YES;
    self.schoolIntroductionVC.contentArray = _contentArray;
    self.schoolIntroductionVC.schoolId = _schoolId;
    [self addChildViewController:self.schoolIntroductionVC];
    [self.myScrollView addSubview:self.schoolIntroductionVC.view];
    self.schoolIntroductionVC.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 49 - 64);
    
}



- (void)createImageView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 120 * kWidth / 375)];
    headView.backgroundColor = UIColorFromRGB(0, 170, 42);
    
    //设置头像
    CGFloat iconWidth = 87.0 * kWidth / 375;
    CGFloat iconHeight = 87.0 * kWidth / 375;
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(iconWidth / 4, headView.frame.size.height / 2 - iconHeight / 2, iconWidth, iconHeight)];
    _iconImageView.layer.cornerRadius = iconWidth / 2;
    _iconImageView.layer.masksToBounds = YES;
    
    [headView addSubview:_iconImageView];
    
    //设置头像右边文字
    titleLabel = [UILabel createLabelWithFrame:CGRectMake(iconWidth * 1.4, headView.frame.size.height / 2 - iconHeight / 2, 150 * kWidth / 375, 30 * kWidth / 375) Font:16 * kWidth / 375 Text:@""];
    titleLabel.textColor = [UIColor whiteColor];
    
    [headView addSubview:titleLabel];
    
    //星级评分
    starRankButton = [UIButton createButtonWithFrame:CGRectMake(iconWidth * 1.4, headView.frame.size.height / 2 - iconHeight / 2 + 30 * kWidth / 375, 100 * kWidth / 375, 40 * kWidth / 375) backGruondImageName:nil Target:self Action:@selector(starRankButtonClick) Title:@""];
    starRankButton.titleLabel.font = [UIFont boldSystemFontOfSize:14 * kWidth / 375];
    [starRankButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [headView addSubview:starRankButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 30 * kWidth / 375, 95 * kWidth / 375, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [starRankButton addSubview:lineView];
    
    
    //浏览
    browseLabel = [UILabel createLabelWithFrame:CGRectMake(iconWidth * 1.4 + 100, headView.frame.size.height / 2 - iconHeight / 2 + 40 * kWidth / 375, 80 * kWidth / 375, 20 * kWidth / 375) Font:14 * kWidth / 375 Text:@""];
    browseLabel.textColor = [UIColor whiteColor];
    [headView addSubview:browseLabel];
    
    
    //收藏
    collectionLabel = [UILabel createLabelWithFrame:CGRectMake(iconWidth * 1.4 + 100 * kWidth / 375 + 80 * kWidth / 375, headView.frame.size.height / 2 - iconHeight / 2 + 40 * kWidth / 375, 100 * kWidth / 375, 20 * kWidth / 375) Font:14 * kWidth / 375 Text:@""];
    collectionLabel.textColor = [UIColor whiteColor];
    [headView addSubview:collectionLabel];
    
    [self.view addSubview:headView];
}

#pragma mark 星级评分 跳转----------------------------------------------
- (void)starRankButtonClick{
    XXEStarRemarkViewController *starRemarkVC = [[XXEStarRemarkViewController alloc] init];
    starRemarkVC.hidesBottomBarWhenPushed = YES;
    starRemarkVC.schoolId = _schoolId;
    [self.navigationController pushViewController:starRemarkVC animated:YES];
    
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
    
    //---------------------------机构简介
    introductionButton = [self createButtonFrame:CGRectMake(buttonWidth / 2 * 0, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) unseletedImageName:@"home_logo_tabbar_introduction_unseletedIcon48x48" seletedImageName:@"home_logo_tabbar_introduction_seletedIcon48x48" title:@"机构简介" unseletedTitleColor:[UIColor lightGrayColor] seletedTitleColor:XXEColorFromRGB(0, 170, 42) font:[UIFont systemFontOfSize:10] target:self action:@selector(tabbarButtonClick:)];
    introductionButton.tag = 10;
    //设置 图片 位置
    introductionButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 - 30 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    introductionButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -introductionButton.titleLabel.bounds.size.width-30, 0, 0);
    [bottomView addSubview:introductionButton];
    
    //---------------------------学校课程
    courseButton = [self createButtonFrame:CGRectMake(buttonWidth, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) unseletedImageName:@"home_logo_tabbar_course_unseletedIcon48x48" seletedImageName:@"home_logo_tabbar_course_seletedIcon48x48" title:@"学校课程" unseletedTitleColor:[UIColor lightGrayColor] seletedTitleColor:XXEColorFromRGB(0, 170, 42) font:[UIFont systemFontOfSize:10] target:self action:@selector(tabbarButtonClick:)];
    courseButton.tag = 11;
    //设置 图片 位置
    courseButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 - 30 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    courseButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -courseButton.titleLabel.bounds.size.width-30, 0, 0);
    [bottomView addSubview:courseButton];
    
    //--------------------------------校长致辞
    speechButton  = [self createButtonFrame:CGRectMake(buttonWidth * 2, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) unseletedImageName:@"home_logo_tabbar_speech_unseletedIcon48x48" seletedImageName:@"home_logo_tabbar_speech_seletedIcon48x48" title:@"校长致辞" unseletedTitleColor:[UIColor lightGrayColor] seletedTitleColor:XXEColorFromRGB(0, 170, 42) font:[UIFont systemFontOfSize:10] target:self action:@selector(tabbarButtonClick:)];
    speechButton.tag = 12;
    //设置 图片 位置
    speechButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 - 30 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    speechButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -speechButton.titleLabel.bounds.size.width-20, 0, 0);
    
    [bottomView addSubview:speechButton];
    
    _buttonArray = [[NSMutableArray alloc] initWithObjects:introductionButton, courseButton, speechButton, nil];
}


- (void)tabbarButtonClick:(UIButton *)button{
    //    NSLog(@"button.tag  ---  %ld", button.tag);
    
    for (UIButton *btn in _buttonArray) {
        btn.selected = NO;
    }
    
    button.selected = YES;
    
    _myScrollView.contentOffset = CGPointMake(KScreenWidth * (button.tag - 10), 0);
    
    if (button == introductionButton) {
        self.navigationItem.title = @"机构简介";
        
//        UIButton *collectionBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 22, 22) backGruondImageName:@"comment_request_icon" Target:self Action:@selector(collectionBtnClick:) Title:@""];
//        UIBarButtonItem *requestItem =[[UIBarButtonItem alloc]initWithCustomView:collectionBtn];
//        self.navigationItem.rightBarButtonItem =requestItem;
        
        
        self.schoolIntroductionVC.contentArray = _contentArray;
        self.schoolIntroductionVC.schoolId = _schoolId;
        [self addChildViewController:self.schoolIntroductionVC];
        [self.myScrollView addSubview:self.schoolIntroductionVC.view];
        self.schoolIntroductionVC.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 49 - 64);
        
    }else if (button == courseButton){
        self.navigationItem.title = @"学校课程";
        self.navigationItem.rightBarButtonItem = nil;
        self.schoolCourseVC.schoolId = _schoolId;
//        NSLog(@"%@", _course_groupArray);
        self.schoolCourseVC.course_groupArray = _course_groupArray;
        [self addChildViewController:self.schoolCourseVC];
        [self.myScrollView addSubview:self.schoolCourseVC.view];
        self.schoolCourseVC.view.frame = CGRectMake(KScreenWidth, 0, KScreenWidth, KScreenHeight - 49 - 64);
        
    }else if (button == speechButton){
        self.navigationItem.title = @"校长致辞";
        
//        UIButton *sentBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 22, 22) backGruondImageName:@"home_redflower_sent" Target:self Action:@selector(sent:) Title:@""];
//        UIBarButtonItem *sentItem =[[UIBarButtonItem alloc]initWithCustomView:sentBtn];
//        self.navigationItem.rightBarButtonItem =sentItem;
        self.headmasterSpeechVC.schoolId = _schoolId;
        self.headmasterSpeechVC.pdt_speech = _pdt_speech;
        self.headmasterSpeechVC.head_img = _head_img;
        [self addChildViewController:self.headmasterSpeechVC];
        [self.myScrollView addSubview:self.headmasterSpeechVC.view];
        self.headmasterSpeechVC.view.frame = CGRectMake(KScreenWidth * 2, 0, KScreenWidth, KScreenHeight - 49 - 64);
    }
    
    
}

- (void)request:(UINavigationItem *)item{
    
    //    NSLog(@"点评 请求");
    
//    XXECommentStudentViewController *commentStudentVC = [[XXECommentStudentViewController alloc] init];
//    
//    commentStudentVC.schoolId = _schoolId;
//    commentStudentVC.classId = _classId;
//    
//    [self.navigationController pushViewController:commentStudentVC animated:YES];
}

- (void)sent:(UIButton *)button{
    
    //    NSLog(@"小红花");
    
//    XXESentToPeopleViewController *sentToPeopleVC = [[XXESentToPeopleViewController alloc] init];
//    
//    sentToPeopleVC.schoolId = _schoolId;
//    sentToPeopleVC.classId = _classId;
//    //    sentToPeopleVC.basketNumStr = _RedFlowerSentHistoryVC.flower_able;
//    
//    [self.navigationController pushViewController:sentToPeopleVC animated:YES];
    
}



- (void)createBigScrollView{
    
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 120, KScreenWidth, KScreenHeight - 64 - 49)];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
