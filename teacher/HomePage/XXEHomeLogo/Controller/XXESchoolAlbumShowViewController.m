
//
//  XXESchoolAlbumShowViewController.m
//  teacher
//
//  Created by Mac on 16/9/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolAlbumShowViewController.h"
#import "XXEHomePageCollectionPhotoApi.h"
#import "ReportPicViewController.h"
#import "XXEAllImageCollectionApi.h"
#import "XXEShoolPicSupportApi.h"
#import "XXESchoolAlbumModel.h"
#import "KTActionSheet.h"

#import "UMSocial.h"

@interface XXESchoolAlbumShowViewController ()<UIActionSheetDelegate, UIScrollViewDelegate, UMSocialUIDelegate>
{
    //图片浏览 的 底层 scrollview
    UIScrollView *bgScrollView;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
    //下载 按钮
    UIButton *downloadButton;
    //分享 按钮(含 分享/举报)
    UIButton *shareButton;
    //点赞 按钮
    UIButton *supportButton;
    
    //点赞 数量
    UIButton *redBtn;
}


@end

@implementation XXESchoolAlbumShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    [self createContent];
    
    //创建 底部 view
    [self createBottomViewButton];
}

- (void)createContent{
    //--------  bgScrollView  ---------
    bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 44)];
    bgScrollView.pagingEnabled = YES;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    
    //判断 进入 图片 浏览 模式 时,应该 从 什么位置 开始
    CGPoint contentOffset = bgScrollView.contentOffset;
    contentOffset.x = _currentIndex * KScreenWidth;
    [bgScrollView setContentOffset:contentOffset animated:YES];
    
    bgScrollView.contentSize = CGSizeMake(_imageUrlArray.count * KScreenWidth, 0);
    bgScrollView.delegate = self;
    
    [self.view addSubview:bgScrollView];
    
    //创建 一个个 图片 视图
    if (_imageUrlArray.count != 0) {
        for (int i = 0; i < _imageUrlArray.count; i++ ) {
            
            UIImageView *imageCell = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, KScreenHeight - 44)];
            imageCell.contentMode = UIViewContentModeScaleAspectFit;
            imageCell.userInteractionEnabled = YES;
            [imageCell sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, _imageUrlArray[i]]] placeholderImage:[UIImage imageNamed:@""]];
            [bgScrollView addSubview:imageCell];
            
            //图片 长按 收藏
            UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapClick:)];
            [imageCell addGestureRecognizer:longTap];
        }
    }
    
}

//图片 长按 收藏
- (void)longTapClick:(UILongPressGestureRecognizer *)longTap{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //收藏 图片
        [self imageCollecting];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //取消 无操作
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)imageCollecting{
    
    CGPoint contentOffset =bgScrollView.contentOffset;
    int d =contentOffset.x/kWidth;
    
    XXEAllImageCollectionApi *allImageCollectionApi = [[XXEAllImageCollectionApi alloc] initWithXid:parameterXid user_id:parameterUser_Id url:_imageUrlArray[d]];
    [allImageCollectionApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
        //            NSLog(@"收藏 -- %@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"收藏成功!" forSecond:1.5];
        }else{
            [self showHudWithString:@"收藏失败!" forSecond:1.5];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"请检查网络!" forSecond:1.5];
    }];
    
    
    
}

