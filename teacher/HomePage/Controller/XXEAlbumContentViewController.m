//
//  XXEAlbumContentViewController.m
//  teacher
//
//  Created by codeDing on 16/8/15.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEAlbumContentViewController.h"
#import "XXEAlbumContentApi.h"
#import "XXEContentAlbumCollectionViewCell.h"
#import "XXECollectionHeaderReusableView.h"


@class XXEMySelfAlbumModel;
@interface XXEAlbumContentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *contentCollectionView;


@end

static NSString *identifierCell = @"CELL";
static NSString *headerCell = @"HEADERCELL";

@implementation XXEAlbumContentViewController

- (XXEMySelfAlbumModel *)contentModel
{
    if (!_contentModel) {
        _contentModel = [[XXEMySelfAlbumModel alloc]init];
    }
    return _contentModel;
}

- (UICollectionView *)contentCollectionView
{
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
        _contentCollectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowlayout];
        flowlayout.minimumLineSpacing = 10;
        flowlayout.minimumInteritemSpacing = 10;
        flowlayout.itemSize = CGSizeMake((KScreenWidth - 4*10), (KScreenHeight - 4*10)/3);
        flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _contentCollectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowlayout];
        _contentCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return _contentCollectionView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    self.navigationController.navigationBarHidden = NO;
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _contentModel.album_name;
    [self.view addSubview:self.contentCollectionView];
    self.contentCollectionView.delegate =self;
    self.contentCollectionView.dataSource = self;
    [self.contentCollectionView registerClass:[XXEContentAlbumCollectionViewCell class] forCellWithReuseIdentifier:identifierCell];
    [self.contentCollectionView registerClass:[XXECollectionHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerCell];
    //获取数据
//    [self setupAlbumContentRequeue];
}

#pragma mark - UICollectionViewDelegate/ Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 10;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XXEContentAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"===选中某一个View====");
}

//头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        XXECollectionHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerCell forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor redColor];
        headerView.title =  @"时间";
        return headerView;
    } else {
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(20, 20);
}

#pragma mark - 获取数据
- (void)setupAlbumContentRequeue
{
    XXEAlbumContentApi *contentApi = [[XXEAlbumContentApi alloc]initWithAlbumContentAlbumId:self.contentModel.album_id];
    [contentApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        NSLog(@"%@",request.responseJSONObject);
        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
        NSLog(@"======%lu",(unsigned long)data.count);
        NSLog(@"=------%@",[data objectForKey:@"1458894982"]);
        for (NSMutableArray *arr in data) {
            NSLog(@"数组里面都有什么%@",arr);
        }
        
        
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
