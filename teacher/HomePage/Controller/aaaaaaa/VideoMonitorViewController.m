//
//  VideoMonitorViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/2/15.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define bgt    @"http://data.vod.itc.cn/?prod=app&new=/194/216/JBUeCIHV4s394vYk3nbgt2.mp4"
#define ktpqk  @"http://data.vod.itc.cn/?prod=app&new=/5/36/aUe9kB0906IvkI5UCpq11K.mp4"
#define hvd    @"http://data.vod.itc.cn/?prod=app&new=/10/66/eCGPkAewSVqy9P57hvB11D.mp4"
#define cpf    @"http://data.vod.itc.cn/?prod=app&new=/125/206/g586XlZhJQBGTnFDS75cPF.mp4"
#define kPData @"VedioCell"
#define tbC    @"TableHeadCell"
#import "VideoMonitorViewController.h"
//splitList
#import "LMContainsLMComboxScrollView.h"
#import "WJCommboxView.h"
#import "LMComBoxView.h"
#import "UtilityFunc.h"
#import "HHControl.h"
#import "VedioCell.h"
#import "SSVideoPlayContainer.h"
#import "VedioSaveViewController.h"
#import "SSVideoPlayController.h"
@interface VideoMonitorViewController ()<UITableViewDataSource,UITableViewDelegate,LMComBoxViewDelegate,UISearchBarDelegate,UIAlertViewDelegate>
{
    LMContainsLMComboxScrollView *bgScrollView;
    UITableView *_tableView;
    NSMutableArray *dataSourse;
    NSInteger olderValue;
    NSArray *ktArr;
    UIAlertView *_alert;
    
}
//school
@property(nonatomic,strong)NSArray *schoolTypeArr;
@property(nonatomic,strong)WJCommboxView *schoolTypeCombox;
@property(nonatomic,strong)UIView *schoolTypeView;
//grade
@property(nonatomic,strong)NSArray *classTypeArr;
@property(nonatomic,strong)WJCommboxView *classTypeCombox;
@property(nonatomic,strong)UIView *classTypeView;

@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UISearchController *searchDC;
@end

@implementation VideoMonitorViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    self.navigationController.navigationBarHidden = NO;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"视频监控";
    // self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    [self createTableView];
    [self createRightBar];
}
- (void)createRightBar{
    //searchBar
    UIBarButtonItem *searchBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"NavBarIconSearch_blue@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(searchB:)];
    
    UIBarButtonItem *rightBar =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"saveBt"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarClick:)];
    [rightBar setTintColor:UIColorFromRGB(37, 89, 33)];
    
    
    self.navigationItem.rightBarButtonItems =@[rightBar,searchBar];
    
}

