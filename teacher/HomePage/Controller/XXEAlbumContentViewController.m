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
#import "XXEContentAlbumCollectionCell.h"

//#import "XXECollectionHeaderReusableView.h"
#import "XXEAlbumDetailsModel.h"
#import "XXEAlbumShowViewController.h"
#import "XXEUpdataImageViewController.h"
#import "XXEDeleteClassPicApi.h"


@class XXEMySelfAlbumModel;
@interface XXEAlbumContentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    //右上  编辑 按钮
    UIButton *editButton;
    //底部 视图
    UIView *bottomView;
    //全选
    UIButton *allSeletedButton;
    //删除
    UIButton *deleteButton;
    //上传
    UIButton *upButton;
}

@property (nonatomic, strong)UICollectionView *myCollcetionView;
/** 时间戳数组 */
@property (nonatomic, strong)NSMutableArray *timesDatasource;
/** 原始的时间数组 */
@property (nonatomic, strong)NSMutableArray *originalDatasource;
/** 数据源 */
@property (nonatomic, strong)NSMutableArray *datasourceA;
/** 每一区的数组元 */
@property (nonatomic, strong)NSMutableArray *itemDatasource;
//选中 item 的model
@property (nonatomic, strong) NSMutableArray *seletedModelArray;

@property (nonatomic, copy)NSString *isAllSelected;

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

- (NSMutableArray *)datasourceA
{
    if (!_datasourceA) {
        _datasourceA = [NSMutableArray array];
    }
    return _datasourceA;
}

- (NSMutableArray *)timesDatasource
{
    if (!_timesDatasource) {
        _timesDatasource = [NSMutableArray array];
    }
    return _timesDatasource;
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
    
    editButton.selected = YES;
    deleteButton.selected = YES;
    _seletedModelArray = [[NSMutableArray alloc] init];
    //下面 bottom
    [self createBottomView];
    //设置 navgiationBar
    [self settingNavgiationBar];
    ///获取数据
    [self setupAlbumContentRequeue];
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
}

#pragma mark - 设置页面
- (void)settingNavgiationBar{
    editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(330, 5, 40, 22);
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonCick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    self.navigationItem.rightBarButtonItem =rightItem;
    
}

- (void)creatCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake((KScreenWidth- 4*10)/3, (KScreenWidth-4*10)/3);
    self.myCollcetionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,KScreenWidth , KScreenHeight-64) collectionViewLayout:layout];
    self.myCollcetionView.backgroundColor = [UIColor whiteColor];
    self.myCollcetionView.delegate =self;
    self.myCollcetionView.dataSource = self;
    [self.myCollcetionView registerNib:[UINib nibWithNibName:@"XXEContentAlbumCollectionCell" bundle:nil] forCellWithReuseIdentifier:identifierCell];
    
//    [self.myCollcetionView registerClass:[XXECollectionHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerCell];
    [self.view addSubview:self.myCollcetionView];
}

