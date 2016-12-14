

//
//  XXEXingClassRoomTeacherDetailInfoViewController.m
//  teacher
//
//  Created by Mac on 16/10/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingClassRoomTeacherDetailInfoViewController.h"
#import "XXEXingClassRoomTeacherHomePageViewController.h"
#import "XXEXingClassRoomTeacherCourseInfoViewController.h"
#import "XXEXingClassRoomTeacherStyleViewController.h"
#import "XXEXingClassRoomTeacherDetailInfoApi.h"
#import "XXEFriendMyCircleViewController.h"
#import "WMConversationViewController.h"
#import "ReportPicViewController.h"
#import "XXEGlobalDecollectApi.h"
#import "XXEGlobalCollectApi.h"
#import "QHNavSliderMenu.h"
#import "UMSocial.h"

@interface XXEXingClassRoomTeacherDetailInfoViewController ()<QHNavSliderMenuDelegate, UIScrollViewDelegate, UMSocialDataDelegate>
{
    QHNavSliderMenu *_navSliderMenu;
    NSMutableDictionary  *_listVCQueue;
    UIScrollView *_contentScrollView;
    int _menuCount;
    //头像
    NSMutableArray *pictureArray;
    //标题
    NSMutableArray *titleArray;
    //内容
    NSMutableArray *contentArray;
    
    //老师 xid
    NSString *teacher_xid;
    //个人 头像
    NSString *headImageStr;
    //头部 视图
    UIView *headerView;
    UIImageView *headerBgImageView;
    UIImageView *iconImageView;
    //添加性别
    UIImageView *manimage;
    
    //下个等级 星币
    NSString *next_grade_coinStr;
    //现有 星币
    NSString *coin_totalStr;
    //等级
    NSString *lvStr;
    UILabel *lvLabel;
    //性别
    UIImage *sexPic;
    //距下等级 还差 多少 个 星币
    UILabel *titleLbl;
    //进度条
    UIProgressView * progressView;
    //用户名
    UILabel *nameLbl;
    NSString *nameStr;
    //个性签名
    NSString *signStr;
    UILabel *signLabel;
    //明天 签到 将 获得 多少 星币
    NSString *numStr;
    UILabel *numLabel;
    //是否 收藏
    BOOL isCollect;
    UIButton *rightBtn;
    UIImage *saveImage;
    
    //课程数组
    NSMutableArray *course_groupArray;
    //教学经历
    NSString *teach_lifeStr;
    //教学感悟
    NSString *teach_feelStr;
    //老师 照片 数组
    NSMutableArray *teacher_pic_groupArray;
    
    //发起聊天 按钮
    UIButton *chartButton;
    //查看圈子 按钮
    UIButton *seeButton;
    //分享 按钮
    UIButton *shareButton;
    //举报 按钮
    UIButton *reportButton;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@property (nonatomic)QHNavSliderMenuType menuType;

@end

@implementation XXEXingClassRoomTeacherDetailInfoViewController

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
    teach_feelStr = @"";
    teach_lifeStr = @"";
    teacher_xid = @"";
    
    [self createRightBar];
    [self fetchNetData];
    [self createHeadView];
    [self createBottomViewButton];
    
}

