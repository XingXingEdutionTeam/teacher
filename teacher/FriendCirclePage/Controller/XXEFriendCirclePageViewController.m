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
#import "XXEWhoCanLookController.h"
#import "XXELocationAddController.h"
#import <AVFoundation/AVFoundation.h>

@interface XXEFriendCirclePageViewController ()<DFTimeLineViewControllerDelegate, NSCopying>
{

    NSString *parameterXid;
    NSString *parameterUser_Id;
}

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

@property(nonatomic ,assign) BOOL isMaxLoading;


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
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    NSLog(@"朋友圈控制器");
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.page = 1;
    //获取朋友圈信息
    [self setupFriendCircleMessagePage: _page];
    
    self.delegate = self;
}


#pragma mark - 下拉刷新 与上拉加载更多
- (void)refresh
{
    self.page = 1;
    [self setupFriendCircleMessagePage:self.page];
}

- (void)loadMore
{
    if (self.isMaxLoading) {
        return;
    }
    
    self.page ++;
    [self setupFriendCircleMessagePage:self.page];
}


#pragma mark - 朋友圈网络请求
- (void)setupFriendCircleMessagePage:(NSInteger )page
{
    /*
     【我的圈子--查询我发布的】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Global/select_mycircle
     传参:
     other_xid	//别人查看某人时,传某人的xid,如果是查看自己发布的,不需要这个参数
     page	//加载第几次(第几页),默认1
     */
//    __weak __typeof(self) weakSelf = self;
    NSString *pageNum = [NSString stringWithFormat:@"%ld",(long)page];
    if ([pageNum isEqualToString:@"1"]) {
        [self.circleListDatasource removeAllObjects];
    }
    __weak __typeof(self)weakSelf = self;
    XXEFriendCircleApi *friendCircleApi = [[XXEFriendCircleApi alloc]initWithFriendCircleXid:parameterXid CircleUserId:parameterUser_Id PageNumber:pageNum];
    [friendCircleApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        NSInteger maxPage = [[[request.responseJSONObject objectForKey:@"data"] objectForKey:@"max_page"] integerValue];
        
        if ([code intValue]==1 && [[request.responseJSONObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            [weakSelf detelAllSource];
            NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
            NSDictionary *userInfo = [data objectForKey:@"user_info"];
            XXECircleUserModel *Usermodel = [[XXECircleUserModel alloc]initWithDictionary:userInfo error:nil];
            [weakSelf.headerDatasource addObject:Usermodel];
            [weakSelf setHeaderMessage:Usermodel];
            
            //判断是否有信息
            if ([Usermodel.circle_noread isEqualToString:@"1"]) {
                [weakSelf creatNewMessageRemindcircleNoread:Usermodel.circle_noread];
            }
            
            if ([[data objectForKey:@"list"]isKindOfClass:[NSArray class]] ) {
                NSArray *list = [data objectForKey:@"list"];
                for (int i =0; i<list.count; i++) {
                    XXECircleModel *circleModel = [[XXECircleModel alloc]initWithDictionary:list[i] error:nil];
                    [weakSelf.circleListDatasource addObject:circleModel];
                };
                
                [weakSelf friendCircleMessage];
//                dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                    for (int i =0; i<list.count; i++) {
//                        XXECircleModel *circleModel = [[XXECircleModel alloc]initWithDictionary:list[i] error:nil];
//                        [weakSelf.circleListDatasource addObject:circleModel];
//                    }
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                       [weakSelf friendCircleMessage];
//                    });
//                });
                
//                NSLog(@"%lu",(unsigned long)self.circleListDatasource.count);
                //朋友圈的信息列表
                
            }
            
            [weakSelf endRefresh];
            weakSelf.isMaxLoading = NO;
            
            if (weakSelf.page == maxPage) {
                weakSelf.isMaxLoading = YES;
                [weakSelf hudShowText:@"已经是最后一条了" second:2.f];
                [weakSelf endRefresh];
                [weakSelf endLoadMore];
            }
            [weakSelf.tableView reloadData];
        }else {
            weakSelf.isMaxLoading = YES;
            [weakSelf hudShowText:@"获取数据错误" second:2.f];
            [weakSelf endRefresh];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
         [weakSelf endRefresh];
        [weakSelf endLoadMore];
    }];
}

/** 朋友圈头部信息 */
- (void)setHeaderMessage:(XXECircleUserModel *)model
{
    NSString *cover;
//    NSLog(@"======%@",model.head_img);
    if ([model.head_img_type isEqualToString:@"0"]){
        cover = [NSString stringWithFormat:@"%@%@",kXXEPicURL,model.head_img];
    }else {
        cover = model.head_img;
    }
    
    self.userNickName = model.nickname;
    [self setCover:cover];
    [self setUserAvatar:cover];
    [self setUserNick:model.nickname];
    [self setUserSign:@""];
}

/** 朋友圈的信息列表 */
- (void)friendCircleMessage
{
//    NSLog(@"有多少个单元格:%lu",(unsigned long)self.circleListDatasource.count);
    int j=1;
    if (self.circleListDatasource.count != 0) {
        for (int i =0; i<self.circleListDatasource.count; i++) {
            XXECircleModel *circleModel = self.circleListDatasource[i];
            DFTextImageLineItem *textImageItem = [[DFTextImageLineItem alloc] init];
            
            
            textImageItem.itemId = j;
//            NSLog(@"时间轴:%lld",textImageItem.itemId);
            j++;
            [textImageItem configure:[circleModel copy]];
            //如果发布的圈子有图片则显示图片
            if (self.page == 1) {
                [self.tableView reloadData];
            }
            
            [self fritnd_circleImageShowTextImageItem:textImageItem CircleModel:circleModel];
        }
    }else{
        NSLog(@"ggg没有数据");
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
        NSArray *array = [circleModel.pic_url componentsSeparatedByString:@","];
        for (NSString *image in array) {
            [srcSmallImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,image]];
            [thumbBigImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,image]];
            
        }
        textImageItem.srcImages = srcSmallImages;
        textImageItem.thumbImages = thumbBigImages;
    }else{
//        NSLog(@"不包含");
        [srcSmallImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,circleModel.pic_url ]];
        [srcSmallImages addObject:@"哈哈.png"];
        
        [thumbBigImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,circleModel.pic_url ]];
        [thumbBigImages addObject:@"哈哈.png"];
        textImageItem.srcImages = srcSmallImages;
        textImageItem.thumbImages = thumbBigImages;
    }
    //发布的评论和点赞
    [self friend_circleShowCommentAndGoodCircleModel:circleModel TextImageItem:textImageItem];
}

