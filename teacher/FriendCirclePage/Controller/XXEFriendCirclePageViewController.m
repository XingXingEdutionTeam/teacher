//
//  XXEFriendCirclePageViewController.m
//  teacher
//
//  Created by codeDing on 16/8/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFriendCirclePageViewController.h"
#import "XXEFriendCircleApi.h"
#import "XXECircleUserModel.h"
#import "XXECircleModel.h"
#import "XXECommentModel.h"
#import "XXEGoodUserModel.h"
#import "XXEFriendMyCircleViewController.h"
#import "XXEPublishFriendCircleApi.h"

@interface XXEFriendCirclePageViewController ()
/** 朋友圈的头部视图信息 */
@property (nonatomic, strong)NSMutableArray *headerDatasource;
/** 朋友圈列表的信息 */
@property (nonatomic, strong)NSMutableArray *circleListDatasource;
/** 页数 */
@property (nonatomic, assign)NSInteger page;
@end

@implementation XXEFriendCirclePageViewController

- (NSMutableArray *)headerDatasource
{
    if (!_headerDatasource) {
        _headerDatasource = [NSMutableArray array];
    }
    return _headerDatasource;
}

- (NSMutableArray *)circleListDatasource
{
    if (!_circleListDatasource) {
        _circleListDatasource = [NSMutableArray array];
    }
    return _circleListDatasource;
}
/** 这两个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = XXEBackgroundColor;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"朋友圈控制器");
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.page = 1;
    //获取朋友圈信息
    [self setupFriendCircleMessagePage:1];
}

#pragma mark - 下拉刷新 与上拉加载更多
- (void)refresh
{
    self.page = 1;
    [self setupFriendCircleMessagePage:self.page];
    [self endRefresh];
}

- (void)loadMore
{
    self.page ++;
    NSLog(@"宫锁少爷%ld",(long)self.page);
    [self setupFriendCircleMessagePage:self.page];
    [self endLoadMore];
}


#pragma mark - 朋友圈网络请求
- (void)setupFriendCircleMessagePage:(NSInteger )page
{
    NSString *strngXid;
    NSString *homeUserId;
    if ([XXEUserInfo user].login) {
        strngXid = [XXEUserInfo user].xid;
        homeUserId = [XXEUserInfo user].user_id;
    }else {
        strngXid = XID;
        homeUserId = USER_ID;
    }
    
    NSString *pageNum = [NSString stringWithFormat:@"%ld",(long)page];
    if ([pageNum isEqualToString:@"1"]) {
        [self.circleListDatasource removeAllObjects];
    }
    XXEFriendCircleApi *friendCircleApi = [[XXEFriendCircleApi alloc]initWithFriendCircleXid:strngXid CircleUserId:homeUserId PageNumber:pageNum];
    [friendCircleApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSLog(@"%@",request.responseJSONObject);
        NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
        
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        
        if ([code intValue]==1 && [[request.responseJSONObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
            NSArray *list = [data objectForKey:@"list"];
            
            NSLog(@"用户信息%@",[data objectForKey:@"user_info"]);
            NSDictionary *userInfo = [data objectForKey:@"user_info"];
            
            XXECircleUserModel *Usermodel = [[XXECircleUserModel alloc]initWithDictionary:userInfo error:nil];
            [self.headerDatasource addObject:Usermodel];
            //设置顶部视图信息
            [self setHeaderMessage:Usermodel];
            NSLog(@"评论信息的列表的%@",list);
            NSLog(@"数组为%@",list[0]);
            for (int i =0; i<list.count; i++) {
                XXECircleModel *circleModel = [[XXECircleModel alloc]initWithDictionary:list[i] error:nil];
                [self.circleListDatasource addObject:circleModel];
            }
            [self endLoadMore];
        //朋友圈的信息列表
        [self friendCircleMessage];
        NSLog(@"圈子顶部信息数组信息%@",self.headerDatasource);
        }else{
            [self hudShowText:@"获取数据错误" second:2.f];
             [self endRefresh];
             [self endLoadMore];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
         [self endRefresh];
        [self endLoadMore];
    }];
}

/** 朋友圈头部信息 */
- (void)setHeaderMessage:(XXECircleUserModel *)model
{
    NSLog(@"======%@",model.head_img);
    NSString *cover = [NSString stringWithFormat:@"%@%@",kXXEPicURL,model.head_img];
    [self setCover:cover];
    [self setUserAvatar:cover];
    [self setUserNick:model.nickname];
    [self setUserSign:@""];
}