- (void)fetchNetData{
    
    XXEXingClassRoomTeacherDetailInfoApi *xingClassRoomTeacherDetailInfoApi = [[XXEXingClassRoomTeacherDetailInfoApi alloc] initWithXid:parameterXid user_id:parameterUser_Id teacher_id:_teacher_id];
    
    [xingClassRoomTeacherDetailInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        NSLog(@"111   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSDictionary *dict = request.responseJSONObject[@"data"];
            teacher_xid = dict[@"xid"];
            
            //头像
            NSString * head_img;
            if([[NSString stringWithFormat:@"%@",dict[@"head_img_type"]]isEqualToString:@"0"]){
                head_img=[kXXEPicURL stringByAppendingString:dict[@"head_img"]];
            }else{
                head_img=dict[@"head_img"];
            }
            
            headImageStr = head_img;
            
            /*
             [cheeck_collect] => 1		//是否收藏过 1:收藏过  2:未收藏过
             */
            if ([dict[@"cheeck_collect"] integerValue] == 1) {
                isCollect = YES;
                saveImage = [UIImage imageNamed:@"home_logo_collection_icon44x44"];
                
            }else if([dict[@"cheeck_collect"] integerValue] == 2){
                isCollect = NO;
                saveImage = [UIImage imageNamed:@"home_logo_uncollection_icon44x44"];
            }
            [rightBtn setBackgroundImage:saveImage forState:UIControlStateNormal];
            
            //tname
            nameStr = dict[@"tname"];
            //下等级 星币数
            next_grade_coinStr = dict[@"next_grade_coin"];
            
            //现有 星币数
            coin_totalStr = dict[@"coin_total"];
            
            //现在 等级
            lvStr = dict[@"lv"];
            
            //性别
            if ([dict[@"sex"] isEqualToString:@"男"]) {
                sexPic = [UIImage imageNamed:@"home_men_sex"];
            }else if ([dict[@"sex"] isEqualToString:@"女"]){
                sexPic = [UIImage imageNamed:@"home_women_sex"];
            }
            //个性签名
            NSString *signString = @"";
            if (dict[@"personal_sign"] != nil) {
                signString = dict[@"personal_sign"];
            }
            signStr = [NSString stringWithFormat:@"个性签名:%@", signString];
            //数量 学生
            NSString *studentNumStr = @"0";
            if (dict[@"baby_count"] != nil) {
                studentNumStr = dict[@"baby_count"];
            }
            //数量 收藏
            NSString *collect_numNumStr = @"0";
            if (dict[@"collect"] != nil) {
                collect_numNumStr = dict[@"collect"];
            }
            //数量 浏览
            NSString *browseNumStr = @"0";
            if (dict[@"read_num"] != nil) {
                browseNumStr = dict[@"read_num"];
            }
            
            numStr = [NSString stringWithFormat:@"学生:%@人  收藏:%@次  浏览:%@次", studentNumStr, collect_numNumStr, browseNumStr];
            
            //[certification] => 1	//专业认证  0:没认证  1:已认证
            NSString *str1 = @"";
            if ([dict[@"certification"] integerValue] == 0) {
                str1 = @"已认证";
            }else if ([dict[@"certification"] integerValue] == 1){
                 str1 = @"没认证";
            }
            
            NSString *str2 = @"";
            if (dict[@"exper_year"] != nil) {
                str2 = [NSString stringWithFormat:@"%@年", dict[@"exper_year"]];
            }
            
            //content 内容
            //毕业院校/所学专业/授课范围/教龄/认证/手机/QQ/邮箱/
            contentArray = [[NSMutableArray alloc] initWithObjects:dict[@"graduate_sch"], dict[@"specialty"], dict[@"teach_range"], str2, str1, dict[@"phone"],dict[@"qq"], dict[@"email"],@"", nil];
            
            
            //course_group
            course_groupArray = [[NSMutableArray alloc] initWithArray:dict[@"course_group"]];
            //teacher_pic_group
            teacher_pic_groupArray = [[NSMutableArray alloc] initWithArray:dict[@"teacher_pic_group"]];
            if (dict[@"teach_life"] != nil) {
                teach_lifeStr = dict[@"teach_life"];
            }
            if (dict[@"teach_feel"] != nil) {
                teach_feelStr = dict[@"teach_feel"];
            }
            
        }else{
            
        }
        //        NSLog(@"%@", contentArray);
        
        [self updateHeadViewInfo];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}

- (void)updateHeadViewInfo{
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:headImageStr] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    manimage.image = sexPic;
    
    if (nameStr == nil) {
        nameStr = @" ";
    }
    nameLbl.text = [NSString stringWithFormat:@"%@", nameStr];
    
    if (lvStr == nil) {
        lvStr = @" ";
    }
    lvLabel.text = [NSString stringWithFormat:@"LV%@", lvStr];
    
    //等级  星币 差距
    int a = [next_grade_coinStr intValue];
    int b = [coin_totalStr intValue];
    int c = a - b;
    int d = [lvStr intValue] + 1;
    
    //    NSLog(@"%d  ////   %d  //// %d //// %d", a, b,c,d);
    
//    NSString *titleStr = [NSString stringWithFormat:@"还差%d星币升级到%d级会员  %d/%d", c, d, b, a];
//    titleLbl.text = titleStr;
    progressView.progress = [coin_totalStr floatValue] / [next_grade_coinStr floatValue] ;
    
    signLabel.text = signStr;

    numLabel.text = numStr;
    
    [self createSliderMenu];
}


