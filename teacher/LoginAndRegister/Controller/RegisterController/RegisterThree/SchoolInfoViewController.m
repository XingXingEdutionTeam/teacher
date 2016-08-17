//
//  SchoolInfoViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/1/14.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define  kDropDownListTag 1000

#import "SchoolInfoViewController.h"
#import "LMContainsLMComboxScrollView.h"
//#import "MyTabBarController.h"
#import "XXETabBarControllerConfig.h"
//#import "SVProgressHUD.h"
#import "WJCommboxView.h"
#import "LMComBoxView.h"
#import "AppDelegate.h"
#import "UtilityFunc.h"
#import "HHControl.h"
@interface SchoolInfoViewController ()<LMComBoxViewDelegate,UISearchBarDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
   
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
    UIView *bgView;
   
}
@property(nonatomic, strong)UISearchBar *searchBar;
@property(nonatomic, strong)UISearchController *searchDC;
@property(nonatomic, strong)UIView *schoolTypeView;
@property(nonatomic, strong)NSArray *schoolNameArr;
@property(nonatomic, strong)NSArray *schoolTypeArr;
@property(nonatomic, strong)NSArray *majorTypeArr;
@property(nonatomic, strong)UIView *schoolNameView;
@property(nonatomic, strong)NSArray *gradeNameArr;
@property(nonatomic, strong)UIView *gradeNameView;
@property(nonatomic, strong)NSArray *classNameArr;
@property(nonatomic, strong)UIView *classNameView;
@property(nonatomic, strong)NSArray *trainAgencyArr;
@property(nonatomic, strong)UIView *trainAgencyView;
@property(nonatomic, strong)NSArray *auditPeopleArr;
@property(nonatomic, strong)UIView *auditPeopleView;



@property(nonatomic, strong)WJCommboxView *schoolTypeCombox;
@property(nonatomic, strong)WJCommboxView *majorTypeCombox;
@property(nonatomic, strong)WJCommboxView *schoolNameCombox;
@property(nonatomic, strong)WJCommboxView *gradeNameCombox;
@property(nonatomic, strong)WJCommboxView *classNameCombox;
@property(nonatomic, strong)WJCommboxView *trainSubjectCombox;
@property(nonatomic, strong)WJCommboxView *auditNameCombox;

@property(nonatomic, strong)UILabel * auditNameLabel;
@property(nonatomic, strong)UILabel * schoolNameLabel;
@property(nonatomic, strong)UILabel * trainNameLabel;
@property(nonatomic, strong)UILabel *trainLabel;
@end

@implementation SchoolInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"完善信息";
    [self performSelector:@selector(pickup) withObject:self afterDelay:1];
    // Do any additional setup after loading the view.
