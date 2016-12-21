//
//  XXEOtherTeacherAlbumViewController.m
//  teacher
//
//  Created by codeDing on 16/8/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEOtherTeacherAlbumViewController.h"
#import "XXEMyClassAlbumTableViewCell.h"
#import "XXEMyselfAblumApi.h"
#import "XXEAlbumContentViewController.h"

static NSString * OTherCELL = @"OTHERCELL";
@interface XXEOtherTeacherAlbumViewController ()<UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate>
{

    UIImageView *placeholderImageView;
}

/** 单元格 */
@property (nonatomic, strong)UITableView *otherTeacherTableView;
/** 数据源 */
@property (nonatomic, strong)NSMutableArray *datasource;

@end

@implementation XXEOtherTeacherAlbumViewController

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}
- (UITableView *)otherTeacherTableView
{
    if (!_otherTeacherTableView) {
        _otherTeacherTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -30*kScreenRatioHeight, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _otherTeacherTableView.delegate = self;
        _otherTeacherTableView.dataSource = self;
    }
    return _otherTeacherTableView;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    self.navigationController.navigationBarHidden = NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"老师的相册";
    [self.otherTeacherTableView registerNib:[UINib nibWithNibName:@"XXEMyClassAlbumTableViewCell" bundle:nil] forCellReuseIdentifier:OTherCELL];
    [self.view addSubview:self.otherTeacherTableView];
    //请求数据
    [self setupOtherMyselfAlbumMessage];
}

#pragma mark - 请求数据
- (void)setupOtherMyselfAlbumMessage
{
    NSString *strngXid;
    NSString *albumUserId;
    if ([XXEUserInfo user].login) {
        strngXid = [XXEUserInfo user].xid;
        albumUserId = [XXEUserInfo user].user_id;
    }else {
        strngXid = XID;
        albumUserId = USER_ID;
    }
    
//    NSLog(@"老师ID%@ 学校%@ 班级%@",self.otherTeacherId,self.otherSchoolId,self.otherClassId);
    
    //真实环境
        XXEMyselfAblumApi *myselfAblum = [[XXEMyselfAblumApi alloc]initWithMyselfAblumSchoolId:self.otherSchoolId ClassId:self.otherClassId TeacherId:self.otherTeacherId AlbumXid:strngXid AlbumUserId:albumUserId position:@""];
    [myselfAblum startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//        NSLog(@" hhhh === %@", request.responseJSONObject);
        
        if ([request.responseJSONObject[@"code"] integerValue] == 1) {
            if ([self.datasource count] != 0) {
                [self.datasource removeAllObjects];
            }
            
            NSArray *picArray = [NSArray arrayWithArray:request.responseJSONObject[@"data"]];
            if (picArray.count != 0) {
                for (int i =0; i < picArray.count; i++) {
                XXEMySelfAlbumModel *model = [[XXEMySelfAlbumModel alloc]initWithDictionary:picArray[i] error:nil];
                    [self.datasource addObject:model];
                }
            }
            
        }

//        [self.otherTeacherTableView reloadData];
        [self customContent];
    } failure:^(__kindof YTKBaseRequest *request) {
        [self showString:@"获取数据失败!" forSecond:1.5];
    }];
}

// 有数据 和 无数据 进行判断
- (void)customContent{
    // 如果 有占位图 先 移除
    [self removePlaceholderImageView];
    
    if (_datasource.count == 0) {
        _otherTeacherTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 1、无数据的时候
        [self createPlaceholderView];
        
    }else{
        //2、有数据的时候
    }
    
    [_otherTeacherTableView reloadData];
    
}


//没有 数据 时,创建 占位图
- (void)createPlaceholderView{
    // 1、无数据的时候
    UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
    CGFloat myImageWidth = myImage.size.width;
    CGFloat myImageHeight = myImage.size.height;
    
    placeholderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
    placeholderImageView.image = myImage;
    [self.view addSubview:placeholderImageView];
}

//去除 占位图
- (void)removePlaceholderImageView{
    if (placeholderImageView != nil) {
        [placeholderImageView removeFromSuperview];
    }
}

#pragma mark - 设置单元格的代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XXEMyClassAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OTherCELL forIndexPath:indexPath];
    XXEMySelfAlbumModel *model = self.datasource[indexPath.row];
//    NSLog(@"显示的Model:%@",model);
    [cell configerGetClassAlubmMessage:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"===相册的详情=====");
//    NSLog(@"%@", _userIdentifier);
    
    XXEAlbumContentViewController *contentVC = [[XXEAlbumContentViewController alloc]init];
    contentVC.contentModel = self.datasource[indexPath.row];
    contentVC.albumTeacherXID  = self.otherTeacherId;
    contentVC.fromFlagStr = @"fromOtherAlbum";
    contentVC.userIdentifier = _userIdentifier;
    NSLog(@"%@",contentVC.contentModel);
    [self.navigationController pushViewController:contentVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
