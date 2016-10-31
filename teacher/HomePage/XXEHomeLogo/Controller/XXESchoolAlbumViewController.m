

//
//  XXESchoolAlbumViewController.m
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolAlbumViewController.h"
#import "XXESchoolAlbumCollectionViewCell.h"
#import "XXESchoolAlbumShowViewController.h"
#import "XXESchoolUpPicViewController.h"
#import "XXESchoolPicApi.h"
#import "XXESchoolAlbumModel.h"
#import "XXEDeleteSchoolPicApi.h"
#import "XXEAlbumShowViewController.h"
#import "XXEAlbumContentApi.h"
#import "XXEAlbumDetailsModel.h"

@interface XXESchoolAlbumViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSString *parameterXid;
    NSString *parameterUser_Id;
    //右上  编辑 按钮
    UIButton *editButton;
    //要删除 图片 的id
    NSString *pic_id_str;
    //底部 视图
    UIView *bottomView;
    //全选
    UIButton *allSeletedButton;
    //删除
    UIButton *deleteButton;
    //上传
    UIButton *upButton;
}
//    数据源数组
@property (nonatomic) NSMutableArray *dataSourceArray;

@property (nonatomic, strong) UICollectionView *myCollcetionView;

//选中 item 的model
@property (nonatomic, strong) NSMutableArray *seletedModelArray;

//@property (nonatomic, strong) NSArray* contacts;
@property (nonatomic, strong) NSMutableIndexSet* selectedIndexSet;

@end

@implementation XXESchoolAlbumViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    pic_id_str = @"";
    editButton.selected = YES;
    deleteButton.selected = YES;
    _seletedModelArray = [[NSMutableArray alloc] init];
    _selectedIndexSet = [NSMutableIndexSet indexSet];
//    _myCollcetionView.allowsMultipleSelection = YES;
    
    [self updateSelections];
    
    //初始化数据源
    [self fetchNetData];
    [_myCollcetionView reloadData];
    
    //设置 navgiationBar
    [self settingNavgiationBar];
    
    //设置内容
    [self customContent];
    
    //下面 bottom
    [self createBottomView];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  设置 navigationBar 上左右字体 颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    
    self.title = @"相   册";
    [self.myCollcetionView registerNib:[UINib nibWithNibName:NSStringFromClass([XXESchoolAlbumCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XXESchoolAlbumCollectionViewCell class])];
    
}

