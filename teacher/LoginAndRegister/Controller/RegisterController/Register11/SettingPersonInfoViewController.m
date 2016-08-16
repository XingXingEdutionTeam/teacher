//
// SettingPersonInfoViewController.m
//  Created by codeDing on 16/1/16.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "SettingPersonInfoViewController.h"
#import "HHControl.h"
#import "WJCommboxView.h"
#import "CheckIDCard.h"
#import "SchoolInfoViewController.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "LMContainsLMComboxScrollView.h"
#import "LMComBoxView.h"
#import "UtilityFunc.h"
#import "Constants.h"
#import "HZQDatePickerView.h"
//#import "HeadmasterInfoViewController.h"
//#import "TeacherInfoViewController.h"

#define ORIGINAL_MAX_WIDTH 640.0f
#define  kDropDownListTag 1000

#define awayX 20
#define spaceX 5
#define spaceY 35

#define kMarg 10.0f
#define kLabelW 80.0f
#define kLabelH 30.0f
#define kTextFW 240.0f
#define kTextFH 30.0f

@interface SettingPersonInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, VPImageCropperDelegate,HZQDatePickerViewDelegate>

{
    UIView *bgView;
    UILabel *parentsNameLabel;   //姓名
    UILabel *parentsIDCardLabel;   //身份证号
    UILabel *inviteCodeLabel;   //邀请码
    UITextField *parentsName;   //姓名
     UITextField *parentsIDCard;   //身份证号
    UITextField *inviteCode;   //邀请码
    
    
    LMContainsLMComboxScrollView *bgScrollView;
    NSMutableDictionary *addressDict;
    NSDictionary *areaDict;
    NSArray *provinceArr;
    NSArray *cityArr;
    NSArray *districtArr;
    NSString *selectProvinceStr;
    NSString *selectCityStr;
    NSString *selectAreaStr;
    UILabel *trainAgencyLbl;
    
    HZQDatePickerView *_pikerView;//截止日期选择器
    
    UIButton *landBtn;
    NSTimer *timer;

}
@property (nonatomic,strong) UIButton *head; //头像
@property(nonatomic,strong)WJCommboxView *relationCombox;//下拉选择框
@property(nonatomic,strong)WJCommboxView *parentsIDCardCombox;//家长身份证下拉选择框
@property(nonatomic,strong)WJCommboxView *studentIDCardCombox;//学生身份证下拉选择框
@property (nonatomic, strong) UIImageView *portraitImageView;//头像


@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UISearchController *searchDC;
@property(nonatomic,strong)UIView *schoolTypeView;
@property(nonatomic,strong)NSArray *schoolNameArr;
@property(nonatomic,strong)NSArray *schoolTypeArr;
@property(nonatomic,strong)UIView *schoolNameView;
@property(nonatomic,strong)NSArray *gradeNameArr;
@property(nonatomic,strong)UIView *gradeNameView;
@property(nonatomic,strong)NSArray *classNameArr;
@property(nonatomic,strong)UIView *classNameView;
@property(nonatomic,strong)NSArray *trainAgencyArr;
@property(nonatomic,strong)UIView *trainAgencyView;
@property(nonatomic,strong)NSArray *auditPeopleArr;
@property(nonatomic,strong)NSArray *teacherTypeArr;
@property(nonatomic,strong)NSArray *teacherSubjectArr;
@property(nonatomic,strong)UIView *auditPeopleView;


@property(nonatomic,strong)WJCommboxView *teacherTypeCombox;
@property(nonatomic,strong)UILabel * auditNameLabel;
@property(nonatomic,strong)UILabel * schoolNameLabel;
@property(nonatomic,strong)UILabel * trainNameLabel;
@property(nonatomic,strong)UILabel *trainLabel;
@property(nonatomic,strong)UILabel *teacherTypeLabel;
@property(nonatomic,strong)UILabel *teacherDateLabel;
@property(nonatomic,strong)UILabel *teacherSubjectLabel;

@property(nonatomic,strong)UIButton *teacherDateBtn;

@end

@implementation SettingPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"注册3/4";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor= [UIColor colorWithRed:229/255.0f green:232/255.0f blue:234/255.0f alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0, 170, 42);
    [self createUI];
    [self loadPortrait];
    
}



