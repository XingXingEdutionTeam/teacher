//
//  XXEUpdataImageViewController.m
//  teacher
//
//  Created by codeDing on 16/8/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEUpdataImageViewController.h"
#import "WJCommboxView.h"
#import "XXEMySelfAlbumModel.h"
#import "ZYQAssetPickerController.h"
#import "XXEMyselfAblumUpDataApi.h"
#import "YTKBatchRequest.h"
@interface XXEUpdataImageViewController ()<UIScrollViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate>
    {
        UIButton *updataButton;
        UIScrollView *src;
        UIPageControl *pageControl;
        
    }

@property (nonatomic, strong) WJCommboxView *albumCommbox;
@property (nonatomic, strong) UIView *albumCommboxBackView;
/** 相册名称 */
@property (nonatomic, strong)NSMutableArray *albumNameDatasource;
/** 上传图片时的相册ID */
@property (nonatomic, strong)NSString *albumID;
/** 上传多张相片数组源 */
@property (nonatomic, strong)NSMutableArray *photoDatasource;

@end

@implementation XXEUpdataImageViewController

-(NSMutableArray *)albumNameDatasource
{
    if (!_albumNameDatasource) {
        _albumNameDatasource = [NSMutableArray array];
    }
    return _albumNameDatasource;
}

- (NSMutableArray *)photoDatasource
{
    if (!_photoDatasource) {
        _photoDatasource = [NSMutableArray array];
    }
    return _photoDatasource;
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
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"上传照片";
    NSLog(@"数据都有什么:%@",self.datasource);
    for (XXEMySelfAlbumModel *model in self.datasource) {
        NSLog(@"属性都有什么%@",model.album_name);
        [self.albumNameDatasource addObject:model.album_name];
    }
    
    [self createRightBar];
    [self createTextView];
    [self createPictureCommBox];
    [self createUpBtn];
}

- (void)createUpBtn{
    __weak typeof(self)weakSelf = self;
    updataButton=[[UIButton alloc] init];
    [updataButton setBackgroundImage:[UIImage imageNamed:@"updata_icon"] forState:UIControlStateNormal];
    [updataButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:updataButton];
    [updataButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(20*kScreenRatioWidth);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-20*kScreenRatioHeight);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20*kScreenRatioWidth);
         make.height.mas_equalTo(40 * kScreenRatioHeight);
    }];
    
    [updataButton addTarget:self action:@selector(updataButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 上传按钮
- (void)updataButtonClick:(UIButton*)btn{

    [self showHudWithString:@"正在上传"];
    NSLog(@"%@",self.photoDatasource);
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i =0; i < self.photoDatasource.count; i++) {
        XXEMyselfAblumUpDataApi *updataApi = [[XXEMyselfAblumUpDataApi alloc]initWithAblumSchoolId:self.myAlbumUpSchoolId ClassId:self.myAlbumUpClassId AblumId:self.albumID ImageArray:self.photoDatasource[i]];
        [arr addObject:updataApi];
    }
    
    NSLog(@"相册  -- %@", arr);
    YTKBatchRequest *bathRequest = [[YTKBatchRequest alloc]initWithRequestArray:arr];
    [bathRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
        NSLog(@"----%@",bathRequest);
        NSArray *array = bathRequest.requestArray;
        XXEMyselfAblumUpDataApi *api1 = (XXEMyselfAblumUpDataApi *)array[0];
        NSLog(@"信息%@",api1.responseJSONObject);
        XXEMyselfAblumUpDataApi *api2 = (XXEMyselfAblumUpDataApi *)array[1];
        NSLog(@"信息%@",api2.responseJSONObject);
        XXEMyselfAblumUpDataApi *api3 = (XXEMyselfAblumUpDataApi *)array[2];
        NSLog(@"信息%@",api3.responseJSONObject);

        [self hideHud];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(YTKBatchRequest *batchRequest) {
        [self showHudWithString:@"上传失败" forSecond:1.f];
    }];
}


- (void)createRightBar{
    UIBarButtonItem *rightBar =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"class_album_add_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBar)];
    self.navigationItem.rightBarButtonItem =rightBar;
    
    src=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-104-50)];
    
    src.pagingEnabled=YES;
    src.backgroundColor=[UIColor lightGrayColor];
    src.delegate=self;
    [self.view addSubview:src];
    
    pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(src.frame.origin.x, src.frame.origin.y+src.frame.size.height-20, src.frame.size.width, 20)];
    [self.view addSubview:pageControl];
}

