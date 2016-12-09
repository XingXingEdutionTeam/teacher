

//
//  XXECommentHistoryDetailInfoViewController.m
//  teacher
//
//  Created by Mac on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECommentHistoryDetailInfoViewController.h"
#import "XXERedFlowerDetialInfoTableViewCell.h"
#import "XXEImageBrowsingViewController.h"
#import "XXEGlobalDecollectApi.h"
#import "XXEGlobalCollectApi.h"
#import "XXECommentDeleteApi.h"


@interface XXECommentHistoryDetailInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    //头像
    NSMutableArray *picArray;
    //标题
    NSMutableArray *titleArray;
    //内容
    NSMutableArray *contentArray;
    //照片墙 的图片 可以排列几行
    NSInteger picRow;
    //照片墙 照片 宽
    CGFloat picWidth;
    //照片墙 照片 高
    CGFloat picHeight;
    CGFloat maxWidth;;
    
    BOOL isCollect;
    NSString *parameterXid;
    NSString *parameterUser_Id;
    UIButton*rightButton;
}

@end

@implementation XXECommentHistoryDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    NSString *timeStr = [XXETool dateStringFromNumberTimer:_ask_time];
    //[type] => 1  //点评类型  1:老师主动点评,2:家长请求点评
    if ([_type isEqualToString:@"1"]) {
        picArray =[[NSMutableArray alloc]initWithObjects:@"comment_people_icon", @"comment_content_icon", @"home_redflower_picIcon",nil];
        titleArray =[[NSMutableArray alloc]initWithObjects:@"学生:", @"评价内容:", @"图片:", nil];
        contentArray = [[NSMutableArray alloc] initWithObjects:_name,  _com_con, @"", nil];
    }else if ([_type isEqualToString:@"2"]){
    picArray =[[NSMutableArray alloc]initWithObjects:@"comment_people_icon", @"comment_ask_content_icon", @"comment_time_icon", @"comment_content_icon", @"home_redflower_picIcon",nil];
    titleArray =[[NSMutableArray alloc]initWithObjects:@"学生:",@"请求:",@"时间:", @"评价内容:", @"图片:", nil];
        contentArray = [[NSMutableArray alloc] initWithObjects:_name, _ask_con, timeStr, _com_con, @"", nil];
    }
    if (![_picString isEqualToString:@""]) {
        _picWallArray = [[NSMutableArray alloc] initWithObjects:_picString, nil];
    }
    
    if ([_picString containsString:@","]) {
        _picWallArray = [_picString componentsSeparatedByString:@","];
    }
    
    [self createTableView];
    
    if ([_fromFlagStr isEqualToString:@"fromCollection"]) {
        
    }else{
    
    [self setRightCollectionButton];
    }
}




- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
    
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
    
    return picArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXERedFlowerDetialInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (cell == nil) {
        cell = [[XXERedFlowerDetialInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    cell.iconImageView.image = [UIImage imageNamed:picArray[indexPath.row]];
    cell.titleLabel.text = titleArray[indexPath.row];
    
    if (contentArray.count != 0) {
        cell.contentLabel.text = contentArray[indexPath.row];
        
        maxWidth = cell.contentLabel.width;
        CGFloat height = [StringHeight contentSizeOfString:contentArray[indexPath.row] maxWidth:maxWidth fontSize:14 * kScreenRatioWidth];
        
        CGSize size = cell.contentLabel.size;
        size.height = height;
        cell.contentLabel.size = size;
    }
    
    NSInteger t;
    //[type] => 1			//点评类型  1:老师主动点评,2:家长请求点评
    if ([_type isEqualToString:@"1"]) {
        t = 2;
    }else if ([_type isEqualToString:@"2"]){
        t = 4;
    }
    
    
    if (indexPath.row == t) {
        
        //result= num1>num2?num1:num2;
        
//        NSLog(@"%@", _picWallArray);
        
        if (_picWallArray.count % 3 == 0) {
            picRow = _picWallArray.count / 3;
        }else{
            
            picRow = _picWallArray.count / 3 + 1;
        }
        //创建 十二宫格  三行、四列
        int margin = 10;
        picWidth = (KScreenWidth - 20 - 4 * margin - 5 * 2) / 3;
        picHeight = picWidth;
        
        for (int i = 0; i < _picWallArray.count; i++) {
            
            //行
            int buttonRow = i / 3;
            
            //列
            int buttonLine = i % 3;
            
            CGFloat buttonX = 10 + (picWidth + margin) * buttonLine;
            CGFloat buttonY = 44 + (picHeight + margin) * buttonRow;
            
            UIImageView *pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(buttonX + 5, buttonY, picWidth, picHeight)];
            pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
            pictureImageView.clipsToBounds = YES;
            
            NSString *str = [NSString stringWithFormat:@"%@%@", kXXEPicURL, _picWallArray[i]];
            [pictureImageView sd_setImageWithURL:[NSURL URLWithString:str]];
            pictureImageView.tag = 20 + i;
            pictureImageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickPicture:)];
            [pictureImageView addGestureRecognizer:tap];
            
            [cell.contentView addSubview:pictureImageView];
        }
        
    }
    
    return cell;
}

