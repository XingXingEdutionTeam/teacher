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
#import "XXEAlbumDetailsModel.h"
#import "XXEAlbumShowViewController.h"


@class XXEMySelfAlbumModel;
@interface XXEAlbumContentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *contentCollectionView;
/** 时间戳数组 */
@property (nonatomic, strong)NSMutableArray *timeDatasource;
/** 原始的时间数组 */
@property (nonatomic, strong)NSMutableArray *originalDatasource;
/** 数据源 */
@property (nonatomic, strong)NSMutableArray *datasource;
/** 每一区的数组元 */
@property (nonatomic, strong)NSMutableArray *itemDatasource;
@end

static NSString *identifierCell = @"CELL";
static NSString *headerCell = @"HEADERCELL";

@implementation XXEAlbumContentViewController

- (NSMutableArray *)itemDatasource
{
    if (!_itemDatasource) {
        _itemDatasource = [NSMutableArray array];
    }
    return _itemDatasource;
}

- (NSMutableArray *)originalDatasource
{
    if (!_originalDatasource) {
        _originalDatasource = [NSMutableArray array];
    }
    return _originalDatasource;
}

- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (NSMutableArray *)timeDatasource
{
    if (!_timeDatasource) {
        _timeDatasource = [NSMutableArray array];
    }
    return _timeDatasource;
}

- (XXEMySelfAlbumModel *)contentModel
{
    if (!_contentModel) {
        _contentModel = [[XXEMySelfAlbumModel alloc]init];
    }
    return _contentModel;
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
    //创建试图
    [self creatCollectionView];
    
    ///获取数据
    [self setupAlbumContentRequeue];
}

- (void)creatCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake((KScreenWidth- 4*10)/3, (KScreenWidth-4*10)/3);
    self.contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,KScreenWidth , KScreenHeight-64) collectionViewLayout:layout];
    self.contentCollectionView.backgroundColor = [UIColor whiteColor];
    self.contentCollectionView.delegate =self;
    self.contentCollectionView.dataSource = self;
    [self.contentCollectionView registerClass:[XXEContentAlbumCollectionViewCell class] forCellWithReuseIdentifier:identifierCell];
    [self.contentCollectionView registerClass:[XXECollectionHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerCell];
    [self.view addSubview:self.contentCollectionView];
}

#pragma mark - UICollectionViewDelegate/ Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  self.itemDatasource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.itemDatasource[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XXEContentAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    XXEAlbumDetailsModel *model = self.itemDatasource[indexPath.section][indexPath.item];
    NSLog(@"相片的地址:%@",model.pic);
    NSString *string = [NSString stringWithFormat:@"%@%@",kXXEPicURL,model.pic];
    cell.imageName = string;
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"===选中某一个View====");
    XXEAlbumShowViewController *showVC = [[XXEAlbumShowViewController alloc]init];
    showVC.showDatasource = self.itemDatasource[indexPath.section];
    showVC.showAlbumXid = self.albumTeacherXID;
    [self.navigationController pushViewController:showVC animated:YES];
}

//头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        XXECollectionHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerCell forIndexPath:indexPath];
        headerView.title =  self.timeDatasource[indexPath.section];
        headerView.backgroundColor = [UIColor lightGrayColor];
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
    NSLog(@"%@",self.contentModel.album_id);
    
    [contentApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"总的%@",request.responseJSONObject);
        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
        NSLog(@"data:%@",data);
        
        for (NSString *timeStr in data) {
            NSString *newTime = [XXETool dateStringFromNumberTimer:timeStr];
            [self.timeDatasource addObject:newTime];
            [self.originalDatasource addObject:timeStr];
        }
        
        for (int i = 0; i<self.originalDatasource.count; i++) {
            NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:[data objectForKey:self.originalDatasource[i]]];
            
            self.datasource = NULL;
            for (int j =0; j<arr.count; j++) {
                XXEAlbumDetailsModel *model = [[XXEAlbumDetailsModel alloc]initWithDictionary:arr[j] error:nil];
                [self.datasource addObject:model];
            }
            [self.itemDatasource addObject:self.datasource];
        }
        NSLog(@"%@",self.itemDatasource);
        [self.contentCollectionView reloadData];
    } failure:^(__kindof YTKBaseRequest *request) {
        [self showString:@"照片数据请求失败" forSecond:1.f];
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