#pragma mark - 数据点赞和评论的信息
- (void)friend_circleShowCommentAndGoodCircleModel:(XXECircleModel *)circleModel TextImageItem:(DFTextImageLineItem *)textImageItem
{
    
    //点赞
    if (circleModel.good_user.count == 0) {
//        NSLog(@"没有人点赞");
    }else{
        
        for (int j =0; j<circleModel.good_user.count; j++) {
            XXEGoodUserModel *goodModel = circleModel.good_user[j];
            DFTextImageLineItem *likeItem = [[DFTextImageLineItem alloc]init];
            likeItem.userNick = goodModel.goodNickName;
            likeItem.userId = [goodModel.goodXid integerValue];
            [textImageItem.likes addObject:likeItem];
        }
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
//        NSLog(@"评论的信息%@",textImageItem.comments);
        
    }else{
        NSLog(@"数组为空");
    }
    
    [self addItem:textImageItem];
}


#pragma mark - DFImagesSendViewControllerDelegate 发布圈子的代理
-(void)onSendTextImage:(NSString *)text images:(NSArray *)images Location:(NSString *)location PersonSee:(NSString *)personSee
{
//    NSLog(@"发布的文字%@ 发布的图片%@",text,images);
    if (images.count ==0) {
        
        //往服务器传所有的参数
        [self publishFriendCircleText:text ImageFile:@"" Location:location PersonSee:personSee];
    }else if(images.count == 1) {
        
        NSDictionary *dict = @{@"file_type":@"1",
                               @"page_origin":@"35",
                               @"upload_format":@"1",
                               @"appkey":APPKEY,
                               @"user_type":USER_TYPE,
                               @"backtype":BACKTYPE
                               };
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:XXERegisterUpLoadPicUrl parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
                NSData *data = UIImageJPEGRepresentation(images[0], 0.5);
                NSString *name = [NSString stringWithFormat:@"1.jpeg"];
                NSString *formKey = [NSString stringWithFormat:@"file"];
                NSString *type = @"image/jpeg";
                [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
            
        } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
//            NSLog(@"%@",responseObject);
//            NSLog(@"%@",[responseObject objectForKey:@"msg"]);
            NSString *code = [responseObject objectForKey:@"code"];
            if ([code intValue] == 1) {
                NSString *data = [responseObject objectForKey:@"data"];
                
//                NSLog(@"图片的网址:%@",data);
                //往服务器传所有的参数
                [self publishFriendCircleText:text ImageFile:data Location:location PersonSee:personSee];
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
        
    }else{
//    NSLog(@"%@",images);
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
//            NSLog(@"图片的网址:%@",str);
            //往服务器传所有的参数
            [self publishFriendCircleText:text ImageFile:str Location:location PersonSee:personSee];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    }
}

#pragma mark - 网服务器上传发布信息

- (void)publishFriendCircleText:(NSString *)text ImageFile:(NSString *)imageFile Location:(NSString *)location PersonSee:(NSString *)personSee
{
//    NSLog(@"图片:%@",imageFile);
//    NSLog(@"内容:%@",text);
//    NSLog(@"地点:%@",location);
//    NSLog(@"谁可见:%@",personSee);
    
    if ([personSee isEqualToString:@""]) {
        personSee = @"0";
    }else if ([personSee isEqualToString:@"仅自己可见"]){
        personSee = @"1";
    }else if ([personSee isEqualToString:@"好友可见"]){
        personSee = @"2";
    }else if ([personSee isEqualToString:@"班级通讯录可见"]){
        personSee = @"3";
    }else{
        personSee = @"0";
    }
    
    XXEPublishFriendCircleApi *publishFriendApi = [[XXEPublishFriendCircleApi alloc]initWithPublishFriendCirclePosition:location FileType:@"1" Words:text PicGroup:imageFile VideoUrl:@"" CircleSet:personSee UserXid:parameterXid UserId:parameterUser_Id];
    
    [publishFriendApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        NSLog(@"发布内筒%@",request.responseJSONObject);
//        NSLog(@"发布%@",[request.responseJSONObject objectForKey:@"msg"]);
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        if ([code integerValue]== 1) {
            
            NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
            NSString *head_image = [data objectForKey:@"head_img"];
            
            DFTextImageLineItem *textImageItem = [[DFTextImageLineItem alloc]init];
            textImageItem.itemId = 1;
            textImageItem.userId =[parameterXid integerValue];
            NSString *avatarImage = [NSString stringWithFormat:@"%@%@",kXXEPicURL,head_image];
            textImageItem.userAvatar = avatarImage;
            textImageItem.userNick = [data objectForKey:@"nickname"];
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
//                 NSLog(@"小%@ 大%@",textImageItem.srcImages,textImageItem.thumbImages);
            }else{
                NSLog(@"不包含");
                [srcSmallImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,imageFile ]];
                [srcSmallImages addObject:@"哈哈.png"];
                [thumbBigImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,imageFile ]];
                [thumbBigImages addObject:@"哈哈.png"];
                textImageItem.srcImages = srcSmallImages;
                textImageItem.thumbImages = thumbBigImages;
                
//                NSLog(@"小图片%@ 大图片%@",srcSmallImages,thumbBigImages);
//                NSLog(@"小%@ 大%@",textImageItem.srcImages,textImageItem.thumbImages);
            }
            textImageItem.location = location;
             [self addItemTop:textImageItem];
            //获取朋友圈信息
            [self setupFriendCircleMessagePage:1];
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
            [self endRefresh];
            [self endLoadMore];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
        [self endRefresh];
        [self endLoadMore];
    }];
}