- (void)createHeadView{
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 180 * kScreenRatioHeight)];
    [self.view addSubview:headerView];
    
    headerBgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 180 * kScreenRatioHeight)];
    headerBgImageView.image = [UIImage imageNamed:@"green_background_banner"];
    headerBgImageView.userInteractionEnabled =YES;
    [headerView addSubview:headerBgImageView];
    
    iconImageView = [[UIImageView alloc] init];
    
    CGFloat iconWidth = 86 * kScreenRatioWidth;
    CGFloat iconHeight = iconWidth;
    
    [iconImageView setFrame:CGRectMake(30 * kScreenRatioWidth, 30 * kScreenRatioHeight, iconWidth, iconHeight)];
    iconImageView.layer.cornerRadius =iconWidth / 2;
    iconImageView.layer.masksToBounds =YES;
    [headerView addSubview:iconImageView];
    iconImageView.userInteractionEnabled =YES;
    
    CGFloat iconBottom = iconImageView.frame.origin.y + iconImageView.frame.size.height;
    
    CGFloat sexWidth = 20  *kScreenRatioWidth;
    CGFloat sexHeight = sexWidth;
    
    manimage = [[UIImageView alloc]initWithFrame:CGRectMake(35 * kScreenRatioWidth, 60 * kScreenRatioHeight, sexWidth, sexHeight)];
    
    [iconImageView addSubview:manimage];
    
    //名称
    CGFloat nameLabelWidth = 150 * kScreenRatioWidth;
    CGFloat nameLabelHeight = 20 * kScreenRatioHeight;
    
    nameLbl =[UILabel createLabelWithFrame:CGRectMake(150 * kScreenRatioWidth, 20 * kScreenRatioHeight, nameLabelWidth, nameLabelHeight) Font:18 * kScreenRatioWidth Text:nil];
    nameLbl.textAlignment = NSTextAlignmentLeft;
    nameLbl.textColor =UIColorFromRGB(255, 255, 255);
    [headerView addSubview:nameLbl];
    
    //等级
    CGFloat lvLabelWidth = 30 * kScreenRatioWidth;
    CGFloat lvLabelHeight = 15 * kScreenRatioHeight;
    
    lvLabel = [UILabel createLabelWithFrame:CGRectMake(300 * kScreenRatioWidth, 22 * kScreenRatioHeight, lvLabelWidth, lvLabelHeight) Font:12 * kScreenRatioWidth Text:@""];
    lvLabel.textColor = UIColorFromRGB(3, 169, 244);
    lvLabel.textAlignment = NSTextAlignmentCenter;
    lvLabel.backgroundColor = [UIColor whiteColor];
    lvLabel.layer.cornerRadius = 5;
    lvLabel.layer.masksToBounds = YES;
    [headerView addSubview:lvLabel];
    
    CGFloat titleLabelWidth = 200 *kScreenRatioWidth;
    CGFloat titleLabelHeight = 35 * kScreenRatioHeight;
    
    signLabel =[UILabel createLabelWithFrame:CGRectMake(150 * kScreenRatioWidth, 50 * kScreenRatioHeight, titleLabelWidth, titleLabelHeight) Font:12 * kScreenRatioWidth Text:@""];
    signLabel.numberOfLines = 0;
    signLabel.textAlignment = NSTextAlignmentLeft;
    signLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:signLabel];
    
    numLabel =[UILabel createLabelWithFrame:CGRectMake(150 * kScreenRatioWidth, 80 * kScreenRatioHeight, titleLabelWidth, titleLabelHeight) Font:12 * kScreenRatioWidth Text:@""];
    numLabel.numberOfLines = 0;
    numLabel.textAlignment = NSTextAlignmentLeft;
    numLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:numLabel];
    
    //中间 进度条
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.frame = CGRectMake(150 * kScreenRatioWidth, 120 * kScreenRatioHeight, 160 * kScreenRatioWidth, 10 * kScreenRatioHeight);
    // 设置已过进度部分的颜色
    progressView.progressTintColor = XXEColorFromRGB(255, 255, 255);
    // 设置未过进度部分的颜色
    progressView.trackTintColor = XXEColorFromRGB(220, 220, 220);
    [headerView addSubview:progressView];
    
}

