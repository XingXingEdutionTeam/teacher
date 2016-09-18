

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
#import "XXEDeleteSchoolPicApi.h"


@interface XXESchoolAlbumViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSString *parameterXid;
    NSString *parameterUser_Id;
    //右下  编辑 按钮
    UIButton *editButton;
    //要删除 图片 的id
    NSString *pic_id_str;
}
//    数据源数组
@property (nonatomic) NSMutableArray *dataSourceArray;

@property (nonatomic, strong) UICollectionView *myCollcetionView;

//选中 item 的model
@property (nonatomic, strong) NSMutableArray *seletedModelArray;


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
 
    //右下  编辑 按钮
    editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(KScreenWidth - 50, 15, 40, 20);
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];

    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:editButton];
}



- (void)editButtonClick{
    
    if (_seletedModelArray.count == 0) {
        [self showHudWithString:@"请选择要删除的图片!" forSecond:1.5];
    }else{
        [self deleteShoolPic];

    }
    
}

- (void)deleteShoolPic{
//XXEDeleteSchoolPicApi
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
        }else{
            [self showHudWithString:@"删除失败!" forSecond:1.5];
        }

    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
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
    
    if ([_flagStr isEqualToString:@"formSchoolInfo"]) {
        //修改 学校 相册
        [self modifySchoolPic];
    }else if ([_flagStr isEqualToString:@"fromMyselfInfo"]) {
        //修改 个人 相册
        [self modifyMyselfPic];
    }
}

- (void)modifySchoolPic{

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

- (void)modifyMyselfPic{


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
    [cell.schoolImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kXXEPicURL,model.url]] placeholderImage:[UIImage imageNamed:@""]];

    return cell;
}

//设置距离四边的距离
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark PickerViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

//    NSLog(@" 选中 之前 -- %@", _seletedModelArray);
    XXESchoolAlbumModel *picModel = _dataSourceArray[indexPath.item];
    [_seletedModelArray addObject:picModel];
//    NSLog(@" 选中 之后 -- %@", _seletedModelArray);
    [self updateButtonTitle];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {

//    NSLog(@" 取消 之前 -- %@", _seletedModelArray);
    XXESchoolAlbumModel *picModel = _dataSourceArray[indexPath.item];
    [_seletedModelArray removeObject:picModel];
//    NSLog(@" 取消 之后 -- %@", _seletedModelArray);
    [self updateButtonTitle];
}

- (void)updateButtonTitle{
    if (_seletedModelArray.count == 0) {
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    }else if (_seletedModelArray.count != 0) {
        [editButton setTitle:@"删除" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
