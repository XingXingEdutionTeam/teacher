


//
//  XXEMyselfInfoViewController.m
//  teacher
//
//  Created by Mac on 16/9/5.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoViewController.h"
#import "XXERedFlowerDetialTableViewCell.h"
#import "XXEMySelfInfoApi.h"
#import "XXEMyselfInfoNameModifyViewController.h"
#import "XXEMyselfInfoOldPhoneNumViewController.h"
#import "XXESchoolEmailModiyfViewController.h"
#import "XXESchoolFeatureModifyViewController.h"
#import "VPImageCropperViewController.h"
#import "XXEXingCoinViewController.h"
#import "XXELoginViewController.h"
#import "XXEModifyCodeViewController.h"
#import "XXEMySelfInfoAlbumViewController.h"
#import "XXEMyselfInfoGraduateInstitutionsViewController.h"
#import "AppDelegate.h"
#import "SystemPopView.h"
#import "JPUSHService.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface XXEMyselfInfoViewController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, VPImageCropperDelegate>
{
    UITableView *_myTableView;
    
//    NSMutableArray *_dataSourceArray;
    
    //头像
    NSMutableArray *pictureArray;
    //标题
    NSMutableArray *titleArray;
    //内容
    NSMutableArray *contentArray;
    //个人 头像
    NSString *headImageStr;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
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
    //已连续签到 多少天
    NSString *continued;
    UILabel *continuedLabel;
    //明天 签到 将 获得 多少 星币
    NSString *next_get_coin;
    UILabel *next_get_coinLabel;
    
    //更换头像 时 提示框
    UIActionSheet *headImageActionSheet;
    //修改 密码
    UIActionSheet *modifyActionSheet;
    
}



@end

@implementation XXEMyselfInfoViewController



- (void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = XXEBackgroundColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    pictureArray = [[NSMutableArray alloc] initWithObjects:@"myself_xid_icon40x40", @"myself_nickname_icon40x44", @"myself_name_icon40x40", @"myself_age_icon40x46", @"home_redflower_courseIcon", @"home_logo_phone_icon40x40", @"home_logo_email_icon40x40",@"myself_school_icon", @"myself_professional_icon", @"myself_experience_icon40x40", @"myself_feeling_icon40x40",@"myself_Individuality signature_icon40x40", @"home_redflower_picIcon", nil];
    titleArray = [[NSMutableArray alloc] initWithObjects:@"猩ID",@"昵称",@"姓名",@"教龄",@"科目" , @"手机号", @"邮箱", @"毕业院校", @"所学专业", @"教学经历",@"教学感悟", @"个性签名", @"个人相册", nil];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    [self createHeadView];
    
    [self fetchNetData];
    
    [self createTableView];
    
    [self createFooterView];
}