- (void)createBottomViewButton{
    //下载/分享(含分享/举报)/点赞
    UIImageView *bottomView= [[UIImageView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 49 - 64, KScreenWidth, 49)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    bottomView.userInteractionEnabled =YES;
    
    CGFloat itemWidth = KScreenWidth / 2;
    CGFloat itemHeight = 49;
    
    CGFloat buttonWidth = itemWidth;
    CGFloat buttonHeight = itemHeight;
    
    //----------------------------下载 ---------
    downloadButton = [UIButton createButtonWithFrame:CGRectMake(buttonWidth / 2 * 0, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) backGruondImageName:nil Target:self Action:@selector(downloadButtonClick:) Title:@"下载"];
    [downloadButton setImage:[UIImage imageNamed:@"album_down_icon_click"] forState:UIControlStateNormal];
    [downloadButton setImage:[UIImage imageNamed:@"album_down_icon"] forState:UIControlStateHighlighted];
    downloadButton.titleLabel.font = [UIFont systemFontOfSize:10];
    //设置 图片 位置
    downloadButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 - 110 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    downloadButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -downloadButton.titleLabel.bounds.size.width-60, 0, 0);
    [bottomView addSubview:downloadButton];
    
    //--------------------------------分享-------
    shareButton = [UIButton createButtonWithFrame:CGRectMake(buttonWidth * 1, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) backGruondImageName:nil Target:self Action:@selector(shareButtonClick:) Title:@"分享"];
    [shareButton setImage:[UIImage imageNamed:@"classAddress_share_unseleted_icon"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"classAddress_share_seleted_icon"] forState:UIControlStateHighlighted];
    shareButton.titleLabel.font = [UIFont systemFontOfSize:10];
    //设置 图片 位置
    shareButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 - 65 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    shareButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -shareButton.titleLabel.bounds.size.width-20, 0, 0);
    [bottomView addSubview:shareButton];
    
//    //--------------------------------点赞----------------
//    supportButton = [UIButton createButtonWithFrame:CGRectMake(buttonWidth * 2, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) backGruondImageName:nil Target:self Action:@selector(supportButtonClick:) Title:@"点赞"];
//    [supportButton setImage:[UIImage imageNamed:@"album_good_icon_click"] forState:UIControlStateNormal];
//    [supportButton setImage:[UIImage imageNamed:@"album_good_icon"] forState:UIControlStateHighlighted];
//    supportButton.titleLabel.font = [UIFont systemFontOfSize:10];
//    //设置 图片 位置
//    supportButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 + 7 * kScreenRatioWidth, 0, 0);
//    //设置title在button上的位置（上top，左left，下bottom，右right）
//    supportButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -supportButton.titleLabel.bounds.size.width + 20, 0, 0);
//    [bottomView addSubview:supportButton];
    
    //点赞数量
//    redBtn = [[UIButton alloc]initWithFrame:CGRectMake(20,-10, 20, 20) ];
//    [redBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    
////    if (self.goodNMArr.count!=0) {
////        [redBtn setTitle:[NSString stringWithFormat:@"%@",self.goodNMArr[0]] forState:UIControlStateNormal];
////    }
//    redBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    redBtn.titleLabel.font =[UIFont boldSystemFontOfSize:12.0f];
//    redBtn.backgroundColor = [UIColor whiteColor];
//    [redBtn.layer setMasksToBounds:YES];   //设置yes
//    [redBtn.layer setCornerRadius:10.0f];   //弧度等于宽度的一半 就是圆角
//    
//    [supportButton addSubview:redBtn];

    
}

#pragma mark - 下载
- (void)downloadButtonClick:(UIButton *)button{
    
    //    NSLog(@"********下载 *******");
    CGPoint contentOffset =bgScrollView.contentOffset;
    int d =contentOffset.x/kWidth;
    NSString *imageUrl = _imageUrlArray[d];
    NSString *stringUtl = [NSString stringWithFormat:@"%@%@",kXXEPicURL,imageUrl];
    NSURL *url = [NSURL URLWithString:stringUtl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    //    NSLog(@"%@",image);
    [self saveImageToPgoto:image];
    
}

#pragma mark - 保存图片
- (void)saveImageToPgoto:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        [self showString:@"保存失败" forSecond:1.f];
    }else {
        [self showString:@"保存成功" forSecond:1.f];
    }
}


#pragma mark - 分享
- (void)shareButtonClick:(UIButton *)button
{
    
    KTActionSheet *actionSheet1 = [[KTActionSheet alloc]initWithTitle:@"" itemTitles:@[@"分享",@"举报"]];
    actionSheet1.tag = 1001;
    actionSheet1.delegate = self;

}



