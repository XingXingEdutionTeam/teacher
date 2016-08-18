



//
//  XXECommentStudentViewController.m
//  teacher
//
//  Created by Mac on 16/8/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECommentStudentViewController.h"
#import "XXEChiefAndTeacherViewController.h"
#import "XXEManagerAndHeadmasterViewController.h"
#import "DynamicScrollView.h"
#import "FSImagePickerView.h"
#import "XXEInitiativeCommentCertainApi.h"
#import "YTKBatchRequest.h"
#import "FSImageModel.h"


@interface XXECommentStudentViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextViewDelegate>
{
    DynamicScrollView *dynamicScrollView;
    NSMutableArray *didSelectBabyNameArray;//选中宝贝 名称  数组
    NSMutableArray *didSelectBabyIdArray;//选中宝贝 id  数组
    NSMutableArray *didSelectSchoolIdArray;//选中宝贝 学校 id  数组
    NSMutableArray *didSelectClassIdArray;//选中宝贝 班级 id  数组
    
    NSString *babyIdStr; //选中 的 宝贝 id
    NSString *jsonString;
    //添加 照片
    FSImagePickerView *pickerView;
    
    NSString *conStr;
    
}

@property (nonatomic, strong) NSMutableArray *selectedBabyInfoArray;


@end

@implementation XXECommentStudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    didSelectBabyNameArray = [[NSMutableArray alloc] init];
    didSelectBabyIdArray = [[NSMutableArray alloc] init];
    didSelectSchoolIdArray = [[NSMutableArray alloc] init];
    didSelectClassIdArray = [[NSMutableArray alloc] init];
    
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
    pickerView = [[FSImagePickerView alloc] initWithFrame:CGRectMake(10, 30, kWidth - 10 * 2, 80) collectionViewLayout:layout1];
    pickerView.backgroundColor = UIColorFromRGB(255, 255, 255);
    pickerView.showsHorizontalScrollIndicator = NO;
    pickerView.controller = self;
    
    [self.upPicImageView addSubview:pickerView];
    
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
//        XXEChiefAndTeacherViewController *chiefAndTeacherVC = [[XXEChiefAndTeacherViewController alloc] init];
//    
//        chiefAndTeacherVC.schoolId = _schoolId;
//        chiefAndTeacherVC.classId = _classId;
//    
//        [self.navigationController pushViewController:chiefAndTeacherVC animated:YES];
    
    //如果是管理员 或者 校长身份
    
    XXEManagerAndHeadmasterViewController *managerAndHeadmasterVC = [[XXEManagerAndHeadmasterViewController alloc] init];
    managerAndHeadmasterVC.schoolId = _schoolId;
    
    //返回 数组 头像、名称、id、课程
    [managerAndHeadmasterVC returnArray:^(NSMutableArray *selectedBabyInfoArray) {
        _selectedBabyInfoArray = [NSMutableArray arrayWithArray:selectedBabyInfoArray];

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
    }];
    
    [self.navigationController pushViewController:managerAndHeadmasterVC animated:YES];

    
}

- (IBAction)certenButtonClick:(UIButton *)sender {
    
    /*
     【点评->主动点评】
     
     接口类型:2
     
     接口:
     http://www.xingxingedu.cn/Teacher/teacher_comment_action
     
     
     传参:
     school_id	//学校id
     class_id	//班级id
     baby_id		//评论id
     com_con		//评论内容
     file		//批量上传图片 ★现在的版本没有上传图片的,应该是之前遗漏了,请加上     */
    NSMutableArray *arr1 = [NSMutableArray array];
    
    NSLog(@"%@",pickerView.data);
    
    if (pickerView.data.count == 0) {
        
    }else if (pickerView.data.count == 1){
    
    }else if (pickerView.data.count > 1){
    
    for (int i = 0; i < pickerView.data.count - 1; i++) {
        
        FSImageModel *mdoel = pickerView.data[i];
        
        UIImage *image1 = [UIImage imageWithData:mdoel.data];
        [arr1 addObject:image1];

    }
    }
    
    NSLog(@"上传 图片 %@", arr1);
    
    [self showHudWithString:@"正在上传......"];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i =0; i < arr1.count; i++) {
        XXEInitiativeCommentCertainApi *initiativeCommentCertainApi = [[XXEInitiativeCommentCertainApi alloc]initWithXid:XID user_id:USER_ID user_type:USER_TYPE school_id:_schoolId class_id:_classId baby_id:babyIdStr com_con:conStr upImage:arr1[i]];
        [arr addObject:initiativeCommentCertainApi];
    }
    
    YTKBatchRequest *bathRequest = [[YTKBatchRequest alloc]initWithRequestArray:arr];
    [bathRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
        
        
        NSLog(@"%@",bathRequest);
        
        [self hideHud];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(YTKBatchRequest *batchRequest) {
        [self showHudWithString:@"上传失败" forSecond:1.f];
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
