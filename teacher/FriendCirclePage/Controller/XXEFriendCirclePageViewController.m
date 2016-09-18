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
#import "XXEFriendCirclegoodApi.h"
#import "XXEFriendCircleCommentApi.h"
#import "SVProgressHUD.h"
#import "XXEDeleteCommentApi.h"

@interface XXEFriendCirclePageViewController ()
/** 朋友圈的头部视图信息 */
@property (nonatomic, strong)NSMutableArray *headerDatasource;
/** 朋友圈列表的信息 */
@property (nonatomic, strong)NSMutableArray *circleListDatasource;
/** 页数 */
@property (nonatomic, assign)NSInteger page;
/** 说说ID */
@property (nonatomic, copy)NSString *speakId;
/** 用户昵称 */
@property (nonatomic, copy)NSString *userNickName;

/** 回复的内容 */
@property (nonatomic, copy)NSString *toWhoComment;


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
    self.speakId = @"";
    self.view.backgroundColor = XXEBackgroundColor;
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
    NSLog(@"数组为数据:%@",self.circleListDatasource);
    XXEFriendCircleApi *friendCircleApi = [[XXEFriendCircleApi alloc]initWithFriendCircleXid:strngXid CircleUserId:homeUserId PageNumber:pageNum];
    [friendCircleApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSLog(@"%@",request.responseJSONObject);
        NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
        
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        NSLog(@"%@",code);
        if ([code intValue]==1 && [[request.responseJSONObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
            NSArray *list = [data objectForKey:@"list"];
            
            NSLog(@"用户信息%@",[data objectForKey:@"user_info"]);
            NSDictionary *userInfo = [data objectForKey:@"user_info"];
            
            XXECircleUserModel *Usermodel = [[XXECircleUserModel alloc]initWithDictionary:userInfo error:nil];
            [self.headerDatasource addObject:Usermodel];
            //设置顶部视图信息
            [self setHeaderMessage:Usermodel];
            NSLog(@"!!!!!!!评论信息的列表的%@",list);
             NSLog(@"!!!!!!!评论信息的列表的%@",list[0]);
            for (int i =0; i<list.count; i++) {
                XXECircleModel *circleModel = [[XXECircleModel alloc]initWithDictionary:list[i] error:nil];
                [self.circleListDatasource addObject:circleModel];
            }
        //朋友圈的信息列表
        [self friendCircleMessage];
        NSLog(@"圈子顶部信息数组信息%@",self.headerDatasource);
        }else{
            [self hudShowText:@"获取数据错误" second:2.f];
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
    self.userNickName = model.nickname;
    [self setCover:cover];
    [self setUserAvatar:cover];
    [self setUserNick:model.nickname];
    [self setUserSign:@""];
}

/** 朋友圈的信息列表 */
- (void)friendCircleMessage
{
    NSLog(@"有多少个单元格:%lu",(unsigned long)self.circleListDatasource.count);
    int j=1;
    if (self.circleListDatasource.count != 0) {
        for (int i =0; i<self.circleListDatasource.count; i++) {
            XXECircleModel *circleModel = self.circleListDatasource[i];
            DFTextImageLineItem *textImageItem = [[DFTextImageLineItem alloc]init];
            
            textImageItem.itemId = j;
            j++;
            textImageItem.userId = [circleModel.xid intValue];
            textImageItem.userAvatar = [NSString stringWithFormat:@"%@%@",kXXEPicURL,circleModel.head_img];
            textImageItem.userNick = circleModel.nickname;
            textImageItem.title = @"发表了";
            textImageItem.text = circleModel.words;
            textImageItem.location = circleModel.position;
            NSString *timeString = [XXETool dateAboutStringFromNumberTimer:circleModel.date_tm];
            NSLog(@"时间:%@",timeString);
            textImageItem.ts = [circleModel.date_tm integerValue]*1000;;
            textImageItem.speak_Id = circleModel.talkId;
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
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        if ([code integerValue]== 1) {
            
            NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
            NSString *head_image = [data objectForKey:@"head_img"];
            
            DFTextImageLineItem *textImageItem = [[DFTextImageLineItem alloc]init];
            textImageItem.itemId = 10000;
            textImageItem.userId =[strngXid integerValue];
            NSString *avatarImage = [NSString stringWithFormat:@"%@%@",kXXEPicURL,head_image];
            textImageItem.userAvatar = avatarImage;
            textImageItem.userNick = [XXEUserInfo user].nickname;
            textImageItem.title = @"发表了";
            textImageItem.text = text;
            textImageItem.ts = [[NSDate date] timeIntervalSince1970]*1000;
            //处理发布圈子的图片问题
            NSMutableArray *srcSmallImages = [NSMutableArray array];
            NSMutableArray *thumbBigImages = [NSMutableArray array];
            //判断图片的字符串里面有没有逗号
            if ([imageFile containsString:@","]) {
                NSLog(@"包含");
                NSArray *array = [imageFile componentsSeparatedByString:@","];
                for (NSString *image in array) {
                    [srcSmallImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,image]];
                    [thumbBigImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,image]];
                    NSLog(@"小图片%@ 大图片%@",srcSmallImages,thumbBigImages);
                    
                }
                textImageItem.srcImages = srcSmallImages;
                textImageItem.thumbImages = thumbBigImages;
            }else{
                NSLog(@"不包含");
                [srcSmallImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,imageFile ]];
                [thumbBigImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,imageFile ]];
                textImageItem.srcImages = srcSmallImages;
                textImageItem.thumbImages = thumbBigImages;
                
                NSLog(@"小图片%@ 大图片%@",srcSmallImages,thumbBigImages);
            }
            
            textImageItem.location = @"上海";
             [self addItemTop:textImageItem];
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
        }
        [self refresh];
    } failure:^(__kindof YTKBaseRequest *request) {
        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
    }];
}