/** 朋友圈的信息列表 */
- (void)friendCircleMessage
{
    NSLog(@"有多少个单元格:%lu",(unsigned long)self.circleListDatasource.count);
    
    if (self.circleListDatasource.count != 0) {
        for (int i =0; i<self.circleListDatasource.count; i++) {
            XXECircleModel *circleModel = self.circleListDatasource[i];
            DFTextImageLineItem *textImageItem = [[DFTextImageLineItem alloc]init];
            textImageItem.itemId = 10000;
            textImageItem.userId = [circleModel.xid intValue];
            textImageItem.userAvatar = [NSString stringWithFormat:@"%@%@",kXXEPicURL,circleModel.head_img];
            textImageItem.userNick = circleModel.nickname;
            textImageItem.title = @"发表了";
            textImageItem.text = circleModel.words;
            textImageItem.location = circleModel.position;
            NSString *timeString = [XXETool dateAboutStringFromNumberTimer:circleModel.date_tm];
            NSLog(@"时间:%@",timeString);
            textImageItem.ts = [circleModel.date_tm integerValue]*1000;;
            
            //如果发布的圈子有图片则显示图片
            [self fritnd_circleImageShowTextImageItem:textImageItem CircleModel:circleModel];
        }
    }else{
        NSLog(@"没有数据");
    }
}

#pragma mark - 显示图片
- (void)fritnd_circleImageShowTextImageItem:(DFTextImageLineItem *)textImageItem CircleModel:(XXECircleModel *)circleModel
{
    //处理发布圈子的图片问题
    NSMutableArray *srcSmallImages = [NSMutableArray array];
    NSMutableArray *thumbBigImages = [NSMutableArray array];
    //判断图片的字符串里面有没有逗号
    
    if ([circleModel.pic_url containsString:@","]) {
        NSLog(@"包含");
        NSArray *array = [circleModel.pic_url componentsSeparatedByString:@","];
        for (NSString *image in array) {
            [srcSmallImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,image]];
            [thumbBigImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,image]];
            NSLog(@"小图片%@ 大图片%@",srcSmallImages,thumbBigImages);
            
        }
        textImageItem.srcImages = srcSmallImages;
        textImageItem.thumbImages = thumbBigImages;
    }else{
        NSLog(@"不包含");
        [srcSmallImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,circleModel.pic_url ]];
        [thumbBigImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,circleModel.pic_url ]];
        textImageItem.srcImages = srcSmallImages;
        textImageItem.thumbImages = thumbBigImages;
        
        NSLog(@"小图片%@ 大图片%@",srcSmallImages,thumbBigImages);
    }
    
    //发布的评论和点赞
    [self friend_circleShowCommentAndGoodCircleModel:circleModel TextImageItem:textImageItem];
    
}

#pragma mark - 数据点赞和评论的信息
- (void)friend_circleShowCommentAndGoodCircleModel:(XXECircleModel *)circleModel TextImageItem:(DFTextImageLineItem *)textImageItem
{
    //点赞
    if (circleModel.good_user.count == 0) {
        NSLog(@"没有人点赞");
    }else{
        for (int j =0; j<circleModel.good_user.count; j++) {
            XXEGoodUserModel *goodModel = circleModel.good_user[j];
            NSLog(@"%@",goodModel.goodXid);
            DFTextImageLineItem *likeItem = [[DFTextImageLineItem alloc]init];
            likeItem.userNick = goodModel.goodNickName;
            likeItem.userId = [goodModel.goodXid integerValue];
            [textImageItem.likes addObject:likeItem];
        }
        NSLog(@"点赞的信息%@",textImageItem.likes);
    }
    
    // 评论内容
    if (circleModel.comment_group.count != 0) {
        for (int k =0; k<circleModel.comment_group.count; k++) {
            DFLineCommentItem *commentItem = [[DFLineCommentItem alloc]init];
            XXECommentModel *commentModel = circleModel.comment_group[k];
            commentItem.commentId = [commentModel.commentId integerValue];
            commentItem.userId = [commentModel.commentXid integerValue];
            commentItem.userNick = commentModel.commentNicknName;
            commentItem.replyUserId = [commentModel.to_who_xid integerValue];
            commentItem.replyUserNick = commentModel.to_who_nickname;
            commentItem.text = commentModel.con;
            [textImageItem.comments addObject:commentItem];
        }
        NSLog(@"评论的信息%@",textImageItem.comments);
        
    }else{
        NSLog(@"数组为空");
    }
    [self addItem:textImageItem];
}