- (void)createBottomView{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 64 - 49, KScreenWidth, 49)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.hidden = YES;
    [self.view addSubview:bottomView];
    bottomView.userInteractionEnabled =YES;
    
    CGFloat itemWidth = KScreenWidth / 3;
    CGFloat itemHeight = 49;
    
    CGFloat buttonWidth = itemWidth;
    CGFloat buttonHeight = itemHeight;
    
    //---------------------------- 全选 -----------
    allSeletedButton = [UIButton createButtonWithFrame:CGRectMake(buttonWidth / 2 * 0, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) backGruondImageName:nil Target:self Action:@selector(allSeletedButtonClick:) Title:@"全选"];
    [allSeletedButton setImage:[UIImage imageNamed:@"home_logo_allselete_unseleted_icon"] forState:UIControlStateNormal];
    [allSeletedButton setImage:[UIImage imageNamed:@"home_logo_allselete_seleted_icon"] forState:UIControlStateHighlighted];
    allSeletedButton.titleLabel.font = [UIFont systemFontOfSize:10];
    //设置 图片 位置
    allSeletedButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 - 38 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    allSeletedButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -allSeletedButton.titleLabel.bounds.size.width-20, 0, 0);
    [bottomView addSubview:allSeletedButton];
    
    //-------------------------- 删除 ----------
    deleteButton = [UIButton createButtonWithFrame:CGRectMake(buttonWidth, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) backGruondImageName:nil Target:self Action:@selector(deleteButtonClick:) Title:@"删除"];
    [deleteButton setImage:[UIImage imageNamed:@"home_logo_delete_unseleted_icon"] forState:UIControlStateNormal];
    [deleteButton setImage:[UIImage imageNamed:@"home_logo_delete_seleted_icon"] forState:UIControlStateHighlighted];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:10];
    //设置 图片 位置
    deleteButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 - 38 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    deleteButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -deleteButton.titleLabel.bounds.size.width-20, 0, 0);
    [bottomView addSubview:deleteButton];
    
    //--------------------------------上传-------
    upButton = [UIButton createButtonWithFrame:CGRectMake(buttonWidth * 2, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) backGruondImageName:nil Target:self Action:@selector(upButtonClick:) Title:@"上传"];
    [upButton setImage:[UIImage imageNamed:@"home_logo_upload_unseleted_icon"] forState:UIControlStateNormal];
    [upButton setImage:[UIImage imageNamed:@"home_logo_upload_seleted_icon"] forState:UIControlStateHighlighted];
    upButton.titleLabel.font = [UIFont systemFontOfSize:10];
    //设置 图片 位置
    upButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 - 38 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    upButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -upButton.titleLabel.bounds.size.width-20, 0, 0);
    [bottomView addSubview:upButton];
    
}


#pragma mark - UICollectionViewDelegate/ Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datasourceA.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XXEContentAlbumCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    XXEAlbumDetailsModel *model = self.datasourceA[indexPath.item];
    NSLog(@"相片的地址:%@",model.pic);
    NSString *string = [NSString stringWithFormat:@"%@%@",kXXEPicURL,model.pic];
    
    [cell configterContentAblumCellPicURl:string];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editButton.selected == YES) {
        XXEAlbumDetailsModel *model = self.datasourceA[indexPath.item];
        NSLog(@"%@",model);
        [_seletedModelArray addObject:model];
        [self updateButtonTitle];
    }else if(editButton.selected == NO){
        
        XXEAlbumShowViewController *showVC = [[XXEAlbumShowViewController alloc]init];
        showVC.showDatasource = self.datasourceA[indexPath.item];
        showVC.showAlbumXid = self.albumTeacherXID;
        [self.navigationController pushViewController:showVC animated:YES];
    }
//    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XXEAlbumDetailsModel *picModel = _datasourceA[indexPath.item];
    [_seletedModelArray removeObject:picModel];
    [self updateButtonTitle];
    
}


////头视图
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        XXECollectionHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerCell forIndexPath:indexPath];
//        headerView.title =  self.timesDatasource[indexPath.section];
//        headerView.backgroundColor = [UIColor lightGrayColor];
//        return headerView;
//    } else {
//        return nil;
//    }
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(20, 20);
}

#pragma mark - 方法
- (void)updateButtonTitle{
    
    if (editButton.selected == NO) {
        _myCollcetionView.allowsMultipleSelection = NO;
    }else if (editButton.selected == YES){
        _myCollcetionView.allowsMultipleSelection = YES;
    }
}

#pragma mark - actionButton
- (void)editButtonCick:(UIButton *)button{
    //    NSLog(@"-----  editButtonCick ----");
    button.selected = !button.selected;
    bottomView.hidden = !editButton.selected;
    if (editButton.selected == YES) {
        _myCollcetionView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 49);
    }else if (editButton.selected == NO){
        _myCollcetionView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64);
    }
    
}

