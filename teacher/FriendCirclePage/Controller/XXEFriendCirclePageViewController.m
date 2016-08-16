//
//  XXEFriendCirclePageViewController.m
//  teacher
//
//  Created by codeDing on 16/8/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFriendCirclePageViewController.h"
#import "DFTextImageLineItem.h"
#import "DFLineLikeItem.h"
#import "DFLineCommentItem.h"

#import "XXEFriendCircleApi.h"
#import "XXECircleUserModel.h"
#import "XXECircleModel.h"
#import "XXECommentModel.h"
#import "XXEGoodUserModel.h"

@interface XXEFriendCirclePageViewController ()
/** 朋友圈的头部视图信息 */
@property (nonatomic, strong)NSMutableArray *headerDatasource;

@end

@implementation XXEFriendCirclePageViewController

- (NSMutableArray *)headerDatasource
{
    if (!_headerDatasource) {
        _headerDatasource = [NSMutableArray array];
    }
    return _headerDatasource;
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
    
    //设置朋友圈单元格信息
//    [self]
}

- (void)setHeaderMessage:(XXECircleUserModel *)model
{
    NSLog(@"======%@",model.head_img);
    NSString *cover = [NSString stringWithFormat:@"%@%@",kXXEPicURL,model.head_img];
    [self setCover:cover];
    [self setUserAvatar:cover];
    [self setUserNick:model.nickname];
    [self setUserSign:@"哈哈哈"];
}


- (void)setupFriendCircleMessagePage:(NSString *)page
{
    XXEFriendCircleApi *friendCircleApi = [[XXEFriendCircleApi alloc]initWithFriendCircleXid:XID PageNumber:page];
    [friendCircleApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSLog(@"%@",request.responseJSONObject);
        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
        
        
        NSArray *list = [data objectForKey:@"list"];
        NSLog(@"数组为%@",list[0]);
        NSLog(@"用户信息%@",[data objectForKey:@"user_info"]);
        NSDictionary *userInfo = [data objectForKey:@"user_info"];
        
        XXECircleUserModel *Usermodel = [[XXECircleUserModel alloc]initWithDictionary:userInfo error:nil];
        [self.headerDatasource addObject:Usermodel];
        //设置顶部视图信息
        [self setHeaderMessage:Usermodel];
        NSLog(@"圈子顶部信息数组信息%@",self.headerDatasource);
        NSLog(@"%@",Usermodel.head_img);
        NSLog(@"%@",Usermodel.circle_noread);
        NSLog(@"%@",Usermodel.nickname);
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
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
