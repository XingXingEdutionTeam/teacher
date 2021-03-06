//
//  XXEMyClassAlbumViewController.m
//  teacher
//
//  Created by codeDing on 16/8/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyClassAlbumViewController.h"
#import "XXEMyClassAlbumTableViewCell.h"
#import "XXEUpdataImageViewController.h"
#import "XXEMyselfAblumApi.h"
#import "XXEMySelfAlbumModel.h"
#import "XXEMyselfAblumAddApi.h"
#import "XXEMyselfAblumDeleApi.h"
#import "XXEAlbumContentViewController.h"
#import "XXESchoolAlbumViewController.h"

static NSString * IdentifierCELL = @"IdentifierCELL";

@interface XXEMyClassAlbumViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UIImageView *placeholderImageView;
    
    NSString *strngXid;
    NSString *albumUserId;
}

@property (nonatomic, strong)UITableView *myClassAlumTableView;
/** 创建相册 */
@property (nonatomic, strong)NSString * myNewAlbumName;

/** 数据源 */
@property (nonatomic, strong)NSMutableArray *datasource;

@end

@implementation XXEMyClassAlbumViewController

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (UITableView *)myClassAlumTableView
{
    if (!_myClassAlumTableView) {
        _myClassAlumTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -30*kScreenRatioHeight, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _myClassAlumTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myClassAlumTableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    self.navigationController.navigationBarHidden = NO;
    //请求数据
    [self setupMyselfAlbumMessage];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的相册";
    if ([XXEUserInfo user].login) {
        strngXid = [XXEUserInfo user].xid;
        albumUserId = [XXEUserInfo user].user_id;
    }else {
        strngXid = XID;
        albumUserId = USER_ID;
    }
     self.myClassAlumTableView.delegate = self;
    self.myClassAlumTableView.dataSource = self;
    [self.myClassAlumTableView registerNib:[UINib nibWithNibName:@"XXEMyClassAlbumTableViewCell" bundle:nil] forCellReuseIdentifier:IdentifierCELL];
    [self.view addSubview:self.myClassAlumTableView];
    //创建导航栏右边的按钮设置
    [self rightNavigationButton];
    
}

#pragma mark - 获取数据 我的相册

- (void)setupMyselfAlbumMessage
{
    //真实环境
    XXEMyselfAblumApi *myselfAblum = [[XXEMyselfAblumApi alloc]initWithMyselfAblumSchoolId:self.myAlbumSchoolId ClassId:self.myAlbumClassId TeacherId:self.myAlbumTeacherId AlbumXid:strngXid AlbumUserId:albumUserId position:_userIdentifier];
//    NSLog(@"学校%@ 班级%@ 教师%@ XID%@ USerID%@ 身份:%@",self.myAlbumSchoolId,self.myAlbumClassId,self.myAlbumTeacherId,strngXid,albumUserId, _userIdentifier);

    [myselfAblum startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {

//        NSArray *data = [request.responseJSONObject objectForKey:@"data"];
//        NSLog(@"我的相册 结果 --=-=-%@",request.responseJSONObject);
        //取出之前的数据
        if (self.datasource.count != 0) {
           [self.datasource removeAllObjects];
        }
        
        if ([request.responseJSONObject[@"code"] integerValue] == 1) {

            NSArray *arr = [NSArray array];
            arr = request.responseJSONObject[@"data"];
            for (int i =0; i < arr.count; i++) {
                    XXEMySelfAlbumModel *model = [[XXEMySelfAlbumModel alloc]initWithDictionary:arr[i] error:nil];
                    [self.datasource addObject:model];
            }
        }
        
//        if ([[request.responseJSONObject objectForKey:@"data"] isKindOfClass:[NSString class]]) {
//            NSLog(@"shizifuchuan");
//            
//        }else{

//        }
//        NSLog(@"%@",self.datasource);
//        [self.myClassAlumTableView reloadData];
        [self customContent];
        [self hideHud];
    } failure:^(__kindof YTKBaseRequest *request) {
        [self hideHud];
        [self showHudWithString:@"请求失败" forSecond:1.f];
    }];
}

// 有数据 和 无数据 进行判断
- (void)customContent{
    // 如果 有占位图 先 移除
    [self removePlaceholderImageView];
    
    if (self.datasource.count == 0) {
        self.myClassAlumTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 1、无数据的时候
        [self createPlaceholderView];
        
    }else{
        //2、有数据的时候
    }
    
    [self.myClassAlumTableView reloadData];
    
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


#pragma mark - 单元格的代理方法

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
    XXEMyClassAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentifierCELL forIndexPath:indexPath];
    XXEMySelfAlbumModel *model = self.datasource[indexPath.row];
    NSLog(@"显示的Model:%@",model);
    [cell configerGetClassAlubmMessage:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"===相册的详情=====");
    XXEAlbumContentViewController *contentVC = [[XXEAlbumContentViewController alloc]init];
    contentVC.contentModel = self.datasource[indexPath.row];
    contentVC.albumTeacherXID  = self.myAlbumTeacherId;
    contentVC.myAlbumUpSchoolId = self.myAlbumSchoolId;
    contentVC.myAlbumUpClassId = self.myAlbumClassId;
    contentVC.fromFlagStr = @"fromMyselfAlbum";
    contentVC.datasource = self.datasource;
    contentVC.userIdentifier = _userIdentifier;
    NSLog(@"%@",contentVC.contentModel);
    [self.navigationController pushViewController:contentVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        XXEMySelfAlbumModel *model = self.datasource[indexPath.row];
        
        XXEMyselfAblumDeleApi *ablumApi = [[XXEMyselfAblumDeleApi alloc]initWithDeleMyselfAblumId:model.album_id UserXid:strngXid UserId:albumUserId];
        [ablumApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            
            NSString *code = [request.responseJSONObject objectForKey:@"code"];
            if ([code intValue] == 1) {
                [self showHudWithString:@"删除成功" forSecond:1.f];
                [self.datasource removeObjectAtIndex:indexPath.row];
                NSLog(@"删除的时候数据源个数%lu",(unsigned long)self.datasource.count);
                [self.myClassAlumTableView reloadData];
            } else{
                [self showHudWithString:@"删除失败" forSecond:1.f];
            }
        } failure:^(__kindof YTKBaseRequest *request) {
            [self showHudWithString:@"删除失败" forSecond:1.f];
        }];
    }
}