#pragma mark - ---------------------上传 照片----------------
- (void)upButtonClick:(UIButton *)upBtn{
    NSLog(@"上传图片");
    XXEUpdataImageViewController *updataVC = [[XXEUpdataImageViewController alloc]init];
    updataVC.datasource = self.datasource ;
    updataVC.myAlbumUpSchoolId = self.myAlbumUpSchoolId;
    updataVC.myAlbumUpClassId = self.myAlbumUpClassId;
    [self.navigationController pushViewController:updataVC animated:YES];
}

#pragma mark ----------------全选 -------------------
- (void)allSeletedButtonClick:(UIButton *)button{
    self.isAllSelected = @"1";
    //暂时不让全选
    if (_datasourceA.count != 0) {
        if (_seletedModelArray.count != 0) {
            [_seletedModelArray removeAllObjects];
        }
        for (int i = 0; i < _datasourceA.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            
            [self collectionView:_myCollcetionView didSelectItemAtIndexPath:indexPath];
            UICollectionViewCell *cell = (XXEContentAlbumCollectionCell *)[_myCollcetionView cellForItemAtIndexPath:indexPath];
            cell.selected = YES;
        }
    }
    
    [self popoverPresentationController];
}

#pragma mark ----------------删除 -------------------
- (void)deleteButtonClick:(UIButton *)button{
    //    NSLog(@"=====  deleteButtonClick =====");
    button.selected = !button.selected;
    if (button.selected == YES) {
        if (_seletedModelArray.count == 0) {
            [self showHudWithString:@"请选择要删除的图片!" forSecond:1.5];
        }else{
            [self deleteShoolPic];
            
        }
    }
    
}

#pragma mark - 删除相册
- (void)deleteShoolPic
{
    NSLog(@"%@",self.seletedModelArray);
    NSString *strngXid;
    NSString *homeUserId;
    if ([XXEUserInfo user].login) {
        strngXid = [XXEUserInfo user].xid;
        homeUserId = [XXEUserInfo user].user_id;
    }else {
        strngXid = XID;
        homeUserId = USER_ID;
    }
    
    for (int i=0; i<self.seletedModelArray.count; i++) {
       XXEAlbumDetailsModel *model = self.seletedModelArray[i];
        XXEDeleteClassPicApi *deleteApi = [[XXEDeleteClassPicApi alloc]initWithDeleteUserXid:strngXid UserID:homeUserId PicId:model.photoId];
        [deleteApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            NSLog(@"%@",request.responseJSONObject);
            NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
            
        } failure:^(__kindof YTKBaseRequest *request) {
            
        }];
    }
    //重新获取数据
    [self setupAlbumContentRequeue];
}


#pragma mark - 获取数据
- (void)setupAlbumContentRequeue
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
    
    XXEAlbumContentApi *contentApi = [[XXEAlbumContentApi alloc]initWithAlbumContentAlbumId:self.contentModel.album_id UserXid:strngXid UserId:homeUserId];
    NSLog(@"%@",self.contentModel.album_id);
    
    [contentApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"总的%@",request.responseJSONObject);
        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
        NSLog(@"data:%@",data);
        [self.timesDatasource removeAllObjects];
        [self.originalDatasource removeAllObjects];
        [self.itemDatasource removeAllObjects];
        [self.datasourceA removeAllObjects];
        
        for (NSString *timeStr in data) {
            NSString *newTime = [XXETool dateStringFromNumberTimer:timeStr];
            [self.timesDatasource addObject:newTime];
            [self.originalDatasource addObject:timeStr];
        }
        
        for (int i = 0; i<self.originalDatasource.count; i++) {
            NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:[data objectForKey:self.originalDatasource[i]]];
            
//            self.datasourceA = NULL;
            for (int j =0; j<arr.count; j++) {
                XXEAlbumDetailsModel *model = [[XXEAlbumDetailsModel alloc]initWithDictionary:arr[j] error:nil];
                [self.datasourceA addObject:model];
            }
//            [self.itemDatasource addObject:self.datasourceA];
        }
        NSLog(@"所有对象%@",self.datasourceA);
        [self.myCollcetionView reloadData];
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