#pragma mark - 评论和点赞
-(void)onCommentCreate:(long long)commentId text:(NSString *)text itemId:(long long) itemId
{
    NSString *otherXid;

    NSInteger myXId = [parameterXid integerValue];
    
    long indexId = itemId-1;
//    NSLog(@"新的:%ld",indexId);
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
//        [self setupFriendCircleMessagePage:1];
    }else{
        //评论
        //网络请求可以放在这里
        XXEFriendCircleCommentApi *friendCommentApi = [[XXEFriendCircleCommentApi alloc]initWithFriendCircleCommentUerXid:parameterXid UserID:parameterUser_Id TalkId:self.speakId Com_type:@"1" Con:text To_Who_Xid:otherXid];
        [friendCommentApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            
            NSLog(@"点赞/评论 数据 --- %@", request.responseJSONObject);
            NSString *code = [request.responseJSONObject objectForKey:@"code"];
            NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
            
            if ([code integerValue] == 1) {
                DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
                commentItem.commentId = [data[@"id"] intValue];
                commentItem.userId = myXId;
                commentItem.userNick = self.userNickName;
                commentItem.text = text;
                [self addCommentItem:commentItem itemId:itemId replyCommentId:commentId];
                [self hudShowText:@"评论成功" second:1.f];
//                [self setupFriendCircleMessagePage:_page];
            }else{
                
                [self hudShowText:@"评论失败" second:1.f];
            }
//            NSLog(@"%@",request.responseJSONObject);
//            NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
            
        } failure:^(__kindof YTKBaseRequest *request) {
            [self hudShowText:@"网络失败" second:1.f];
        }];
    }
}

