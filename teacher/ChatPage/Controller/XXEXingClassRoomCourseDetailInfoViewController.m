
//
//  XXEXingClassRoomCourseDetailInfoViewController.m
//  teacher
//
//  Created by Mac on 16/10/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingClassRoomCourseDetailInfoViewController.h"
#import "XXEXingClassRoomBuyCourseViewController.h"
#import "XXEXingClassRoomCourseDetailInfoApi.h"
#import "XXEImageBrowsingViewController.h"
#import "WMConversationViewController.h"
#import "XXEConfirmCourseOrderApi.h"
#import "XXEGlobalDecollectApi.h"
#import "XXEGlobalCollectApi.h"
#import "UMSocial.h"

#define Kmarg 15.0f
#define KLabelX 20.0f
#define KLabelW 65.0f
#define KLabelH 30.0f
#define kUnderButtonH 64.0f

@interface XXEXingClassRoomCourseDetailInfoViewController ()<UMSocialDataDelegate>
{

    UIScrollView *bgScrollView;
    UIScrollView *scrollView;//课程详情图片滚动
    //课程 详情
    NSString *details;
    //课程 名称
    NSString *course_name;
    //图片 数组
    NSMutableArray *picGroup;
    
    BOOL isCollect;
    UIImage *saveImage;
    UIButton *rightBtn;
    NSInteger picRow;
    
    UIButton *_buyBtn;
    
    NSMutableArray *detailedLabelArr;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXEXingClassRoomCourseDetailInfoViewController

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
    
    [self getSubjectInfo:_course_id];
    [self createRightBar];
}

#pragma mark 网络 获取课程详情
//获取课程列表
- (void)getSubjectInfo:(NSString *)courseId
{
    XXEXingClassRoomCourseDetailInfoApi *xingClassRoomCourseDetailInfoApiApi = [[XXEXingClassRoomCourseDetailInfoApi alloc] initWithXid:parameterXid user_id:parameterUser_Id course_id:_course_id];
    [xingClassRoomCourseDetailInfoApiApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//        NSLog(@"kk %@", request.responseJSONObject);
        //
        if ([request.responseJSONObject[@"code"] integerValue] == 1) {
            
            NSDictionary *dict = request.responseJSONObject[@"data"];
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
            //课程名称
            course_name = dict[@"course_name"];
            self.title = course_name;
            //老师名字
            NSString * tname = [NSString stringWithFormat:@"%@",[dict[@"teacher_tname"][0] objectForKey:@"tname"]];
            //机构
            NSString * school_name = [NSString stringWithFormat:@"%@",dict[@"school_name"]];
            //浏览
            NSString * read_num = [NSString stringWithFormat:@"%@次",dict[@"read_num"]];
            //收藏
            NSString * collect_num = [NSString stringWithFormat:@"%@次",dict[@"collect_num"]];
            //招生人数
            NSString * need_num =[NSString stringWithFormat:@"%@",dict[@"need_num"]];
            //适用人群
            NSString * age =[NSString stringWithFormat:@"%@岁到%@岁",dict[@"age_up"],dict[@"age_down"]];
            //教学目标
            NSString * teach_goal = [NSString stringWithFormat:@"%@",dict[@"teach_goal"]];
            //上课时间
            NSString * course_time_str = [NSString stringWithFormat:@"%@",dict[@"course_time_str"]];
            //上课地址
            NSString *  address = [NSString stringWithFormat:@"%@",dict[@"address"]];
            //插班规则
            NSString * middle_in_rule =[NSString stringWithFormat:@"%@",dict[@"middle_in_rule"]];
            //退班规则
            NSString * quit_rule = [NSString stringWithFormat:@"%@",dict[@"quit_rule"]];
            //原价
            NSString * original_price = [NSString stringWithFormat:@"%@元",dict[@"original_price"]];
            //现价
            NSString * now_price = [NSString stringWithFormat:@"%@元",dict[@"now_price"]];
            //课程详情
            details = [NSString stringWithFormat:@"%@",dict[@"details"]];
            //课程ID
            
            //课程详情图片
            picGroup = [[NSMutableArray alloc] initWithArray:dict[@"course_pic_group"]];
            detailedLabelArr = [[NSMutableArray alloc] initWithObjects:tname,school_name,read_num,collect_num,need_num,age,teach_goal,course_time_str,address,middle_in_rule,quit_rule,original_price,now_price,nil];
            
//            NSLog(@"pp %@", detailedLabelArr);
            
            [self scrollViewUI];

            
        }
        
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"数据请求失败!" forSecond:1.5];
    }];

}



