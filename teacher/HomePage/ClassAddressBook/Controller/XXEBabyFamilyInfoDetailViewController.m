//
//  XXEBabyFamilyInfoDetailViewController.m
//  teacher
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBabyFamilyInfoDetailViewController.h"
#import "XXERedFlowerDetialTableViewCell.h"
#import "XXEBabyFamilyInfoDetailApi.h"
#import "XXEGlobalCollectApi.h"
#import "XXEGlobalDecollectApi.h"



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
    
    UIImage *saveImage;
    
    //家人 xid
    NSString *familyXidStr;
}


@end

@implementation XXEBabyFamilyInfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pictureArray = [[NSMutableArray alloc] initWithObjects:@"babyinfo_nickname_icon", @"babyinfo_tname_icon", @"home_logo_phone_icon40x40", @"home_logo_email_icon40x40", @"family_setting_icon", nil];
    titleArray = [[NSMutableArray alloc] initWithObjects:@"昵称:",@"姓名:",@"电话号码:",@"邮箱:",@"权限设置", nil];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    [self fetchNetData];
    [self createTableView];
}

- (void)fetchNetData{

    XXEBabyFamilyInfoDetailApi *babyFamilyInfoDetailApi = [[XXEBabyFamilyInfoDetailApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE baby_id:_baby_id parent_id:_parent_id];
    
    [babyFamilyInfoDetailApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//                NSLog(@"111   %@", request.responseJSONObject);
        /*
         {
         "cheeck_collect" = 2;
         "coin_total" = 100;
         email = "";
         "head_img" = "app_upload/text/parent/p12.jpg";
         "head_img_type" = 0;
         id = 17;
         lv = 1;
         "next_grade_coin" = 500;
         nickname = "\U4f59\U751f\U957f\U9189";
         phone = 15026511468;
         relation = "\U7238\U7238";
         sex = "\U7537";
         tname = "\U674e\U529f\U6210";
         token = "";
         xid = 18886379;
         };
         */
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSDictionary *dict = request.responseJSONObject[@"data"];
            //@"昵称:",@"姓名:",@"电话号码:",@"邮箱:",@"权限设置"
            contentArray = [[NSMutableArray alloc] initWithObjects:dict[@"nickname"], dict[@"tname"],  dict[@"phone"], dict[@"email"],@"", nil];
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
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 150 * kScreenRatioHeight)];
    
    headerBgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 150 * kScreenRatioHeight)];
    headerBgImageView.image = [UIImage imageNamed:@"green_background_banner"];
    headerBgImageView.userInteractionEnabled =YES;
    [headerView addSubview:headerBgImageView];

    iconImageView = [[UIImageView alloc] init];
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


