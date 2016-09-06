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

@interface XXEFriendCirclePageViewController ()
/** 朋友圈的头部视图信息 */
@property (nonatomic, strong)NSMutableArray *headerDatasource;
/** 朋友圈列表的信息 */
@property (nonatomic, strong)NSMutableArray *circleListDatasource;
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
    [self setupFriendCircleMessagePage:@"1"];
    [self endLoadMore];
}

/** 朋友圈头部信息 */
- (void)setHeaderMessage:(XXECircleUserModel *)model
{
    NSLog(@"======%@",model.head_img);
    NSString *cover = [NSString stringWithFormat:@"%@%@",kXXEPicURL,model.head_img];
    [self setCover:cover];
    [self setUserAvatar:cover];
    [self setUserNick:model.nickname];
    [self setUserSign:@"哈哈哈"];
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
            NSLog(@"每一个单元格有几个人点赞%lu",(unsigned long)circleModel.good_user.count);
            NSLog(@"点赞%@",circleModel.good_user);
            
//            [self addItem:textImageItem];
            
//            if (circleModel.good_user.count == 0) {
//                NSLog(@"没有人点赞");
//            }else{
//                for (int j =0; j<circleModel.good_user.count; j++) {
//                    XXEGoodUserModel *goodModel = circleModel.good_user[j];
//                    NSLog(@"%@",goodModel.goodXid);
//                    DFTextImageLineItem *likeItem = [[DFTextImageLineItem alloc]init];
//                    likeItem.userNick = goodModel.goodNickName;
//                    likeItem.userId = [goodModel.goodXid integerValue];
//                    [textImageItem.likes addObject:circleModel.good_user];
            
                    //评论内容
//                    DFLineCommentItem *commentItem = [[DFLineCommentItem alloc]init];
//                    XXECommentModel *commentModel = circleModel.comment_group[j];
//                    if (circleModel.comment_group.count != 0) {
//                        commentItem.commentId = [commentModel.commentId intValue];
//                        commentItem.userId = [commentModel.commentXid intValue];
//                        commentItem.userNick = commentModel.commentNicknName;
//                        commentItem.replyUserId = [commentModel.to_who_xid intValue];
//                        commentItem.replyUserNick = commentModel.to_who_nickname;
//                        commentItem.text = commentModel.con;
//                        [textImageItem.comments addObject:commentItem];
//                    }else{
//                        NSLog(@"数组为空");
//                    }
//                }
//            }
            [self addItem:textImageItem];
        }
    }else{
        NSLog(@"没有数据");
    }
}

#pragma mark - 朋友圈网络请求
- (void)setupFriendCircleMessagePage:(NSString *)page
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
    
    XXEFriendCircleApi *friendCircleApi = [[XXEFriendCircleApi alloc]initWithFriendCircleXid:strngXid CircleUserId:homeUserId PageNumber:page];
    [friendCircleApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSLog(@"%@",request.responseJSONObject);
        NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
        
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        NSArray *list = [data objectForKey:@"list"];
        
        NSLog(@"用户信息%@",[data objectForKey:@"user_info"]);
        NSDictionary *userInfo = [data objectForKey:@"user_info"];
        
        XXECircleUserModel *Usermodel = [[XXECircleUserModel alloc]initWithDictionary:userInfo error:nil];
        [self.headerDatasource addObject:Usermodel];
        //设置顶部视图信息
        [self setHeaderMessage:Usermodel];
        NSLog(@"评论信息的列表的%@",list);
        NSLog(@"数组为%@",list[0]);
        
        if ([code intValue]==1) {
            for (int i =0; i<list.count; i++) {
                XXECircleModel *circleModel = [[XXECircleModel alloc]initWithDictionary:list[i] error:nil];
                [self.circleListDatasource addObject:circleModel];
            }
            NSLog(@"朋友圈列表的信息:%@",self.circleListDatasource);
       
        //朋友圈的信息列表
        [self friendCircleMessage];
        NSLog(@"圈子顶部信息数组信息%@",self.headerDatasource);
            [self endRefresh];
            [self endLoadMore];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}




#pragma mark - DFImagesSendViewControllerDelegate 发布圈子的代理
-(void)onSendTextImage:(NSString *)text images:(NSArray *)images
{
    NSLog(@"发布的文字%@ 发布的图片%@",text,images);
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