-(void)scrollViewUI{
    NSMutableArray *nameLabelArr = [[NSMutableArray alloc] initWithObjects:@"授课老师:",@"机构名称:",@"浏览次数:",@"收藏次数:",@"招生人数:",@"适用人群:",@"教学目标:",@"上课时间:",@"上课地址:",@"插班规则:",@"退班规则:",@"原       价:",@"现       价:",nil];
    
    //背景
    bgScrollView = [[UIScrollView alloc] init];
    bgScrollView.frame = CGRectMake(0, 0, kWidth,kHeight + 64 + 49);
    bgScrollView.backgroundColor = [UIColor whiteColor];
    bgScrollView.pagingEnabled = NO;
    bgScrollView.showsHorizontalScrollIndicator = YES;
    bgScrollView.showsVerticalScrollIndicator  = YES;
    bgScrollView.alwaysBounceVertical = YES;
    [self.view addSubview:bgScrollView];
    
    for (int i = 0; i < nameLabelArr.count; i ++) {
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(KLabelX, KLabelH * i + Kmarg , KLabelW, KLabelH)];
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.text = nameLabelArr[i];
        [bgScrollView addSubview:nameLabel];
        if (i == 7) {
            UITextView *detailedText = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame) + Kmarg, KLabelH * 7 + Kmarg , kWidth - CGRectGetMaxX(nameLabel.frame) - KLabelH , 25)];
            detailedText.text = detailedLabelArr[7];
            detailedText.font = [UIFont systemFontOfSize:12];
            detailedText.userInteractionEnabled = YES;
            detailedText.editable = NO;
            detailedText.textColor = [UIColor grayColor];
            [bgScrollView addSubview:detailedText];
        }else{
            UITextField *detailedText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame) + Kmarg, KLabelH * i + Kmarg, kWidth - CGRectGetMaxX(nameLabel.frame) - KLabelH , KLabelH)];
            detailedText.text = detailedLabelArr[i];
            detailedText.borderStyle = UITextBorderStyleNone;
            detailedText.font = [UIFont systemFontOfSize:12];
            detailedText.userInteractionEnabled = NO;
            detailedText.textColor = [UIColor grayColor];
            [bgScrollView addSubview:detailedText];
            
            //判断是否允许插班 退班
            if (i == 9) {
                if ([detailedLabelArr[9] isEqualToString:@"1"]) {
                    detailedText.text = @"是";
                }else{
                    detailedText.text = @"否";
                }
            }
            if (i == 10) {
                if ([detailedLabelArr[10] isEqualToString:@"1"]) {
                    detailedText.text = @"是";
                }else{
                    detailedText.text = @"否";
                }
            }
        }
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(KLabelX, KLabelH * (i+1) + 12, kWidth - KLabelX * 2, 1)];
        line.backgroundColor = UIColorFromRGB(204, 204, 204);
        [bgScrollView addSubview:line];
    }
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, KLabelH * 13 + 12, kWidth , 5)];
    lineView.backgroundColor = UIColorFromRGB(204, 204, 204);
    [bgScrollView addSubview:lineView];
    
    //课程说明
    
    UILabel *subjectSay = [UILabel createLabelWithFrame:CGRectMake(KLabelX, CGRectGetMaxY(lineView.frame) + KLabelX, KLabelW, KLabelH) Font:14 Text:@"课程说明:"];
    [bgScrollView addSubview:subjectSay];
    
    UILabel *xingMoneyLabel = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMaxX(subjectSay.frame) + Kmarg, CGRectGetMaxY(lineView.frame) + KLabelX, 150, KLabelH) Font:12 Text:@"(此课程可抵扣猩币上限1%)"];
    xingMoneyLabel.textColor = [UIColor grayColor];
    //    xingMoneyLabel.backgroundColor = [UIColor redColor];
    [bgScrollView addSubview:xingMoneyLabel];
    
    
    UITextView *subjectSayView = [[UITextView alloc] initWithFrame:CGRectMake(KLabelX, CGRectGetMaxY(subjectSay.frame) + Kmarg, kWidth - KLabelX *2, 120)];
    subjectSayView.text = details;
    subjectSayView.font = [UIFont systemFontOfSize:12];
    subjectSayView.userInteractionEnabled = NO;
    [subjectSayView flashScrollIndicators];   // 闪动滚动条
    //自动适应行高
    static CGFloat maxHeight = 130.0f;
    CGRect frame = subjectSayView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [subjectSayView sizeThatFits:constraintSize];
    if (size.height >= maxHeight){
        size.height = maxHeight;
        subjectSayView.scrollEnabled = YES;   // 允许滚动
    }
    else{
        subjectSayView.scrollEnabled = NO;    // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况
    }
    subjectSayView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    [bgScrollView addSubview:subjectSayView];
    
    
    //    NSLog(@"picGroup --  %@", picGroup);
    if (picGroup.count % 4 == 0) {
        picRow = picGroup.count / 4;
    }else{
        
        picRow = picGroup.count / 4 + 1;
    }
    //创建 十二宫格  三行、四列
    //              int totalLine = 4;
    //              int buttonCount = 12;
    int margin = 5;
    
    
    CGFloat picWidth = (kWidth - 5 * margin) / 4;
    CGFloat picHeight = picWidth;
    
    for (int i = 0; i < picGroup.count; i++) {
        
        //行
        int buttonRow = i / 4;
        
        //列
        int buttonLine = i % 4;
        
        CGFloat buttonX =  KLabelX + (picWidth + margin) * buttonLine;
        CGFloat buttonY = CGRectGetMaxY(subjectSayView.frame) + Kmarg + (picHeight + margin) * buttonRow;
        
        UIImageView *pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(buttonX, buttonY, picWidth, picHeight)];
        
        [pictureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, picGroup[i]]]];
        pictureImageView.tag = 20 + i;
        pictureImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickPicture:)];
        [pictureImageView addGestureRecognizer:tap];
        
        [bgScrollView addSubview:pictureImageView];
        
    }
    
    
    CGFloat maxH =  CGRectGetMaxY(scrollView.frame) + 1000;
    bgScrollView.contentSize = CGSizeMake(0, maxH);
    
    //创建底部button
    [self butttomBtn];
    
}