- (void)createSliderMenu{
   QHNavSliderMenuStyleModel *model = [QHNavSliderMenuStyleModel new];
    NSMutableArray *titles = [[NSMutableArray alloc] initWithObjects:@"主页",@"课程",@"教师风采",nil];
    _menuCount = 3;
    model.menuTitles = [titles copy];
    model.menuWidth=screenWidth / 3.f;
    model.menuHorizontalSpacing = 1;
    model.donotScrollTapViewWhileScroll = YES;
    model.sliderMenuTextColorForNormal = QHRGB(120, 120, 120);
    model.sliderMenuTextColorForSelect = QHRGB(255, 255, 255);
    model.titleLableFont               = defaultFont(16);
    _navSliderMenu = [[QHNavSliderMenu alloc] initWithFrame:(CGRect){0,headerView.size.height - 49,kWidth,49} andStyleModel:model andDelegate:self showType:self.menuType];
    [headerView addSubview:_navSliderMenu];

    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _navSliderMenu.bottom - 10, kWidth, kHeight - _navSliderMenu.bottom-37-64)];
    _contentScrollView.contentSize = (CGSize){kWidth*_menuCount,_contentScrollView.contentSize.height};
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.delegate      = self;
    _contentScrollView.scrollsToTop  = NO;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentScrollView];

    [self addListVCWithIndex:0];

}

#pragma mark -QHNavSliderMenuDelegate
- (void)navSliderMenuDidSelectAtRow:(NSInteger)row {
    [_contentScrollView setContentOffset:CGPointMake(row*screenWidth, _contentScrollView.contentOffset.y)  animated:NO];
}
#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //用scrollView的滑动大小与屏幕宽度取整数 得到滑动的页数
    [_navSliderMenu selectAtRow:(int)((scrollView.contentOffset.x+screenWidth/2.f)/screenWidth) andDelegate:NO];
    //根据页数添加相应的视图
    [self addListVCWithIndex:(int)(scrollView.contentOffset.x/screenWidth)];
    
}

#pragma mark -addVC

- (void)addListVCWithIndex:(NSInteger)index {
    if (!_listVCQueue) {
        _listVCQueue=[[NSMutableDictionary alloc] init];
    }
    if (index<0||index>=_menuCount) {
        return;
    }
    if (index == 0) {
        //根据页数添加相对应的视图 并存入数组
        XXEXingClassRoomTeacherHomePageViewController *xingClassRoomTeacherHomePageVC =[[XXEXingClassRoomTeacherHomePageViewController alloc]init];
//        NSLog(@"%@", contentArray);
        
            xingClassRoomTeacherHomePageVC.contentArray = contentArray;
        xingClassRoomTeacherHomePageVC.teacher_xid = teacher_xid;
        [self addChildViewController:xingClassRoomTeacherHomePageVC];
        [_contentScrollView addSubview:xingClassRoomTeacherHomePageVC.view];
        [_listVCQueue setObject:xingClassRoomTeacherHomePageVC forKey:@(0)];
    }else if (index == 1){
        XXEXingClassRoomTeacherCourseInfoViewController *XingClassRoomTeacherCourseInfoVC = [[XXEXingClassRoomTeacherCourseInfoViewController alloc]init];
            XingClassRoomTeacherCourseInfoVC.course_groupArray = course_groupArray;
        [self addChildViewController:XingClassRoomTeacherCourseInfoVC];
        XingClassRoomTeacherCourseInfoVC.view.left =1*screenWidth;
        XingClassRoomTeacherCourseInfoVC.view.top=0;
        [_contentScrollView addSubview:XingClassRoomTeacherCourseInfoVC.view];
        [_listVCQueue setObject:XingClassRoomTeacherCourseInfoVC forKey:@(1)];

    }else if (index == 2){
        XXEXingClassRoomTeacherStyleViewController *xingClassRoomTeacherStyleVC =[[XXEXingClassRoomTeacherStyleViewController alloc]init];
            xingClassRoomTeacherStyleVC.teacher_pic_groupArray = teacher_pic_groupArray;
        xingClassRoomTeacherStyleVC.teach_feelStr = teach_feelStr;
        xingClassRoomTeacherStyleVC.teach_lifeStr = teach_lifeStr;
        [self addChildViewController:xingClassRoomTeacherStyleVC];
        xingClassRoomTeacherStyleVC.view.left =2*screenWidth;
        xingClassRoomTeacherStyleVC.view.top =0;
        [_contentScrollView addSubview:xingClassRoomTeacherStyleVC.view];
        [_listVCQueue setObject:xingClassRoomTeacherStyleVC forKey:@(2)];
    }
    
}