- (void)fetchNetData{
    
    XXEMySelfInfoApi *mySelfInfoApi = [[XXEMySelfInfoApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE];
    
    [mySelfInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//                    NSLog(@"111   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSDictionary *dict = request.responseJSONObject[@"data"];
            //头像
            NSString * head_img;
            if([[NSString stringWithFormat:@"%@",dict[@"head_img_type"]]isEqualToString:@"0"]){
                head_img=[kXXEPicURL stringByAppendingString:dict[@"head_img"]];
            }else{
                head_img=dict[@"head_img"];
            }
            
            headImageStr = head_img;
            
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
            //已连续 签到
            continued = dict[@"continued"];
            //明天 签到 将 获得 多少 星币
            next_get_coin = dict[@"next_get_coin"];
            
            //content 内容
            contentArray = [[NSMutableArray alloc] initWithObjects:dict[@"xid"], dict[@"nickname"], dict[@"tname"], dict[@"exper_year"], dict[@"teach_course"], dict[@"phone"],dict[@"email"], dict[@"graduate_sch"], dict[@"specialty"],  dict[@"teach_life"],dict[@"teach_feel"], dict[@"personal_sign"] ,@"", nil];
            
            
        }else{
            
        }
//        NSLog(@"%@", contentArray);
        
        [self updateHeadViewInfo];
        [_myTableView reloadData];
        
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
    
    NSString *titleStr = [NSString stringWithFormat:@"还差%d星币升级到%d级会员  %d/%d", c, d, b, a];
     titleLbl.text = titleStr;
    progressView.progress = [coin_totalStr floatValue] / [next_grade_coinStr floatValue] ;
    
    if (continued == nil) {
        continued = @" ";
    }
    continuedLabel.text = [NSString stringWithFormat:@"已连续签到%@天",continued];
    
    if (next_get_coin == nil) {
        next_get_coin = @" ";
    }
    next_get_coinLabel.text = [NSString stringWithFormat:@"明天继续签到将获得%@个猩币",next_get_coin];
}


- (void)createHeadView{
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 180 * kScreenRatioHeight)];
//    headerBgImageView.backgroundColor = [UIColor redColor];
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
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editPortrait)];
    [iconImageView addGestureRecognizer:tap];
    
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
    
    nameLbl =[UILabel createLabelWithFrame:CGRectMake(150 * kScreenRatioWidth, 40 * kScreenRatioHeight, nameLabelWidth, nameLabelHeight) Font:18 * kScreenRatioWidth Text:nil];
    nameLbl.textAlignment = NSTextAlignmentLeft;
    nameLbl.textColor =UIColorFromRGB(255, 255, 255);
    [headerView addSubview:nameLbl];
    
    //等级
    CGFloat lvLabelWidth = 30 * kScreenRatioWidth;
    CGFloat lvLabelHeight = 15 * kScreenRatioHeight;
    
    lvLabel = [UILabel createLabelWithFrame:CGRectMake(300 * kScreenRatioWidth, 42 * kScreenRatioHeight, lvLabelWidth, lvLabelHeight) Font:12 * kScreenRatioWidth Text:@""];
    lvLabel.textColor = UIColorFromRGB(3, 169, 244);
    lvLabel.textAlignment = NSTextAlignmentCenter;
    lvLabel.backgroundColor = [UIColor whiteColor];
    lvLabel.layer.cornerRadius = 5;
    lvLabel.layer.masksToBounds = YES;
    [headerView addSubview:lvLabel];
    
    CGFloat titleLabelWidth = 200 *kScreenRatioWidth;
    CGFloat titleLabelHeight = 35 * kScreenRatioHeight;
    
    titleLbl =[UILabel createLabelWithFrame:CGRectMake(150 * kScreenRatioWidth, 70 * kScreenRatioHeight, titleLabelWidth, titleLabelHeight) Font:12 * kScreenRatioWidth Text:@""];
    titleLbl.numberOfLines = 0;
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.textColor = [UIColor whiteColor];
    [headerView addSubview:titleLbl];
    
    //中间 进度条
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.frame = CGRectMake(150 * kScreenRatioWidth, 110 * kScreenRatioHeight, 150 * kScreenRatioWidth, 10 * kScreenRatioHeight);
    // 设置已过进度部分的颜色
    progressView.progressTintColor = XXEColorFromRGB(255, 255, 255);
    // 设置未过进度部分的颜色
    progressView.trackTintColor = XXEColorFromRGB(220, 220, 220);
    [headerView addSubview:progressView];
    
    UIButton *checkBtn =[UIButton createButtonWithFrame:CGRectMake(40 * kScreenRatioWidth, iconBottom + 24 * kScreenRatioHeight, 57 * kScreenRatioWidth, 26 * kScreenRatioHeight) backGruondImageName:@"myself_signIn_icon106x48" Target:self Action:@selector(check) Title:@""];
    
    [headerView addSubview:checkBtn];
    
    continuedLabel =[UILabel createLabelWithFrame:CGRectMake(145 * kScreenRatioWidth, iconBottom + 20 * kScreenRatioHeight, 120 * kScreenRatioWidth, 15 * kScreenRatioHeight) Font:12 * kScreenRatioWidth Text:@""];
    continuedLabel.textColor =UIColorFromRGB(255, 255, 255);
    [headerView addSubview:continuedLabel];
    
    next_get_coinLabel =[UILabel createLabelWithFrame:CGRectMake(145 * kScreenRatioWidth, continuedLabel.frame.origin.y + continuedLabel.frame.size.height + 5 *kScreenRatioHeight, 200 * kScreenRatioWidth, 15 * kScreenRatioHeight) Font:12 * kScreenRatioWidth Text:@""];
    next_get_coinLabel.textColor =UIColorFromRGB(255, 255, 255);
    [headerView addSubview:next_get_coinLabel];
}