//#pragma mark - //举报
//- (void)reportButtonClick:(UIButton *)button{
//    
//    //    NSLog(@"********举报 *******");
//    
//    ReportPicViewController *reportVC = [[ReportPicViewController alloc]init];
//    /*
//     other_xid	//被举报人xid (举报用户时才有此参数)
//     report_name_id	//举报内容id , 多个逗号隔开
//     report_type	//举报类型 1:举报用户  2:举报图片
//     url		//被举报的链接(report_type非等于1时才有此参数),如果是图片,不带http头部的,例如:app_upload/........
//     origin_page	//举报内容来源(report_type非等于1时才有此参数),传参是数字:
//     1:小红花赠言中的图片
//     2:圈子图片
//     3:猩课堂发布的课程图片
//     4:学校相册图片
//     5:班级相册
//     6:老师点评
//     7:作业图片
//     8:星级评分图片
//     */
//    //    reportVC.other_xidStr = self.showAlbumXid;
//    //    reportVC.picUrlStr = model.pic;
//    //    reportVC.origin_pageStr = @"5";
//    //    reportVC.report_type = @"2";
//    [self.navigationController pushViewController:reportVC animated:YES];
//    
//}

//- (void)supportButtonClick:(UIButton *)bu{
//    CGPoint contentOffset =bgScrollView.contentOffset;
//    int d =contentOffset.x/kWidth;
////    NSString *imageUrl = _imageUrlArray[d];
//    
//    XXESchoolAlbumModel *model = _imageModelArray[d];
//    
//    XXEShoolPicSupportApi *shoolPicSupportApi = [[XXEShoolPicSupportApi alloc] initWithXid:parameterXid user_id:parameterUser_Id pic_id:model.schoolPicId];
//    [shoolPicSupportApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        //
////        NSLog(@"%@", request.responseJSONObject);
//        
//    } failure:^(__kindof YTKBaseRequest *request) {
//        //
//        [self showHudWithString:@"" forSecond:1.5];
//    }];
//}

#pragma mark - actionViewDelegate
- (void)sheetViewDidSelectIndex:(NSInteger)index title:(NSString *)title sender:(id)sender
{
    
    CGPoint contentOffset =bgScrollView.contentOffset;
    int d =contentOffset.x/kWidth;
    NSString *imageUrl = _imageUrlArray[d];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }
    KTActionSheet *action;
    action = sender;
    if (action.tag == 1000) {
        if (index == 0) {
            NSLog(@"收藏");
            [self collectionPhotoImage:imageUrl];
        }
    }else if (action.tag == 1001) {
        if (index  == 0) {
            NSLog(@"分享");
//            XXEAlbumDetailsModel *model = self.showDatasource[self.albumIndexPaths];
            //                NSLog(@"图片的位置%@",model.pic);
            [self shareTextPicUrl:imageUrl];
        }else {
            NSLog(@"举报");
            
            ReportPicViewController *reportVC = [[ReportPicViewController alloc]init];
            reportVC.picUrlStr = imageUrl;
            reportVC.origin_pageStr = @"4";
            reportVC.report_type = @"2";
            [self.navigationController pushViewController:reportVC animated:YES];
        }
    }
}
#pragma mark - 分享
- (void)shareTextPicUrl:(NSString *)picUrl
{
    NSInteger index = (int)((bgScrollView.contentOffset.x + KScreenWidth)/KScreenWidth) - 1;
    NSString *shareText = @"来自猩猩教室的相册:";
    NSString *PicURL= [NSString stringWithFormat:@"%@%@",kXXEPicURL,self.imageUrlArray[index]];
    UIImage *shareImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:PicURL]]];
//    NSLog(@"%@",shareImage);
    
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

#pragma mark  - 收藏
- (void)collectionPhotoImage:(NSString *)imageUrl
{
    XXEHomePageCollectionPhotoApi *photoApi = [[XXEHomePageCollectionPhotoApi alloc]initHomePageCollectionPhontImageAddress:imageUrl];
    [photoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        if ([code intValue]==1) {
            [self showString:@"收藏图片成功" forSecond:1.f];
        }else{
            [self showString:@"收藏图片失败" forSecond:1.f];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self showString:@"收藏图片失败" forSecond:1.f];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