//    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickaddBtn)];
//    [addBtn setImage:[UIImage imageNamed:@"goback_back_orange_on"]];
//    [addBtn setImageInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
//    addBtn.tintColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
//    [self.navigationItem setLeftBarButtonItem:addBtn];
     [self reloadD];

    
    bgScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    bgScrollView.backgroundColor = UIColorFromRGB(255, 255, 255);
    bgScrollView.showsHorizontalScrollIndicator =NO;
    bgScrollView.showsVerticalScrollIndicator =NO;
    [self.view addSubview:bgScrollView];
    
    
    
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    bgView.backgroundColor =UIColorFromRGB(229, 232, 233);
    [bgScrollView addSubview:bgView];
    [self setBgScrollView];
    [self commBoxInfo];
    bgView.userInteractionEnabled = YES;
     [bgView addSubview:_searchBar];
    
}
- (void)pickup{
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否完善信息赚取200猩币?" delegate:self cancelButtonTitle:@"跳过" otherButtonTitles:@"完善", nil];
    alert.delegate =self;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"0");
            XXETabBarControllerConfig * infoVC =[[XXETabBarControllerConfig alloc]init];
            [self presentViewController:infoVC animated:YES completion:nil];
            
        }
            break;
        case 1:
        {
              NSLog(@"1");
            NSLog(@"完善");
        }
            break;
        default:
            break;
    }
    

}
- (void)clickaddBtn{
    [self dismissViewControllerAnimated:YES completion:nil];
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

//  加载Pist
- (void)reloadD{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"CityPlace" ofType:@"plist"];
    areaDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *components = [areaDict allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [NSMutableArray array];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDict objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    provinceArr = [NSArray arrayWithArray:provinceTmp];
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [provinceArr objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDict objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    cityArray = [NSArray arrayWithArray:[cityDic allKeys]];
    
    selectCityStr = [cityArray objectAtIndex:0];
    districtArr = [NSArray arrayWithArray:[cityDic objectForKey:selectCityStr]];
    
    addressDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   provinceArr,@"province",
                   cityArray,@"city",
                   districtArr,@"area",nil];
    
    selectProvinceStr = [provinceArr objectAtIndex:0];
    selectAreaStr = [districtArr objectAtIndex:0];
    
}

- (void)setBgScrollView{
    UILabel *areaLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 130, 30)];
    
    areaLable.textAlignment = NSTextAlignmentCenter;
    areaLable.text = @"毕业院校信息：";
    [bgScrollView addSubview:areaLable];
    
    
    NSArray *keys = [NSArray arrayWithObjects:@"province",@"city",@"area", nil];
    for(NSInteger i=0;i<3;i++)
    {
        LMComBoxView *comBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(127+(60+12)*i, 20, 65, 30)];
        comBox.backgroundColor = UIColorFromRGB(246, 246, 246);
        comBox.arrowImgName = @"down_dark0.png";
        NSMutableArray *itemsArray = [NSMutableArray arrayWithArray:[addressDict objectForKey:[keys objectAtIndex:i]]];
        comBox.layer.cornerRadius = 5;
        [comBox.layer setMasksToBounds:YES];
        comBox.titlesList = itemsArray;
        comBox.delegate = self;
        comBox.supView = bgScrollView;
        [comBox defaultSettings];
        comBox.tag = kDropDownListTag + i;
        
        [bgScrollView addSubview:comBox];
        [bgScrollView bringSubviewToFront:comBox];
        
    }
}
#pragma mark -LMComBoxViewDelegate
-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox
{
    NSInteger tag = _combox.tag - kDropDownListTag;
    switch (tag) {
        case 0:
        {
            selectProvinceStr =  [[addressDict objectForKey:@"province"]objectAtIndex:index];
            //字典操作
            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDict objectForKey: [NSString stringWithFormat:@"%d", index]]];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectProvinceStr]];
            NSArray *cityArray = [dic allKeys];
            NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;//递减
                }
                
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;//上升
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i=0; i<[sortedArray count]; i++) {
                NSString *index = [sortedArray objectAtIndex:i];
                NSArray *temp = [[dic objectForKey: index] allKeys];
                [array addObject: [temp objectAtIndex:0]];
            }
            cityArr = [NSArray arrayWithArray:array];
            
            NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
            districtArr = [NSArray arrayWithArray:[cityDic objectForKey:[cityArr objectAtIndex:0]]];
            //刷新市、区
            addressDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           provinceArr,@"province",
                           cityArr,@"city",
                           districtArr,@"area",nil];
            LMComBoxView *cityCombox = (LMComBoxView *)[bgScrollView viewWithTag:tag + 1 + kDropDownListTag];
            cityCombox.titlesList = [NSMutableArray arrayWithArray:[addressDict objectForKey:@"city"]];
            [cityCombox reloadData];
            
            LMComBoxView *areaCombox = (LMComBoxView *)[bgScrollView viewWithTag:tag + 2 + kDropDownListTag];
            areaCombox.titlesList = [NSMutableArray arrayWithArray:[addressDict objectForKey:@"area"]];
            [areaCombox reloadData];
            
            selectCityStr = [cityArr objectAtIndex:0];
            selectAreaStr = [districtArr objectAtIndex:0];
            break;
        }
        case 1:
        {
            selectCityStr = [[addressDict objectForKey:@"city"]objectAtIndex:index];
            
            NSString *provinceIndex = [NSString stringWithFormat: @"%ld", [provinceArr indexOfObject: selectProvinceStr]];
            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDict objectForKey: provinceIndex]];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectProvinceStr]];
            NSArray *dicKeyArray = [dic allKeys];
            NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: index]]];
            NSArray *cityKeyArray = [cityDic allKeys];
            districtArr = [NSArray arrayWithArray:[cityDic objectForKey:[cityKeyArray objectAtIndex:0]]];
            //刷新区
            addressDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           provinceArr,@"province",
                           cityArr,@"city",
                           districtArr,@"area",nil];
            LMComBoxView *areaCombox = (LMComBoxView *)[bgScrollView viewWithTag:tag + 1 + kDropDownListTag];
            areaCombox.titlesList = [NSMutableArray arrayWithArray:[addressDict objectForKey:@"area"]];
            [areaCombox reloadData];
            
            selectAreaStr = [districtArr objectAtIndex:0];
            break;
        }
        case 2:
        {
            selectAreaStr = [[addressDict objectForKey:@"area"]objectAtIndex:index];
            break;
        }
        default:
            break;
    }
}
-(void)commBoxInfo{
//毕业院校
   
    self.schoolTypeArr = [[NSArray alloc]initWithObjects:@"北京理工大学",@"北京工业大学",@"北京大学",@"北京航空航天大学",@"北京外国语大学",@"北京电影学院",@"中国政法大学",@"中国人民大学",nil];
    UILabel * schoolTypeLabel=[[UILabel alloc]initWithFrame:CGRectMake(16, 82, 102, 30)];
    schoolTypeLabel.text=@"毕业院校:";
    [bgScrollView addSubview:schoolTypeLabel];
    self.schoolTypeCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(127, 82, 165, 30)];
    self.schoolTypeCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    
    self.schoolTypeCombox.textField.placeholder = @"请选择您的学校";
    
    self.schoolTypeCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.schoolTypeCombox.textField.tag = 101;
    self.schoolTypeCombox.dataArray = self.schoolTypeArr;
    [bgScrollView addSubview:self.schoolTypeCombox];
    
    
    //专业类型
    self.majorTypeArr = [[NSArray alloc]initWithObjects:@"化工",@"计算机",@"中文",@"数应",@"哲学",@"舞蹈",@"教育",@"经济",@"医学",@"管理",@"法学",@"农学",@"军事",nil];
    UILabel * majorTypeLabel=[[UILabel alloc]initWithFrame:CGRectMake(16, 142, 102, 30)];
    majorTypeLabel.text=@"所学专业:";
    [bgScrollView addSubview:majorTypeLabel];
    self.majorTypeCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(127, 142, 165, 30)];
    //self.majorTypeCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    
    self.majorTypeCombox.textField.placeholder = @"请选择您的专业";
    
    self.majorTypeCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.majorTypeCombox.textField.tag = 102;
    self.majorTypeCombox.dataArray = self.majorTypeArr;
    [bgScrollView addSubview:self.majorTypeCombox];
    /**
     学校名称
     */
    self.schoolNameArr = [[NSArray alloc]initWithObjects:@"语文",@"数学",@"英语",@"历史",@"美术",@"物理",@"生物",@"地理",@"舞蹈",@"化学",nil];
    _schoolNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(16, 202, 102, 30)];
    _schoolNameLabel.text=@"授课范围：";
    [bgScrollView addSubview:_schoolNameLabel];
    self.schoolNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(127, 202, 165, 30)];
    self.schoolNameCombox.textField.placeholder = @"请选择课程";
    self.schoolNameCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.schoolNameCombox.textField.tag = 103;
    self.schoolNameCombox.dataArray = self.schoolNameArr;
    [bgScrollView addSubview:self.schoolNameCombox];
    
    /**
     年级信息
     */
    UILabel * gradeNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(16, 262, 102, 30)];
    self.gradeNameArr = [[NSArray alloc]initWithObjects:@"1年",@"2年",@"3年",@"4年",@"5年",@"6年",@"7年",@"8年",@"9年",nil];
    gradeNameLabel.text=@"教学年限：";
    [bgScrollView addSubview:gradeNameLabel];
    self.gradeNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(127, 262, 160, 30)];
    self.gradeNameCombox.textField.placeholder = @"教龄";
    self.gradeNameCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.gradeNameCombox.textField.tag = 104;
    self.gradeNameCombox.dataArray = self.gradeNameArr;
    [bgScrollView addSubview:self.gradeNameCombox];
    self.gradeNameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.gradeNameView.backgroundColor = UIColorFromRGB(246, 246, 246);
    self.gradeNameView.alpha = 0.5;
    
    self.auditNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(16, 328, 102, 30)];
    self.auditNameLabel.text=@"从教经历：";
    [bgScrollView addSubview:self.auditNameLabel];
    
    //初始化并定义大小
    UITextView *textview = [[UITextView alloc] initWithFrame:CGRectMake(127, 328, 200, 80)];
    textview.backgroundColor=UIColorFromRGB(246, 246, 246); //背景色
    textview.scrollEnabled = YES;    //当文字超过视图的边框时是否允许滑动，默认为“YES”
    textview.editable = YES;        //是否允许编辑内容，默认为“YES”
    textview.delegate = self;//设置代理方法的实现类
    textview.font=[UIFont fontWithName:@"Arial" size:12.0]; //设置字体名字和字体大小;
    textview.returnKeyType = UIReturnKeyDefault;//return键的类型
    textview.keyboardType = UIKeyboardTypeDefault;//键盘类型
    textview.layer.cornerRadius =5;
    textview.layer.masksToBounds =YES;
    textview.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
    textview.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
    textview.textColor = [UIColor blackColor];
  //  textview.text = @"从教经历";//设置显示的文本内容
    [bgScrollView addSubview:textview];

    //  教学感悟
    self.auditNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(16, 420, 102, 30)];
    self.auditNameLabel.text=@"教学感悟：";
    [bgScrollView addSubview:self.auditNameLabel];
    
    //初始化并定义大小
    UITextView *teachingView = [[UITextView alloc] initWithFrame:CGRectMake(127, 420, 200, 80)];
    teachingView.backgroundColor=UIColorFromRGB(246, 246, 246); //背景色
    teachingView.scrollEnabled = YES;    //当文字超过视图的边框时是否允许滑动，默认为“YES”
    teachingView.editable = YES;        //是否允许编辑内容，默认为“YES”
    teachingView.delegate = self;//设置代理方法的实现类
    teachingView.font=[UIFont fontWithName:@"Arial" size:12.0]; //设置字体名字和字体大小;
    teachingView.returnKeyType = UIReturnKeyDefault;//return键的类型
    teachingView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    teachingView.layer.cornerRadius =5;
    teachingView.layer.masksToBounds =YES;
    teachingView.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
    teachingView.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
    teachingView.textColor = [UIColor blackColor];
    //teachingView.text = @"教学感悟";//设置显示的文本内容
    [bgScrollView addSubview:teachingView];
    


