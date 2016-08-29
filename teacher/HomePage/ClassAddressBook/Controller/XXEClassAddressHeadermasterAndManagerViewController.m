



//
//  XXEClassAddressHeadermasterAndManagerViewController.m
//  teacher
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEClassAddressHeadermasterAndManagerViewController.h"
#import "XXEClassAddressHeadermasterAndManagerApi.h"
#import "XXEClassAddressHeadermasterAndManagerModel.h"
#import "XXEClassAddressEveryclassInfoViewController.h"


@interface XXEClassAddressHeadermasterAndManagerViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
}

@property (nonatomic, copy) NSString *selectedClassId;

@end

@implementation XXEClassAddressHeadermasterAndManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = XXEColorFromRGB(0, 170, 42);
    self.navigationController.navigationBarHidden = NO;
    
    self.title = @"通讯录";
    
    [self createTableView];
    
    [self fetchNetData];
}

- (void)fetchNetData{
    /*
     【某个学校所有班级名称列表(当身份时校长和管理员时用到)】
     
     接口类型:1
     
     接口:
     http://www.xingxingedu.cn/Teacher/school_all_class
     
     传参:
     school_id	//学校id
     school_type	//学校类型 */
//    NSLog(@"%@ --  %@", _schoolId, _schoolType);
    
    XXEClassAddressHeadermasterAndManagerApi *classAddressHeadermasterAndManagerApi = [[XXEClassAddressHeadermasterAndManagerApi alloc] initWithXid:XID user_id:USER_ID user_type:USER_TYPE school_id:_schoolId school_type:_schoolType];
    [classAddressHeadermasterAndManagerApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        _dataSourceArray = [[NSMutableArray alloc] init];
//        NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSDictionary *dict = request.responseJSONObject[@"data"];
            
            NSArray *modelArray = [XXEClassAddressHeadermasterAndManagerModel parseResondsData:dict];
            
            [_dataSourceArray addObjectsFromArray:modelArray];
        }else{
            
        }
        
        [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}


// 有数据 和 无数据 进行判断
- (void)customContent{
    
    if (_dataSourceArray.count == 0) {
        
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 1、无数据的时候
        UIImage *myImage = [UIImage imageNamed:@"人物"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth / 2 - myImageWidth / 2, (KScreenHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];
        
    }else{
        //2、有数据的时候
        [_myTableView reloadData];
        
    }
    
}


- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 44) style:UITableViewStyleGrouped];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];
    
}

#pragma mark
#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSourceArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    XXEClassAddressHeadermasterAndManagerModel *model = _dataSourceArray[indexPath.row];
    cell.textLabel.text = model.class_name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XXEClassAddressEveryclassInfoViewController *classAddressEveryclassInfoVC = [[XXEClassAddressEveryclassInfoViewController alloc] init];
    XXEClassAddressHeadermasterAndManagerModel *model = _dataSourceArray[indexPath.row];
    classAddressEveryclassInfoVC.schoolId = _schoolId;
    classAddressEveryclassInfoVC.selectedClassId = model.class_id;
    [self.navigationController pushViewController:classAddressEveryclassInfoVC animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
