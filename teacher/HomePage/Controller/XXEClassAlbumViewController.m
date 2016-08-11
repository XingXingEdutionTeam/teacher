//
//  XXEClassAlbumViewController.m
//  teacher
//
//  Created by codeDing on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEClassAlbumViewController.h"
#import "XXEClassAlbumTableViewCell.h"
#import "XXEClassAlbumApi.h"
#import "XXEClassAlbumModel.h"

@interface XXEClassAlbumViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *classAlbumTableView;
/** 头不文字显示数组 */
@property (nonatomic, strong)NSMutableArray *headDatasource;
/** 相片的数组 */
@property (nonatomic, strong)NSMutableArray *imageViewDatasource;

@end

static NSString *const IdentifierCell = @"classAlbunCell";

@implementation XXEClassAlbumViewController

-(NSMutableArray *)headDatasource
{
    if (!_headDatasource) {
        _headDatasource = [NSMutableArray array];
    }
    return _headDatasource;
}

-(NSMutableArray *)imageViewDatasource
{
    if (!_imageViewDatasource) {
        _imageViewDatasource = [NSMutableArray array];
    }
    return _imageViewDatasource;
}


- (UITableView *)classAlbumTableView
{
    if (!_classAlbumTableView) {
        _classAlbumTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    }
    return _classAlbumTableView;
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
    // Do any additional setup after loading the view.
    self.title = @"相册";
    //获取数据
    [self loadClassAlbumMessage];
    [self.classAlbumTableView registerClass:[XXEClassAlbumTableViewCell class] forCellReuseIdentifier:IdentifierCell];
     _classAlbumTableView.delegate = self;
    _classAlbumTableView.dataSource = self;
    [self.view addSubview:self.classAlbumTableView];
    
}


#pragma mark - 获取数据
- (void)loadClassAlbumMessage
{
    XXEClassAlbumApi *classApi = [[XXEClassAlbumApi alloc]initWithClassAlbumSchoolID:@"1" classID:@"1"];
    [classApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSArray *data = [request.responseJSONObject objectForKey:@"data"];
        NSLog(@"我的相册:%lu",(unsigned long)data.count );
        NSLog(@"%@",data);
        for (int i =0 ; i < data.count; i++) {
            XXEClassAlbumModel *model = [[XXEClassAlbumModel alloc]initWithDictionary:data[i] error:nil];
            [self.headDatasource addObject:model.tname];
            [self.imageViewDatasource addObject:model.pic_arr];
        }
        [self.classAlbumTableView reloadData];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}

#define mark - delegate 单元格的代理方法 datasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 30;
    }
    
    return 10;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.headDatasource.count;
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return   self.headDatasource[section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XXEClassAlbumTableViewCell *cell = (XXEClassAlbumTableViewCell*) [tableView dequeueReusableCellWithIdentifier:IdentifierCell];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        NSArray *model = self.imageViewDatasource[indexPath.section];
    NSLog(@"---------%@",self.imageViewDatasource);
    
        [cell getTheImageViewData:model];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     XXEClassAlbumTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row ==0 && indexPath.section==0) {
        
//        UpLoadPicViewController *upLoadPicVC =[[UpLoadPicViewController alloc]init];
//        
//        [self.navigationController pushViewController:upLoadPicVC animated:YES];
        
    }
    else{
        
//        OtherTeacherViewController *otherTeacherVC =[[OtherTeacherViewController alloc]init];
//        
//        
//        
//        [self.navigationController pushViewController:otherTeacherVC animated:YES];
        
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