//如果是回复就会执行这个方法所以回复的网络请求就可以放在这里
- (void)xxe_friendCirclePageCommentToWhoXid:(NSInteger)toWhoXid
{
//    NSLog(@"%ld",(long)toWhoXid);

    NSString *stringToWhoXid = [NSString stringWithFormat:@"%ld",(long)toWhoXid];
//    NSLog(@"回复人的XID%@,回复人的USERID%@",strngXid,homeUserId);
//    NSLog(@"回复内容%@ 被回复人的XID%@",self.toWhoComment,stringToWhoXid);
     XXEFriendCircleCommentApi *friendCommentApi = [[XXEFriendCircleCommentApi alloc]initWithFriendCircleCommentUerXid:parameterXid UserID:parameterUser_Id TalkId:self.speakId Com_type:@"2" Con:self.toWhoComment To_Who_Xid:stringToWhoXid];
    [friendCommentApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        if ([code integerValue] == 1) {
             [self hudShowText:@"回复成功" second:1.f];
//            [self setupFriendCircleMessagePage:_page];
            [self.tableView reloadData];
        }else{
            [self hudShowText:@"回复失败" second:1.f];
        }
//        NSLog(@"%@",request.responseJSONObject);
//        NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self hudShowText:@"回复失败" second:1.f];
    }];
}

//删除评论 网络请求
#pragma mark - 删除评论 的网络请求

-(void) deleteComment:(long long)commentId itemId:(long long)itemId {
    
    long indexId = itemId-1;
    //    NSLog(@"新的:%ld",indexId);
    if (self.circleListDatasource.count ==0) {
        [self hudShowText:@"没有数据" second:1.f];
    }else{
        XXECircleModel *circleModel = self.circleListDatasource[indexId];
        self.speakId = circleModel.talkId;
    }
    
    //    NSLog(@"commentId%lld itemI%lld",commentId, itemId);
    //    NSLog(@"说说ID%@",self.speakId);
    //    NSLog(@"CommentId%lld",commentId);
    NSString *commentID = [NSString stringWithFormat:@"%lld",commentId];
    XXEDeleteCommentApi *commentApi = [[XXEDeleteCommentApi alloc]initWithDeleteCommentEventType:@"3" TalkId:self.speakId CommentId:commentID UserXid:parameterXid UserId:parameterUser_Id];
    [commentApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //        NSLog(@"%@",request.responseJSONObject);
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        //        NSLog(@":data%@",data);
        if ([code integerValue]==1 || [code integerValue]==5 ) {
            //            NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
            //            NSLog(@"%@",[request.responseJSONObject objectForKey:@"data"]);
            DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
            commentItem.commentId = commentId;
            commentItem.userId = [parameterXid integerValue];
            commentItem.userNick = @"";
            commentItem.text = @"";
            [self cancelCommentItem:commentItem itemId:itemId replyCommentId:commentId];
            [self hudShowText:@"删除成功" second:1.f];
            [self.tableView reloadData];
//            [self setupFriendCircleMessagePage:_page];
        }else{
            [self hudShowText:@"删除失败" second:1.f];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [self hudShowText:@"网络请求失败" second:1.f];
    }];

}