//    UIButton *btn = [HHControl createButtonWithFrame:CGRectMake(300, 198, 30, 330) backGruondImageName:@"" Target:self Action:@selector(tip:) Title:@"?"];
//    [bgScrollView addSubview:btn];
    
    /**
     确定按钮
     */
    UIButton * defineBtn=[[UIButton alloc]initWithFrame:CGRectMake(25, 540, self.view.frame.size.width-50, 42)];
    [defineBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [defineBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [defineBtn setBackgroundImage:[UIImage imageNamed:@"按钮（big）icon650x84"] forState:UIControlStateNormal];
    [defineBtn setTitleColor:UIColorFromRGB(255, 255, 255) forState:UIControlStateNormal];
    [defineBtn addTarget:self action:@selector(defineBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bgScrollView addSubview:defineBtn];
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    //如果被观察者的对象是_playList
    if ([object isKindOfClass:[UITextField class]]) {
        //如果是name属性值发生变化
        if ([keyPath isEqualToString:@"text"]) {
            //取出name的旧值和新值
            
            NSString * newName=[change objectForKey:@"new"];
            NSLog(@"object:%@,new:%@",object,newName);
            if([newName isEqualToString:@"幼儿园"]||[newName isEqualToString:@"小学"]||[newName isEqualToString:@"初中"]){
                _trainNameLabel.hidden=YES;
                _schoolNameLabel.hidden=NO;
                self.classNameCombox.hidden=NO;
                self.gradeNameCombox.hidden=NO;
                self.trainSubjectCombox.hidden=YES;
                self.auditNameCombox.hidden=NO;
                self.auditNameLabel.hidden=NO;
                trainAgencyLbl.hidden=YES;
              
                self.auditNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(16, 348, 102, 30)];
                self.auditNameLabel.text=@"审核人员：";
                [bgScrollView addSubview:self.auditNameLabel];
                 self.auditNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(127, 348, 165, 30)];
                 self.auditPeopleArr = [[NSArray alloc]initWithObjects:@"张老师",@"王老师",@"李老师",@"平台审核",nil];
                 self.auditNameCombox.dataArray = self.auditPeopleArr;
                self.auditNameCombox.textField.placeholder = @"请选择审核人员";
                self.auditNameCombox.textField.textAlignment = NSTextAlignmentLeft;
               
                [bgScrollView addSubview:self.auditNameCombox];
                
            }
            else  if([newName isEqualToString:@"培训机构"]){
                // self.schoolNameCombox.hidden = YES;
                _schoolNameLabel.hidden=YES;
                _trainLabel.hidden =YES;
                self.auditNameCombox.hidden=NO;
                self.auditNameLabel.hidden=NO;
                  self.trainSubjectCombox.hidden=NO;
                /**
                 培训机构科目
                 */
            trainAgencyLbl = [[UILabel alloc]initWithFrame:CGRectMake(16, 224, 102, 30)];
            trainAgencyLbl.text=@"培训机构：";
            [bgScrollView addSubview:trainAgencyLbl];
        
                
                self.gradeNameCombox.hidden=YES;
                self.classNameCombox.hidden=NO;
                self.classNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(127, 286, 80, 30)];
                self.classNameArr = [[NSArray alloc]initWithObjects:@"美术班",@"舞蹈班",@"武术班",@"绘画班",@"写作班",@"乐器班",nil];
                self.classNameCombox.dataArray = self.classNameArr;
                self.classNameCombox.textField.placeholder = @"辅导班";
                [bgScrollView addSubview:self.classNameCombox];
                
                  self.auditNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(127, 348, 165, 30)];
                self.auditPeopleArr = [[NSArray alloc]initWithObjects:@"张老师",@"王老师",@"李老师",@"平台审核",nil];
                self.auditNameCombox.dataArray = self.auditPeopleArr;
                self.auditNameCombox.textField.placeholder = @"请选择审核人员";
                self.auditNameCombox.textField.textAlignment = NSTextAlignmentLeft;
              
                [bgScrollView addSubview:self.auditNameCombox];
            }
        }
        
    }
    
}

