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
    //要删除 图片 的id
    NSString *pic_id_str;
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

@property (nonatomic, strong) NSMutableIndexSet* selectedIndexSet;

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
//    bottomView.hidden = !editButton.selected;
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
    _selectedIndexSet = [NSMutableIndexSet indexSet];
    _seletedModelArray = [[NSMutableArray alloc] init];
    
    editButton.selected = YES;
    
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
    self.myCollcetionView.allowsMultipleSelection = YES;
    
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
//    NSLog(@"相片的地址:%@",model.pic);
    NSString *string = [NSString stringWithFormat:@"%@%@",kXXEPicURL,model.pic];
    
    [cell configterContentAblumCellPicURl:string];
    cell.model = model;
    cell.disabled = [self.disabledContactIds containsObject:model.photoId];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
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

    NSUInteger count = [_datasourceA count];
    BOOL allEnabledContactsSelected = [self allEnabledContactsSelected];
    if (!allEnabledContactsSelected) {
        [_myCollcetionView performBatchUpdates:^{
            for (NSUInteger index = 0; index < count; ++index) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
                
                if ([self collectionView:_myCollcetionView shouldSelectItemAtIndexPath:indexPath]) {
                    [_myCollcetionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                    [self.selectedIndexSet addIndex:indexPath.item];
                }
            }
        } completion:^(BOOL finished) {
            [self updateToggleSelectionButton];
        }];
    } else {
        [_myCollcetionView performBatchUpdates:^{
            [self.selectedIndexSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL * _Nonnull stop) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
                
                if ([self collectionView:_myCollcetionView shouldDeselectItemAtIndexPath:indexPath]) {
                    [_myCollcetionView deselectItemAtIndexPath:indexPath animated:YES];
                    [self.selectedIndexSet removeIndex:indexPath.item];
                }
                
            }];
        } completion:^(BOOL finished) {
            [self updateToggleSelectionButton];
        }];
    }

}

#pragma mark ----------------删除 -------------------
- (void)deleteButtonClick:(UIButton *)button{
    
//    NSLog(@"--- %@ ==", _selectedIndexSet);
    
    NSMutableArray *allIndexArray = [[NSMutableArray alloc] init];
    NSArray *seletedIndexArray = [[NSArray alloc] init];
    for (int i = 0; i < _datasourceA.count; i++) {
        [allIndexArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    seletedIndexArray = [allIndexArray objectsAtIndexes:_selectedIndexSet];
    
    for (NSString *str in seletedIndexArray) {
        NSInteger t = [str integerValue];
        
        [_seletedModelArray addObject:_datasourceA[t]];
    }

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
    if (_seletedModelArray.count == 1) {
        XXEAlbumDetailsModel *picModel = _seletedModelArray[0];
        pic_id_str = picModel.photoId;
        
    }else if (_seletedModelArray.count > 1){
        
        NSMutableString *tidStr = [NSMutableString string];
        
        for (int j = 0; j < _seletedModelArray.count; j ++) {
            
            XXEAlbumDetailsModel *picModel = _seletedModelArray[j];
            
            NSString *str = picModel.photoId;
            
            if (j != _seletedModelArray.count - 1) {
                [tidStr appendFormat:@"%@,", str];
            }else{
                [tidStr appendFormat:@"%@", str];
            }
        }
        pic_id_str = tidStr;
    }

    
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
    
//    for (int i=0; i<self.seletedModelArray.count; i++) {
//       XXEAlbumDetailsModel *model = self.seletedModelArray[i];
    XXEDeleteClassPicApi *deleteApi = [[XXEDeleteClassPicApi alloc]initWithDeleteUserXid:strngXid UserID:homeUserId PicId:pic_id_str];
        [deleteApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//            NSLog(@"%@",request.responseJSONObject);
//            NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
            NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
            if ([codeStr isEqualToString:@"1"]) {
                [self showHudWithString:@"删除成功!" forSecond:1.5];
                
                [_datasourceA removeObjectsInArray:_seletedModelArray];
                
                [_myCollcetionView reloadData];
//                editButton.selected = NO;
                //            [self updateButtonTitle];
            }else{
                [self showHudWithString:@"删除失败!" forSecond:1.5];
            }

        } failure:^(__kindof YTKBaseRequest *request) {
           [self showString:@"数据请求失败" forSecond:1.f];
        }];
//    }
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
//        NSLog(@"总的%@",request.responseJSONObject);
        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
//        NSLog(@"data:%@",data);
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
            
            for (int j =0; j<arr.count; j++) {
                XXEAlbumDetailsModel *model = [[XXEAlbumDetailsModel alloc]initWithDictionary:arr[j] error:nil];
                [self.datasourceA addObject:model];
            }
        }
        NSLog(@"所有对象%@",self.datasourceA);
        [self.myCollcetionView reloadData];
    } failure:^(__kindof YTKBaseRequest *request) {
        [self showString:@"照片数据请求失败" forSecond:1.f];
    }];
}