- (void)check{
//    NSLog(@"签到---------------");
    XXEXingCoinViewController *xingCoinVC = [[XXEXingCoinViewController alloc] init];
    [self.navigationController pushViewController:xingCoinVC animated:YES];
}

- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 180 * kScreenRatioHeight, KScreenWidth, KScreenHeight - 180 * kScreenRatioHeight - 49 - 20) style:UITableViewStyleGrouped];
    
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
//@"猩ID"--0,@"昵称"--1,@"姓名"--2,@"教龄"--3,@"科目"--4 , @"手机号"--5, @"邮箱"--6, @"毕业院校"--7, @"所学专业"--8, @"教学经历"--9,@"教学感悟"--10, @"个性签名"--11, @"相册"--12
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4) {
        //
    }else {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return  0.0000001;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

//@"猩ID"--0,@"昵称"--1,@"姓名"--2,@"教龄"--3,@"科目"--4 , @"手机号"--5, @"邮箱"--6, @"毕业院校"--7, @"所学专业"--8, @"教学经历"--9,@"教学感悟"--10, @"个性签名"--11, @"相册"--12
    
    //昵称 1
    if (indexPath.row == 1) {
        XXEMyselfInfoNameModifyViewController *myselfInfoNameModifyVC = [[XXEMyselfInfoNameModifyViewController alloc] init];
        myselfInfoNameModifyVC.nickNameStr = contentArray[1];
        myselfInfoNameModifyVC.flagStr = @"fromMyselfModifyName";
        [myselfInfoNameModifyVC returnStr:^(NSString *str) {
            //
            contentArray[1] = str;
            [_myTableView reloadData];
        }];
        [self.navigationController pushViewController:myselfInfoNameModifyVC animated:YES];
    }
    //教龄
    if (indexPath.row == 3) {
        XXEMyselfInfoNameModifyViewController *myselfInfoNameModifyVC = [[XXEMyselfInfoNameModifyViewController alloc] init];
        myselfInfoNameModifyVC.nickNameStr = contentArray[3];
        myselfInfoNameModifyVC.flagStr = @"fromMyselfModifyTeachingAge";
        [myselfInfoNameModifyVC returnStr:^(NSString *str) {
            //
            contentArray[3] = str;
            [_myTableView reloadData];
        }];
        [self.navigationController pushViewController:myselfInfoNameModifyVC animated:YES];
    }
    //手机号
    if (indexPath.row == 5) {
        
        NSString *phone = [NSString stringWithFormat:@"%@", contentArray[5]];
        
        if ([phone isEqualToString:@""]) {
            [self showHudWithString:@"请绑定手机号" forSecond:1.5];
        }else{
            XXEMyselfInfoOldPhoneNumViewController *oldPhoneNumVC = [[XXEMyselfInfoOldPhoneNumViewController alloc] init];
            oldPhoneNumVC.phoneStr = contentArray[5];
            [self.navigationController pushViewController:oldPhoneNumVC animated:YES];
        }
    
//        XXESchoolPhoneNumModifyViewController *schoolPhoneNumModifyVC = [[XXESchoolPhoneNumModifyViewController alloc] init];
//        schoolPhoneNumModifyVC.flagStr = @"fromMyselfInfo";
//        [schoolPhoneNumModifyVC returnStr:^(NSString *str) {
//            //
//            contentArray[5] = str;
//            [_myTableView reloadData];
//        }];
//        
//        [self.navigationController pushViewController:schoolPhoneNumModifyVC animated:YES];
    }
    //邮箱
    if (indexPath.row == 6) {
        XXESchoolEmailModiyfViewController *schoolEmailModifyVC = [[XXESchoolEmailModiyfViewController alloc] init];
        schoolEmailModifyVC.flagStr = @"fromMyselfInfo";
        
        schoolEmailModifyVC.emailStr = contentArray[6];
        [schoolEmailModifyVC returnStr:^(NSString *str) {
            //
            contentArray[6] = str;
            [_myTableView reloadData];
        }];
        
        [self.navigationController pushViewController:schoolEmailModifyVC animated:YES];
    }
    
    //毕业院校  7
    if (indexPath.row == 7) {
        XXEMyselfInfoGraduateInstitutionsViewController *myselfInfoGraduateInstitutionsVC = [[XXEMyselfInfoGraduateInstitutionsViewController alloc] init];
        [myselfInfoGraduateInstitutionsVC returnStr:^(NSString *str) {
            //
            contentArray[7] = str;
            [_myTableView reloadData];
        }];
        [self.navigationController pushViewController:myselfInfoGraduateInstitutionsVC animated:YES];
    }
    
    
    //所学专业  8
    if (indexPath.row == 8) {
        
        
        
    }
    
    
    //经历
    if (indexPath.row == 9) {
        XXESchoolFeatureModifyViewController *schoolFeatureModifyVC = [[XXESchoolFeatureModifyViewController alloc] init];
        schoolFeatureModifyVC.flagStr = @"fromMyselfInfoTeachingExperience";
        schoolFeatureModifyVC.schoolfeatureStr = contentArray[9];
        [schoolFeatureModifyVC returnStr:^(NSString *str) {
            //
            contentArray[9] = str;
            [_myTableView reloadData];
        }];
        
        [self.navigationController pushViewController:schoolFeatureModifyVC animated:YES];
    }
    //感悟
    if (indexPath.row == 10) {
        XXESchoolFeatureModifyViewController *schoolFeatureModifyVC = [[XXESchoolFeatureModifyViewController alloc] init];
        schoolFeatureModifyVC.flagStr = @"fromMyselfInfoTeachingFeeling";
        schoolFeatureModifyVC.schoolfeatureStr = contentArray[10];
        [schoolFeatureModifyVC returnStr:^(NSString *str) {
            //
            contentArray[10] = str;
            [_myTableView reloadData];
        }];
        
        [self.navigationController pushViewController:schoolFeatureModifyVC animated:YES];
    }

    
    
    
    //个性签名
    if (indexPath.row == 11) {
        XXESchoolFeatureModifyViewController *schoolFeatureModifyVC = [[XXESchoolFeatureModifyViewController alloc] init];
        schoolFeatureModifyVC.flagStr = @"fromMyselfInfoPersonalSignApi";
        schoolFeatureModifyVC.schoolfeatureStr = contentArray[11];
        [schoolFeatureModifyVC returnStr:^(NSString *str) {
            //
            contentArray[11] = str;
            [_myTableView reloadData];
        }];
        
        [self.navigationController pushViewController:schoolFeatureModifyVC animated:YES];
    }
    //个人 相册 (不同于 首页 相册, 那个是班级相册,此处 是 个人 相册)
    if (indexPath.row == 12) {
        XXEMySelfInfoAlbumViewController *mySelfInfoAlbumVC = [[XXEMySelfInfoAlbumViewController alloc] init];
 
        [self.navigationController pushViewController:mySelfInfoAlbumVC animated:YES];
    }
    
    
}