- (void)commboxAction:(NSNotification *)notif{
    switch ([notif.object integerValue]) {
        case 101:
            [self.self.schoolTypeCombox removeFromSuperview];
            [bgScrollView addSubview:self.schoolTypeView];
            [bgScrollView addSubview:self.schoolTypeCombox];
            break;
        case 102:
            [self.self.schoolNameCombox removeFromSuperview];
            [bgScrollView addSubview:self.schoolNameCombox];
            [bgScrollView addSubview:self.schoolNameCombox];
            break;
        case 105:
            [self.self.trainSubjectCombox removeFromSuperview];
            [bgScrollView addSubview:self.trainSubjectCombox];
            [bgScrollView addSubview:self.trainSubjectCombox];
            break;
        default:
            break;
    }
    
}


- (void)commboxHidden{
    [self.schoolTypeView removeFromSuperview];
    [self.schoolTypeCombox setShowList:NO];
    self.schoolTypeCombox.listTableView.hidden = YES;
    CGRect sf = self.schoolTypeCombox.frame;
    sf.size.height = 30;
    self.schoolTypeCombox.frame = sf;
    CGRect frame = self.schoolTypeCombox.listTableView.frame;
    frame.size.height = 0;
    self.schoolTypeCombox.listTableView.frame = frame;
    [self.schoolTypeCombox removeFromSuperview];
    [bgScrollView addSubview:self.schoolTypeCombox];
    
    [self.schoolNameView removeFromSuperview];
    [self.schoolNameCombox setShowList:NO];
    self.schoolNameCombox.listTableView.hidden = YES;
    CGRect sf2 = self.schoolNameCombox.frame;
    sf2.size.height = 30;
    self.schoolNameCombox.frame = sf2;
    CGRect frame2 = self.schoolTypeCombox.listTableView.frame;
    frame2.size.height = 0;
    self.schoolNameCombox.listTableView.frame = frame2;
    [self.schoolNameCombox removeFromSuperview];
    [bgScrollView addSubview:self.schoolNameCombox];
    
}
-(void)defineBtnPressed:(id)sender{

   XXETabBarControllerConfig * infoVC =[[XXETabBarControllerConfig alloc]init];
    [self presentViewController:infoVC animated:YES completion:nil];
    
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
//#define  kDropDownListTag 200
//
//#import "SchoolInfoViewController.h"
//#import "LMContainsLMComboxScrollView.h"
//#import "WJCommboxView.h"
//#import "LMComBoxView.h"
//@interface SchoolInfoViewController ()<LMComBoxViewDelegate>
//{
//    NSArray *schoolTypeArr;
//    UIView *schoolTypeView;
//    NSArray *schoolNameArr;
//    UIView *schoolNameView;
//    NSArray *gradeNameArr;
//    UIView *gradeNameView;
//    
//    
//    
//
//
//}
//@end
//
//@implementation SchoolInfoViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
