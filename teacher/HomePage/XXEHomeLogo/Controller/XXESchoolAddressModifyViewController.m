


//
//  XXESchoolAddressModifyViewController.m
//  teacher
//
//  Created by Mac on 16/8/25.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolAddressModifyViewController.h"

@interface XXESchoolAddressModifyViewController (){

    //省
    NSMutableArray *provinceArr;
    //省 ID
    NSMutableArray *provinceIDArray;
    NSString *provinceStr;
    
    //市
    NSMutableArray *cityArr;
    //市 ID
    NSMutableArray *cityIDArray;
    NSString *cityStr;
    
    //区
    NSMutableArray *areaArr;
    //区 ID
    NSMutableArray *areaIDArray;
    NSString *areaStr;
}

@property(nonatomic,strong)WJCommboxView *provinceCombox;
@property(nonatomic,strong)WJCommboxView *cityCombox;
@property(nonatomic,strong)WJCommboxView *areaCombox;
@property(nonatomic,strong)UIView *provinceView;
@property(nonatomic,strong)UIView *cityView;
@property(nonatomic,strong)UIView *areaView;


@end

@implementation XXESchoolAddressModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)submitButton:(UIButton *)sender {
    
    
}
@end