#pragma mark - 
#pragma mark - =================点击 头像 ,编辑 头像=================

- (void)editPortrait{
    headImageActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [headImageActionSheet showInView:self.view];
}

#pragma mark - VPImageCropperDeletegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage{
    iconImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        //
        NSData *data =UIImagePNGRepresentation(editedImage);
        NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str =[formatter stringFromDate:[NSDate date]];
        NSString *fileName =[NSString stringWithFormat:@"%@.png", str];
        
        NSString *urlStr = @"http://www.xingxingedu.cn/Teacher/edit_my_info";
        NSDictionary *prag = @{   @"appkey":APPKEY,
                                  @"backtype":BACKTYPE,
                                  @"xid":parameterXid,
                                  @"user_id":parameterUser_Id,
                                  @"user_type":USER_TYPE
                                  };
        
        AFHTTPRequestOperationManager *mgr =[AFHTTPRequestOperationManager manager];
        [mgr POST:urlStr parameters:prag constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
        } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            //
            NSDictionary *dict = responseObject;
            
            if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] ){
//              NSLog(@"2222222================%@",dict[@"data"]);
                [self showHudWithString:@"更换头像成功!" forSecond:1.5];
            }else{
                [self showHudWithString:@"更换头像失败!" forSecond:1.5];
            }

        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            //
            [self showHudWithString:@"数据获取失败!" forSecond:1.5];
            NSLog(@"数据获取失败");
        }];
            
        }];

}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet == headImageActionSheet) {
        if (buttonIndex == 0) {
            // 拍照
            if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([self isFrontCameraAvailable]) {
                    controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                }
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     //    NSLog(@"Picker View Controller is presented");
                                 }];
            }
            
        } else if (buttonIndex == 1) {
            // 从相册中选取
            if ([self isPhotoLibraryAvailable]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     //   NSLog(@"Picker View Controller is presented");
                                 }];
            }
        }

    }else if (actionSheet == modifyActionSheet){
        
#pragma mark - ============== 修改登录密码/修改支付密码 ============
        //修改登录密码  modifyLoginCode  /修改支付密码 modifyPayCode
        if (buttonIndex == 0) {
//            NSLog(@"000");
            //修改登录密码
        XXEModifyCodeViewController *modifyCodeVC = [[XXEModifyCodeViewController alloc] init];
            modifyCodeVC.fromflagStr = @"modifyLoginCode";
            
        [self.navigationController pushViewController:modifyCodeVC animated:YES];
            
        }else if (buttonIndex == 1) {
//            NSLog(@"1111");
            //修改支付密码
            XXEModifyCodeViewController *modifyCodeVC = [[XXEModifyCodeViewController alloc] init];
            modifyCodeVC.fromflagStr = @"modifyPayCode";
            
            [self.navigationController pushViewController:modifyCodeVC animated:YES];
        }else if (buttonIndex == 2){
//            NSLog(@"2222");
            //取消
        }
        
    }
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}
#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

