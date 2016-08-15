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

static NSString * OTherCELL = @"OTHERCELL";
@interface XXEOtherTeacherAlbumViewController ()<UITableViewDelegate,UITableViewDataSource>
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
        _otherTeacherTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
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
    //真实环境
    //    XXEMyselfAblumApi *myselfAblum = [[XXEMyselfAblumApi alloc]initWithMyselfAblumSchoolId:self.myAlbumSchoolId ClassId:self.myAlbumClassId TeacherId:self.myAlbumTeacherId];
    //测试环境
    XXEMyselfAblumApi *myselfAblum = [[XXEMyselfAblumApi alloc]initWithMyselfAblumSchoolId:@"1" ClassId:@"1" TeacherId:@"1"];
    [myselfAblum startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSArray *data = [request.responseJSONObject objectForKey:@"data"];
        
        for (int i =0; i < data.count; i++) {
            XXEMySelfAlbumModel *model = [[XXEMySelfAlbumModel alloc]initWithDictionary:data[i] error:nil];
            [self.datasource addObject:model];
        }
        
        NSLog(@"%@",self.datasource);
        [self.otherTeacherTableView reloadData];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];

    
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
    NSLog(@"显示的Model:%@",model);
    [cell configerGetClassAlubmMessage:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