//创建底部button
- (void)createBottomViewButton{
    //发起聊天/查看圈子/分享/举报
    UIImageView *bottomView= [[UIImageView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 49 - 64, KScreenWidth, 49)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    bottomView.userInteractionEnabled =YES;
    
    CGFloat itemWidth = KScreenWidth / 4;
    CGFloat itemHeight = 49;
    
    CGFloat buttonWidth = itemWidth;
    CGFloat buttonHeight = itemHeight;
    
    //----------------------------发起聊天 ---------
    chartButton = [UIButton createButtonWithFrame:CGRectMake(buttonWidth / 2 * 0, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) backGruondImageName:nil Target:self Action:@selector(chartButtonClick:) Title:@"发起聊天"];
    [chartButton setImage:[UIImage imageNamed:@"classAddress_chart_unseleted_icon"] forState:UIControlStateNormal];
    [chartButton setImage:[UIImage imageNamed:@"classAddress_chart_seleted_icon"] forState:UIControlStateHighlighted];
    chartButton.titleLabel.font = [UIFont systemFontOfSize:10];
    //设置 图片 位置
    chartButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 - 15 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    chartButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -chartButton.titleLabel.bounds.size.width-20, 0, 0);
    [bottomView addSubview:chartButton];
    
    //---------------------------查看圈子 ----------
    seeButton = [UIButton createButtonWithFrame:CGRectMake(buttonWidth, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) backGruondImageName:nil Target:self Action:@selector(seeButtonClick:) Title:@"查看圈子"];
    [seeButton setImage:[UIImage imageNamed:@"classAddress_seeCircle_unseleted_icon"] forState:UIControlStateNormal];
    [seeButton setImage:[UIImage imageNamed:@"classAddress_seeCircle_seleted_icon"] forState:UIControlStateHighlighted];
    seeButton.titleLabel.font = [UIFont systemFontOfSize:10];
    //设置 图片 位置
    seeButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 - 15 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    seeButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -seeButton.titleLabel.bounds.size.width-20 * kScreenRatioWidth, 0, 0);
    [bottomView addSubview:seeButton];
    
    //--------------------------------分享-------
    shareButton = [UIButton createButtonWithFrame:CGRectMake(buttonWidth * 2, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) backGruondImageName:nil Target:self Action:@selector(shareButtonClick:) Title:@"分享"];
    [shareButton setImage:[UIImage imageNamed:@"classAddress_share_unseleted_icon"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"classAddress_share_seleted_icon"] forState:UIControlStateHighlighted];
    shareButton.titleLabel.font = [UIFont systemFontOfSize:10];
    //设置 图片 位置
    shareButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 - 20 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    shareButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -shareButton.titleLabel.bounds.size.width-20, 0, 0);
    [bottomView addSubview:shareButton];
    
    //--------------------------------举报-------
    reportButton = [UIButton createButtonWithFrame:CGRectMake(buttonWidth * 3, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) backGruondImageName:nil Target:self Action:@selector(reportButtonClick:) Title:@"举报"];
    [reportButton setImage:[UIImage imageNamed:@"classAddress_report_unseleted_icon"] forState:UIControlStateNormal];
    [reportButton setImage:[UIImage imageNamed:@"classAddress_report_seleted_icon"] forState:UIControlStateHighlighted];
    reportButton.titleLabel.font = [UIFont systemFontOfSize:10];
    //设置 图片 位置
    reportButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 - 20 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    reportButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -reportButton.titleLabel.bounds.size.width-20, 0, 0);
    [bottomView addSubview:reportButton];
    
}

//发起聊天
- (void)chartButtonClick:(UIButton *)button{
    //    NSLog(@"********发起聊天 *******");
    if ([XXEUserInfo user].login) {
        NSString * userId = [XXEUserInfo user].user_id;
        
        NSString * userNickName = [XXEUserInfo user].nickname;
        
        NSString * userPortraitUri = [XXEUserInfo user].user_head_img;
        
        RCUserInfo *_currentUserInfo =
        [[RCUserInfo alloc] initWithUserId:userId
                                      name:userNickName
                                  portrait:userPortraitUri];
        [RCIM sharedRCIM].currentUserInfo = _currentUserInfo;
        
        WMConversationViewController *vc = [[WMConversationViewController alloc] init];
        
        vc.conversationType = ConversationType_PRIVATE;
        vc.targetId = teacher_xid;
        vc.title = nameStr;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        [self showHudWithString:@"请先用账号登录" forSecond:1.5];
    }
}

