

//
//  XXESchoolAlbumViewController.m
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolAlbumViewController.h"
#import "XXESchoolAlbumCollectionViewCell.h"
#import "XXESchoolUpPicViewController.h"
#import "XXESchoolPicApi.h"
#import "XXESchoolAlbumModel.h"



@interface XXESchoolAlbumViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}
//    数据源数组
@property (nonatomic) NSMutableArray *dataSourceArray;

//    UICollectionView 是IOS6之后出现的控件，继承自UIScrollView,多用于展示图片
@property (nonatomic, strong) UICollectionView *myCollcetionView;

//@property (nonatomic, strong) NSArray* contacts;
@property (nonatomic, strong) NSMutableIndexSet* selectedIndexSet;
//左下角 切换 按钮
@property (nonatomic, strong) UIButton *toggleSelectionBtn;


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
    //初始化数据源
    [self fetchNetData];
    [_myCollcetionView reloadData];
    
    //设置 navgiationBar
    [self settingNavgiationBar];
    
    //设置内容
    [self customContent];
    
    //下面 bottom
    [self createBottomView];
    
    [self updateSelections];
    
}

- (void)updateSelections{
    if (!self.selectedContactIds || ![self.selectedContactIds count]) {
        return;
    }
    NSIndexSet *selectedContactsIndexSet = [self.dataSourceArray indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XXESchoolAlbumModel *picModel = obj;
        return [self.selectedContactIds containsObject:picModel.schoolPicId];
    }];
    
    [selectedContactsIndexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [self.myCollcetionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self.selectedIndexSet addIndex:indexPath.item];
    }];
    
    [self updateToggleSelectionButton];
}

- (void)updateToggleSelectionButton {
    BOOL allEnabledContactsSelected = [self allEnabledContactsSelected];
    NSString *title = !allEnabledContactsSelected ? @"全选" : @"全不选";
    [self.toggleSelectionBtn setTitle:title forState:UIControlStateNormal];
}



- (NSIndexSet *)enabledContactsIndexSetForContancts:(NSArray *)contacts {
    NSIndexSet *enabledContactsIndexSet = nil;
    if ([self.disabledContactIds count]) {
        enabledContactsIndexSet = [contacts indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            XXESchoolAlbumModel* picModel = obj;
            return ![self.disabledContactIds containsObject:picModel.schoolPicId];
        }];
    } else {
        enabledContactsIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [contacts count])];
    }
    
    return enabledContactsIndexSet;
}

- (BOOL)allEnabledContactsSelected {
    NSIndexSet* enabledIndexSet = [self enabledContactsIndexSetForContancts:self.dataSourceArray];
    BOOL allEnabledContactsSelected = [self.selectedIndexSet containsIndexes:enabledIndexSet];
    return allEnabledContactsSelected;
}

- (NSArray *)selectedContacts {
    return [self.dataSourceArray objectsAtIndexes:self.selectedIndexSet];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  设置 navigationBar 上左右字体 颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    
    self.title = @"相   册";
    
    self.selectedIndexSet = [NSMutableIndexSet indexSet];
    // Do any additional setup after loading the view from its nib.
    [self.myCollcetionView registerNib:[UINib nibWithNibName:NSStringFromClass([XXESchoolAlbumCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XXESchoolAlbumCollectionViewCell class])];
    
    self.myCollcetionView.allowsMultipleSelection = YES;
    
}

- (void)settingNavgiationBar{

    //    NSString * name =[[NSUserDefaults standardUserDefaults] objectForKey:@"KEENTEAM"];
    //    //教师 91 只有教师不能改
    //    if ([name integerValue] == 91) {
    //        self.navigationItem.rightBarButtonItem = nil;
    //    }else{
    //设置 navigationBar 右边 赠送
    
    UIButton *upButton = [UIButton buttonWithType:UIButtonTypeCustom];
    upButton.frame = CGRectMake(300, 5, 22, 22);
    [upButton setImage:[UIImage imageNamed:@"class_album_upload"] forState:UIControlStateNormal];
    [upButton addTarget:self action:@selector(upButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:upButton];
    self.navigationItem.rightBarButtonItem =rightItem;
    
    //    }
}


- (void)createBottomView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 64 - 49, KScreenWidth, 49)];
    bottomView.backgroundColor = UIColorFromRGB(0, 170, 42);
    [self.view addSubview:bottomView];
    
    //左下  切换 按钮
    _toggleSelectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _toggleSelectionBtn.frame = CGRectMake(10, 15, 100, 20);
    [_toggleSelectionBtn setTitle:@"全选" forState:UIControlStateNormal];
    [_toggleSelectionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_toggleSelectionBtn addTarget:self action:@selector(toggleSelectionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_toggleSelectionBtn];
    
    
    //右下  编辑 按钮
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(KScreenWidth - 50, 15, 40, 20);
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitle:@"删除" forState:UIControlStateSelected];
    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:editButton];
}

- (void)toggleSelectionBtnClick{

    NSUInteger count = [self.dataSourceArray count];
    BOOL allEnabledContactsSelected = [self allEnabledContactsSelected];
    if (!allEnabledContactsSelected) {
        [self.myCollcetionView performBatchUpdates:^{
            for (NSUInteger index = 0; index < count; ++index) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
                
                if ([self collectionView:self.myCollcetionView shouldSelectItemAtIndexPath:indexPath]) {
                    [self.myCollcetionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                    [self.selectedIndexSet addIndex:indexPath.item];
                }
            }
        } completion:^(BOOL finished) {
            [self updateToggleSelectionButton];
        }];
    } else {
        [self.myCollcetionView performBatchUpdates:^{
            [self.selectedIndexSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL * _Nonnull stop) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
                
                if ([self collectionView:self.myCollcetionView shouldDeselectItemAtIndexPath:indexPath]) {
                    [self.myCollcetionView deselectItemAtIndexPath:indexPath animated:YES];
                    [self.selectedIndexSet removeIndex:indexPath.item];
                }
                
            }];
        } completion:^(BOOL finished) {
            [self updateToggleSelectionButton];
        }];
    }

}


