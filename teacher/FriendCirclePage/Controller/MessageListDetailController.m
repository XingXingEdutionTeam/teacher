//
//  MessageListDetailController.m
//  XingXingEdu
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "MessageListDetailController.h"
#import "XXEImageBrowsingViewController.h"
#import "DFImageUnitView.h"
#import "YDCommentInputView.h"
#import "MessageListDetailViewCell.h"
#import "DFLineCommentItem.h"
#import "WZYTool.h"
#import "XXEUserInfo.h"
#import "AFNetworking.h"
#import "HHControl.h"
#import "SVProgressHUD.h"
#import "XXECommentModel.h"
//#import "XXEFriendCircleCommentApi.h"
#import "XXEEveryTalkDetailApi.h"
#import "XXECircleModel.h"
#import "XXEUserInfo.h"
#import "StringHeight.h"

#define Kmarg 10.0f
#define KLabelH 25.0f
#define Padding 2

/**
 *  消息类型
 */
typedef NS_OPTIONS(NSInteger, Comments){
    /**
     *  评论消息
     */
    CommentsMessage = 0,
    /**
     *  回复消息
     */
    ReplyCommentsMessage
};


@interface MessageListDetailController ()<YDCommentInputViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UIScrollView *_bgScrollView;
    UIView *_detailView;
    UIImageView *_headImage;//头像
    UILabel *_nameLabel;//名字
    UITextView *_detailSayView;//内容
    UIImageView *_picView;//照片
    UILabel *_timeLabel;//时间戳
    UIImageView *_detailImage;//详情评论
    
    //照片墙 的图片 可以排列几行
    NSInteger picRow;
    //照片墙 照片 宽
    CGFloat picWidth;
    //照片墙 照片 高
    CGFloat picHeight;
    //图片 数组
    NSMutableArray *_picWallArray;
    
    //这条说说 model
    XXECircleModel *talkModel;

    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}
@property (strong, nonatomic) YDCommentInputView *commentInputView;

@property (strong, nonatomic)  NSString *name;/*用户*/
@property (assign, nonatomic) int message;/*消息类型*/

@end

@implementation MessageListDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets=YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    self.title = @"消息详情";
    //获取 这条说说 的具体内容
    [self createDetailMessageNetRequest];
    
}

-(void) initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_detailView.frame), kWidth - 60, talkModel.comment_group.count * 70) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorInset = UIEdgeInsetsZero;
    [_bgScrollView addSubview:_tableView];
}

//键盘
- (YDCommentInputView *)commentInputView
{
    if (!_commentInputView) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"YDCommentInputView" owner:self options:nil];
        _commentInputView = [nib objectAtIndex:0];
        _commentInputView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, _commentInputView.frame.size.height);
        _commentInputView.delegate = self;
    }
    return _commentInputView;
}


-(void)createDetailMessage {
    //背景
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth,kHeight *2 )];
    _bgScrollView.backgroundColor = [UIColor whiteColor];
    _bgScrollView.pagingEnabled = NO;
    _bgScrollView.showsHorizontalScrollIndicator = YES;
    _bgScrollView.showsVerticalScrollIndicator  = YES;
    _bgScrollView.alwaysBounceVertical = YES;
    
    [self.view addSubview:_bgScrollView];
    //
    //详情背景
    _detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 150)];
    [_bgScrollView addSubview:_detailView];
    
    //头像
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(Kmarg , Kmarg , 40, 40)];
    //头像
    NSString * head_img;
    if([talkModel.head_img_type integerValue] == 0){
        head_img=[kXXEPicURL stringByAppendingString:talkModel.head_img];
    }else{
        head_img=talkModel.head_img;
    }
    [_headImage sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    [_detailView addSubview:_headImage];
    
    //名字
    _nameLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(_headImage.frame) + Kmarg, Kmarg, kWidth - 20, KLabelH) Font:16 Text:talkModel.nickname];
    _nameLabel.textColor = UIColorFromRGB(74, 160, 239);
    [_detailView addSubview:_nameLabel];
    
    //内容
    _detailSayView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImage.frame) + Kmarg, CGRectGetMaxY(_nameLabel.frame) + Kmarg, kWidth - 80, 120)];
    _detailSayView.text = talkModel.words;
    _detailSayView.font = [UIFont systemFontOfSize:12];
    _detailSayView.userInteractionEnabled = NO;
    [_detailSayView flashScrollIndicators];   // 闪动滚动条
    //自动适应行高
    static CGFloat maxHeight = 130.0f;
    CGRect frame = _detailSayView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [_detailSayView sizeThatFits:constraintSize];
    if (size.height >= maxHeight){
        size.height = maxHeight;
        _detailSayView.scrollEnabled = YES;   // 允许滚动
    }
    else{
        _detailSayView.scrollEnabled = NO;    // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况
    }
    _detailSayView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    [_detailView addSubview:_detailSayView];
    
    //图片 待完善
    //    for (int i = 0; i < 9; i ++) {
    
    _picView = [[UIImageView alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_headImage.frame) + Kmarg, CGRectGetMaxY(_detailSayView.frame), kWidth - 100, 120)];
    _picView.contentMode = UIViewContentModeScaleAspectFill;
    _picView.clipsToBounds = YES;
    