-(void)createUI
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-80)/2, 145, 80, 40)];
    label.text=@"点击设置头像";
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:label];

    bgView = [[UIView alloc] initWithFrame:CGRectMake(spaceX, CGRectGetMaxY(label.frame) + 20, kWidth - spaceX * 2, 130)];
    bgView.backgroundColor = UIColorFromRGB(255, 255, 255);
    [self.view addSubview:bgView];
    
    UIView *bigGbView = [[UIView alloc] initWithFrame:CGRectMake(spaceX, CGRectGetMaxY(label.frame) + 20, kWidth , kHeight)];
    bigGbView.backgroundColor = [UIColor clearColor];
    bigGbView.userInteractionEnabled = YES;
    [self.view addSubview:bigGbView];
    //姓名
    parentsNameLabel=[self createLabelWithFrame:CGRectMake(kMarg ,kMarg , kLabelW, kLabelH) Font:16 Text:@"注册姓名:"];
    parentsName=[self createTextFielfFrame:CGRectMake(CGRectGetMaxX(parentsNameLabel.frame) + kMarg, kMarg, kTextFW, kTextFH) font:[UIFont systemFontOfSize:14] placeholder:@"请输入您的姓名"  alignment:NSTextAlignmentLeft clearButtonMode:UITextFieldViewModeWhileEditing];
    parentsName.borderStyle = UITextBorderStyleNone;
    [bigGbView addSubview:parentsName];
    [bigGbView addSubview:parentsNameLabel];
    
    //身份证号
    parentsIDCardLabel=[self createLabelWithFrame:CGRectMake(kMarg, CGRectGetMaxY(parentsNameLabel.frame) + kMarg, kLabelW, kLabelH) Font:16 Text:@"身份证号:"];
    parentsIDCard=[self createTextFielfFrame:CGRectMake(CGRectGetMaxX(parentsIDCardLabel.frame) + kMarg, CGRectGetMaxY(parentsName.frame)+ kMarg, kTextFW, kTextFH) font:[UIFont systemFontOfSize:14] placeholder:@"请输入您的身份号"  alignment:NSTextAlignmentLeft clearButtonMode:UITextFieldViewModeWhileEditing];
    parentsIDCard.borderStyle = UITextBorderStyleNone;
    [bigGbView addSubview:parentsIDCard];
    [bigGbView addSubview:parentsIDCardLabel];
    
    //确认按钮
    landBtn=[self createButtonFrame:CGRectMake(awayX, CGRectGetMaxY(bgView.frame) + 140,325, 42) backImageName:@"login_green" title:@"下一步" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:17] target:self action:@selector(landClick)];
    landBtn.layer.cornerRadius=5.0f;
    [self.view addSubview:landBtn];
    
    [self.view addSubview:self.portraitImageView];
    
    /**
     教师身份
     */
    self.teacherTypeArr = [[NSArray alloc]initWithObjects:@"授课老师",@"班主任",@"管理员",@"校长",nil];
    _teacherTypeLabel=[[UILabel alloc]initWithFrame:CGRectMake(awayX,CGRectGetMaxY(parentsIDCard.frame) + kMarg, kLabelW, kLabelH)];
    _teacherTypeLabel.text=@"教职身份:";
    _teacherTypeLabel.font = [UIFont systemFontOfSize:16];
    self.teacherTypeCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(parentsIDCardLabel.frame) + kMarg, CGRectGetMaxY(parentsIDCard.frame)+ kMarg,kWidth - CGRectGetMaxX(_teacherTypeLabel.frame) - kMarg * 2, kTextFH)];
    self.teacherTypeCombox.textField.placeholder = @"请选择职位";
    self.teacherTypeCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.teacherTypeCombox.textField.borderStyle = UITextBorderStyleNone;
    self.teacherTypeCombox.textField.tag = 102;
    self.teacherTypeCombox.dataArray = self.teacherTypeArr;
    self.teacherTypeCombox.listTableView.showsVerticalScrollIndicator = NO;
    [bigGbView addSubview:_teacherTypeLabel];
    [bigGbView addSubview:self.teacherTypeCombox];

    for (int i = 1; i < 3 ; i ++ ) {
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(parentsNameLabel.frame) * i + 5, bgView.size.width, 1)];
        line.backgroundColor = UIColorFromRGB(204, 204, 204);
        [bgView addSubview:line];
    }
    
}
//返回
-(void)clickaddBtn
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController pushViewController:[[MMZCViewController alloc]init] animated:YES];
}