//班级选择
- (void)createPictureCommBox{
    
    self.albumCommbox = [[WJCommboxView alloc]initWithFrame:CGRectMake(50 , 10, kWidth-70, 30)];
    self.albumCommbox.textField.placeholder = @"请选择相册";
    self.albumCommbox.textField.textAlignment = NSTextAlignmentLeft;
    self.albumCommbox.textField.tag = 101;

    self.albumCommbox.dataArray = self.albumNameDatasource;
    [self.view addSubview:self.albumCommbox];
    
    self.albumCommboxBackView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight+300)];
    self.albumCommboxBackView.backgroundColor = [UIColor clearColor];
    self.albumCommboxBackView.alpha = 0.5;
    UITapGestureRecognizer *bingleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(albumsHidden)];
    [self.albumCommboxBackView addGestureRecognizer:bingleTouch];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(classAction:) name:@"commboxNotice"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(classAction2:) name:@"commboxNotice2"object:nil];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)albumsHidden{
    [self.albumCommboxBackView removeFromSuperview];
    
    [self.albumCommbox setShowList:NO];
    self.albumCommbox.listTableView.hidden = YES;
    
    CGRect sf = self.albumCommbox.frame;
    sf.size.height = 30;
    self.albumCommbox.frame = sf;
    CGRect frame = self.albumCommbox.listTableView.frame;
    frame.size.height = 0;
    self.albumCommbox.listTableView.frame = frame;
    
    [self.albumCommbox removeFromSuperview];
    [self.view addSubview:self.albumCommbox];
}

- (void)classAction:(NSNotification *)notif{
    switch ([notif.object integerValue]) {
        case 101:
            [self.albumCommbox removeFromSuperview];
            [self.view addSubview:self.albumCommboxBackView];
            [self.view addSubview:self.albumCommbox];
            break;
        default:
            break;
    }
}

- (void)classAction2:(NSNotification *)notif{
    NSLog(@"%@",self.albumCommbox.textField.text);
    NSString *string = self.albumCommbox.textField.text;
    
    for (XXEMySelfAlbumModel *model in self.datasource) {
        NSLog(@"属性都有什么%@",model.album_name);
        if ([string isEqualToString:model.album_name]) {
            _albumID = [NSString stringWithFormat:@"%@",model.album_id];
            NSLog(@"%@",_albumID);
        }
        
    }
    
    [self.albumCommboxBackView removeFromSuperview];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)rightBar{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 10;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}
- (void)createTextView{
    
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        
        backView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:backView];

        UIImageView *albumImageView = [[UIImageView alloc] init];
        albumImageView.frame = CGRectMake(10, 10, 22, 22);
        albumImageView.image = [UIImage imageNamed:@"class_album_icon"];
        
        [backView addSubview:albumImageView];
    
}
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    [src.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        src.contentSize=CGSizeMake(assets.count*src.frame.size.width, src.frame.size.height);
        dispatch_async(dispatch_get_main_queue(), ^{
            pageControl.numberOfPages=assets.count;
        });
        
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(i*src.frame.size.width, 0, src.frame.size.width, src.frame.size.height)];
            src.contentSize = CGSizeMake(kWidth*assets.count, 0);
            imgview.contentMode=UIViewContentModeScaleAspectFill;
            imgview.clipsToBounds=YES;
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            NSLog(@"======选择的图片:%@",tempImg);
            [self.photoDatasource addObject:tempImg];
            dispatch_async(dispatch_get_main_queue(), ^{
                [imgview setImage:tempImg];
                [src addSubview:imgview];
            });
        }
    });
}

#pragma mark - UIScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    pageControl.currentPage=floor(scrollView.contentOffset.x/scrollView.frame.size.width);;
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