//    NSLog(@"照片 === %@", _baseInfo[3]);
    NSString *picStr = talkModel.pic_url;
    
    if ([picStr containsString:@","]) {
        
        NSArray *arr = [[NSArray alloc] init];
       arr = [picStr componentsSeparatedByString:@","];
        _picWallArray = [[NSMutableArray alloc] initWithArray:arr];
        
    }else{
        _picWallArray = [[NSMutableArray alloc] initWithObjects:picStr, nil];
    }
    
        if (_picWallArray.count % 3 == 0) {
            picRow = _picWallArray.count / 3;
        }else{
            
            picRow = _picWallArray.count / 3 + 1;
        }
        //创建 十二宫格  三行、四列
        int margin = 10;
        picWidth = (_picView.frame.size.width - 4 * margin) / 3;
        picHeight = picWidth;
        
        for (int i = 0; i < _picWallArray.count; i++) {
            
            //行
            int buttonRow = i / 3;
            
            //列
            int buttonLine = i % 3;
            
            CGFloat buttonX = (picWidth + margin) * buttonLine;
            CGFloat buttonY = (picHeight + margin) * buttonRow;
            
            UIImageView *pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(buttonX, buttonY, picWidth, picHeight)];
            
            [pictureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, _picWallArray[i]]]];
            pictureImageView.tag = 20 + i;
            pictureImageView.userInteractionEnabled = YES;
            _picView.userInteractionEnabled = YES;
            _detailView.userInteractionEnabled = YES;
            _bgScrollView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickPicture:)];
            [pictureImageView addGestureRecognizer:tap];
            
            [_picView addSubview:pictureImageView];
        }
    //图片背景 大小
    CGSize size1 = _picView.size;
    size1.height = picRow * (picHeight + 5);
    _picView.size = size1;

    [_detailView addSubview:_picView];

    
    //时间戳
    NSString *timeStr = [WZYTool dateStringFromNumberTimer:talkModel.date_tm];
    _timeLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(_headImage.frame) + Kmarg,CGRectGetMaxY(_picView.frame) + Kmarg, KScreenWidth - 100, KLabelH) Font:14 Text:timeStr];
    _timeLabel.textColor = UIColorFromRGB(74, 160, 239);
    [_detailView addSubview:_timeLabel];
    
    //评论
    _detailImage = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth - Kmarg*6 , CGRectGetMaxY(_picView.frame) + Kmarg, 40, 30)];
    _detailImage.image = [UIImage imageNamed:@"AlbumOperateMoreHL@2x.png"];
    _detailImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onComment)];
    [_detailImage addGestureRecognizer:tap];
    [_detailView addSubview:_detailImage];
    
    //重写详情背景的frame
    CGSize size3 = _detailView.size;
    size3.height = _timeLabel.frame.origin.y + _timeLabel.size.height;
    _detailView.size = size3;
    
    //创建 评论 tableView
    [self initTableView];
    
}


