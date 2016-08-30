

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
        self.navigationItem.rightBarButtonItem = rightItem;
        
//    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  设置 navigationBar 上左右字体 颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    
    self.title = @"相   册";
    
    //设置内容
    [self customContent];
    
    
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
        
        NSLog(@"%@", _dataSourceArray);
        
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
    
    //    UICollectionViewLayout 是苹果提供一个布局类，他是一个抽象类。
    //    苹果给我们提供了UICollectionViewFlowLayout，网格布局类
    //    当创建一个UICollectionView对象的时候，需要一个布局类的对象来布局
    
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
    //    一定要实现，否则会崩溃
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
    
    cell.imageName = [NSString stringWithFormat:@"%@%@",kXXEPicURL,model.url];
    
    return cell;
}

//设置距离四边的距离
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//选中某一个item时的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
