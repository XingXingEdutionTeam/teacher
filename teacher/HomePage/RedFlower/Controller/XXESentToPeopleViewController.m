

//
//  XXESentToPeopleViewController.m
//  teacher
//
//  Created by Mac on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESentToPeopleViewController.h"
#import "XXEChiefAndTeacherViewController.h"
#import "XXEManagerAndHeadmasterViewController.h"
#import "DynamicScrollView.h"
#import "FSImagePickerView.h"
#import "XXESubmitSeletedBabyInfoApi.h"


@interface XXESentToPeopleViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextViewDelegate>
{
    DynamicScrollView *dynamicScrollView;
    NSMutableArray *didSelectBabyNameArray;//选中宝贝 名称  数组
    NSMutableArray *didSelectBabyIdArray;//选中宝贝 id  数组
    NSMutableArray *didSelectSchoolIdArray;//选中宝贝 学校 id  数组
    NSMutableArray *didSelectClassIdArray;//选中宝贝 班级 id  数组
    
    NSString *babyIdStr; //选中 的 宝贝 id
    
    NSMutableArray *submitBabyInfoArray; //选中 宝贝 提交 宝贝信息(baby id ,school id, class id)
    NSString *jsonString;
    
    NSString *conStr;

}

@property (nonatomic, strong) NSMutableArray *selectedBabyInfoArray;

@end

@implementation XXESentToPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    didSelectBabyNameArray = [[NSMutableArray alloc] init];
    didSelectBabyIdArray = [[NSMutableArray alloc] init];
    didSelectSchoolIdArray = [[NSMutableArray alloc] init];
    didSelectClassIdArray = [[NSMutableArray alloc] init];
    
    submitBabyInfoArray = [[NSMutableArray alloc] init];
    
    [self createContent];
    

}

- (void)createContent{
    
    //选中 宝贝 头像 / 名称
    //选取控件
    dynamicScrollView = [[DynamicScrollView alloc] initWithFrame:CGRectMake(80 * kScreenRatioWidth,10 * kScreenRatioHeight,WinWidth-80,70 * kScreenRatioHeight) withImages:nil];
    [self.view addSubview:dynamicScrollView];
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(removeSuccess:) name:@"TeacherNameRemoveSuccess" object:nil];
    
    //选择图片
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    FSImagePickerView *picker1 = [[FSImagePickerView alloc] initWithFrame:CGRectMake(10, 30, kWidth - 10 * 2, 80) collectionViewLayout:layout1];
    picker1.backgroundColor = UIColorFromRGB(255, 255, 255);
    picker1.showsHorizontalScrollIndicator = NO;
    picker1.controller = self;
    
    [self.upPicImageView addSubview:picker1];
    
    _contentTextField.delegate = self;

}


- (void)removeSuccess:(NSNotification *)notification
{
    NSString *indexStr=[[notification userInfo] valueForKey:@"index"];
    NSInteger index=[indexStr integerValue];
    [didSelectBabyNameArray removeObjectAtIndex:index];
    NSMutableString *labelStr=[NSMutableString string];
    for (NSString * str in didSelectBabyNameArray ) {
        [labelStr appendString:str];
        [labelStr appendString:@"  "];
    }
        self.nameLabel.text=labelStr;
    
    //宝贝 id
    [didSelectBabyIdArray removeObjectAtIndex:index];
    
        NSMutableString *tidStr = [NSMutableString string];
    
        for (int j = 0; j < didSelectBabyIdArray.count; j ++) {
            NSString *str = didSelectBabyIdArray[j];
    
            if (j != didSelectBabyIdArray.count - 1) {
                [tidStr appendFormat:@"%@,", str];
            }else{
                [tidStr appendFormat:@"%@", str];
            }
        }
        
        babyIdStr = tidStr;
    
}