- (void)onClickPicture:(UITapGestureRecognizer *)tap{
    
    XXEImageBrowsingViewController * imageBrowsingVC = [[XXEImageBrowsingViewController alloc] init];
    
    imageBrowsingVC.imageUrlArray = picGroup;
    imageBrowsingVC.currentIndex = tap.view.tag - 20;
    //举报 来源 3:猩课堂发布的课程图片
    imageBrowsingVC.origin_pageStr = @"3";
    
    [self.navigationController pushViewController:imageBrowsingVC animated:YES];
    
}

-(void)butttomBtn {
    UIView *underButton = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 50, kWidth, 50)];
    [self.view addSubview:underButton];
    [self.view bringSubviewToFront:underButton];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 1)];
    line.backgroundColor = UIColorFromRGB(239, 232, 233);
    [underButton addSubview:line];
    //咨询按钮
    UIButton *talkBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 1, kWidth/2, kUnderButtonH)];
    [talkBtn setImage:[UIImage imageNamed:@"consult_unseleted_icon48x48"] forState:UIControlStateNormal];
    [talkBtn setImage:[UIImage imageNamed:@"consult_seleted_icon48x48"] forState:UIControlStateHighlighted];
    talkBtn.imageEdgeInsets = UIEdgeInsetsMake(5,(kWidth/2 - 24)/2,30,(kWidth/2 - 24)/2);
    talkBtn.imageView.frame = CGRectMake(0, 0, 24, 24);
    [talkBtn setTitle:@"咨询" forState:UIControlStateNormal];
    [talkBtn setTitleColor:UIColorFromRGB(159,159,159) forState:UIControlStateNormal];
    [talkBtn setTitleColor:UIColorFromRGB(0,172,54) forState:UIControlStateHighlighted];
    talkBtn.titleEdgeInsets = UIEdgeInsetsMake(20, - talkBtn.titleLabel.bounds.size.width - 25, 0, 0);
    talkBtn.backgroundColor =[UIColor whiteColor];
    talkBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [talkBtn addTarget:self action:@selector(clickchatBtn:) forControlEvents:UIControlEventTouchUpInside];
    [underButton addSubview:talkBtn];
    
    //分享按钮
    UIButton *shareBtn= [[UIButton alloc]initWithFrame:CGRectMake(kWidth/2, 1, kWidth/2, kUnderButtonH)];
    [shareBtn setImage:[UIImage imageNamed:@"classAddress_share_unseleted_icon"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"classAddress_share_seleted_icon"] forState:UIControlStateHighlighted];
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(5,(kWidth/2 - 24)/2,30,(kWidth/2 - 24)/2);
    shareBtn.imageView.frame = CGRectMake(0, 0, 24, 24);
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:UIColorFromRGB(159,159,159) forState:UIControlStateNormal];
    [shareBtn setTitleColor:UIColorFromRGB(0,172,54) forState:UIControlStateHighlighted];
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(20, -shareBtn.titleLabel.bounds.size.width - 25, 0, 0);
    shareBtn.backgroundColor = [UIColor whiteColor];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [shareBtn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [underButton addSubview:shareBtn];
    
    //购买按钮
//    _buyBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth/3 * 2,1,kWidth/3, kUnderButtonH)];
//    [_buyBtn  setImage:[UIImage imageNamed:@"buy_unseleted_icon48x48"] forState:UIControlStateNormal];
//    [_buyBtn setImage:[UIImage imageNamed:@"buy_seleted_icon48x48"] forState:UIControlStateHighlighted];
//    _buyBtn.imageEdgeInsets = UIEdgeInsetsMake(5,(kWidth/3 - 24)/2,30,(kWidth/3 - 24)/2);
//    _buyBtn.imageView.frame = CGRectMake(0, 0, 24, 24);
//    [_buyBtn setTitle:@"购买" forState:UIControlStateNormal];
//    [_buyBtn  setTitleColor:UIColorFromRGB(159,159,159) forState:UIControlStateNormal];
//    [_buyBtn setTitleColor:UIColorFromRGB(0,172,54) forState:UIControlStateHighlighted];
//    _buyBtn.titleEdgeInsets = UIEdgeInsetsMake(20, -_buyBtn.titleLabel.bounds.size.width - 20, 0, 0);
//    _buyBtn.backgroundColor =[UIColor whiteColor];
//    _buyBtn.titleLabel.font = [UIFont systemFontOfSize:10];
//    [_buyBtn  addTarget:self action:@selector(clickBuyBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [underButton addSubview:_buyBtn ];
    
//    //间隔线
//    for (NSUInteger i = 1; i < 3; i++) {
//        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(i* kWidth/3 + 2,10, 1, 30)];
//        line.backgroundColor = [UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3];
//        
//        [underButton addSubview:line];
//        
//    }
}

