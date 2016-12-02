//
//  XXEReleaseDetailInfoViewController.m
//  teacher
//
//  Created by Mac on 16/9/14.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEReleaseDetailInfoViewController.h"

@interface XXEReleaseDetailInfoViewController ()
{
    UITextView *contentTextView;

}


@end

@implementation XXEReleaseDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XXEBackgroundColor;

    
    [self createContent];

}

- (void)createContent{

#pragma mark ======== //通知主题 bgView ========
    UIView *cellBgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    cellBgView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cellBgView1];
    
    //标题
    UILabel *titleLabel1 = [UILabel createLabelWithFrame:CGRectMake(10, 10, 70, 20) Font:14 Text:@"通知主题:"];
    [cellBgView1 addSubview:titleLabel1];
    
    //内容
    UILabel *contentLabel1 = [UILabel createLabelWithFrame:CGRectMake(titleLabel1.frame.origin.x + titleLabel1.width, titleLabel1.frame.origin.y, KScreenWidth - 100, 20) Font:14 Text:_subjectStr];
    
    CGFloat height = [StringHeight contentSizeOfString:_subjectStr maxWidth:contentLabel1.width fontSize:14];
    
    CGSize size1 = contentLabel1.size;
    size1.height = height;
    contentLabel1.size = size1;
    [cellBgView1 addSubview:contentLabel1];
    
    CGSize size11 = cellBgView1.size;
    size11.height = 10 + height + 10;
    cellBgView1.size = size11;
    
    
#pragma mark ============ 创建 下部  ===========
    //创建 下部
    contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, cellBgView1.frame.origin.y + cellBgView1.height + 5, KScreenWidth, KScreenHeight - cellBgView1.height - 100)];
    contentTextView.font = [UIFont systemFontOfSize:14];
    contentTextView.backgroundColor = [UIColor whiteColor];
    contentTextView.text = _contentStr;
    contentTextView.editable = NO;
    [self.view addSubview:contentTextView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
