//
// SettingPersonInfoViewController.m
//  Created by codeDing on 16/1/16.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "SettingPersonInfoViewController.h"
#import "WJCommboxView.h"
#import "CheckIDCard.h"
#import "XXERegisterTeacherViewController.h"
#import "XXERegisterHeadMasterViewController.h"
#import "KTActionSheet.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface SettingPersonInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,KTActionSheetDelegate>

{
    UITextField *parentsName;   //姓名
     UITextField *parentsIDCard;   //身份证号
    UIImagePickerController *_ipc;
}
/** 头像 */
@property (nonatomic, strong) UIImageView *portraitImageView;

@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)NSArray *teacherTypeArr;
@property(nonatomic,strong)WJCommboxView *teacherTypeCombox;
@property(nonatomic,strong)UILabel *teacherTypeLabel;

@end

@implementation SettingPersonInfoViewController

#pragma mark portraitImageView getter
- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        _portraitImageView = [[UIImageView alloc] init];
        _portraitImageView.layer.masksToBounds = YES;
        _portraitImageView.layer.cornerRadius = 120*kScreenRatioWidth/2;
        [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.backgroundColor = [UIColor blackColor];
        _portraitImageView.image = [UIImage imageNamed:@"home_logo"];
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_portraitImageView addGestureRecognizer:portraitTap];
    }
    return _portraitImageView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    self.navigationItem.title = @"3/4注册";
    self.navigationController.navigationBarHidden = NO;
}

