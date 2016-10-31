

//
//  XXECourseManagerViewController1.m
//  teacher
//
//  Created by Mac on 16/9/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECourseManagerViewController1.h"
#import "XXECourseManagerViewController.h"
#import "XXECourseManagerCourseToAuditViewController.h"
#import "XXECourseManagerCourseRefuseViewController.h"
#import "XXECourseManagerCourseReleaseViewController.h"

@interface XXECourseManagerViewController1 ()<UIScrollViewDelegate>
{
    UISegmentedControl *_segmentedControl;
    UIScrollView *_contentScrollView;
    NSMutableDictionary  *_listVCQueue;
}


@end

@implementation XXECourseManagerViewController1


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"管理";

    [self createSegmentedControl];
    [self createScrollView];
    
    [self createReleaseButton];
    
}

- (void)createSegmentedControl{
//    NSArray *titleArray = [[NSArray alloc] initWithObjects:@"已上线", @"草稿箱", @"待校长审核", @"待平台审核", @"校长驳回", @"平台驳回", nil];
    NSArray *titleArray = [[NSArray alloc] initWithObjects:@"已上线", @"草稿箱", @"待审核", @"驳回", nil];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:titleArray];
    _segmentedControl.frame = CGRectMake(5, 10, KScreenWidth - 10, 35);
    _segmentedControl.tintColor = UIColorFromRGB(0, 170, 42);
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.backgroundColor = [UIColor whiteColor];

    [_segmentedControl addTarget:self action:@selector(didClickSegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];
    
}

- (void)createScrollView{
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,_segmentedControl.y + _segmentedControl.size.height + 10 , KScreenWidth, KScreenHeight - _segmentedControl.size.height - _segmentedControl.frame.origin.y - 49 - 64 - 50)];
    _contentScrollView.contentSize = (CGSize){KScreenWidth * 1,_contentScrollView.contentSize.height};
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.delegate      = self;
    _contentScrollView.scrollsToTop  = NO;
//    _contentScrollView.backgroundColor = [UIColor redColor];
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentScrollView];
}


- (void)didClickSegmentedControlAction:(UISegmentedControl *)seg{
    if (!_listVCQueue) {
        _listVCQueue=[[NSMutableDictionary alloc] init];
    }
    
    NSInteger index = seg.selectedSegmentIndex;
    switch (index) {
        case 0:
        {
            //0:待完善(草稿)  1:等待校长审核   2:等待官方审核  3:已上线(官方审核通过)  4:校长驳回  5:官方驳回     
            //0 已上线
            [self onlineViewController];
        break;
        }
        case 1:
        {
            //0:待完善(草稿)  1:等待校长审核   2:等待官方审核  3:已上线(官方审核通过)  4:校长驳回  5:官方驳回
            //1 草稿箱
            [self draftBoxViewController];
            
            break;
        }
        case 2:
        {
            //0:待完善(草稿)  1:等待校长审核   2:等待官方审核  3:已上线(官方审核通过)  4:校长驳回  5:官方驳回
            //1 待审核
            [self toAuditViewController];

            
            break;
        }
        case 3:
        {
            //0:待完善(草稿)  1:等待校长审核   2:等待官方审核  3:已上线(官方审核通过)  4:校长驳回  5:官方驳回
            //2 驳回
            [self refuseViewController];
            
            break;
        }


        default:
            break;
    }

}

//0 上线
- (void)onlineViewController{

    XXECourseManagerViewController * vc0 = [[XXECourseManagerViewController alloc]init];
    vc0.schoolId = _schoolId;
    vc0.condit = @"3";
    vc0.position = _position;
//    vc0.view.left = 0*screenWidth;
//    vc0.view.top  = 0;
    [self addChildViewController:vc0];

    [_contentScrollView addSubview:vc0.view];
    [_listVCQueue setObject:vc0 forKey:@(0)];
}

//1 草稿箱
- (void)draftBoxViewController{
    XXECourseManagerViewController * vc1 = [[XXECourseManagerViewController alloc]init];
    vc1.schoolId = _schoolId;
    vc1.condit = @"0";
    vc1.position = _position;
//    vc1.view.left = 1*screenWidth;
//    vc1.view.top  = 0;
    [self addChildViewController:vc1];

    [_contentScrollView addSubview:vc1.view];
    [_listVCQueue setObject:vc1 forKey:@(1)];
}


//2 待审核
- (void)toAuditViewController{
    XXECourseManagerCourseToAuditViewController * vc2 = [[XXECourseManagerCourseToAuditViewController alloc]init];
    vc2.schoolId = _schoolId;
    vc2.position = _position;
//    vc2.view.left = 2*screenWidth;
//    vc2.view.top  = 0;
    [self addChildViewController:vc2];

    [_contentScrollView addSubview:vc2.view];
    [_listVCQueue setObject:vc2 forKey:@(2)];

}

//3 驳回
- (void)refuseViewController{
    XXECourseManagerCourseRefuseViewController * vc3 = [[XXECourseManagerCourseRefuseViewController alloc]init];
    vc3.schoolId = _schoolId;
    vc3.position = _position;
//    vc3.view.left = 3*screenWidth;
//    vc3.view.top  = 0;
    [self addChildViewController:vc3];
    [_contentScrollView addSubview:vc3.view];
    [_listVCQueue setObject:vc3 forKey:@(3)];
}

//发布
- (void)createReleaseButton{
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    releaseButton.frame = CGRectMake(0, _contentScrollView.frame.origin.y + _contentScrollView.frame.size.height, KScreenWidth, KScreenHeight - (_contentScrollView.frame.origin.y + _contentScrollView.frame.size.height) - 64 - 50 * kScreenRatioHeight);
    releaseButton.backgroundColor = UIColorFromRGB(0, 170, 42);
    [releaseButton setTitle:@"发布课程" forState:UIControlStateNormal];
    [releaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:16 * kScreenRatioWidth];
    [releaseButton addTarget:self action:@selector(releaseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:releaseButton];
    
}

- (void)releaseButtonClick{

//    NSLog(@"发布课程");
    XXECourseManagerCourseReleaseViewController *courseManagerCourseReleaseVC = [[XXECourseManagerCourseReleaseViewController alloc] init];
    
    courseManagerCourseReleaseVC.schoolId = _schoolId;
    courseManagerCourseReleaseVC.schoolType = _schoolType;
    courseManagerCourseReleaseVC.classId = _classId;
    courseManagerCourseReleaseVC.position = _position;
    
    
    [self.navigationController pushViewController:courseManagerCourseReleaseVC animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