- (void)settingNavgiationBar{

    if ([self.position isEqualToString:@"3"] || [self.position isEqualToString:@"4"]) {
        //设置 navigationBar 右边 赠送
        editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        editButton.frame = CGRectMake(330, 5, 40, 22);
        [editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(editButtonCick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
        self.navigationItem.rightBarButtonItem =rightItem;
    }

}

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

#pragma mark ----------------全选 -------------------
- (void)allSeletedButtonClick:(UIButton *)button{
    NSUInteger count = [_dataSourceArray count];
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

    //self.selectedIndexSet
    NSMutableArray *allIndexArray = [[NSMutableArray alloc] init];
    NSArray *seletedIndexArray = [[NSArray alloc] init];
    for (int i = 0; i < _dataSourceArray.count; i++) {
        [allIndexArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
   seletedIndexArray = [allIndexArray objectsAtIndexes:_selectedIndexSet];
    
    for (NSString *str in seletedIndexArray) {
        NSInteger t = [str integerValue];
        
        [_seletedModelArray addObject:_dataSourceArray[t]];
    }
    button.selected = !button.selected;
    if (button.selected == YES) {
        if (_seletedModelArray.count == 0) {
            [self showHudWithString:@"请选择要删除的图片!" forSecond:1.5];
        }else{
            [self deleteShoolPic];
            
        }
    }
    
}

- (void)deleteShoolPic{
    if (_seletedModelArray.count == 1) {
        XXESchoolAlbumModel *picModel = _seletedModelArray[0];
        pic_id_str = picModel.schoolPicId;
        
    }else if (_seletedModelArray.count > 1){
        
        NSMutableString *tidStr = [NSMutableString string];
        
        for (int j = 0; j < _seletedModelArray.count; j ++) {
            
            XXESchoolAlbumModel *picModel = _seletedModelArray[j];
            
            NSString *str = picModel.schoolPicId;
            
            if (j != _seletedModelArray.count - 1) {
                [tidStr appendFormat:@"%@,", str];
            }else{
                [tidStr appendFormat:@"%@", str];
            }
        }
        pic_id_str = tidStr;
    }

//    NSLog(@"bbb %@", pic_id_str);
    
    XXEDeleteSchoolPicApi *deleteSchoolPicApi = [[XXEDeleteSchoolPicApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:_schoolId position:@"4" pic_id_str:pic_id_str];
    [deleteSchoolPicApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//                NSLog(@"2222---   %@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"删除成功!" forSecond:1.5];
            
            [_dataSourceArray removeObjectsInArray:_seletedModelArray];
            
            [_myCollcetionView reloadData];
//            editButton.selected = NO;
//            [self updateButtonTitle];
        }else{
            [self showHudWithString:@"删除失败!" forSecond:1.5];
        }

    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
}

#pragma mark - ---------------------上传 照片----------------
- (void)upButtonClick:(UIButton *)upBtn{
    NSLog(@"上传图片");
    int i=1;
    XXESchoolUpPicViewController *schoolUpPicVC =[[XXESchoolUpPicViewController alloc]init];
    schoolUpPicVC.t =i;

    schoolUpPicVC.schoolId = _schoolId;
    schoolUpPicVC.flagStr = @"fromSchoolAlbum";
    [self.navigationController pushViewController:schoolUpPicVC animated:YES];
}

//
- (void)fetchNetData{
    
    if ([_flagStr isEqualToString:@"formSchoolInfo"]) {
        //修改 学校 相册
        [self modifySchoolPic];
    }
}

- (void)modifySchoolPic{

    XXESchoolPicApi *schoolPicApi = [[XXESchoolPicApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE school_id:_schoolId];
    [schoolPicApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        _dataSourceArray = [[NSMutableArray alloc] init];
        //        NSLog(@"2222---   %@", request.responseJSONObject);

        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSArray *modelArray = [XXESchoolAlbumModel parseResondsData:request.responseJSONObject[@"data"]];
            
            [_dataSourceArray addObjectsFromArray:modelArray];
            
        }else{
            
        }
        
        [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];

}

//相册 有数据 和 无数据 进行判断
- (void)customContent{
        // 1、无数据的时候
    if (_dataSourceArray.count == 0) {
        UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth / 2 - myImageWidth / 2, (KScreenHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];
    }else{
        //2、有数据的时候
        [self createCollectionView];
    }
    
}


//初始化CollectionView
-(void)createCollectionView{
    //    布局对象
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //    默认是垂直滚动
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //    设置行间距
    layout.minimumLineSpacing = 10;
    //    设置列间距
    layout.minimumInteritemSpacing = 10;
    //    设置item的大小
    layout.itemSize = CGSizeMake((KScreenWidth - 4 * 10) / 3, (KScreenWidth - 4 * 10) / 3);
    
    //    初始化UICollectionView,并设置布局对象
    self.myCollcetionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) collectionViewLayout:layout];
    
    //    设置代理
    self.myCollcetionView.dataSource = self;
    self.myCollcetionView.delegate = self;
    _myCollcetionView.allowsMultipleSelection = YES;
    
    [self.view addSubview:self.myCollcetionView];
    
    //    提前告诉_collectionView用什么视图作为显示的复用视图，并且设置复用标识
    //    一定要实现，否则会崩溃 有xib的时候 用nib,纯代码 用 class
//    [self.myCollcetionView registerClass:[XXESchoolAlbumCollectionViewCell class] forCellWithReuseIdentifier:@"XXESchoolAlbumCollectionViewCell"];
    [self.myCollcetionView registerNib:[UINib nibWithNibName:@"XXESchoolAlbumCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"XXESchoolAlbumCollectionViewCell"];
}
#pragma mark -
//返回有几组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每组有几个
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataSourceArray.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"XXESchoolAlbumCollectionViewCell";
    XXESchoolAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

        XXESchoolAlbumModel *model = _dataSourceArray[indexPath.item];
    [cell.schoolImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kXXEPicURL,model.pic]] placeholderImage:[UIImage imageNamed:@""]];
    
    cell.model = model;
    cell.disabled = [self.disabledContactIds containsObject:model.schoolPicId];
    return cell;
}

#pragma mark ------- ++++++ ====== 全选/反选 ======= ++++++++ ----------

- (void)updateSelections {
    if (!self.selectedContactIds || ![self.selectedContactIds count]) {
        return;
    }
    NSIndexSet *selectedContactsIndexSet = [_dataSourceArray indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XXESchoolAlbumModel *contact = obj;
        return [self.selectedContactIds containsObject:contact.schoolPicId];
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
            XXESchoolAlbumModel* contact = obj;
            return ![self.disabledContactIds containsObject:contact.schoolPicId];
        }];
    } else {
        enabledContactsIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [contacts count])];
    }
    
    return enabledContactsIndexSet;
}

- (BOOL)allEnabledContactsSelected {
    NSIndexSet* enabledIndexSet = [self enabledContactsIndexSetForContancts:_dataSourceArray];
    BOOL allEnabledContactsSelected = [self.selectedIndexSet containsIndexes:enabledIndexSet];
    return allEnabledContactsSelected;
}

- (NSArray *)selectedContacts {
    return [_dataSourceArray objectsAtIndexes:self.selectedIndexSet];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.disabledContactIds count]) {
        NSInteger item = indexPath.item;
        XXESchoolAlbumModel *contact = _dataSourceArray[item];
        return ![self.disabledContactIds containsObject:contact.schoolPicId];
    }
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.disabledContactIds count]) {
        NSInteger item = indexPath.item;
        XXESchoolAlbumModel *contact = _dataSourceArray[item];
        return ![self.disabledContactIds containsObject:contact.schoolPicId];
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
    
            XXESchoolAlbumShowViewController *showVC = [[XXESchoolAlbumShowViewController alloc]init];
    
            NSMutableArray *picArr = [[NSMutableArray alloc] init];
            for (XXESchoolAlbumModel *model in _dataSourceArray) {
                [picArr addObject:model.pic];
            }
    
            showVC.imageUrlArray = picArr;
            showVC.currentIndex = indexPath.item;
            //举报 来源 8:星级评分图片
            showVC.origin_pageStr = @"4";
            showVC.imageModelArray = _dataSourceArray;
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