//发起聊天
- (void)clickchatBtn:(UIButton*)btn{
    //    NSLog(@"聊聊");
//    if ([XXEUserInfo user].login) {
//        NSString * userId = [XXEUserInfo user].user_id;
//        
//        NSString * userNickName = [XXEUserInfo user].nickname;
//        
//        NSString * userPortraitUri = [XXEUserInfo user].user_head_img;
//        
//        RCUserInfo *_currentUserInfo =
//        [[RCUserInfo alloc] initWithUserId:userId
//                                      name:userNickName
//                                  portrait:userPortraitUri];
//        [RCIM sharedRCIM].currentUserInfo = _currentUserInfo;
//        
//        WMConversationViewController *chatPrivateVC = [[WMConversationViewController alloc]init];
//        
//        chatPrivateVC.conversationType = ConversationType_PRIVATE;
//        chatPrivateVC.targetId = @"18886064";
//        chatPrivateVC.title = @"想要显示的会话标题";
//    
//        [self.navigationController pushViewController:chatPrivateVC animated:YES];
//    }else{
//    
//        [self showHudWithString:@"请先用账号登录" forSecond:1.5];
//    }
    
}

// 购买
- (void)clickBuyBtn:(UIButton*)btn{
    
    [self getSubjectBuyInfo];
    
}


-(void)getSubjectBuyInfo{
    XXEConfirmCourseOrderApi *confirmCourseOrderApi = [[XXEConfirmCourseOrderApi alloc] initWithXid:parameterXid user_id:parameterUser_Id course_id:_course_id];
    [confirmCourseOrderApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
//        NSLog(@"%@", request.responseJSONObject);
        
        if ([request.responseJSONObject[@"code"] integerValue] == 1) {
            XXEXingClassRoomBuyCourseViewController *xingClassRoomBuyCourseVC = [[XXEXingClassRoomBuyCourseViewController alloc] init];
            
            xingClassRoomBuyCourseVC.dict = request.responseJSONObject[@"data"];
            
            xingClassRoomBuyCourseVC.course_id = _course_id;
            
            [self.navigationController pushViewController:xingClassRoomBuyCourseVC animated:YES];

        }else{
            _buyBtn.userInteractionEnabled = NO;
            [self showHudWithString:@"人数已满,无法报名" forSecond:1.5];
        
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"获取数据失败!" forSecond:1.5];
    }];

}
//分享功能
- (void)clickShareBtn:(UIButton*)btn{
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
    
    XXEGlobalCollectApi *globalCollectApi = [[XXEGlobalCollectApi alloc] initWithXid:parameterXid user_id:parameterUser_Id collect_id:_course_id collect_type:@"4"];
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
    
    XXEGlobalDecollectApi *globalDecollectApi = [[XXEGlobalDecollectApi alloc] initWithXid:parameterXid user_id:parameterUser_Id collect_id:_course_id collect_type:@"4"];
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
