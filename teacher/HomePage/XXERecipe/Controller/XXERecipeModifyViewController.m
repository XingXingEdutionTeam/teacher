

//
//  XXERecipeModifyViewController.m
//  teacher
//
//  Created by Mac on 16/8/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERecipeModifyViewController.h"
#import "FSImagePickerView.h"



@interface XXERecipeModifyViewController ()
{
    //图标
    NSString *iconStr;
    //meal_type	//餐类型,传数字(1:早餐  2:午餐  3:晚餐)
    NSString *meal_type;
    //添加 照片
    FSImagePickerView *pickerView;
    
}


@end

@implementation XXERecipeModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createContent];
}

- (void)createContent{

    _timeLabel.text = _dateStr;
    
    if (_titleStr != nil) {
        _mealNameLabel.text = _titleStr;
        
        if ([_titleStr isEqualToString:@"早餐"]) {
            
            iconStr = @"home_recipe_breakfast_icon38x34";
            meal_type = @"1";
            
        }else if ([_titleStr isEqualToString:@"午餐"]) {
            
            iconStr = @"home_recipe_lunch_icon38x34";
            meal_type = @"2";
            
        }else if ([_titleStr isEqualToString:@"晚餐"]) {
            
            iconStr = @"home_recipe_dinner_icon38x34";
            meal_type = @"3";
        }
    }
    
    _mealIconImageView.image = [UIImage imageNamed:iconStr];
    
    //选择图片
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    pickerView = [[FSImagePickerView alloc] initWithFrame:CGRectMake(10, 10, kWidth - 10 * 2, 80) collectionViewLayout:layout1];
    pickerView.backgroundColor = UIColorFromRGB(255, 255, 255);
    pickerView.showsHorizontalScrollIndicator = NO;
    pickerView.controller = self;
    
    [self.upPicImageView addSubview:pickerView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}



- (IBAction)certainButton:(UIButton *)sender {
    
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
