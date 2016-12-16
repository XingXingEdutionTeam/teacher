//
//  XXEBabyFamilyInfoDetailViewController.m
//  teacher
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBabyFamilyInfoDetailViewController.h"
#import "XXEPermissionSettingViewController.h"
#import "XXERedFlowerDetialTableViewCell.h"
#import "WMConversationViewController.h"
#import "XXEBabyFamilyInfoDetailApi.h"
#import "ReportPicViewController.h"
#import "XXEGlobalDecollectApi.h"
#import "XXEGlobalCollectApi.h"
#import "UMSocial.h"
#import "XXEFriendMyCircleViewController.h"

@interface XXEBabyFamilyInfoDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    NSMutableArray *_dataSourceArray;
    
    //头像
    NSMutableArray *pictureArray;
    //标题
    NSMutableArray *titleArray;
    //内容
    NSMutableArray *contentArray;
    //宝贝 头像
    NSString *headImageStr;
    UIImage *headImg;
    NSString *parameterXid;
    NSString *parameterUser_Id;
    //头部 视图
    UIView *headerView;
    UIImageView *headerBgImageView;
    UIImageView *iconImageView;
    //下个等级 星币
    NSString *next_grade_coinStr;
    //现有 星币
    NSString *coin_totalStr;
    //等级
    NSString *lvStr;
    //性别
    UIImage *sexPic;
    //右边 收藏
    UIButton *rightBtn;
    //
    UIImage *saveImage;
    //家人 xid
    NSString *familyXidStr;
    //发起聊天 按钮
    UIButton *chartButton;
    //查看圈子 按钮
    UIButton *seeButton;
    //分享 按钮
    UIButton *shareButton;
    //举报 按钮
    UIButton *reportButton;
}


@end

@implementation XXEBabyFamilyInfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

    
    if ([_fromFlagStr isEqualToString:@"fromCollection"]) {
        pictureArray = [[NSMutableArray alloc] initWithObjects:@"babyinfo_nickname_icon", @"babyinfo_tname_icon", @"home_logo_phone_icon40x40", @"home_logo_email_icon40x40", @"family_setting_icon", nil];
        
        titleArray = [[NSMutableArray alloc] initWithObjects:@"昵称:",@"姓名:", @"电话号码:",@"邮箱:",@"权限设置", nil];
    }else{
        pictureArray = [[NSMutableArray alloc] initWithObjects:@"babyinfo_nickname_icon", @"babyinfo_tname_icon", @"babyinfo_relation_icon",@"home_logo_phone_icon40x40", @"home_logo_email_icon40x40", @"family_setting_icon", nil];
        
        titleArray = [[NSMutableArray alloc] initWithObjects:@"昵称:",@"姓名:", @"关系:", @"电话号码:",@"邮箱:",@"权限设置", nil];
    }
    
    [self fetchNetData];
    [self createTableView];
    [self createRightBar];
    [self createBottomViewButton];
}