- (void)onClickPicture:(UITapGestureRecognizer *)tap{
    
//    NSLog(@"--- 点击了第%ld张图片", tap.view.tag - 20);
    XXEImageBrowsingViewController * imageBrowsingVC = [[XXEImageBrowsingViewController alloc] init];
    
    imageBrowsingVC.imageUrlArray = _picWallArray;
    imageBrowsingVC.currentIndex = tap.view.tag - 20;
    //举报 来源 6:老师点评
    imageBrowsingVC.origin_pageStr = @"6";
    
    [self.navigationController pushViewController:imageBrowsingVC animated:YES];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger t;
    //[type] => 1			//点评类型  1:老师主动点评,2:家长请求点评
    if ([_type isEqualToString:@"1"]) {
        t = 2;
    }else if ([_type isEqualToString:@"2"]){
        t = 4;
    }
    
    if (indexPath.row == t - 1) {
        CGFloat height = [StringHeight contentSizeOfString:contentArray[indexPath.row] maxWidth:maxWidth fontSize:14 * kScreenRatioWidth];
        return height + 20;
    }

    if (indexPath.row==t) {

        return 44 + picRow * (picHeight + 10);
    }
    else{
        return 44;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 100)];
    
    if ([_fromFlagStr isEqualToString:@"fromCollection"]) {
        
    }else{

    UIButton *deleteButton = [UIButton createButtonWithFrame:CGRectMake((KScreenWidth - 325 * kScreenRatioWidth) / 2, 30 * kScreenRatioHeight, 325 * kScreenRatioWidth, 42 * kScreenRatioHeight) backGruondImageName:@"login_green" Target:self Action:@selector(deleteButtonClick) Title:@"删除评论"];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerView addSubview:deleteButton];
    }
    return footerView;
}

- (void)deleteButtonClick{
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定删除好友？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];

        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //删除 好友
            [self deleteComment];

        }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];


}

- (void)deleteComment{
    
    XXECommentDeleteApi *commentDeleteApi = [[XXECommentDeleteApi alloc] initWithXid:parameterXid user_id:parameterUser_Id com_id:_comment_id];
    [commentDeleteApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {

        //      NSLog(@"2222---   %@", request.responseJSONObject);

        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];

        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"删除成功!" forSecond:1.5];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self showHudWithString:@"删除失败!" forSecond:1.5];
        }

    } failure:^(__kindof YTKBaseRequest *request) {

        [self showString:@"数据请求失败" forSecond:1.f];
    }];

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 100;

}


- (void)setRightCollectionButton{

    rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
    [rightButton addTarget:self action:@selector(collectbtn:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;

    //[collect_condit] => 1			//1:是收藏过这个商品  2:未收藏过
    UIImage *saveImage;

    if ([_collect_conditStr integerValue] == 1) {
        isCollect = YES;
        saveImage = [UIImage imageNamed:@"home_logo_collection_icon44x44"];

    }else if([_collect_conditStr integerValue] == 2){
        isCollect = NO;
        saveImage = [UIImage imageNamed:@"home_logo_uncollection_icon44x44"];
    }
    [rightButton setBackgroundImage:saveImage forState:UIControlStateNormal];

}

-(void)collectbtn:(UIButton *)btn{

    if (isCollect==NO) {
        [self collectRedFlower];

    }
    else  if (isCollect==YES) {

        [self deleteCollectcollectRedFlower];
    }

}

//收藏  小红花
- (void)collectRedFlower{
    /*
     【收藏】通用于各种收藏
     接口类型:2
     接口:
     http://www.xingxingedu.cn/Global/collect
     传参:
     collect_id	//收藏id (如果是收藏用户,这里是xid)
     collect_type	//收藏品种类型	1:商品  2:点评  3:用户  4:课程  5:学校  6:花朵
     */

    XXEGlobalCollectApi *globalCollectApi = [[XXEGlobalCollectApi alloc] initWithXid:parameterXid user_id:parameterUser_Id collect_id:_collect_id collect_type:@"2"];
    [globalCollectApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
        NSLog(@"收藏 -- %@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"收藏成功!" forSecond:1.5];
            [rightButton setBackgroundImage:[UIImage imageNamed:@"home_logo_collection_icon44x44"] forState:UIControlStateNormal];
            isCollect=!isCollect;
        }else{

        }

    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"收藏失败!" forSecond:1.5];
    }];

}

//取消收藏机构
- (void)deleteCollectcollectRedFlower{
    /*
     【删除/取消收藏】通用于各种取消收藏
     接口类型:2
     接口:
     http://www.xingxingedu.cn/Global/deleteCollect
     传参:
     collect_id	//收藏id (如果是收藏用户,这里是xid)
     collect_type	//收藏品种类型	1:商品  2:点评  3:用户  4:课程  5:学校  6:花朵 7:图片
     */
    XXEGlobalDecollectApi *globalDecollectApi = [[XXEGlobalDecollectApi alloc] initWithXid:parameterXid user_id:parameterUser_Id collect_id:_collect_id collect_type:@"2"];
    [globalDecollectApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
        //        NSLog(@"取消收藏 -- %@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"取消收藏成功!" forSecond:1.5];

            [rightButton setBackgroundImage:[UIImage imageNamed:@"home_logo_uncollection_icon44x44"] forState:UIControlStateNormal];
            isCollect=!isCollect;
        }else{


        }

    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"取消收藏失败!" forSecond:1.5];
    }];

}

@end