/** 这个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self createUI];
    if (!_ipc) {
        _ipc = [[UIImagePickerController alloc]init];
    }
    _ipc.delegate = self;
    _ipc.allowsEditing  = YES;
}


-(void)createUI
{
    __weak typeof(self)weakSelf = self;
    [self.view addSubview:self.portraitImageView];
    [self.portraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10*kScreenRatioHeight);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(120*kScreenRatioWidth, 120*kScreenRatioWidth));
    }];
    
    UILabel *label=[[UILabel alloc]init];
    label.text=@"点击设置头像";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(weakSelf.portraitImageView.mas_bottom).offset(10*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(100*kScreenRatioWidth, 40*kScreenRatioHeight));
    }];

   UIImageView * bgImageView = [[UIImageView alloc] init];
    bgImageView.backgroundColor = XXEColorFromRGB(255, 255, 255);
    bgImageView.image = [UIImage imageNamed:@"register_background"];
    bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20*kScreenRatioHeight);
        make.left.equalTo(weakSelf.view.mas_left).offset(8);
        make.size.mas_equalTo(CGSizeMake(359*kScreenRatioWidth, 158*kScreenRatioHeight));
    }];
    
    //姓名
    
    UILabel *parentsNameLabel = [UILabel setupMessageLabel:@"注册姓名:"];
//    parentsNameLabel.backgroundColor = [UIColor redColor];
    [bgImageView addSubview:parentsNameLabel];
    [parentsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgImageView.mas_left).offset(5);
        make.top.equalTo(bgImageView.mas_top).offset(1);
        make.size.mas_equalTo(CGSizeMake(80*kScreenRatioWidth, 52*kScreenRatioHeight));
    }];
    
    parentsName = [UITextField createTextFieldWithIsOpen:NO textPlaceholder:@"请输入您的姓名"];
    parentsName.borderStyle = UITextBorderStyleNone;
    [bgImageView addSubview:parentsName];
    [parentsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(parentsNameLabel.mas_right).offset(2);
        make.centerY.equalTo(parentsNameLabel.mas_centerY);
        make.right.equalTo(bgImageView.mas_right).offset(4);
        make.height.equalTo(@(52*kScreenRatioHeight));
    }];
    
    //身份证号
    UILabel *parentsIDCardLabel = [UILabel setupMessageLabel:@"身份证号:"];
//    parentsIDCardLabel.backgroundColor = [UIColor redColor];
    [bgImageView addSubview:parentsIDCardLabel];
    [parentsIDCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgImageView.mas_left).offset(5);
        make.top.equalTo(parentsNameLabel.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(80*kScreenRatioWidth, 52*kScreenRatioHeight));
    }];

    parentsIDCard = [UITextField createTextFieldWithIsOpen:NO textPlaceholder:@"请输入您的身份号"];
    parentsIDCard.borderStyle = UITextBorderStyleNone;
    [bgImageView addSubview:parentsIDCard];
    [parentsIDCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(parentsIDCardLabel.mas_right).offset(2);
        make.centerY.equalTo(parentsIDCardLabel.mas_centerY);
        make.right.equalTo(bgImageView.mas_right).offset(4);
        make.height.equalTo(@(52*kScreenRatioHeight));
    }];
    
    //教职身份
    UILabel *teacherTypeLabel = [UILabel setupMessageLabel:@"教职身份:"];
//    teacherTypeLabel.backgroundColor = [UIColor redColor];
    [bgImageView addSubview:teacherTypeLabel];
    [teacherTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgImageView.mas_left).offset(5);
        make.top.equalTo(parentsIDCardLabel.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(80*kScreenRatioWidth, 52*kScreenRatioHeight));
    }];
    
    self.teacherTypeArr = [[NSArray alloc]initWithObjects:@"授课老师",@"班主任",@"管理员",@"校长",nil];
    
    
    self.teacherTypeCombox = [[WJCommboxView alloc]initWithFrame:CGRectMake(95*kScreenRatioWidth, 318*kScreenRatioHeight, 260*kScreenRatioWidth, 100*kScreenRatioHeight)];
//    self.teacherTypeCombox.backgroundColor = [UIColor redColor];
    self.teacherTypeCombox.textField.placeholder = @"请选择职位";
    self.teacherTypeCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.teacherTypeCombox.textField.borderStyle = UITextBorderStyleNone;
    self.teacherTypeCombox.textField.tag = 102;
    self.teacherTypeCombox.dataArray = self.teacherTypeArr;
    self.teacherTypeCombox.listTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.teacherTypeCombox];
    
    
    UIButton *nextButton = [[UIButton alloc]init];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"login_green"] forState:UIControlStateNormal];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(landClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-30*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(335*kScreenRatioWidth, 41*kScreenRatioHeight));
    }];

}

-(void)landClick:(UIButton *)sender
{
    
    XXERegisterHeadMasterViewController *headerVC = [[XXERegisterHeadMasterViewController alloc]init];
    [self.navigationController pushViewController:headerVC animated:YES];
    
        if ([parentsName.text isEqualToString:@""])
        {
            [self showString:@"请输入姓名" forSecond:1.f];
            return;
        }
        else if (parentsName.text.length >5||parentsName.text.length <2)
        {
            [self showString:@"请输入正确的姓名" forSecond:1.f];
            return;
        }
        else if ([parentsIDCard.text isEqualToString:@""])
        {
            [self showString:@"请输入正确的身份证" forSecond:1.f];
            return;
        }
        else if (parentsIDCard.text.length !=18)
                {
                    [self showString:@"您输入的身份证号码格式不正确" forSecond:1.f];
                    return;
                }
        else if (![CheckIDCard checkIDCard:parentsIDCard.text]){
            [self showString:@"您输入的家长身份证号码不存在" forSecond:1.f];
            return;
        }
     else if ([self.teacherTypeCombox.textField.text isEqualToString:@"校长"] || [self.teacherTypeCombox.textField.text isEqualToString:@"管理员"]){
         
         XXERegisterHeadMasterViewController *headerVC = [[XXERegisterHeadMasterViewController alloc]init];
         [self.navigationController pushViewController:headerVC animated:YES];
            return;
        }
      else{
    
        XXERegisterTeacherViewController *teacherVC = [[XXERegisterTeacherViewController alloc]init];
        [self.navigationController pushViewController:teacherVC animated:YES];
    }
}


-(NSString * )rangeString:(NSString *)str begin:(NSInteger )begin  length:(NSInteger)length{
    NSRange r1 = {begin,length};
    return  [str substringWithRange:r1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --更换头像
- (void)editPortrait {
    
    KTActionSheet *actionSheet = [[KTActionSheet alloc]initWithTitle:@"" itemTitles:@[@"拍照",@"从手机相册选择"]];
    actionSheet.delegate = self;
}

- (void)sheetViewDidSelectIndex:(NSInteger)index title:(NSString *)title sender:(id)sender
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }
    if (index == 1) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _ipc.sourceType = sourceType;
        _ipc.navigationBar.tintColor = [UIColor whiteColor];

        [self presentViewController:_ipc animated:YES completion:nil];
    }
    if (index == 0) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        _ipc.allowsEditing = YES;//设置可编辑
        _ipc.sourceType = sourceType;
        _ipc.navigationBar.tintColor = [UIColor whiteColor];
        [self presentViewController:_ipc animated:YES completion:nil];//进入照相界面
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imageAvatar = [info objectForKey:UIImagePickerControllerEditedImage];
    NSLog(@"%@",imageAvatar);
//    UIImage *imageBack = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.portraitImageView setImage:imageAvatar];
    //网络请求
//    MGTPhotoPageApi *userMessageApi = [[MGTPhotoPageApi alloc]initWithUserUid:userUid andImage:imageAvatar];
//    [userMessageApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
//        if ([[request.responseJSONObject objectForKey:@"errorCode"] isEqualToString:@"0"]) {
//            self.productModel.imageUrl = [request.responseJSONObject objectForKey:@"errorMessage"];
//        }else{
//            self.productModel.imageUrl = [MGTUser user].avatar;
//            [self showString:@"上传图片失败，请重试" forSeconds:2];
//        }
//    } failure:^(YTKBaseRequest *request) {
//        self.productModel.imageUrl = [MGTUser user].avatar;
//        [self showString:@"上传图片失败，请重试" forSeconds:2];
//    }];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}


-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    //搜尋結束後，恢復原狀
    return YES;
}
#pragma mark - search bar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    // [searchBar setShowsCancelButton:YES animated:YES];
    _searchBar.showsCancelButton = YES;
    [self  allview:searchBar indent:0];
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}
/*递归*/
//（深度优先算法）
-(void)allview:(UIView *)rootview indent:(NSInteger)indent
{
    //    NSLog(@"[%2d] %@",indent, rootview);
    indent++;
    for (UIView *aview in rootview.subviews)
    {
        /**
         在这里还可以遍历得到 UISearchBarTextField，即搜索输入框，
         */
        
        [self allview:aview indent:indent];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_searchBar endEditing:YES];
    [self.view endEditing:YES];
}

@end