- (void)fetchNetData{
    
    if (_baby_id == nil) {
        _baby_id = @"";
    }

    XXEBabyFamilyInfoDetailApi *babyFamilyInfoDetailApi = [[XXEBabyFamilyInfoDetailApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE baby_id:_baby_id parent_id:_parent_id];
    
    [babyFamilyInfoDetailApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//    NSLog(@"111   %@", request.responseJSONObject);

        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            
            
            NSDictionary *dict = request.responseJSONObject[@"data"];
            self.familyMemberName = dict[@"tname"];
            if ([_fromFlagStr isEqualToString:@"fromCollection"]) {
                //@"昵称:",@"姓名:",@"电话号码:",@"邮箱:",@"权限设置"
                contentArray = [[NSMutableArray alloc] initWithObjects:dict[@"nickname"], dict[@"tname"], dict[@"phone"], dict[@"email"],@"", nil];
            }else{
                //@"昵称:",@"姓名:",@"电话号码:",@"邮箱:",@"权限设置"
                contentArray = [[NSMutableArray alloc] initWithObjects:dict[@"nickname"], dict[@"tname"], dict[@"relation"], dict[@"phone"], dict[@"email"],@"", nil];
            }
            

            //头像
            NSString * head_img;
            if([[NSString stringWithFormat:@"%@",dict[@"head_img_type"]]isEqualToString:@"0"]){
                head_img=[kXXEPicURL stringByAppendingString:dict[@"head_img"]];
            }else{
                head_img=dict[@"head_img"];
            }
            
            headImageStr = head_img;
            
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
            
            //家人 Xid
            familyXidStr = dict[@"xid"];
            
            /*
             [cheeck_collect] => 1		//是否收藏过 1:收藏过  2:未收藏过
             */
            if ([dict[@"cheeck_collect"] integerValue] == 1) {
                _isCollected = YES;
                saveImage = [UIImage imageNamed:@"home_logo_collection_icon44x44"];
                
            }else if([dict[@"cheeck_collect"] integerValue] == 2){
                _isCollected = NO;
                saveImage = [UIImage imageNamed:@"home_logo_uncollection_icon44x44"];
            }
            [rightBtn setBackgroundImage:saveImage forState:UIControlStateNormal];
        }else{
            
        }
        [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}



// 有数据 和 无数据 进行判断
- (void)customContent{
    
    if (contentArray.count == 0) {
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
    
}



- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];
}


#pragma mark
#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXERedFlowerDetialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXERedFlowerDetialTableViewCell" owner:self options:nil]lastObject];
    }
    
    cell.iconImageView.image = [UIImage imageNamed:pictureArray[indexPath.row]];
    cell.titleLabel.text = titleArray[indexPath.row];
    cell.contentLabel.text = contentArray[indexPath.row];
    
    if ([_fromFlagStr isEqualToString:@"fromCollection"]) {
        if (indexPath.row == 4) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else{
        if (indexPath.row == 5) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([_fromFlagStr isEqualToString:@"fromCollection"]) {
        if (indexPath.row == 4) {
            XXEPermissionSettingViewController *permissionSettingVC = [[XXEPermissionSettingViewController alloc] init];
            
            permissionSettingVC.XIDStr = familyXidStr;
            [self.navigationController pushViewController:permissionSettingVC animated:YES];        }
    }else{
        if (indexPath.row == 5) {
            XXEPermissionSettingViewController *permissionSettingVC = [[XXEPermissionSettingViewController alloc] init];
            
            permissionSettingVC.XIDStr = familyXidStr;
            [self.navigationController pushViewController:permissionSettingVC animated:YES];        }
    }

}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 150 * kScreenRatioHeight)];
    
    headerBgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 150 * kScreenRatioHeight)];
    headerBgImageView.image = [UIImage imageNamed:@"green_background_banner"];
    headerBgImageView.userInteractionEnabled =YES;
    [headerView addSubview:headerBgImageView];

    iconImageView = [[UIImageView alloc] init];
    
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:headImageStr] placeholderImage:[UIImage imageNamed:@"headplaceholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        headImg = image;
    }];
    
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:headImageStr] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    
    CGFloat iconWidth = 86 * kScreenRatioWidth;
    CGFloat iconHeight = iconWidth;
    
    [iconImageView setFrame:CGRectMake(30 * kScreenRatioWidth, 30 * kScreenRatioHeight, iconWidth, iconHeight)];
    iconImageView.layer.cornerRadius = iconWidth / 2;
    iconImageView.layer.masksToBounds =YES;
    [headerView addSubview:iconImageView];
    iconImageView.userInteractionEnabled =YES;
    
    //添加性别
    CGFloat sexWidth = 20 * kScreenRatioWidth;
    CGFloat sexHeight = sexWidth;
    
    UIImageView *manimage = [[UIImageView alloc]initWithFrame:CGRectMake(35 * kScreenRatioWidth, 60 * kScreenRatioHeight, sexWidth, sexHeight)];
    manimage.image = sexPic;
    [iconImageView addSubview:manimage];
    
    CGFloat buttonWidth = 80 * kScreenRatioWidth;
    CGFloat buttonHeight = 30 * kScreenRatioHeight;
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(iconImageView.frame.origin.x+50 * kScreenRatioWidth ,iconImageView.frame.size.width+iconImageView.frame.origin.y+10 * kScreenRatioHeight, buttonWidth, buttonHeight)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //用户名
    CGFloat nameLabelWidth = 150 * kScreenRatioWidth;
    CGFloat nameLabelHeight = 20 * kScreenRatioHeight;
    
    UILabel *nameLbl =[UILabel createLabelWithFrame:CGRectMake(150 * kScreenRatioWidth, 40 * kScreenRatioHeight, nameLabelWidth, nameLabelHeight) Font:18 * kScreenRatioWidth Text:nil];
    nameLbl.text = contentArray[1];
    nameLbl.textAlignment = NSTextAlignmentLeft;
    nameLbl.textColor =UIColorFromRGB(255, 255, 255);
    [headerView addSubview:nameLbl];
    
    //等级
    NSString *lvString = [NSString stringWithFormat:@"LV%@", lvStr];
    CGFloat lvLabelWidth = 30 * kScreenRatioWidth;
    CGFloat lvLabelHeight = 15 * kScreenRatioHeight;
    
    UILabel *lvLabel = [UILabel createLabelWithFrame:CGRectMake(300 * kScreenRatioWidth, 42 * kScreenRatioHeight, lvLabelWidth, lvLabelHeight) Font:12 * kScreenRatioWidth Text:lvString];
    lvLabel.textColor = UIColorFromRGB(3, 169, 244);
    lvLabel.textAlignment = NSTextAlignmentCenter;
    lvLabel.backgroundColor = [UIColor whiteColor];
    lvLabel.layer.cornerRadius = 5;
    lvLabel.layer.masksToBounds = YES;
    [headerView addSubview:lvLabel];
    
    //等级  星币 差距
    int a = [next_grade_coinStr intValue];
    int b = [coin_totalStr intValue];
    int c = a - b;
    int d = [lvStr intValue] + 1;
    
    NSString *titleStr = [NSString stringWithFormat:@"还差%d星币升级到%d级会员  %d/%d", c, d, b, a];
    
    CGFloat titleLabelWidth = 200 * kScreenRatioWidth;
    CGFloat titleLabelHeight = 35 * kScreenRatioHeight;
    
    UILabel *titleLbl =[UILabel createLabelWithFrame:CGRectMake(150 * kScreenRatioWidth, 70 * kScreenRatioHeight, titleLabelWidth, titleLabelHeight) Font:12 *kScreenRatioWidth Text:titleStr];
    titleLbl.numberOfLines = 0;
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.text = titleStr;
    
    titleLbl.textColor = [UIColor whiteColor];
    
    [headerView addSubview:titleLbl];
    
    //中间 进度条
    UIProgressView * progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];

    progressView.frame = CGRectMake(150 * kScreenRatioWidth, 110 * kScreenRatioHeight, 150 * kScreenRatioWidth, 10 * kScreenRatioHeight);
    // 设置已过进度部分的颜色
    progressView.progressTintColor = XXEColorFromRGB(255, 255, 255);
    // 设置未过进度部分的颜色
    progressView.trackTintColor = XXEColorFromRGB(220, 220, 220);
    progressView.progress = [coin_totalStr floatValue] / [next_grade_coinStr floatValue] ;
    [headerView addSubview:progressView];
    
    return headerView;
}

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
    seeButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -seeButton.titleLabel.bounds.size.width-20, 0, 0);
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

    NSLog(@"********发起聊天 *******");
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
        vc.targetId = familyXidStr;
        vc.title = contentArray[1];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        [self showHudWithString:@"请先用账号登录" forSecond:1.5];
    }
}