-(void) deleteClickComment:(long long) commentId itemId:(long long) itemId
{
//    NSLog(@"长按删除评论");
//    
//    long indexId = itemId-1;
////    NSLog(@"新的:%ld",indexId);
//    if (self.circleListDatasource.count ==0) {
//        [self hudShowText:@"没有数据" second:1.f];
//    }else{
//        XXECircleModel *circleModel = self.circleListDatasource[indexId];
//        self.speakId = circleModel.talkId;
//    }
//    
////    NSLog(@"commentId%lld itemI%lld",commentId, itemId);
////    NSLog(@"说说ID%@",self.speakId);
////    NSLog(@"CommentId%lld",commentId);
//    NSString *commentID = [NSString stringWithFormat:@"%lld",commentId];
//    XXEDeleteCommentApi *commentApi = [[XXEDeleteCommentApi alloc]initWithDeleteCommentEventType:@"3" TalkId:self.speakId CommentId:commentID UserXid:parameterXid UserId:parameterUser_Id];
//    [commentApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
////        NSLog(@"%@",request.responseJSONObject);
//        NSString *code = [request.responseJSONObject objectForKey:@"code"];
//        NSString *data = [request.responseJSONObject objectForKey:@"data"];
////        NSLog(@":data%@",data);
//        if ([code integerValue]==1 || [code integerValue]==5 ) {
////            NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
////            NSLog(@"%@",[request.responseJSONObject objectForKey:@"data"]);
//            DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
//            commentItem.commentId = commentId;
//            commentItem.userId = [parameterXid integerValue];
//            commentItem.userNick = @"";
//            commentItem.text = @"";
//            [self cancelCommentItem:commentItem itemId:itemId replyCommentId:commentId];
//            [self hudShowText:@"删除成功" second:1.f];
//            [self setupFriendCircleMessagePage:_page];
//        }else{
//            [self hudShowText:@"删除失败" second:1.f];
//        }
//    } failure:^(__kindof YTKBaseRequest *request) {
//        [self hudShowText:@"网络请求失败" second:1.f];
//    }];
}