#pragma mark - 评论和点赞
-(void)onCommentCreate:(long long)commentId text:(NSString *)text itemId:(long long) itemId
{
    NSLog(@"-=-=-:%lld",commentId);
    NSLog(@"%lld",itemId);
    NSString *strngXid;
    NSString *homeUserId;
    NSString *otherXid;
    if ([XXEUserInfo user].login) {
        strngXid = [XXEUserInfo user].xid;
        homeUserId = [XXEUserInfo user].user_id;
    }else {
        strngXid = XID;
        homeUserId = USER_ID;
    }
    
    NSInteger myXId = [[XXEUserInfo user].xid integerValue];
    
    long indexId = itemId-1;
    NSLog(@"新的:%ld",indexId);
    if (self.circleListDatasource.count ==0) {
        [self hudShowText:@"没有数据" second:1.f];
    }else{
        XXECircleModel *circleModel = self.circleListDatasource[indexId];
        self.speakId = circleModel.talkId;
        otherXid = circleModel.xid;
    }
    self.toWhoComment = text;
    if (commentId > 0) {
        //回复
        DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
        commentItem.commentId = [[NSDate date] timeIntervalSince1970];
        commentItem.userId = myXId;
        commentItem.userNick = self.userNickName;
        commentItem.text = text;
        [self addCommentItem:commentItem itemId:itemId replyCommentId:commentId];
    }else{
        //评论
        //网络请求可以放在这里
        
        XXEFriendCircleCommentApi *friendCommentApi = [[XXEFriendCircleCommentApi alloc]initWithFriendCircleCommentUerXid:strngXid UserID:homeUserId TalkId:self.speakId Com_type:@"1" Con:text To_Who_Xid:otherXid];
        [friendCommentApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            NSString *code = [request.responseJSONObject objectForKey:@"code"];
            if ([code integerValue] == 1) {
                DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
                commentItem.commentId = [[NSDate date] timeIntervalSince1970];
                commentItem.userId = myXId;
                commentItem.userNick = self.userNickName;
                commentItem.text = text;
                [self addCommentItem:commentItem itemId:itemId replyCommentId:commentId];
                [self hudShowText:@"评论成功" second:1.f];
            }else{
                
                [self hudShowText:@"评论失败" second:1.f];
            }
            NSLog(@"%@",request.responseJSONObject);
            NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
            
        } failure:^(__kindof YTKBaseRequest *request) {
            [self hudShowText:@"网络失败" second:1.f];
        }];
    }
}

//如果是回复就会执行这个方法所以回复的网络请求就可以放在这里
- (void)xxe_friendCirclePageCommentToWhoXid:(NSInteger)toWhoXid
{
//    NSLog(@"%ld",(long)toWhoXid);
    NSString *strngXid;
    NSString *homeUserId;
    if ([XXEUserInfo user].login) {
        strngXid = [XXEUserInfo user].xid;
        homeUserId = [XXEUserInfo user].user_id;
    }else {
        strngXid = XID;
        homeUserId = USER_ID;
    }
    NSString *stringToWhoXid = [NSString stringWithFormat:@"%ld",(long)toWhoXid];
//    NSLog(@"回复人的XID%@,回复人的USERID%@",strngXid,homeUserId);
//    NSLog(@"回复内容%@ 被回复人的XID%@",self.toWhoComment,stringToWhoXid);
     XXEFriendCircleCommentApi *friendCommentApi = [[XXEFriendCircleCommentApi alloc]initWithFriendCircleCommentUerXid:strngXid UserID:homeUserId TalkId:self.speakId Com_type:@"2" Con:self.toWhoComment To_Who_Xid:stringToWhoXid];
    [friendCommentApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        if ([code integerValue] == 1) {
             [self hudShowText:@"回复成功" second:1.f];
        }else{
            [self hudShowText:@"回复失败" second:1.f];
        }
        NSLog(@"%@",request.responseJSONObject);
        NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self hudShowText:@"回复失败" second:1.f];
    }];
}