#pragma mark ------- ++++++ ====== 全选/反选 ======= ++++++++ ----------

- (void)updateSelections {
    if (!self.selectedContactIds || ![self.selectedContactIds count]) {
        return;
    }
    NSIndexSet *selectedContactsIndexSet = [_datasourceA indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XXEAlbumDetailsModel *contact = obj;
        return [self.selectedContactIds containsObject:contact.photoId];
    }];
    
    [selectedContactsIndexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [_myCollcetionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self.selectedIndexSet addIndex:indexPath.item];
    }];
    
    [self updateToggleSelectionButton];
}

- (void)updateToggleSelectionButton {
    BOOL allEnabledContactsSelected = [self allEnabledContactsSelected];
    NSString *title = !allEnabledContactsSelected ? @"全选" : @"全不选";
    [allSeletedButton setTitle:title forState:UIControlStateNormal];
}

- (NSIndexSet *)enabledContactsIndexSetForContancts:(NSArray *)contacts {
    NSIndexSet *enabledContactsIndexSet = nil;
    if ([self.disabledContactIds count]) {
        enabledContactsIndexSet = [contacts indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            XXEAlbumDetailsModel* contact = obj;
            return ![self.disabledContactIds containsObject:contact.photoId];
        }];
    } else {
        enabledContactsIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [contacts count])];
    }
    
    return enabledContactsIndexSet;
}

- (BOOL)allEnabledContactsSelected {
    NSIndexSet* enabledIndexSet = [self enabledContactsIndexSetForContancts:_datasourceA];
    BOOL allEnabledContactsSelected = [self.selectedIndexSet containsIndexes:enabledIndexSet];
    return allEnabledContactsSelected;
}

- (NSArray *)selectedContacts {
    return [_datasourceA objectsAtIndexes:self.selectedIndexSet];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.disabledContactIds count]) {
        NSInteger item = indexPath.item;
        XXEAlbumDetailsModel *contact = _datasourceA[item];
        return ![self.disabledContactIds containsObject:contact.photoId];
    }
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.disabledContactIds count]) {
        NSInteger item = indexPath.item;
        XXEAlbumDetailsModel *contact = _datasourceA[item];
        return ![self.disabledContactIds containsObject:contact.photoId];
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"%@",editButton.selected ? @"YES":@"NO");
    //        XXESchoolAlbumModel *picModel = _dataSourceArray[indexPath.item];
    if (editButton.selected == YES) {
        [self.selectedIndexSet addIndex:indexPath.item];
        [self updateToggleSelectionButton];
    }else if(editButton.selected == NO){
        XXEAlbumShowViewController *showVC = [[XXEAlbumShowViewController alloc]init];
        showVC.detailsModel = self.datasourceA[indexPath.item];
        showVC.showAlbumXid = self.albumTeacherXID;
        [self.navigationController pushViewController:showVC animated:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.selectedIndexSet removeIndex:indexPath.item];
    
    [self updateToggleSelectionButton];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