#pragma mark *******************  点赞  ********************
- (void)onLike:(long long)itemId
{
    NSLog(@"%lld",itemId);

    long indexId = itemId-1;
//    NSLog(@"新的:%ld",indexId);
    if (self.circleListDatasource.count ==0) {
        [self hudShowText:@"没有数据" second:1.f];
    }else{
       XXECircleModel *circleModel = self.circleListDatasource[indexId];
        self.speakId = circleModel.talkId;
//    NSLog(@"说说ID%@ XID%@ UserID%@",self.speakId ,strngXid,homeUserId);
    XXEFriendCirclegoodApi *friendGoodApi = [[XXEFriendCirclegoodApi alloc]initWithFriendCircleGoodOrCancelUerXid:parameterXid UserID:parameterUser_Id TalkId:self.speakId];
    [friendGoodApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        /*
         code = 10;    //取消点赞 成功
         data =     {
         nickname = summer;
         xid = 18886394;
         };
         msg = "Success!\U53d6\U6d88\U8d5e\U6210\U529f!";
         */
        
//        NSLog(@"zan ===== %@", request.responseJSONObject);
        
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
        NSString *goodXid = [data objectForKey:@"xid"];
        NSString *goodNickName = [data objectForKey:@"nickname"];
        
        if ([code integerValue]==1) {
            DFLineLikeItem *likeItem = [[DFLineLikeItem alloc] init];
            likeItem.userId = [goodXid integerValue];
            likeItem.userNick = goodNickName;
//            NSLog(@"Model%@ ID%lld",likeItem,itemId);
            [self addLikeItem:likeItem itemId:itemId isSelet:NO];
            [self hudShowText:@"点赞成功" second:1.f];
        }else if ([code integerValue]==10){
            DFLineLikeItem *likeItem = [[DFLineLikeItem alloc] init];
            likeItem.userId = [goodXid integerValue];
            likeItem.userNick = goodNickName;
            [self addLikeItem:likeItem itemId:itemId isSelet:YES];
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
//    NSLog(@"%lu",(unsigned long)userId);
    XXEFriendMyCircleViewController *myCircleVC = [[XXEFriendMyCircleViewController alloc]init];
    myCircleVC.otherXid = [NSString stringWithFormat:@"%lu", userId];
    myCircleVC.friendCirccleRefreshBlock = ^(){
        [self refresh];
    };
    [self.navigationController pushViewController:myCircleVC animated:YES];
}

-(void)onClickHeaderUserAvatar
{
    
    NSInteger myXId = [parameterXid integerValue];
    [self onClickUser:myXId];
}


//发送视频 目前没有实现填写文字
-(void)onSendVideo:(NSString *)text videoPath:(NSString *)videoPath screenShot:(UIImage *)screenShot name:(NSString *)name fileName:(NSString *)fileName
{
    NSData *data = [NSData dataWithContentsOfFile:videoPath];
//    NSURL *sourceUrl = [NSURL URLWithString:videoPath];
//    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
//    
//    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
//    
//    NSLog(@"%@",compatiblePresets);
//    
//    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
//        
//        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
//        
//        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
//        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
//        
//        NSString * resultPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
//        
//        NSLog(@"resultPath = %@",resultPath);
//        
//        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
//        
//        exportSession.outputFileType = AVFileTypeMPEG4;
//        
//        exportSession.shouldOptimizeForNetworkUse = YES;
//        
//        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
//         
//         {
//             
//             switch (exportSession.status) {
//                     
//                 case AVAssetExportSessionStatusUnknown:
//                     
//                     NSLog(@"AVAssetExportSessionStatusUnknown");
//                     
//                     break;
//                     
//                 case AVAssetExportSessionStatusWaiting:
//                     
//                     NSLog(@"AVAssetExportSessionStatusWaiting");
//                     
//                     break;
//                     
//                 case AVAssetExportSessionStatusExporting:
//                     
//                     NSLog(@"AVAssetExportSessionStatusExporting");
//                     
//                     break;
//                     
//                 case AVAssetExportSessionStatusCompleted:
//                     
//                     NSLog(@"AVAssetExportSessionStatusCompleted");
//                     
//                     break;  
//                     
//                 case AVAssetExportSessionStatusFailed:  
//                     
//                     NSLog(@"AVAssetExportSessionStatusFailed");  
//                     
//                     break;  
//                     
//             }  
//             
//         }];  
//        
//    }
    
    

    DFVideoLineItem *videoItem = [[DFVideoLineItem alloc] init];
    videoItem.itemId = 1; //随便设置一个 待服务器生成
    videoItem.userId = 10018;
    videoItem.userAvatar = @"http://file-cdn.datafans.net/avatar/1.jpeg";
    videoItem.userNick = @"富二代";
    videoItem.title = @"发表了";
    videoItem.text = @"新年过节 哈哈"; //这里需要present一个界面 用户填入文字后再发送 场景和发图片一样
//    XXEWhoCanLookController *whoVC = [[XXEWhoCanLookController alloc]init];
//    [self presentViewController:whoVC animated:YES completion:nil];
    
    videoItem.location = @"广州";
    
    videoItem.localVideoPath = videoPath;
    videoItem.videoUrl = @""; //网络路径
    videoItem.thumbUrl = @"";
    videoItem.thumbImage = screenShot; //如果thumbImage存在 优先使用thumbImage
    [self wwwqqqqqqWithPath:data name:name fileName:fileName dataURL:[NSURL URLWithString:videoPath]];
//    [self addItemTop:videoItem];
    
    //接着上传图片 和 请求服务器接口
    //请求完成之后 刷新整个界面
    
//    NSDictionary *dict = @{@"file_type":@"2",
//                           @"page_origin":@"35",
//                           @"upload_format":@"1",
//                           @"appkey":APPKEY,
//                           @"user_type":USER_TYPE,
//                           @"backtype":BACKTYPE
//                           };
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager POST:XXERegisterUpLoadPicUrl parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:data name:@"video" fileName:@"video.mov" mimeType:@"video/quicktime"];
//        
//    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        
//        NSLog(@"%@",responseObject);
////        NSLog(@"%@",[responseObject objectForKey:@"msg"]);
//        
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
}


//测试传视频
- (void)wwwqqqqqqWithPath:(NSData *)data1 name:(NSString*)name fileName:(NSString*)fileName dataURL:(NSURL*)dataURL
{
    NSDictionary *dict = @{@"file_type":@"2",
                           @"page_origin":@"35",
                           @"upload_format":@"1",
                           @"appkey":APPKEY,
                           @"user_type":USER_TYPE,
                           @"backtype":BACKTYPE,
                           @"return_param_all":@"1",
                           @"return":@"re"
                           };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:XXERegisterUpLoadPicUrl parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSString *name = [NSString stringWithFormat:@"video2"];
//        NSString *formKey = [NSString stringWithFormat:@"video2.mp4"];
        NSString *type = @"video/mp4";
        NSError *error = nil;
        [formData appendPartWithFileURL:dataURL name:name fileName:fileName mimeType:type error:&error];
        NSLog(@"%@",error);
//        [formData appendPartWithFileURL:dataURL name:formKey fileName:name mimeType:type];
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"%@",responseObject);
//        NSLog(@"%@",[responseObject objectForKey:@"msg"]);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}
- (void)aaa{
//    NSDictionary *dict = @{@"file_type":@"2",
//                           @"page_origin":@"35",
//                           @"upload_format":@"1",
//                           @"appkey":APPKEY,
//                           @"user_type":USER_TYPE,
//                           @"backtype":BACKTYPE,
//                           @"return_param_all":@"1",
//                           @"return": @"return"
//                           };
//    AFHTTPRequestSerializer *ser = [[AFHTTPRequestSerializer alloc] init];
//    NSMutableURLRequest *request = [ser multipartFormRequestWithMethod:@"POST"
//                                                             URLString:XXERegisterUpLoadPicUrl parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//                                                                 [formData appendPartWithFileURL:fileURL name:@"file" fileName:@"fileName" mimeType:@"video/mp4" error:nil];
//                                                             } error:nil];
//    
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    
//    NSProgress *progress = nil;
//    
//    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"request = %@", request );
//            //            MyLog(@"response = %@", response );
//            //            MyLog(@"Error: %@", error );
//            //            [_hud hide:YES];
//            //            CXAlertView *alert=[[CXAlertView alloc]initWithTitle:NSLocalizedString(@"Warning", nil)
//            //                                                         message:NSLocalizedString(@"Upload Failed",nil)
//            //                                               cancelButtonTitle:NSLocalizedString(@"Iknow", nil)];
//            //            alert.showBlurBackground = NO;
//            //            [alert show];
//        } else {
//            NSLog(@"%@ %@", response, responseObject);
//            NSDictionary *backDict=(NSDictionary *)responseObject;
//            if ([backDict[@"success"] boolValue] != NO) {
//                //                _hud.labelText = NSLocalizedString(@"Updating", nil);
//                //                [self UpdateResxDateWithDict:backDict discription:dict[@"discription"]];
//                //                [_hud hide:YES];
//            }else{
//                //                [_hud hide:YES];
//                //                [MyHelper showAlertWith:nil txt:backDict[@"msg"]];
//            }
//        }
//        //        [progress removeObserver:self
//        //                      forKeyPath:@"fractionCompleted"
//        //                         context:@"1"];
//    }];
//    
//    //    [progress addObserver:self
//    //               forKeyPath:@"fractionCompleted"
//    //                  options:NSKeyValueObservingOptionNew
//    //                  context:@"1"];
//    //    [progress setUserInfoObject:@"someThing" forKey:@"Y.X."];
//    [uploadTask resume];
}
#pragma mark - TabelViewDelegate

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //点击所有cell空白地方 隐藏toolbar
//    NSInteger rows =  [tableView numberOfRowsInSection:0];
//    for (int row = 0; row < rows; row++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//        DFBaseLineCell *cell  = (DFBaseLineCell *)[tableView cellForRowAtIndexPath:indexPath];
//        [cell hideLikeCommentToolbar];
//    }
//    NSLog(@"第几个单元格%ld",(long)indexPath.row);
//}


//#pragma mark - Method
//
//-(DFBaseLineCell *) getCell:(Class)itemClass
//{
//    DFLineCellManager *manager = [DFLineCellManager sharedInstance];
//    return [manager getCell:itemClass];
//}

-(void) onClickLikeCommentBtn:(id)sender{
/*
 _likeCommentToolbar.zanFlag = @"赞";
 _isLikeCommentToolbarShow = !_isLikeCommentToolbarShow;
 _likeCommentToolbar.hidden = !_isLikeCommentToolbarShow;
 */
    DFBaseLineCell *cell = [[DFBaseLineCell alloc] init];
    cell.likeCmtButton = sender;
    
    NSLog(@"aaa");
    
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
