
//
//  XXEXingClassRoomTeacherStyleViewController.m
//  teacher
//
//  Created by Mac on 16/10/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingClassRoomTeacherStyleViewController.h"
#import "XXEImageBrowsingViewController.h"
#define Kmarg 5.0f
#define KLabelH 25.0f

@interface XXEXingClassRoomTeacherStyleViewController ()
{
    
    //最下面 scrollView
    UIScrollView *_scrollV;
    
//    UIScrollView *scrollView;//老师详情图片滚动
    NSMutableArray *_picImageArr;
    
    //照片墙 的图片 可以排列几行
    NSInteger picRow;
    //照片墙 照片 宽
    CGFloat picWidth;
    //照片墙 照片 高
    CGFloat picHeight;
}

@end

@implementation XXEXingClassRoomTeacherStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XXEBackgroundColor;
    
    [self createContent];
    
}

- (void)createContent{
    
    _scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 250)];
    _scrollV.contentSize = CGSizeMake(KScreenWidth, KScreenHeight);
    _scrollV.userInteractionEnabled =YES;
    _scrollV.pagingEnabled = NO;
    _scrollV.showsHorizontalScrollIndicator = YES;
    _scrollV.showsVerticalScrollIndicator  = YES;
    _scrollV.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollV];
    //教学经历
    UIView *teachImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 150)];
    teachImage.backgroundColor = [UIColor whiteColor];
    [_scrollV addSubview:teachImage];
    
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(Kmarg + 3, Kmarg + 3, 20, 20)];
    headImage.image = [UIImage imageNamed:@"myself_experience_icon40x40"];
    [teachImage addSubview:headImage];
    
    
    UILabel *teachLbl = [UILabel createLabelWithFrame:CGRectMake(headImage.x + headImage.size.width + Kmarg, Kmarg, kWidth - 20, KLabelH) Font:16 Text:@"教学经历:"];
    teachLbl.textColor = [UIColor blackColor];
    [teachImage addSubview:teachLbl];
    
    
    UITextView *lifeTextView = [[UITextView alloc] initWithFrame:CGRectMake(headImage.x, teachLbl.y + teachLbl.size.height + Kmarg, kWidth - 20, 80)];
    lifeTextView.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    lifeTextView.editable = NO;
    lifeTextView.textColor = UIColorFromRGB(118, 118, 118);
    lifeTextView.text = _teach_feelStr;
    [_scrollV addSubview:lifeTextView];

    
    //老师感悟
    UIView *teachThinkImage = [[UIView alloc] initWithFrame:CGRectMake(0, teachImage.y + teachImage.size.height + Kmarg, kWidth, 120)];
    teachThinkImage.backgroundColor = [UIColor whiteColor];
    [_scrollV addSubview:teachThinkImage];
    
    UIImageView *headThinkImage = [[UIImageView alloc] initWithFrame:CGRectMake(Kmarg + 3, Kmarg + 3, 20, 20)];
    headThinkImage.image = [UIImage imageNamed:@"myself_feeling_icon40x40"];
    [teachThinkImage addSubview:headThinkImage];
    
    UILabel *teachThinkLbl = [UILabel createLabelWithFrame:CGRectMake(headThinkImage.x + headThinkImage.size.width +Kmarg, Kmarg, kWidth - 20, KLabelH) Font:16 Text:@"教学感悟:"];
    teachThinkLbl.textColor = [UIColor blackColor];
    [teachThinkImage addSubview:teachThinkLbl];
    
    UITextView *feelTextView = [[UITextView alloc] initWithFrame:CGRectMake(headThinkImage.x, teachThinkLbl.y +teachThinkLbl.size.height + Kmarg, kWidth - 20, 60)];
    feelTextView.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    feelTextView.editable = NO;
    feelTextView.textColor = UIColorFromRGB(118, 118, 118);
    feelTextView.text = _teach_feelStr;
    [_scrollV addSubview:feelTextView];
    
    //相册
    if (_teacher_pic_groupArray.count % 4 == 0) {
        picRow = _teacher_pic_groupArray.count / 4;
    }else{
        
        picRow = _teacher_pic_groupArray.count / 4 + 1;
    }
    //创建 十二宫格  三行、四列
    int margin = 10;
    picWidth = (KScreenWidth - 5 * margin) / 4;
    picHeight = picWidth;
    NSInteger picBgViewHeight;
    
    if (picRow * picHeight == 0) {
        picBgViewHeight = 180;
    }else{
        picBgViewHeight = 44 + picRow * (picHeight + margin * 2);
    }
    
    UIView *teachAlbumLbl = [[UIView alloc] initWithFrame:CGRectMake(0, teachThinkImage.y + teachThinkImage.size.height + Kmarg, kWidth, picBgViewHeight)];
    teachAlbumLbl.backgroundColor = [UIColor whiteColor];
    //    teachAlbumLbl.userInteractionEnabled = YES;
    [_scrollV addSubview:teachAlbumLbl];
    
    UIImageView *headAlbumLblImage = [[UIImageView alloc] initWithFrame:CGRectMake(Kmarg + 3, Kmarg + 3, 20, 20)];
    headAlbumLblImage.image = [UIImage imageNamed:@"home_redflower_picIcon"];
    [teachAlbumLbl addSubview:headAlbumLblImage];
    
    UILabel *teachAlbumLblL = [UILabel createLabelWithFrame:CGRectMake(headAlbumLblImage.x + headAlbumLblImage.size.width +Kmarg, Kmarg, kWidth - 20, KLabelH) Font:14 Text:@"老师相册"];
    teachAlbumLblL.textColor = [UIColor blackColor];
    [teachAlbumLbl  addSubview:teachAlbumLblL];
    
    for (int i = 0; i < _teacher_pic_groupArray.count; i++) {
        
        //行
        int buttonRow = i / 4;
        
        //列
        int buttonLine = i % 4;
        
        CGFloat buttonX = 10 + (picWidth + margin) * buttonLine;
        CGFloat buttonY = 40 + (picHeight + margin) * buttonRow;
        
        UIImageView *pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(buttonX, buttonY, picWidth, picHeight)];
        
        [pictureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, _teacher_pic_groupArray[i]]]];
        pictureImageView.tag = 20 + i;
        pictureImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickPicture:)];
        [pictureImageView addGestureRecognizer:tap];
        [teachAlbumLbl addSubview:pictureImageView];
    }
    
}



- (void)onClickPicture:(UITapGestureRecognizer *)tap{
    
    //    NSLog(@"--- 点击了第%ld张图片", tap.view.tag - 20);
    
    XXEImageBrowsingViewController * imageBrowsingVC = [[XXEImageBrowsingViewController alloc] init];
    
    imageBrowsingVC.imageUrlArray = _teacher_pic_groupArray;
    imageBrowsingVC.currentIndex = tap.view.tag - 20;
    //举报 来源 3:猩课堂发布的课程图片
    imageBrowsingVC.origin_pageStr = @"3";
    
    [self.navigationController pushViewController:imageBrowsingVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