//删除评论 网络请求
#pragma mark - 删除评论 的网络请求
-(void) deleteClickComment:(long long) commentId itemId:(long long) itemId
{
    NSLog(@"长按删除评论");
    NSString *strngXid;
    NSString *homeUserId;
    if ([XXEUserInfo user].login) {
        strngXid = [XXEUserInfo user].xid;
        homeUserId = [XXEUserInfo user].user_id;
    }else {
        strngXid = XID;
        homeUserId = USER_ID;
    }
    
    long indexId = itemId-1;
    NSLog(@"新的:%ld",indexId);
    if (self.circleListDatasource.count ==0) {
        [self hudShowText:@"没有数据" second:1.f];
    }else{
        XXECircleModel *circleModel = self.circleListDatasource[indexId];
        self.speakId = circleModel.talkId;
    }
    
    NSLog(@"commentId%lld itemI%lld",commentId, itemId);
    NSLog(@"说说ID%@",self.speakId);
    NSLog(@"CommentId%lld",commentId);
    NSString *commentID = [NSString stringWithFormat:@"%lld",commentId];
    XXEDeleteCommentApi *commentApi = [[XXEDeleteCommentApi alloc]initWithDeleteCommentEventType:@"3" TalkId:self.speakId CommentId:commentID UserXid:strngXid UserId:homeUserId];
    [commentApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"%@",request.responseJSONObject);
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        NSString *data = [request.responseJSONObject objectForKey:@"data"];
        NSLog(@":data%@",data);
        if ([code integerValue]==1) {
            NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
            NSLog(@"%@",[request.responseJSONObject objectForKey:@"data"]);
            DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
            commentItem.commentId = [[NSDate date] timeIntervalSince1970];
            commentItem.userId = [strngXid integerValue];
            commentItem.userNick = @"";
            commentItem.text = @"";
            [self cancelCommentItem:commentItem itemId:itemId replyCommentId:commentId];
            [self hudShowText:@"删除成功" second:1.f];
        }else{
            [self hudShowText:@"删除失败" second:1.f];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [self hudShowText:@"网络请求失败" second:1.f];
    }];
}

- (void)onLike:(long long)itemId
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
    long indexId = itemId-1;
    NSLog(@"新的:%ld",indexId);
    if (self.circleListDatasource.count ==0) {
        [self hudShowText:@"没有数据" second:1.f];
    }else{
       XXECircleModel *circleModel = self.circleListDatasource[indexId];
        self.speakId = circleModel.talkId;
    NSLog(@"说说ID%@ XID%@ UserID%@",self.speakId ,strngXid,homeUserId);
    XXEFriendCirclegoodApi *friendGoodApi = [[XXEFriendCirclegoodApi alloc]initWithFriendCircleGoodOrCancelUerXid:strngXid UserID:homeUserId TalkId:self.speakId];
    [friendGoodApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
        NSString *goodXid = [data objectForKey:@"xid"];
        NSString *goodNickName = [data objectForKey:@"nickname"];
        
        if ([code integerValue]==1) {
            DFLineLikeItem *likeItem = [[DFLineLikeItem alloc] init];
            likeItem.userId = [goodXid integerValue];
            likeItem.userNick = goodNickName;
            NSLog(@"Model%@ ID%lld",likeItem,itemId);
            [self addLikeItem:likeItem itemId:itemId];
            [self hudShowText:@"点赞成功" second:1.f];
            
        }else if ([code integerValue]==10){
            DFLineLikeItem *likeItem = [[DFLineLikeItem alloc] init];
            likeItem.userId = [goodXid integerValue];
            likeItem.userNick = goodNickName;
            NSLog(@"Model%@ ID%lld",likeItem,itemId);
            [self cancelLikeItem:likeItem itemId:itemId];
            [self hudShowText:@"取消成功" second:1.f];
        }
    
    } failure:^(__kindof YTKBaseRequest *request) {
        [self hudShowText:@"网络不通，请检查网络！" second:1.f];
    }];
    
    }
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
    videoItem.itemId = 10000; //随便设置一个 待服务器生成
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