#pragma mark - DFImagesSendViewControllerDelegate 发布圈子的代理
-(void)onSendTextImage:(NSString *)text images:(NSArray *)images
{
    NSLog(@"发布的文字%@ 发布的图片%@",text,images);
    if (images.count ==0) {
        //往服务器传所有的参数
        [self publishFriendCircleText:text ImageFile:@""];
    }else{
    
    
    NSLog(@"%@",images);
    NSDictionary *dict = @{@"file_type":@"1",
                           @"page_origin":@"35",
                           @"upload_format":@"2",
                           @"appkey":APPKEY,
                           @"user_type":USER_TYPE,
                           @"backtype":BACKTYPE
                           };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:XXERegisterUpLoadPicUrl parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i< images.count; i++) {
            NSData *data = UIImageJPEGRepresentation(images[i], 0.5);
            NSString *name = [NSString stringWithFormat:@"%d.jpeg",i];
            NSString *formKey = [NSString stringWithFormat:@"file%d",i];
            NSString *type = @"image/jpeg";
            [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
        }
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSString *code = [responseObject objectForKey:@"code"];
        if ([code intValue] == 1) {
            NSArray *data = [responseObject objectForKey:@"data"];
            NSMutableString *str = [NSMutableString string];
            for (int i =0; i< data.count; i++) {
                NSString *string = data[i];
                if (i != data.count -1) {
                    [str appendFormat:@"%@,",string];
                }else {
                    [str appendFormat:@"%@",string];
                }
            }
            NSLog(@"图片的网址:%@",str);
            //往服务器传所有的参数
            [self publishFriendCircleText:text ImageFile:str];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    }
}

#pragma mark - 网服务器上传发布信息

- (void)publishFriendCircleText:(NSString *)text ImageFile:(NSString *)imageFile
{
    NSLog(@"图片:%@",imageFile);
    NSString *strngXid;
    NSString *homeUserId;
    if ([XXEUserInfo user].login) {
        strngXid = [XXEUserInfo user].xid;
        homeUserId = [XXEUserInfo user].user_id;
    }else {
        strngXid = XID;
        homeUserId = USER_ID;
    }
    XXEPublishFriendCircleApi *publishFriendApi = [[XXEPublishFriendCircleApi alloc]initWithPublishFriendCirclePosition:@"上海" FileType:@"1" Words:text File:imageFile UserXid:strngXid UserId:homeUserId];
    [publishFriendApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"发布内筒%@",request.responseJSONObject);
        NSLog(@"发布%@",[request.responseJSONObject objectForKey:@"msg"]);
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}


#pragma mark - 评论和点赞
-(void)onCommentCreate:(long long)commentId text:(NSString *)text itemId:(long long) itemId
{
    NSLog(@"评论%@",text);
    NSInteger myXId = [[XXEUserInfo user].xid integerValue];
    
    DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
    commentItem.commentId = [[NSDate date] timeIntervalSince1970];
    commentItem.userId = myXId;
    commentItem.userNick = [XXEUserInfo user].nickname;
    commentItem.text = text;
    [self addCommentItem:commentItem itemId:itemId replyCommentId:commentId];
}

- (void)onLike:(long long)itemId
{
    NSLog(@"点赞");
    NSInteger myXId = [[XXEUserInfo user].xid integerValue];
    //点赞
    NSLog(@"onLike: %lld", itemId);
    DFLineLikeItem *likeItem = [[DFLineLikeItem alloc] init];
    likeItem.userId = myXId;
    likeItem.userNick = [XXEUserInfo user].nickname;
    [self addLikeItem:likeItem itemId:itemId];
}

//点击左边头像 或者 点击评论和赞的用户昵称
-(void)onClickUser:(NSUInteger)userId
{
    NSLog(@"%lu",(unsigned long)userId);
    XXEFriendMyCircleViewController *myCircleVC = [[XXEFriendMyCircleViewController alloc]init];
    myCircleVC.otherXid = userId;
    [self.navigationController pushViewController:myCircleVC animated:YES];
}


-(void)onClickHeaderUserAvatar
{
    NSString *string = [XXEUserInfo user].xid;
    NSInteger myXId = [string integerValue];
    [self onClickUser:myXId];
}


//发送视频 目前没有实现填写文字
-(void)onSendVideo:(NSString *)text videoPath:(NSString *)videoPath screenShot:(UIImage *)screenShot
{
    DFVideoLineItem *videoItem = [[DFVideoLineItem alloc] init];
    videoItem.itemId = 10000000; //随便设置一个 待服务器生成
    videoItem.userId = 10018;
    videoItem.userAvatar = @"http://file-cdn.datafans.net/avatar/1.jpeg";
    videoItem.userNick = @"富二代";
    videoItem.title = @"发表了";
    videoItem.text = @"新年过节 哈哈"; //这里需要present一个界面 用户填入文字后再发送 场景和发图片一样
    videoItem.location = @"广州";
    
    videoItem.localVideoPath = videoPath;
    videoItem.videoUrl = @""; //网络路径
    videoItem.thumbUrl = @"";
    videoItem.thumbImage = screenShot; //如果thumbImage存在 优先使用thumbImage
    
    [self addItemTop:videoItem];
    
    //接着上传图片 和 请求服务器接口
    //请求完成之后 刷新整个界面
    
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
