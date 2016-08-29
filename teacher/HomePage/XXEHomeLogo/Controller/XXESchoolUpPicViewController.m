

//
//  XXESchoolUpPicViewController.m
//  teacher
//
//  Created by Mac on 16/8/28.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolUpPicViewController.h"
#import "ZYQAssetPickerController.h"
#import "MBProgressHUD.h"
#import "WJCommboxView.h"
#import "YTKBatchRequest.h"
#import "XXESchoolUpPicApi.h"

@interface XXESchoolUpPicViewController ()<ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
{
    UIButton *btn;
    UIScrollView *src;
    UIPageControl *pageControl;
    
}
//上传图片 数组
@property (nonatomic) NSMutableArray *upPicArray;


@end

@implementation XXESchoolUpPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"上传照片";
    _upPicArray = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    // Do any additional setup after loading the view.
    [self createRightBar];
    [self createTextView];
    
    
    [self createUpBtn];
    
}
- (void)createUpBtn{
    
    btn=[[UIButton alloc] init];
    btn.frame=CGRectMake(KScreenWidth / 2 - 325 / 2, KScreenHeight-150, 325, 42);
    //
    [btn setBackgroundImage:[UIImage imageNamed:@"updata_icon"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)btnClick:(UIButton*)btn{

    [self showHudWithString:@"正在上传......"];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i =0; i < _upPicArray.count; i++) {
        XXESchoolUpPicApi *schoolUpPicApi = [[XXESchoolUpPicApi alloc] initWithXid:XID user_id:USER_ID user_type:USER_TYPE school_id:_schoolId position:@"4" upImage:_upPicArray[i]];
        [arr addObject:schoolUpPicApi];
    }
    
    
    YTKBatchRequest *bathRequest = [[YTKBatchRequest alloc]initWithRequestArray:arr];
    [bathRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
        //        NSLog(@"%@",bathRequest);
        
        [self hideHud];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(YTKBatchRequest *batchRequest) {
        [self showHudWithString:@"上传失败" forSecond:1.f];
    }];
    
}


- (void)createRightBar{
    UIBarButtonItem *rightBar =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"class_album_add_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBar)];
    self.navigationItem.rightBarButtonItem =rightBar;
    
    if (self.t) {
        src=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 160-100, self.view.frame.size.width, self.view.frame.size.height-104-140)];
    }
    else {
        src=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height-104-50)];
        
    }
    src.pagingEnabled=YES;
    
    src.backgroundColor=[UIColor lightGrayColor];
    src.delegate=self;
    [self.view addSubview:src];
    
    pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(src.frame.origin.x, src.frame.origin.y+src.frame.size.height-20, src.frame.size.width, 20)];
    [self.view addSubview:pageControl];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)rightBar{
    NSLog(@"");
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
    if (self.t) {
        
    }
    else{
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 66, KScreenWidth, 40)];
        
        backView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:backView];
        
        UIImageView *albumImageView = [[UIImageView alloc] init];
        albumImageView.frame = CGRectMake(10, 10, 22, 22);
        albumImageView.image = [UIImage imageNamed:@"相册名称40x40"];
        
        [backView addSubview:albumImageView];
        
        
    }
    
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [imgview setImage:tempImg];
                [_upPicArray addObject:tempImg];
                
//                NSLog(@"hahahah   %@", tempImg);
                [src addSubview:imgview];
            });
        }
    });
}

#pragma mark - UIScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    pageControl.currentPage=floor(scrollView.contentOffset.x/scrollView.frame.size.width);;
}

@end