- (void)createToolBar{
    
    UIImageView *imageV= [[UIImageView alloc]initWithFrame:CGRectMake(0, kHeight-44, kWidth, 44)];
    imageV.backgroundColor = UIColorFromRGB(255, 255, 255 );
    [self.view addSubview:imageV];
    imageV.userInteractionEnabled =YES;
    
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, 5, 24, 24)];
    [shareBtn setTitle:@"" forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"发起聊天icon48x48"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"发起聊天(H)icon48x48"] forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(shareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:shareBtn];
    
    UILabel *shareLbl =[UILabel createLabelWithFrame:CGRectMake(30, 30, 20, 14) Font:8 Text:@"发起聊天"];
    [imageV addSubview:shareLbl];
    
    
    UIButton *seeBtn = [[UIButton alloc]initWithFrame:CGRectMake(118, 5, 24, 24)];
    [seeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [seeBtn setTitle:@"" forState:UIControlStateNormal];
    [seeBtn setImage:[UIImage imageNamed:@"查看我的圈子icon48x48"] forState:UIControlStateNormal];
    [seeBtn setImage:[UIImage imageNamed:@"查看我的圈子(H)icon48x48"] forState:UIControlStateHighlighted];
    [seeBtn addTarget:self action:@selector(lookBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:seeBtn];
    
    UILabel *downLbl =[UILabel createLabelWithFrame:CGRectMake(123, 30, 20, 14) Font:8 Text:@"查看圈子"];
    [imageV addSubview:downLbl];
    
    
    UIButton * saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(212, 5, 24, 24)];
    [saveBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [saveBtn setTitle:@"" forState:UIControlStateNormal];
    [saveBtn setImage:[UIImage imageNamed:@"分享icon48x48"] forState:UIControlStateNormal];
    [saveBtn setImage:[UIImage imageNamed:@"分享(H)icon48x48"] forState:UIControlStateHighlighted];
    [imageV addSubview:saveBtn];
    [saveBtn addTarget:self action:@selector(firendBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *saveLbl =[UILabel createLabelWithFrame:CGRectMake(217, 30, 20, 14) Font:8 Text:@"分享"];
    [imageV addSubview:saveLbl];
    
    
    UIButton *reportBtn = [[UIButton alloc]initWithFrame:CGRectMake(305, 5, 24, 24)];
    [reportBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [reportBtn setTitle:@"" forState:UIControlStateNormal];
    [reportBtn setImage:[UIImage imageNamed:@"举报icon48x48"] forState:UIControlStateNormal];
    [reportBtn setImage:[UIImage imageNamed:@"举报(H)icon48x48"] forState:UIControlStateHighlighted];
    [imageV addSubview:reportBtn];
    [reportBtn addTarget:self action:@selector(chatBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *reportLbl =[UILabel createLabelWithFrame:CGRectMake(310, 30, 20, 14) Font:8 Text:@"举报"];
    [imageV addSubview:reportLbl];
    
}
- (void)firendBtn:(UIButton*)btn{
    //分享给好友
    //    [UMSocialSnsService  presentSnsIconSheetView:self appKey:@"56d4096e67e58ef29300147c" shareText:@"keenteam" shareImage:[UIImage imageNamed:@"11111.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToQzone,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToSina,UMShareToQQ,nil] delegate:self];
//    [CoreUmengShare show:self text:@"为了孩子的未来,这里有你想要的一切,快点点击下载吧！https://itunes.apple.com/cn/app/jie-dian-qian-zhuan-ye-ban/id1112373854?mt=8&v0=WWW-GCCN-ITSTOP100-FREEAPPS&l=&ign-mpt=uo%3D4" image:[UIImage imageNamed:@"猩猩教室.png"]];
    
    
}
- (void)shareBtn:(UIButton*)btn{
    
    
}
- (void)lookBtn:(UIButton*)btn{
//    ViewController *viewVC =[[ViewController alloc]init];
//    [self.navigationController pushViewController:viewVC animated:YES];
}
//举报
- (void)chatBtn:(UIButton*)btn{
    
//    ReportPicViewController *reportVC =[[ReportPicViewController alloc]init];
//    [self.navigationController pushViewController:reportVC animated:YES];
    
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

//收藏机构
- (void)collectArticle
{
    /*
     【收藏】通用于各种收藏
     
     接口:
     http://www.xingxingedu.cn/Global/collect
     
     传参:
     collect_id	//收藏id (如果是收藏用户,这里是xid)
     collect_type	//收藏品种类型	1:商品  2:点评  3:用户  4:课程  5:学校  6:花朵
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/collect";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"collect_id":familyXidStr,
                           @"collect_type":@"3",
                           
                           };
    //    NSLog(@"%@",dict);
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
//             [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
             
             [rightBtn setBackgroundImage:[UIImage imageNamed:@"commentInfo10"] forState:UIControlStateNormal];
             
             _isCollected=!_isCollected;
             
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         NSLog(@"请求失败:%@",error);
//         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
     }];
}

//取消收藏老师
- (void)deleteCollectArticle
{
    /*
     【删除/取消收藏】通用于各种收藏
     
     接口:
     http://www.xingxingedu.cn/Global/deleteCollect
     
     传参:
     collect_id	//收藏id (如果是收藏用户,这里是xid)
     collect_type	//收藏品种类型	1:商品  2:点评  3:用户  4:课程  5:学校  6:花朵 7:图片
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/deleteCollect";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":@"U3k8Dgj7e934bh5Y",
                           @"backtype":@"json",
                           @"xid":@"18884982",
                           @"user_id":@"1",
                           @"user_type":@"1",
                           @"collect_id":familyXidStr,
                           @"collect_type":@"3",
                           
                           };
    //    NSLog(@"%@",dict);
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] ){
//             [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
             
             
             
             [rightBtn setBackgroundImage:[UIImage imageNamed:@"commentInfo9"] forState:UIControlStateNormal];
             
             _isCollected=!_isCollected;
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         NSLog(@"请求失败:%@",error);
//         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
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
