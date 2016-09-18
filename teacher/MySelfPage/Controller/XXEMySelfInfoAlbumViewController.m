
//
//  XXEMySelfInfoAlbumViewController.m
//  teacher
//
//  Created by Mac on 16/9/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMySelfInfoAlbumViewController.h"
#import "XXESchoolAlbumCollectionViewCell.h"
#import "XXESchoolUpPicViewController.h"
#import "XXEMySelfInfoAlbumModel.h"
#import "XXEImageBrowsingViewController.h"

#import "XXEMyselfInfoAlbumDeletePicApi.h"
#import "XXEMyselfInfoAlbumPicApi.h"


@interface XXEMySelfInfoAlbumViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
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
    //图片 url 数组
    NSMutableArray *picWallArray;
    
}
//    数据源数组
@property (nonatomic) NSMutableArray *dataSourceArray;

@property (nonatomic, strong) UICollectionView *myCollcetionView;

//选中 item 的model
@property (nonatomic, strong) NSMutableArray *seletedModelArray;


@end

@implementation XXEMySelfInfoAlbumViewController

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
    
    self.myCollcetionView.allowsMultipleSelection = YES;
    
}

- (void)settingNavgiationBar{
    //    设置 navigationBar 右边 编辑
    editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(330, 5, 40, 22);
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonCick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    self.navigationItem.rightBarButtonItem =rightItem;
    
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
    
    if (_dataSourceArray.count != 0) {
        if (_seletedModelArray.count != 0) {
            [_seletedModelArray removeAllObjects];
        }
        
        for (int i = 0; i < _dataSourceArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            
            [self collectionView:_myCollcetionView didSelectItemAtIndexPath:indexPath];
            
            XXESchoolAlbumCollectionViewCell *cell = (XXESchoolAlbumCollectionViewCell *)[_myCollcetionView cellForItemAtIndexPath:indexPath];
            if (editButton.selected == NO) {
                cell.checkImageView.hidden = YES;
            }else{
                cell.checkImageView.hidden = NO;
            }
        }
        
    }
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

- (void)deleteShoolPic{
    if (_seletedModelArray.count == 1) {
        XXEMySelfInfoAlbumModel *picModel = _seletedModelArray[0];
        pic_id_str = picModel.myselfPicId;
        
    }else if (_seletedModelArray.count > 1){
        
        NSMutableString *tidStr = [NSMutableString string];
        
        for (int j = 0; j < _seletedModelArray.count; j ++) {
            
            XXEMySelfInfoAlbumModel *picModel = _seletedModelArray[j];
            
            NSString *str = picModel.myselfPicId;
            
            if (j != _seletedModelArray.count - 1) {
                [tidStr appendFormat:@"%@,", str];
            }else{
                [tidStr appendFormat:@"%@", str];
            }
        }
        pic_id_str = tidStr;
    }
    
        NSLog(@"bbb %@", pic_id_str);
    
    XXEMyselfInfoAlbumDeletePicApi *myselfInfoAlbumDeletePicApi = [[XXEMyselfInfoAlbumDeletePicApi alloc] initWithXid:parameterXid user_id:parameterUser_Id pic_id:pic_id_str];
    [myselfInfoAlbumDeletePicApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                        NSLog(@"2222---   %@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"删除成功!" forSecond:1.5];
            
            [_dataSourceArray removeObjectsInArray:_seletedModelArray];
            
            [_myCollcetionView reloadData];
            editButton.selected = NO;
            [self updateButtonTitle];
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
//    int i=1;
//    XXESchoolUpPicViewController *schoolUpPicVC =[[XXESchoolUpPicViewController alloc]init];
//    schoolUpPicVC.t =i;
//    
////    schoolUpPicVC.schoolId = _schoolId;
//    
//    [self.navigationController pushViewController:schoolUpPicVC animated:YES];
}

//
- (void)fetchNetData{
    
    XXEMyselfInfoAlbumPicApi *myselfInfoAlbumPicApi = [[XXEMyselfInfoAlbumPicApi alloc] initWithXid:parameterXid user_id:parameterUser_Id];
    [myselfInfoAlbumPicApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        _dataSourceArray = [[NSMutableArray alloc] init];
        picWallArray = [[NSMutableArray alloc] init];
        //        NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSArray *modelArray = [XXEMySelfInfoAlbumModel parseResondsData:request.responseJSONObject[@"data"]];
            
            [_dataSourceArray addObjectsFromArray:modelArray];
            
            for (int i = 0; i < _dataSourceArray.count; i++) {
                XXEMySelfInfoAlbumModel *model = _dataSourceArray[i];
                [picWallArray addObject:model.pic];
            }
            
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
    if (editButton.selected == NO) {
        cell.checkImageView.hidden = YES;
    }
    return cell;
}

//设置距离四边的距离
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark PickerViewDelegate
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (editButton.selected == YES) {
//        XXESchoolAlbumModel *picModel = _dataSourceArray[indexPath.item];
//        [_seletedModelArray addObject:picModel];
//        [self updateButtonTitle];
//    }
//    return YES;
//}

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if ([self.disabledContactIds count]) {
//        NSInteger item = indexPath.item;
//        User *contact = _contacts[item];
//        return ![self.disabledContactIds containsObject:contact.userId];
//    }
//    return YES;
//}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (editButton.selected == YES) {
        XXEMySelfInfoAlbumModel *picModel = _dataSourceArray[indexPath.item];
        [_seletedModelArray addObject:picModel];
        [self updateButtonTitle];
    }else{
        XXEImageBrowsingViewController * imageBrowsingVC = [[XXEImageBrowsingViewController alloc] init];
        
        imageBrowsingVC.imageUrlArray = picWallArray;
        imageBrowsingVC.currentIndex = indexPath.item;
        //举报 来源 6:老师点评
//        imageBrowsingVC.origin_pageStr = @"6";
        
        [self.navigationController pushViewController:imageBrowsingVC animated:YES];
//        XXEAlbumShowViewController *showVC = [[XXEAlbumShowViewController alloc]init];
//        showVC.showDatasource = _dataSourceArray;
//        //        showVC.showAlbumXid = self.albumTeacherXID;
//        showVC.flagStr = @"fromSchoolAlbum";
//        showVC.currentIndex = indexPath.item;
//        [self.navigationController pushViewController:showVC animated:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XXEMySelfInfoAlbumModel *picModel = _dataSourceArray[indexPath.item];
    [_seletedModelArray removeObject:picModel];
    [self updateButtonTitle];
}

- (void)updateButtonTitle{
    
    if (editButton.selected == NO) {
        
        [editButton setTitle:@"编辑" forState:UIControlStateNormal];
        _myCollcetionView.allowsMultipleSelection = NO;
    }else if (editButton.selected == YES){
        [editButton setTitle:@"删除" forState:UIControlStateNormal];
        _myCollcetionView.allowsMultipleSelection = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
