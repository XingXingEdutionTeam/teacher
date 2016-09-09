//
//  XXEFriendMyCircleViewController.m
//  teacher
//
//  Created by codeDing on 16/9/6.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFriendMyCircleViewController.h"
#import "XXEFriendMyCircleApi.h"
#import "XXECircleUserModel.h"
#import "XXECircleModel.h"
#import "XXECommentModel.h"
#import "XXEGoodUserModel.h"

@interface XXEFriendMyCircleViewController ()

/** 朋友圈的头部视图信息 */
@property (nonatomic, strong)NSMutableArray *headerMyCircleDatasource;
/** 朋友圈列表的信息 */
@property (nonatomic, strong)NSMutableArray *circleMyCircleListDatasource;
/** 页数 */
@property (nonatomic, assign)NSInteger page;

@end

@implementation XXEFriendMyCircleViewController
- (NSMutableArray *)headerMyCircleDatasource
{
    if (!_headerMyCircleDatasource) {
        _headerMyCircleDatasource = [NSMutableArray array];
    }
    return _headerMyCircleDatasource;
}

- (NSMutableArray *)circleMyCircleListDatasource
{
    if (!_circleMyCircleListDatasource) {
        _circleMyCircleListDatasource = [NSMutableArray array];
    }
    return _circleMyCircleListDatasource;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //获取数据
    [self FriendMyCircleMessage];
}

#pragma mark - 获取数据
- (void)FriendMyCircleMessage
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
    NSString *otherXid = [NSString stringWithFormat:@"%ld",(long)self.otherXid];
    XXEFriendMyCircleApi *friendMyApi = [[XXEFriendMyCircleApi alloc]initWithChechFriendCircleOtherXid:otherXid page:@"1" UserId:homeUserId MyCircleXid:strngXid];
    [friendMyApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSLog(@"%@",request.responseJSONObject);
        NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        
        if ([code intValue]==1 && [[request.responseJSONObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
            NSArray *listSS = [data objectForKey:@"ss"];
            NSLog(@"数组信息%@",listSS);
            NSLog(@"用户信息%@",[data objectForKey:@"user_info"]);
            NSDictionary *userInfo = [data objectForKey:@"user_info"];
            
            XXECircleUserModel *Usermodel = [[XXECircleUserModel alloc]initWithDictionary:userInfo error:nil];
            [self.headerMyCircleDatasource addObject:Usermodel];
            //设置顶部视图信息
            [self setHeaderMyCircleMessage:Usermodel];
//            NSLog(@"评论信息的列表的%@",listSS);
//            NSLog(@"数组为%@",listSS[0]);
//            for (int i =0; i<listSS.count; i++) {
//                XXECircleModel *circleModel = [[XXECircleModel alloc]initWithDictionary:listSS[i] error:nil];
//                [self.circleMyCircleListDatasource addObject:circleModel];
//            }
//            [self endLoadMore];
//            //朋友圈的信息列表
//            [self myFriendCircleMessage];
            NSLog(@"圈子顶部信息数组信息%@",self.headerMyCircleDatasource);
        }else{
            [self hudShowText:@"获取数据错误" second:2.f];
            [self endRefresh];
            [self endLoadMore];
        }

        
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}

/** 朋友圈头部信息 */
- (void)setHeaderMyCircleMessage:(XXECircleUserModel *)model
{
    NSLog(@"======%@",model.head_img);
    NSString *cover = [NSString stringWithFormat:@"%@%@",kXXEPicURL,model.head_img];
    [self setCover:cover];
    [self setUserAvatar:cover];
    [self setUserNick:model.nickname];
    [self setUserSign:@""];
}

/** 个人圈子的信息 */
- (void)myFriendCircleMessage
{
    if (self.circleMyCircleListDatasource.count != 0) {
        for (int i =0; i<self.circleMyCircleListDatasource.count; i++) {
            XXECircleModel *circleModel = self.circleMyCircleListDatasource[i];
            DFTextImageUserLineItem *textItem = [[DFTextImageUserLineItem alloc]init];
            textItem.itemId = 10000;
            textItem.ts = [circleModel.date_tm integerValue];
            textItem.cover = circleModel.pic_url;
            
            textItem.text = circleModel.words;
            //如果发布的圈子有图片则显示图片
            [self myFritnd_CircleImageShowTextImageItem:textItem CircleModel:circleModel];
        }
    }else{
        NSLog(@"没有数据");
    }

}

#pragma mark - 显示图片
- (void)myFritnd_CircleImageShowTextImageItem:(DFTextImageUserLineItem *)textItem CircleModel:(XXECircleModel *)circleModel
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
            textItem.photoCount = srcSmallImages.count;
            
        }
    }else{
        NSLog(@"不包含");
        [srcSmallImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,circleModel.pic_url ]];
        [thumbBigImages addObject:[NSString stringWithFormat:@"%@%@",kXXEPicURL,circleModel.pic_url ]];
        textItem.photoCount = srcSmallImages.count;
        NSLog(@"小图片%@ 大图片%@",srcSmallImages,thumbBigImages);
    }
    [self addItem:textItem];
    
    //发布的评论和点赞
//    [self friend_circleShowCommentAndGoodCircleModel:circleModel TextImageItem:textImageItem];
    
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