-(void)landClick
{
    
        if ([parentsName.text isEqualToString:@""])
        {
            [self showString:@"请输入姓名" forSecond:1.f];
            
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:1.5];
            return;
        }
        else if (parentsName.text.length >5||parentsName.text.length <2)
        {
            [self showString:@"请输入正确的姓名" forSecond:1.f];
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:1.5];
            return;
        }
        else if ([parentsIDCard.text isEqualToString:@""])
        {
            [self showString:@"请输入正确的身份证" forSecond:1.f];
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:1.5];
            return;
        }
    
        else if (parentsIDCard.text.length !=18)
                {
                    
                    [self showString:@"您输入的身份证号码格式不正确" forSecond:1.f];
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:1.5];
                    return;
                }
        else if (![CheckIDCard checkIDCard:parentsIDCard.text]){
            [self showString:@"您输入的家长身份证号码不存在" forSecond:1.f];
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:1.5];
            return;
        }
     else if ([self.teacherTypeCombox.textField.text isEqualToString:@"校长"]){

//            [self.navigationController pushViewController:[HeadmasterInfoViewController alloc] animated:YES];
            return;
        }
     else if ([self.teacherTypeCombox.textField.text isEqualToString:@"管理员"]){

//         [self.navigationController pushViewController:[HeadmasterInfoViewController alloc] animated:YES];
         return;
     }
      else{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.navigationController pushViewController:[TeacherInfoViewController alloc] animated:YES];
    });
    }

}


-(NSString * )rangeString:(NSString *)str begin:(NSInteger )begin  length:(NSInteger)length{
    NSRange r1 = {begin,length};
    return  [str substringWithRange:r1];
}

-(UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder alignment:(NSTextAlignment )alignment clearButtonMode:(UITextFieldViewMode )clearButtonMode
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=[UIColor grayColor];
    
    textField.borderStyle=UITextBorderStyleNone;
    
    textField.placeholder=placeholder;
    textField.textAlignment=alignment;
    textField.clearButtonMode=clearButtonMode;
    textField.borderStyle = UITextBorderStyleRoundedRect;

    return textField;
}

-(UILabel *)createLabelWithFrame:(CGRect )frame Font:(int)font Text:(NSString *)text{
    UILabel *myLabel = [[UILabel alloc]initWithFrame:frame];
    myLabel.numberOfLines = 0;//限制行数
    myLabel.textAlignment = NSTextAlignmentRight;//对齐的方式
    myLabel.backgroundColor = [UIColor clearColor];//背景色
    myLabel.font = [UIFont systemFontOfSize:font];//字号
    myLabel.textColor = [UIColor blackColor];//颜色默认是黑色
    //NSLineBreakByCharWrapping以单词为单位换行，以单词为阶段换行
    // NSLineBreakByCharWrapping
    myLabel.lineBreakMode = NSLineBreakByCharWrapping;
    myLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    myLabel.text = text;
    return myLabel;
    
}



-(void)changeHeadView1:(UIButton *)tap
{
    
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"更改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册上传", nil];
    menu.delegate=self;
    menu.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
    
}


- (void)commboxAction2:(NSNotification *)notif{
    
    [self.comBackView removeFromSuperview];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --更换头像
- (void)loadPortrait {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        UIImage *protraitImg = [UIImage imageNamed:@"home_logo"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.portraitImageView.image = protraitImg;
        });
    });
}

- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.portraitImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark portraitImageView getter
- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 120)/2, 30, 120, 120)];
        [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
        [_portraitImageView.layer setMasksToBounds:YES];
        [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_portraitImageView setClipsToBounds:YES];
        _portraitImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
        _portraitImageView.layer.shadowOpacity = 0.5;
        _portraitImageView.layer.shadowRadius = 2.0;
        _portraitImageView.layer.borderColor = [[UIColor clearColor] CGColor];
        _portraitImageView.layer.borderWidth = 2.0f;
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_portraitImageView addGestureRecognizer:portraitTap];
    }
    return _portraitImageView;
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


-(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    
    if (imageName)
    {
        imageView.image=[UIImage imageNamed:imageName];
    }
    if (color)
    {
        imageView.backgroundColor=color;
    }
    
    return imageView;
}

-(UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    if (imageName)
    {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (font)
    {
        btn.titleLabel.font=font;
    }
    
    if (title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    if (target&&action)
    {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}




@end