- (void)updataButtonClick
{
    if (self.datasource.count != 0) {
        XXEUpdataImageViewController *updataVC = [[XXEUpdataImageViewController alloc]init];
        updataVC.datasource = self.datasource ;
        updataVC.myAlbumUpSchoolId = self.myAlbumSchoolId;
        updataVC.myAlbumUpClassId = self.myAlbumClassId;
        updataVC.userIdentifier = _userIdentifier;
        [self.navigationController pushViewController:updataVC animated:YES];

    }else{
        [self showString:@"请先创建相册" forSecond:1.5];
    }
    
}

//创建相册
- (void)createButtonClick
{
    NSString *title =@"新建相薄";
    NSString *message =@"请为此相薄输入名称.";
    NSString *okBtn =@"存储";
    NSString *cancelBtn =@"取消";
    UIAlertController *alertView =[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //创建文本框
    [alertView addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder =@"标题";
        textField.secureTextEntry =NO;
        _myNewAlbumName = textField.text;
    }];
    //取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtn style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertView addAction:cancelAction];
    //确定
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okBtn style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *certeTextFieldn =alertView.textFields.firstObject;
        XXEMySelfAlbumModel *model = [[XXEMySelfAlbumModel alloc]init];
        model.album_name = certeTextFieldn.text;
        model.pic_num = @"0";
        model.album_pic = @"";
        [self.datasource addObject:model];
        NSLog(@"数组个数%lu",(unsigned long)self.datasource.count);
        [self myClassAlbumAdd:certeTextFieldn.text];
        
    }];
    [alertView addAction:okAction];
    [self presentViewController:alertView animated:YES completion:nil];
}

#pragma mark - 添加相册
- (void)myClassAlbumAdd:(NSString *)string
{

    //正式
    XXEMyselfAblumAddApi *addMySelfAblum = [[XXEMyselfAblumAddApi alloc]initWithAddMyselfAblumSchoolId:self.myAlbumSchoolId ClassId:self.myAlbumClassId AlbumName:string AlbumXid:strngXid AlbumUserId:albumUserId position:_userIdentifier];
//    NSLog(@"创建相册=== %@ %@ %@ %@ %@",self.myAlbumSchoolId,self.myAlbumClassId,string,strngXid,albumUserId);
    
    [addMySelfAblum startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
//        NSLog(@"快快快==========  %@",request.responseJSONObject);
        
        if ([code intValue] == 1) {
            [self showString:@"创建成功" forSecond:1.f];
            [self.datasource removeAllObjects];
            //请求数据
            [self setupMyselfAlbumMessage];
        } else {
            [self showHudWithString:@"创建失败" forSecond:1.f];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [self showHudWithString:@"创建失败" forSecond:1.f];
    }];
}


#pragma mark - 设置导航栏右边的样式
- (void)rightNavigationButton
{
    //设置 navigationBar 右边 上传图片
    UIButton *updataButton = [UIButton buttonWithType:UIButtonTypeCustom];
    updataButton.frame = CGRectMake(300, 5, 22, 22);
    [updataButton setImage:[UIImage imageNamed:@"class_album_upload"] forState:UIControlStateNormal];
    [updataButton addTarget:self action:@selector(updataButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithCustomView:updataButton];
    
    //    设置 navigationBar 右边 创建相册
    UIButton *createButton = [UIButton buttonWithType:UIButtonTypeCustom];
    createButton.frame = CGRectMake(300, 5, 22, 22);
    [createButton setImage:[UIImage imageNamed:@"class_abbum_creat"] forState:UIControlStateNormal];
    [createButton addTarget:self action:@selector(createButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc] initWithCustomView:createButton];
    self.navigationItem.rightBarButtonItems = @[rightItem2, rightItem1];
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