//MARK: - 提示框
- (void)showAlertView {
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"校方暂未接入视频监控!" preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

- (void)searchB:(UIBarButtonItem*)btn{
    [self showAlertView];
    return;
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,20, kWidth, 44)];
    UIImage *backgroundImg = [UtilityFunc createImageWithColor:UIColorFromHex(0xf0eaf3) size:_searchBar.frame.size];
    [_searchBar setBackgroundImage:backgroundImg];
    _searchBar.placeholder =@"请输入您想查看视频位置";
    _searchBar.tintColor = [UIColor blackColor];
    _searchBar.delegate =self;
    _searchDC = [[UISearchController alloc]initWithSearchResultsController:self];
    [self.navigationItem.titleView sizeToFit];
    [self.navigationController.view addSubview:_searchBar];
    _searchBar.showsCancelButton =YES;
}
- (void)rightBarClick:(UIBarButtonItem*)btn{
    [self showAlertView];
    return;
    VedioSaveViewController *vedioVC = [[VedioSaveViewController alloc]init];
    [self.navigationController pushViewController:vedioVC animated:NO];
    
}
- (void)createTableView{
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
    [self createFootTable];
//    _tableView.tableFooterView =[[NSBundle mainBundle]loadNibNamed:tbC owner:nil options:nil][0];
    dataSourse = [[NSMutableArray alloc]init];
    ktArr =[NSArray arrayWithObjects:@"教室",@"走廊",@"操场",@"大厅",@"大门", nil];
    [dataSourse addObjectsFromArray:ktArr];
    
}
- (void)createFootTable{
    bgScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth,34)];
    bgScrollView.backgroundColor = UIColorFromRGB(229, 232, 233);
    bgScrollView.showsHorizontalScrollIndicator =NO;
    bgScrollView.showsVerticalScrollIndicator =NO;
    [self.view addSubview:bgScrollView];
    
    _tableView.tableHeaderView =bgScrollView;
    bgScrollView.userInteractionEnabled =YES;
    
    
    //学校区域
    self.schoolTypeArr = [[NSArray alloc]initWithObjects:@"教学区域",@"公共区域",nil];
    self.schoolTypeCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(0, 2, 183, 30)];
    self.schoolTypeCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    
    self.schoolTypeCombox.textField.placeholder = @"请选择学校区域";
    
    self.schoolTypeCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.schoolTypeCombox.textField.tag = 101;
    self.schoolTypeCombox.dataArray = self.schoolTypeArr;
    [bgScrollView addSubview:self.schoolTypeCombox];
    
    self.schoolTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 165, kHeight+300)];
    self.schoolTypeView.backgroundColor = [UIColor clearColor];
    self.schoolTypeView.alpha = 0.5;
    
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden)];
    [self.schoolTypeView addGestureRecognizer:singleTouch];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    
    //    [self.schoolTypeCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    //时间显示倒计时
    
    UITextField *timeTextField =[HHControl createTextFieldWithFrame:CGRectMake(290, 2, kWidth-298, 30) placeholder:@"剩余时间" passWord:NO leftImageView:nil rightImageView:nil Font:12];
    timeTextField.textAlignment =NSTextAlignmentCenter;
    [timeTextField setEnabled:NO];
    timeTextField.layer.cornerRadius =4;
    timeTextField.layer.masksToBounds =YES;
    
    timeTextField.backgroundColor =UIColorFromRGB(246, 246, 246);
    // [bgScrollView addSubview:timeTextField];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    NSString *second =[defaults objectForKey:@"time"];
    NSString *olderV =[defaults objectForKey:@"olderValue"];
    
    long seconds =[second integerValue] +[olderV integerValue];
    
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (seconds/3600 >= 1)
    {
        [formatter setDateFormat:@"HH:mm:ss"];
    }
    else
    {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    
    NSLog(@"showtimeNew::%@",showtimeNew);
    [defaults setObject:[NSString stringWithFormat:@"%ld",seconds] forKey:@"olderValue"];
    //倒计时显示
    timeTextField.text = [NSString stringWithFormat:@"%@/60:00",showtimeNew];
    //@"00:00/60:00";
    
    //年级区域
    self.classTypeArr = [[NSArray alloc]initWithObjects:@"一年级一班",@"书法班",@"美术班",@"舞蹈班", nil];
    self.classTypeCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(184, 2, 189, 30)];
    self.classTypeCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    self.classTypeCombox.textField.placeholder =@"请选择班级区域";
    self.classTypeCombox.textField.textAlignment =NSTextAlignmentLeft;
    self.classTypeCombox.textField.tag =102;
    self.classTypeCombox.dataArray =self.classTypeArr;
    [bgScrollView addSubview:self.classTypeCombox];
    
    self.classTypeView = [[UIView alloc]initWithFrame:CGRectMake(165, 0, kWidth-165, kHeight+300)];
    self.schoolTypeView.backgroundColor = [UIColor clearColor];
    self.schoolTypeView.alpha = 0.5;
    
    
    
    
}
-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox{
    
    
}
- (void)commboxAction:(NSNotification *)notif{
    switch ([notif.object integerValue]) {
        case 101:
            [self.schoolTypeCombox removeFromSuperview];
            [_tableView addSubview:self.schoolTypeView];
            [_tableView addSubview:self.schoolTypeCombox];
            break;
        case 102:
            [self.classTypeCombox removeFromSuperview];
            [_tableView addSubview:self.classTypeView];
            [_tableView addSubview:self.classTypeCombox];
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
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    //如果被观察者的对象是_playList
    if ([object isKindOfClass:[UITextField class]]) {
        //如果是name属性值发生变化
        if ([keyPath isEqualToString:@"text"]) {
            //取出name的旧值和新值
            
            NSString * newName=[change objectForKey:@"new"];
            
            if([newName isEqualToString:@"教学区域"]){
                
            }
            else  if([newName isEqualToString:@"公共区域"]){
                
            }
        }
        
    }
    
}


-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    //搜尋結束後，恢復原狀
    return YES;
}
#pragma mark - search bar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = YES;
    [searchBar resignFirstResponder];
    [searchBar removeFromSuperview];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_searchBar endEditing:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VedioCell *cell =(VedioCell*)[tableView dequeueReusableCellWithIdentifier:kPData];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:kPData owner:[VedioCell class] options:nil];
        cell = (VedioCell*)[nib objectAtIndex:0];
        
    }
    [cell.VedioBtn setBackgroundImage:[UIImage imageNamed:@"vedioimg"] forState:UIControlStateNormal];
    cell.addressLabel.text =[NSString stringWithFormat:@"%@",ktArr[indexPath.row]];
    cell.instructionLabel.text = [NSString stringWithFormat:@"说明:%@",@"暂无情况"];
    
    cell.timeLabel.text =[NSString stringWithFormat:@"%@",@"2016-04-03 12:20"];
    cell.VedioBtn.userInteractionEnabled =NO;
    return cell;
}
// 加载数据
- (void)play{
    NSArray *paths = @[bgt,
                       ktpqk,
                       hvd,
                       cpf,
                       [[NSBundle mainBundle]pathForResource:@"dzs" ofType:@"mp4"]
                       ];
    NSArray *names = @[@"教室",@"走廊",@"操场",@"大厅",@"大门"];
    NSMutableArray *videoList = [NSMutableArray array];
    for (NSInteger i = 0; i<paths.count; i++) {
        SSVideoModel *model = [[SSVideoModel alloc]init];
        model.path = paths[i];
        model.name = names[i];
        [videoList addObject:model];
    }
    SSVideoPlayController *playController = [[SSVideoPlayController alloc]initWithVideoList:videoList];
    SSVideoPlayContainer *playContainer = [[SSVideoPlayContainer alloc]initWithRootViewController:playController];
    [self presentViewController:playContainer animated:NO completion:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 0;
    }
    else{
        return 0;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self showAlertView];
    return;
    if (indexPath.row ==0) {
        NSArray *paths = @[bgt,
                           ktpqk,
                           hvd,
                           cpf,
                           [[NSBundle mainBundle]pathForResource:@"dzs" ofType:@"mp4"]
                           ];
        NSArray *names = @[@"教室",@"走廊",@"操场",@"大厅",@"大门"];
        NSMutableArray *videoList = [NSMutableArray array];
        for (NSInteger i = 0; i<paths.count; i++) {
            SSVideoModel *model = [[SSVideoModel alloc]init];
            model.path = paths[i];
            model.name = names[i];
            [videoList addObject:model];
        }
        SSVideoPlayController *playController = [[SSVideoPlayController alloc]initWithVideoList:videoList];
        SSVideoPlayContainer *playContainer = [[SSVideoPlayContainer alloc]initWithRootViewController:playController];
        [self presentViewController:playContainer animated:NO completion:nil];
        
    }
    else if (indexPath.row ==1)
    {
        
        NSArray *paths = @[ ktpqk,
                            bgt,
                            hvd,
                            cpf,
                            [[NSBundle mainBundle]pathForResource:@"dzs" ofType:@"mp4"]
                            ];
        NSArray *names = @[@"教室",@"走廊",@"操场",@"大厅",@"大门"];
        NSMutableArray *videoList = [NSMutableArray array];
        for (NSInteger i = 0; i<paths.count; i++) {
            SSVideoModel *model = [[SSVideoModel alloc]init];
            model.path = paths[i];
            model.name = names[i];
            [videoList addObject:model];
        }
        SSVideoPlayController *playController = [[SSVideoPlayController alloc]initWithVideoList:videoList];
        SSVideoPlayContainer *playContainer = [[SSVideoPlayContainer alloc]initWithRootViewController:playController];
        [self presentViewController:playContainer animated:NO completion:nil];
        
        
    }
    else if (indexPath.row ==2)
    {
        
        NSArray *paths = @[ hvd,
                            ktpqk,
                            bgt,
                            cpf,
                            [[NSBundle mainBundle]pathForResource:@"dzs" ofType:@"mp4"]
                            ];
        NSArray *names = @[@"教室",@"走廊",@"操场",@"大厅",@"大门"];
        NSMutableArray *videoList = [NSMutableArray array];
        for (NSInteger i = 0; i<paths.count; i++) {
            SSVideoModel *model = [[SSVideoModel alloc]init];
            model.path = paths[i];
            model.name = names[i];
            [videoList addObject:model];
        }
        SSVideoPlayController *playController = [[SSVideoPlayController alloc]initWithVideoList:videoList];
        SSVideoPlayContainer *playContainer = [[SSVideoPlayContainer alloc]initWithRootViewController:playController];
        playController.urlPath =paths[0];
        
        [self presentViewController:playContainer animated:NO completion:nil];
        
    }
    else if (indexPath.row ==3)
    {
        
        NSArray *paths = @[ cpf,
                            hvd,
                            ktpqk,
                            bgt,
                            [[NSBundle mainBundle]pathForResource:@"dzs" ofType:@"mp4"]
                            ];
        NSArray *names = @[@"教室",@"走廊",@"操场",@"大厅",@"大门"];
        NSMutableArray *videoList = [NSMutableArray array];
        for (NSInteger i = 0; i<paths.count; i++) {
            SSVideoModel *model = [[SSVideoModel alloc]init];
            model.path = paths[i];
            model.name = names[i];
            [videoList addObject:model];
        }
        SSVideoPlayController *playController = [[SSVideoPlayController alloc]initWithVideoList:videoList];
        SSVideoPlayContainer *playContainer = [[SSVideoPlayContainer alloc]initWithRootViewController:playController];
        playController.urlPath =paths[0];
        
        [self presentViewController:playContainer animated:NO completion:nil];
        
    }
    else{
        
        NSArray *paths = @[[[NSBundle mainBundle]pathForResource:@"dzs" ofType:@"mp4"],
                           cpf,
                           hvd,
                           ktpqk,
                           bgt                            ];
        NSArray *names = @[@"教室",@"走廊",@"操场",@"大厅",@"大门"];
        NSMutableArray *videoList = [NSMutableArray array];
        for (NSInteger i = 0; i<paths.count; i++) {
            SSVideoModel *model = [[SSVideoModel alloc]init];
            model.path = paths[i];
            model.name = names[i];
            [videoList addObject:model];
        }
        SSVideoPlayController *playController = [[SSVideoPlayController alloc]initWithVideoList:videoList];
        SSVideoPlayContainer *playContainer = [[SSVideoPlayContainer alloc]initWithRootViewController:playController];
        playController.urlPath =paths[0];
        
        [self presentViewController:playContainer animated:NO completion:nil];
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section ==4) {
        return 0;
    }
    return 0;
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