- (IBAction)addButtonClick:(UIButton *)sender {
//    //如果是 主任 或者 老师身份
//    XXEChiefAndTeacherViewController *chiefAndTeacherVC = [[XXEChiefAndTeacherViewController alloc] init];
//    
//    chiefAndTeacherVC.schoolId = _schoolId;
//    chiefAndTeacherVC.classId = _classId;
//    
//    [self.navigationController pushViewController:chiefAndTeacherVC animated:YES];
    
    //如果是管理员 或者 校长身份
    
    XXEManagerAndHeadmasterViewController *managerAndHeadmasterVC = [[XXEManagerAndHeadmasterViewController alloc] init];
    managerAndHeadmasterVC.schoolId = _schoolId;
    
    //返回 数组 头像、名称、id、课程
    [managerAndHeadmasterVC returnArray:^(NSMutableArray *selectedBabyInfoArray) {
        _selectedBabyInfoArray = [NSMutableArray arrayWithArray:selectedBabyInfoArray];
        
//        NSLog(@"剩余  花朵  %@", _basketNumStr);
        
        if (dynamicScrollView.imageViews.count < [_basketNumStr integerValue]) {
            //宝贝 头像
            [dynamicScrollView addImageView:[NSString stringWithFormat:@"%@%@",kXXEPicURL, selectedBabyInfoArray[0] ]];
            
            //宝贝 名字
            [didSelectBabyNameArray addObject:selectedBabyInfoArray[1]];
            NSMutableString *labelStr=[NSMutableString string];
            for (NSString * str in didSelectBabyNameArray ) {
                [labelStr appendString:str];
                [labelStr appendString:@"  "];
            }
            self.nameLabel.text=labelStr;
            
            //宝贝 id
            [didSelectBabyIdArray addObject:selectedBabyInfoArray[2]];
            NSMutableString *tidStr = [NSMutableString string];
            
            for (int j = 0; j < didSelectBabyIdArray.count; j ++) {
                NSString *str = didSelectBabyIdArray[j];
                
                if (j != didSelectBabyIdArray.count - 1) {
                    [tidStr appendFormat:@"%@,", str];
                }else{
                    [tidStr appendFormat:@"%@", str];
                }
            }
            
            babyIdStr = tidStr;
            
            //每一维数组含baby_id,school_id,class_id (请使用孩子列表获得的数据)
            NSDictionary *dic = [[NSDictionary alloc]init];
            dic = @{@"baby_id": selectedBabyInfoArray[2], @"school_id":selectedBabyInfoArray[3] , @"class_id":selectedBabyInfoArray[4] };
            [submitBabyInfoArray addObject:dic];
        
        }else{
        
            [self showHudWithString:@"小红花数量不足!" forSecond:1.5];
        
        }
    
    }];
    
    [self.navigationController pushViewController:managerAndHeadmasterVC animated:YES];
        
    
}

- (IBAction)certenButtonClick:(UIButton *)sender {
    /*
     【小红花->点击赠送】
     
     接口类型:2
     
     接口:
     http://www.xingxingedu.cn/Teacher/action_give_flower
     
     传参:
     position	//教职身份
     baby_info	//★二维数组的json数据,每一维数组含baby_id,school_id,class_id (请使用孩子列表获得的数据)
     con		//赠言
     
     file	//批量上传图片,app上漏写了上传图片
     */
    //position	//身份,传数字(1教师/2班主任/3管理/4校长)

    if (![submitBabyInfoArray isEqual:@"..."]) {
        NSError *error;
        NSData *jsonData =[NSJSONSerialization dataWithJSONObject:submitBabyInfoArray  options:kNilOptions error:&error];
        jsonString =[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    if (conStr == nil) {
        conStr = @"";
    }
    
    XXESubmitSeletedBabyInfoApi *submitSeletedBabyInfoApi = [[XXESubmitSeletedBabyInfoApi alloc] initWithXid:XID user_id:USER_ID user_type:USER_TYPE position:@"4" baby_info:jsonString con:conStr];
    [submitSeletedBabyInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//    NSLog(@"111777   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        [self showHudWithString:@"发送中......"];
        
        if ([codeStr isEqualToString:@"1"]) {

//        [self hideHud];
        [self.navigationController popViewControllerAnimated:YES];

        }else{
          [self showHudWithString:@"发送失败!" forSecond:1.5 ];
        }
        
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}


- (void)textViewDidChange:(UITextView *)textView{
    if (textView == _contentTextField) {
        self.contentNumLabel.text=[NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
        conStr = textView.text;
    }
    

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