//查看圈子
- (void)seeButtonClick:(UIButton *)button{
    
    NSLog(@"********查看圈子 *******");
    if ([XXEUserInfo user].login) {
    XXEFriendMyCircleViewController *friendMyCircleVC = [[XXEFriendMyCircleViewController alloc] init];
    friendMyCircleVC.otherXid = teacher_xid;
    friendMyCircleVC.rootChat = @"猩课堂";
    [self.navigationController pushViewController:friendMyCircleVC animated:YES];
    }else{
        [self showHudWithString:@"请先用账号登录" forSecond:1.5];
    }

}

//分享
- (void)shareButtonClick:(UIButton *)button{

    NSLog(@"********分享 *******");
    NSString *shareText = @"来自猩猩教室:";
    UIImage *shareImage = [UIImage imageNamed:@"xingxingjiaoshi_share_icon"];
    //    snsNames 你要分享到的sns平台类型，该NSArray值是`UMSocialSnsPlatformManager.h`定义的平台名的字符串常量，有UMShareToSina，UMShareToTencent，UMShareToRenren，UMShareToDouban，UMShareToQzone，UMShareToEmail，UMShareToSms等
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMSocialAppKey shareText:shareText shareImage:shareImage shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,nil] delegate:self];
    
    
}

//分享的代理方法
- (void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    NSLog(@"关闭的是%u",fromViewControllerType);
}

//分享完成后的回调
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"信息是什么%@",response);
    //根据responseCode得到发送结果,如果分享成功
    if (response.responseCode == UMSResponseCodeSuccess) {
        //得到分享的微博平台名
        NSLog(@"share to sns name is%@",[[response.data allKeys]objectAtIndex:0]);
    }
    
}

//举报
- (void)reportButtonClick:(UIButton *)button{
    
    NSLog(@"********举报 *******");
    ReportPicViewController * vc=[[ReportPicViewController alloc]init];
    
    /*
     【举报提交】
     接口类型:2
     接口:
     http://www.xingxingedu.cn/Global/report_sub
     传参:
     other_xid	//被举报人xid (举报用户时才有此参数)
     report_name_id	//举报内容id , 多个逗号隔开
     report_type	//举报类型 1:举报用户  2:举报图片
     */
    vc.other_xidStr = teacher_xid;
    vc.report_type = @"1";
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)isDirectShareInIconActionSheet{
    return YES;
}



- (void)createRightBar{
    //设置 navigationBar 右边 收藏
    rightBtn = [UIButton createButtonWithFrame:CGRectMake(kWidth - 100, 0, 22, 22) backGruondImageName:nil Target:self Action:@selector(right:) Title:nil];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)right:(UIButton*)sender{
    
    if (isCollect== NO) {
        
        [self collectArticle];
        
    }
    else  if (isCollect== YES) {
        [self deleteCollectArticle];
        
    }
    
}

//收藏老师
- (void)collectArticle{
    
    XXEGlobalCollectApi *globalCollectApi = [[XXEGlobalCollectApi alloc] initWithXid:parameterXid user_id:parameterUser_Id collect_id:teacher_xid collect_type:@"3"];
    [globalCollectApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
        //        NSLog(@"收藏 -- %@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"收藏成功!" forSecond:1.5];
            [rightBtn setBackgroundImage:[UIImage imageNamed:@"home_logo_collection_icon44x44"] forState:UIControlStateNormal];
            isCollect=!isCollect;
        }else{
            
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"收藏失败!" forSecond:1.5];
    }];
    
}

//取消收藏家人
- (void)deleteCollectArticle{
    
    XXEGlobalDecollectApi *globalDecollectApi = [[XXEGlobalDecollectApi alloc] initWithXid:parameterXid user_id:parameterUser_Id collect_id:teacher_xid collect_type:@"3"];
    [globalDecollectApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
        //        NSLog(@"取消收藏 -- %@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"取消收藏成功!" forSecond:1.5];
            
            [rightBtn setBackgroundImage:[UIImage imageNamed:@"home_logo_uncollection_icon44x44"] forState:UIControlStateNormal];
            isCollect=!isCollect;
        }else{
            
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"取消收藏失败!" forSecond:1.5];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