- (void)onClickPicture:(UITapGestureRecognizer *)tap{
    
    //    NSLog(@"--- 点击了第%ld张图片", tap.view.tag - 20);
    XXEImageBrowsingViewController * imageBrowsingVC = [[XXEImageBrowsingViewController alloc] init];
    
    imageBrowsingVC.imageUrlArray = _picWallArray;
    imageBrowsingVC.currentIndex = tap.view.tag - 20;
    //举报 来源 2:圈子图片
    imageBrowsingVC.origin_pageStr = @"2";
    
    [self.navigationController pushViewController:imageBrowsingVC animated:YES];
    
}
-(void)createDetailMessageNetRequest{
    XXEEveryTalkDetailApi * everyTalkDetailApi = [[XXEEveryTalkDetailApi alloc] initWithXid:parameterXid user_id:parameterUser_Id talk_id:_talkId];
    [everyTalkDetailApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
//        NSLog(@"999== %@", request.responseJSONObject);
        NSString *codeStr= request.responseJSONObject[@"code"];
        if ([codeStr integerValue] == 1) {
            NSDictionary *dic = request.responseJSONObject[@"data"];
            talkModel = [[XXECircleModel alloc]initWithDictionary:dic error:nil];
            
//            NSLog(@"talkModel.comment_group %@", talkModel.comment_group);
            //创建  说说 视图
            [self createDetailMessage];
            
            CGFloat bgScrollMaxH =  CGRectGetMaxY(_tableView.frame) + 800;
            _bgScrollView.contentSize = CGSizeMake(0, bgScrollMaxH);
        }
        
     [_tableView reloadData];
     
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
    }];


}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return talkModel.comment_group.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XXECommentModel *model = talkModel.comment_group[indexPath.row];
    CGFloat height = [StringHeight contentSizeOfString:model.con maxWidth:kWidth - 60 - 70 fontSize:12*kScreenRatioHeight];
    
    if(height <= 25) {
        return 60;
    }else {
        return 40 + height;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageListDetailViewCell"];
    if(cell==nil){
        cell=[[MessageListDetailViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageListDetailViewCell"];
    }
    if (indexPath.row != 0) {
        cell.commentIconImageView.hidden = YES;
    }
    
    XXECommentModel *model = talkModel.comment_group[indexPath.row];
    [cell configure:model isLastCell:indexPath.row == talkModel.comment_group.count - 1 ? NO : YES];
//    评论 类型
//    cell.com_type = model.com_type;
//    
//    //头像
//    NSString * head_img;
//    if([model.head_img_type integerValue] == 0){
//        head_img=[kXXEPicURL stringByAppendingString:model.head_img];
//    }else{
//        head_img=model.head_img;
//    }
//    [cell.headIconImageView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
//     
//    if ([model.com_type integerValue] == 1){
//      //别人评论
//        cell.otherName = @"";
//        cell.nickName.text = model.commentNicknName;
//    }else if ([model.com_type integerValue] == 2){
//      //本人 回复
//        cell.otherName = model.to_who_nickname;
//        cell.nickName.text = [NSString stringWithFormat:@"%@ 回复 %@", model.commentNicknName, model.to_who_nickname];
//    }
//    //内容
//    cell.contentTextView.text = model.con;
//    cell.contentTextView.userInteractionEnabled = NO;
//    cell.contentTextView.scrollEnabled = NO;
//    cell.contentTextView.font = [UIFont systemFontOfSize:12];
//    //自动适应行高
//    static CGFloat maxHeight = 130.0f;
//    CGRect frame = cell.contentTextView.frame;
//    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
//    CGSize size3 = [cell.contentTextView sizeThatFits:constraintSize];
//    if (size3.height >= maxHeight){
//        size3.height = maxHeight;
//        cell.contentTextView.scrollEnabled = YES;   // 允许滚动
//    }else{
//        cell.contentTextView.scrollEnabled = NO;    // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况
//    }
//    cell.contentTextView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size3.height);
    //时间
//    NSString *string = [XXETool dateStringFromNumberTimer:model.date_tm];
//    if (![string isEqualToString:@""]) {
//        //2010-9-9 0:0:0
//        NSArray *arr = [string componentsSeparatedByString:@" "];
//        //
//        NSArray *arr1 = [arr[0] componentsSeparatedByString:@"-"];
//        //9月9日
//        NSString *str1 = [NSString stringWithFormat:@"%@月%@日", arr1[1], arr1[2]];
//        NSArray *arr2 = [arr[1] componentsSeparatedByString:@":"];
//        NSString *str2 = [NSString stringWithFormat:@"%@:%@", arr2[0], arr2[1]];
//        
//        NSString *newStr = [NSString stringWithFormat:@"%@ %@", str1, str2];
//        cell.dateTime.text = newStr;
//        
//    }

    return cell;
}

#pragma mark - TabelViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UILabel *replyUserNick = [_tableView viewWithTag:10000];
    //回复评论
    self.message = ReplyCommentsMessage;
    self.commentInputView.commentInputTextField.placeholder = [NSString stringWithFormat:@"回复%@",replyUserNick.text];
    [self.commentInputView showInputView];
    
}

//(long)评论
-(void)onComment{
    self.message = CommentsMessage;
    [self.commentInputView showInputView];
}


#pragma mark - YDCommentInputViewDelegate
- (void)commentInputView:(YDCommentInputView *)anInputView onSendText:(NSString *)aText
{
    
    if (self.message == CommentsMessage) {
        NSString *urlStr = @"http://www.xingxingedu.cn/Global/my_circle_comment";
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *dict = @{@"appkey":APPKEY,
                               @"backtype":BACKTYPE,
                               @"xid":parameterXid,
                               @"user_id":parameterUser_Id,
                               @"user_type":USER_TYPE,
                               @"com_type":@"1",
                               @"talk_id":_talkId,
                               @"con":aText,
                               };
        // 服务器返回的数据格式
        mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
        [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
             //               NSLog(@"======commentInputTextViewcommentInputTextView=============%@",dict);
             if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] ){
                 NSDictionary *dictK =dict[@"data"];
                 NSString *commentXid = [NSString stringWithFormat:@"%@",dictK[@"xid"]];
                 NSString *commentNickName =[NSString stringWithFormat:@"%@",dictK[@"nickname"]];
                 
                 DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
                 commentItem.commentId = [commentXid integerValue];
                 commentItem.userId = [commentXid integerValue];
                 commentItem.userNick = commentNickName;
                 commentItem.text = aText;
             }
             
             [SVProgressHUD showSuccessWithStatus:@"评论成功"];
             
             [self createDetailMessageNetRequest];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败:%@",error);
             [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
             
         }];
        
    } else {
        
        NSString *urlStr = @"http://www.xingxingedu.cn/Global/my_circle_comment";
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *dict = @{@"appkey":APPKEY,
                               @"backtype":BACKTYPE,
                               @"xid":parameterXid,
                               @"user_id":parameterUser_Id,
                               @"user_type":USER_TYPE,
                               @"com_type":@"2",
                               @"talk_id":_talkId,
                               @"con":aText,
                               @"to_who_xid":@"12345",
                               };
        
        // 服务器返回的数据格式
        mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
        [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
             
             if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] ){
                 NSDictionary *dictK =dict[@"data"];
                 NSString *commentXid = [NSString stringWithFormat:@"%@",dictK[@"xid"]];
                 NSString *commentNickName =[NSString stringWithFormat:@"%@",dictK[@"nickname"]];
                 NSString *commentTo_who_xid = [NSString stringWithFormat:@"%@",dictK[@"to_who_xid"]];
                 NSString *commentTo_who_nickname =[NSString stringWithFormat:@"%@",dictK[@"to_who_nickname"]];
                 
                 DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
                 commentItem.commentId = [commentXid integerValue];
                 commentItem.userId = [commentXid integerValue];
                 commentItem.userNick = commentNickName;
                 commentItem.text = aText;
                 commentItem.replyUserId = [commentTo_who_xid integerValue];
                 commentItem.replyUserNick = commentTo_who_nickname;
                 
             }
             [SVProgressHUD showSuccessWithStatus:@"回复成功"];
             
             [self createDetailMessageNetRequest];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败:%@",error);
             [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
             
         }];
        
    }
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