- (void)editButtonClick{

    [self.delegate contactsPickerViewControllerDidFinish:self withSelectedContacts:[self selectedContacts]];
    
    [self deleteShoolPic];

}

- (void)deleteShoolPic{
//    NSLog(@"self.selectedIndexSet -- %@", self.selectedIndexSet);
//
//    NSLog(@"self.disabledContactIds == %@", self.disabledContactIds);
//    //selectedContactIds
//    NSLog(@"self.selectedContactIds == %@", self.selectedContactIds);
}


- (void)upButton:(UIButton *)upBtn{
    NSLog(@"上传图片");
    int i=1;
    XXESchoolUpPicViewController *schoolUpPicVC =[[XXESchoolUpPicViewController alloc]init];
    schoolUpPicVC.t =i;
    schoolUpPicVC.albumName =@"上传图片";
    schoolUpPicVC.vedioName =@"请为您发布的相册命名";
    
    schoolUpPicVC.schoolId = _schoolId;
    
    [self.navigationController pushViewController:schoolUpPicVC animated:YES];
}

//
- (void)fetchNetData{
//    if ([_flagStr isEqualToString:@"formSchoolInfo"]) {
//        //修改 学校 邮箱
//        [self modifySchoolEmail];
//    }else if ([_flagStr isEqualToString:@"fromMyselfInfo"]) {
//        //修改 个人 邮箱
//        [self modifyMyselfEmail];
//    }
    

    XXESchoolPicApi *schoolPicApi = [[XXESchoolPicApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE school_id:_schoolId];
    [schoolPicApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        _dataSourceArray = [[NSMutableArray alloc] init];
//        NSLog(@"2222---   %@", request.responseJSONObject);
        /*
         {
         "good_num" = 1;
         id = 2;
         url = "app_upload/text/school/z1.jpg";
         }
         */
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSArray *modelArray = [XXESchoolAlbumModel parseResondsData:request.responseJSONObject[@"data"]];
            
            [_dataSourceArray addObjectsFromArray:modelArray];
            
        }else{
            
        }
        
//        NSLog(@"%@", _dataSourceArray);
        
        [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}


//相册 有数据 和 无数据 进行判断
- (void)customContent{
        // 1、无数据的时候
        UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
    
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth / 2 - myImageWidth / 2, (KScreenHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];
    //2、有数据的时候
    
    [self createCollectionView];
    
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
    self.myCollcetionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 49) collectionViewLayout:layout];
    
    //    设置代理
    self.myCollcetionView.dataSource = self;
    self.myCollcetionView.delegate = self;
    
    [self.view addSubview:self.myCollcetionView];
    
    //    提前告诉_collectionView用什么视图作为显示的复用视图，并且设置复用标识
    //    一定要实现，否则会崩溃 有xib的时候 用nib,纯代码 用 class
    [self.myCollcetionView registerClass:[XXESchoolAlbumCollectionViewCell class] forCellWithReuseIdentifier:@"XXESchoolAlbumCollectionViewCell"];
    
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
    //    到复用池中找标识为AlbumCollectionViewCell 的空闲cell,如果有就使用，没有就创建
    XXESchoolAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    XXESchoolAlbumModel *model = _dataSourceArray[indexPath.item];
    
    cell.schoolPicName = [NSString stringWithFormat:@"%@%@",kXXEPicURL,model.url];
    cell.checkImageView.hidden = YES;
    return cell;
}

//设置距离四边的距离
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//选中某一个item时的方法
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"%ld",indexPath.item);
    //
    //    DetailViewController *detailVc = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    //
    //    //    属性传值
    //    detailVc.imageName = _dataArray[indexPath.item];
    //
    //    [self.navigationController pushViewController:detailVc animated:YES];
    
//    PhotoBrowseViewController *photoBrowseVC =[[PhotoBrowseViewController alloc]init];
//    photoBrowseVC.imageName =self.dataArray[indexPath.section];
//    photoBrowseVC.i =self.dataArray.count;
//    photoBrowseVC.index =indexPath.row;
//    photoBrowseVC.imageA =self.dataArray;
//    [self.navigationController pushViewController:photoBrowseVC animated:YES];
//}

#pragma mark PickerViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"111");
    XXESchoolAlbumCollectionViewCell *cell = (XXESchoolAlbumCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.checkImageView.hidden = NO;
    if ([self.disabledContactIds count]) {
    NSInteger item = indexPath.item;
    XXESchoolAlbumModel *picModel = _dataSourceArray[item];
    return ![self.disabledContactIds containsObject:picModel.schoolPicId];
    }
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"222");
    XXESchoolAlbumCollectionViewCell *cell = (XXESchoolAlbumCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.checkImageView.hidden = YES;
    if ([self.disabledContactIds count]) {

    NSInteger item = indexPath.item;
    XXESchoolAlbumModel *picModel = _dataSourceArray[item];
    return ![self.disabledContactIds containsObject:picModel.schoolPicId];
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.selectedIndexSet addIndex:indexPath.item];
    [self updateToggleSelectionButton];
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
