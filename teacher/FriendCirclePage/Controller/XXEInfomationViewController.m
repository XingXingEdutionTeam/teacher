//
//  XXEInfomationViewController.m
//  teacher
//
//  Created by codeDing on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEInfomationViewController.h"
#import "AFNetworking.h"
#import "CommentInputViewController.h"
#import "MessageListDetailController.h"

@interface XXEInfomationViewController ()<UIActionSheetDelegate,UIScrollViewDelegate>
{
    UIImageView *imageView;
    UIScrollView *_scrollView;
    UIButton *_detaileBtn;
    BOOL isGood;
}

@property (nonatomic, strong) UIView *panelView;

/**
 *  加载视图
 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
//@property(nonatomic,retain) NSMutableArray *ittms;

@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, strong) UIButton *commentButton;

@end

@implementation XXEInfomationViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
}
/** 这两个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"图片的数组%@",self.imagesArr);
    
    //时间戳转时间
    NSDateFormatter *fomatter =[[NSDateFormatter alloc]init];
    [fomatter setDateStyle:NSDateFormatterMediumStyle];
    [fomatter setTimeStyle:NSDateFormatterShortStyle];
    [fomatter setDateFormat:@"yyyy年MM月dd日 HH:MM:ss"];
    NSString *str =[NSString stringWithFormat:@"%ld",self.ts];
    str =[str substringToIndex:10];
    NSInteger i =str.integerValue;
    //时间戳转时间
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:i];
    NSString *confromTimespStr = [fomatter stringFromDate:confromTimesp];
    self.title =[NSString stringWithFormat:@"%@",confromTimespStr];
    
    [self createscrollView];
    [self createToolbtn];
}

-(void)createscrollView{
    
    _scrollView =  [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 113)];
//    _scrollView.backgroundColor = [UIColor redColor];
    _scrollView.pagingEnabled =YES;
    _scrollView.showsHorizontalScrollIndicator =NO;
    [self.view addSubview:_scrollView];
    //
    //加载等待视图
    self.panelView = [[UIView alloc] initWithFrame:self.view.bounds];
//    self.panelView.backgroundColor = [UIColor blackColor];
    self.panelView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.panelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    self.loadingView.backgroundColor = [UIColor yellowColor];
    self.loadingView.frame = CGRectMake((self.view.frame.size.width - self.loadingView.frame.size.width) / 2, (self.view.frame.size.height - self.loadingView.frame.size.height) / 2, self.loadingView.frame.size.width, self.loadingView.frame.size.height);
    self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.panelView addSubview:self.loadingView];
    
    NSArray *arrayImage;
    if ([_imagesArr containsString:@","]) {
        arrayImage = [_imagesArr componentsSeparatedByString:@","];
        //  加载图片
        for (int i=0; i< arrayImage.count; i++) {
            UIImageView *imV = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth*i, 0, KScreenWidth, KScreenHeight)];
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@",kXXEPicURL,arrayImage[i]];
            NSURL *url =[NSURL URLWithString:imageUrl];
            [imV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"11111"] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [_scrollView addSubview:imV];
                
            }];
            dispatch_queue_t queue  = dispatch_queue_create("loadImage", NULL);
            
            dispatch_async(queue, ^{
                NSData *reslut =[NSData dataWithContentsOfURL:url];
                UIImage *imag =[UIImage imageWithData:reslut];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    imV.image =imag;
                    [_scrollView addSubview:imV];
                });
            });
        }
        CGPoint contentOffset = _scrollView.contentOffset;
        [_scrollView setContentOffset:contentOffset animated:YES];
        [self createToolBarItems];
        _scrollView.contentSize =CGSizeMake(arrayImage.count*kWidth, kHeight-64);
        _scrollView.delegate =self;

    }else{
        UIImageView *imV = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth, 0, KScreenWidth, KScreenHeight)];
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",kXXEPicURL,_imagesArr];
            NSURL *url =[NSURL URLWithString:imageUrl];
            [imV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"11111"] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [_scrollView addSubview:imV];
            }];
            dispatch_queue_t queue  = dispatch_queue_create("loadImage", NULL);
            dispatch_async(queue, ^{
                NSData *reslut =[NSData dataWithContentsOfURL:url];
                UIImage *imag =[UIImage imageWithData:reslut];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    imV.image =imag;
                    [_scrollView addSubview:imV];
                });
            });
        
        CGPoint contentOffset = _scrollView.contentOffset;
        [_scrollView setContentOffset:contentOffset animated:YES];
        [self createToolBarItems];
        _scrollView.contentSize =CGSizeMake(kWidth, kHeight-64);
        _scrollView.delegate =self;
    }
}
- (void)createToolbtn{
    
    //UILabel 加白字
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, KScreenHeight-153, kWidth, 50)];
    textLabel.backgroundColor =UIColorFromRGB(125, 130, 147);
    [self.view addSubview:textLabel];
    textLabel.numberOfLines =0;
    textLabel.font =[UIFont systemFontOfSize:15];
    textLabel.text = _conText;
    textLabel.textColor =UIColorFromRGB(255, 255, 255);
    
    UIImageView *imageV= [[UIImageView alloc]initWithFrame:CGRectMake(0, KScreenHeight-108, KScreenWidth, 44)];
    imageV.backgroundColor = UIColorFromRGB(0, 0, 0 );
    [self.view addSubview:imageV];
    imageV.userInteractionEnabled =YES;
    
    if (![_goodArr isEqual:@""]) {
        _likeButton = [self getButton:CGRectMake(5, 2, 60, 40) title:@"取消" image:@"AlbumLike"];
        [_likeButton addTarget:self action:@selector(onLike:) forControlEvents:UIControlEventTouchUpInside];
        [imageV addSubview:_likeButton];
        _likeButton.selected = NO;
    }else{
        _likeButton = [self getButton:CGRectMake(5, 2, 60, 40) title:@"赞" image:@"AlbumLike"];
        [_likeButton addTarget:self action:@selector(onLike:) forControlEvents:UIControlEventTouchUpInside];
        [imageV addSubview:_likeButton];
        _likeButton.selected = YES;
    }

    _commentButton = [self getButton:CGRectMake(70, 2, 60, 40) title:@"评" image:@"AlbumComment"];
    [_commentButton addTarget:self action:@selector(commentButton:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:_commentButton];
    
    _detaileBtn = [self getButton:CGRectMake(kWidth-45, 2, 40, 40) title:@"" image:@"AlbumOperateMoreHL"];
    [_detaileBtn addTarget:self action:@selector(detaileButton:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:_detaileBtn];
}
- (void)createToolBarItems{
    UIBarButtonItem *deletBar =[[UIBarButtonItem alloc]initWithTitle:@"..." style:UIBarButtonItemStylePlain target:self action:@selector(delete:)];
    self.navigationItem.rightBarButtonItem = deletBar;
}
- (void)delete:(UINavigationItem*)sender{
    UIActionSheet *actionSheet =[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"发送给QQ好友" otherButtonTitles:@"发送给微信好友",@"保存图片",@"删除", nil];
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
    actionSheet.tag=100;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag==100) {
        if (buttonIndex ==0) {
            NSLog(@"发送给QQ好友");
            [self performSelector:@selector(delayView) withObject:nil afterDelay:0.6];
            
        }
        else if (buttonIndex==1){
            NSLog(@"发送给微信好友");
            
            [self performSelector:@selector(delayWX) withObject:nil afterDelay:0.6];
        }
        else  if (buttonIndex==2){
            NSLog(@"保存图片");
            [self performSelector:@selector(delaySavePic) withObject:nil afterDelay:0.6];
            
        } else  if (buttonIndex==3){
            NSLog(@"删除");
            [self performSelector:@selector(delayDelete) withObject:nil afterDelay:0.6];
        }
        else{
            NSLog(@"cancel");
        }
    }else{
        
    }
}

- (void)delaySavePic{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImageWriteToSavedPhotosAlbum(nil, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)delayDelete{
    [self showString:@"删除成功" forSecond:1.f];
}
- (void)delayWX{
//    [[UMSocialControllerService defaultControllerService] setShareText:@"猩猩教室" shareImage:[UIImage imageNamed:@"11111.png"]socialUIDelegate:self];
//    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler([UIApplication sharedApplication].keyWindow.rootViewController,[UMSocialControllerService defaultControllerService],YES);
    
}
- (void)delayView{
//    [[UMSocialControllerService defaultControllerService] setShareText:@"猩猩教室" shareImage:[UIImage imageNamed:@"11111.png"]socialUIDelegate:self];
//    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler([UIApplication sharedApplication].keyWindow.rootViewController,[UMSocialControllerService defaultControllerService],YES);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [self showString:@"保存失败" forSecond:1.f];
    } else {
        [self showString:@"成功保存到相册" forSecond:1.f];
    }
}

- (void)commentButton:(UIButton*)shareBtn{
    CommentInputViewController *commentInputVC = [[CommentInputViewController alloc] init];
    commentInputVC.itemId = _itemId;
    [self.navigationController pushViewController:commentInputVC animated:YES];
    
}
- (void)detaileButton:(UIButton*)btn{
    MessageListDetailController *messageListDetailVC = [[MessageListDetailController alloc] init];
    messageListDetailVC.talkId = _itemId;
    [self.navigationController pushViewController:messageListDetailVC animated:YES];
    
}

//点赞
-(void)onLike:(UIButton *)shareBtn{
    
    if (_likeButton.selected == NO) {
        
        [self onClickLikeButton];
        
    }else if (_likeButton.selected == YES){
        
        [self onClickLikeButton];
    }
}
-(void)onClickLikeButton{
    NSString *strngXid;
    NSString *homeUserId;
    if ([XXEUserInfo user].login) {
        strngXid = [XXEUserInfo user].xid;
        homeUserId = [XXEUserInfo user].user_id;
    }else {
        strngXid = XID;
        homeUserId = USER_ID;
    }
    //点赞网络请求
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/my_circle_good";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":strngXid,
                           @"user_id":homeUserId,
                           @"user_type":USER_TYPE,
                           @"talk_id":_itemId,
                           };
    // 服务器返回的数据格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [manager POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] ){
            
            [self showString:@"点赞成功" forSecond:1.f];
            [_likeButton setTitle:@"取消" forState:UIControlStateSelected];
            _likeButton.selected = !_likeButton.selected;
        }else{
            
            [self showString:@"取消点赞" forSecond:1.f];
            
            [_likeButton setTitle:@"赞" forState:UIControlStateNormal];
            _likeButton.selected = !_likeButton.selected;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showString:@"网络不通，请检查网络！" forSecond:1.f];
        
    }];
}


- (BOOL)isDirectShareInIconActionSheet{
    return YES;
}

-(UIButton *) getButton:(CGRect) frame title:(NSString *) title image:(NSString *) image
{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return btn;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