- (void)createFooterView{

    UIImageView *footerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 90 * kScreenRatioHeight)];
    _myTableView.tableFooterView = footerView;
    footerView.userInteractionEnabled = YES;
    
    //注销登录
    UIButton *cancelButton = [UIButton createButtonWithFrame:CGRectMake(25 * kScreenRatioWidth, 0, 325 * kScreenRatioWidth, 42 * kScreenRatioHeight) backGruondImageName:@"login_green" Target:self Action:@selector(cancelButtonClick) Title:@"注销登录"];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerView addSubview:cancelButton];
    
    //修改密码
    UIButton *modifyCodeButton = [UIButton createButtonWithFrame:CGRectMake(25 * kScreenRatioWidth, 50 * kScreenRatioHeight, 325 * kScreenRatioWidth, 42 * kScreenRatioHeight) backGruondImageName:@"login_green" Target:self Action:@selector(modifyCodeButtonClick) Title:@"修改密码"];
    [modifyCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerView addSubview:modifyCodeButton];

}

//修改密码
- (void)modifyCodeButtonClick{
    
    if ([[XXEUserInfo user].account isEqualToString:@""]) {
        [SystemPopView showSystemPopViewWithTitle:@"请先绑定手机号" vc:self];
        return;
    }
    
    modifyActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改登录密码", @"修改支付密码" , nil];
    modifyActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    [modifyActionSheet showInView:self.view];
    
}

//注销登录
- (void)cancelButtonClick{
  UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否确定注销登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
            [[XXEUserInfo user]cleanUserInfo];
            [XXEUserInfo user].login = NO;
            XXELoginViewController *landVC =[[XXELoginViewController alloc]init];
            [self presentViewController:landVC animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
