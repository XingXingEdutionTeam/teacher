

//
//  XXEStoreMyselfViewController.m
//  teacher
//
//  Created by Mac on 16/11/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStoreMyselfViewController.h"
#import "XXESotreGoodsCollectionViewController.h"
#import "XXEXingCoinHistoryViewController.h"
#import "XXEStoreConsigneeAddressViewController.h"
#import "XXEStoreGoodsListViewController.h"

@interface XXEStoreMyselfViewController ()
{

    NSMutableArray *titleArray;

}
@end

@implementation XXEStoreMyselfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XXEBackgroundColor;
    self.title= @"我的";
    
    titleArray = [NSMutableArray arrayWithObjects:@"我的收藏", @"猩币记录", @"收货地址", @"我的订单", nil];
    
    [self createButtons];

}

- (void)createButtons{

    CGFloat buttonW = 325 * kScreenRatioWidth;
    CGFloat buttonH = 42 * kScreenRatioHeight;
    CGFloat buttonX = (KScreenWidth - buttonW) / 2;
    
    
    
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton createButtonWithFrame:CGRectMake(buttonX, 50 * kScreenRatioHeight + 70 * i, buttonW, buttonH) backGruondImageName:@"login_green" Target:self Action:@selector(buttonClick:) Title:titleArray[i]];
        button.tag = 100 + i;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemWithIphone6P:18 Iphone6:16 Iphone5:14 Iphone4:10];
        [self.view addSubview:button];
    }


}


- (void)buttonClick:(UIButton *)button{

    if (button.tag == 100) {
      //我的收藏
        XXESotreGoodsCollectionViewController *goodsCollectionVC = [[XXESotreGoodsCollectionViewController alloc] init];
        [self.navigationController pushViewController:goodsCollectionVC animated:YES];
        
    }else if (button.tag == 101){
       //猩币记录
        XXEXingCoinHistoryViewController *xingCoinHistoryVC = [[XXEXingCoinHistoryViewController alloc] init];
        
        [self.navigationController pushViewController:xingCoinHistoryVC animated:YES];
        
    }else if (button.tag == 102){
        //收货地址
        XXEStoreConsigneeAddressViewController *storeConsigneeAddressVC = [[XXEStoreConsigneeAddressViewController alloc] init];
        
        
        [self.navigationController pushViewController:storeConsigneeAddressVC animated:YES];
    }else if (button.tag == 103){
        //商城订单
        XXEStoreGoodsListViewController *storeGoodsListVC = [[XXEStoreGoodsListViewController alloc] init];
        
        [self.navigationController pushViewController:storeGoodsListVC animated:YES];
    }

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