//查看圈子
- (void)seeButtonClick:(UIButton *)button{
    XXEFriendMyCircleViewController *friendVC = [[XXEFriendMyCircleViewController alloc] init];
    friendVC.otherXid = familyXidStr;
    friendVC.rootChat = @"family";
    [self.navigationController pushViewController:friendVC animated:YES];
NSLog(@"********查看圈子 *******");

}

//分享
- (void)shareButtonClick:(UIButton *)button{
NSLog(@"********分享 *******");
    NSString *shareText = [NSString stringWithFormat:@"%@%@",@"来自猩猩教室的名片:  ",self.familyMemberName];
//    UIImage *shareImage = [UIImage imageNamed:@"xingxingjiaoshi_share_icon"];
    //    snsNames 你要分享到的sns平台类型，该NSArray值是`UMSocialSnsPlatformManager.h`定义的平台名的字符串常量，有UMShareToSina，UMShareToTencent，UMShareToRenren，UMShareToDouban，UMShareToQzone，UMShareToEmail，UMShareToSms等
    //调用快速分享接口
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:headImageStr]];
    UIImage *img = [UIImage imageWithData:data];
    
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMSocialAppKey shareText:shareText shareImage:img shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,nil] delegate:self];

}

//举报
- (void)reportButtonClick:(UIButton *)button{

//NSLog(@"********举报 *******");
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
    vc.other_xidStr = familyXidStr;
    vc.report_type = @"1";
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


- (void)createRightBar{
    
    //设置 navigationBar 右边 收藏 home_logo_uncollection_icon44x44
    rightBtn = [UIButton createButtonWithFrame:CGRectMake(kWidth - 100, 0, 22, 22) backGruondImageName:nil Target:self Action:@selector(right:) Title:nil];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
- (void)right:(UIButton*)sender{
    
    if (_isCollected== NO) {
        
        [self collectArticle];
        
    }
    else  if (_isCollected== YES) {
        [self deleteCollectArticle];
        
    }
    
}

//收藏家人
- (void)collectArticle{

    XXEGlobalCollectApi *globalCollectApi = [[XXEGlobalCollectApi alloc] initWithXid:parameterXid user_id:parameterUser_Id collect_id:familyXidStr collect_type:@"3"];
    [globalCollectApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
//        NSLog(@"收藏 -- %@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"收藏成功!" forSecond:1.5];
           [rightBtn setBackgroundImage:[UIImage imageNamed:@"home_logo_collection_icon44x44"] forState:UIControlStateNormal];
            _isCollected=!_isCollected;
        }else{
        
        
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"收藏失败!" forSecond:1.5];
    }];

}

//取消收藏家人
- (void)deleteCollectArticle{
    
    XXEGlobalDecollectApi *globalDecollectApi = [[XXEGlobalDecollectApi alloc] initWithXid:parameterXid user_id:parameterUser_Id collect_id:familyXidStr collect_type:@"3"];
    [globalDecollectApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
//        NSLog(@"取消收藏 -- %@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"取消收藏成功!" forSecond:1.5];
            
            [rightBtn setBackgroundImage:[UIImage imageNamed:@"home_logo_uncollection_icon44x44"] forState:UIControlStateNormal];
            _isCollected=!_isCollected;
        }else{
            
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"取消收藏失败!" forSecond:1.5];
    }];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 150 * kScreenRatioHeight;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
