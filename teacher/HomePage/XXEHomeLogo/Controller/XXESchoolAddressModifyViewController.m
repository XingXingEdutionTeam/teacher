


//
//  XXESchoolAddressModifyViewController.m
//  teacher
//
//  Created by Mac on 16/8/25.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolAddressModifyViewController.h"
#import "XXESchoolAddressApi.h"


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

    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    
//    [self fetchProvinceData];
    [self customContent];
    
}

- (void)customContent{
    UILabel *areaLable = [[UILabel alloc]initWithFrame:CGRectMake(30 * kWidth / 375,70 * kWidth / 375, 92 * kWidth / 375, 30 * kWidth / 375)];
    areaLable.textAlignment = NSTextAlignmentLeft;
    areaLable.text = @"区     域";
    areaLable.font = [UIFont systemFontOfSize:14 * kWidth / 375];
    [self.view addSubview:areaLable];
    UIImageView *starImgV =[[UIImageView alloc]initWithFrame:CGRectMake(5 * kWidth / 375,73 * kWidth / 375, 20 * kWidth / 375, 20 * kWidth / 375)];
    starImgV.image =[UIImage imageNamed:@"必填符号38x38"];
    [self.view addSubview:starImgV];
    
    /**省   98  */
    
    [self createProvinceCombox];
    //    [self fetchProvinceData];
    
    /**市   99  */
    [self createCityCombox];
    
    /**区   100  */
    [self createAreaCombox];



}

/**
 *  创建 省 下拉框 10
 */
- (void)createProvinceCombox{
    self.provinceCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(100 * kWidth / 375+(80+10)*0, 70 * kWidth / 375, 80 * kWidth / 375, 30 * kWidth / 375)];
    CGRect rect =  self.provinceCombox.listTableView.frame;
    rect = CGRectMake(rect.origin.x - 10, rect.origin.y , rect.size.width + 20, rect.size.height);
    self.provinceCombox.listTableView.frame = rect;
    
    //    self.provinceCombox.listTableView =[[UITableView alloc] initWithFrame:CGRectMake(-10, 30, frame.size.width, 0) style:UITableViewStyleGrouped];
    self.provinceCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    self.provinceCombox.textField.placeholder= @"省";
    self.provinceCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.provinceCombox.textField.tag = 98;
    self.provinceCombox.dataArray = provinceArr;
    [self.provinceCombox.listTableView reloadData];
    //    }
    
    [self.view addSubview:self.provinceCombox];
    
    self.provinceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.provinceView.backgroundColor = [UIColor clearColor];
    self.provinceView.alpha = 0.5;
    UITapGestureRecognizer *provinceTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden)];
    [self.provinceView addGestureRecognizer:provinceTouch];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    
    [self.provinceCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"10"];
    
    
}


/**
 *  创建 市 下拉框 11
 */
- (void)createCityCombox{
    
    self.cityCombox = [[WJCommboxView alloc]initWithFrame:CGRectMake((100+(80+10)*1) * kWidth / 375, 70 * kWidth / 375, 80 * kWidth / 375, 30 * kWidth / 375)];
    
    CGRect rect =  self.cityCombox.listTableView.frame;
    rect = CGRectMake(rect.origin.x - 10, rect.origin.y , rect.size.width + 20, rect.size.height);
    self.cityCombox.listTableView.frame = rect;
    
    
    self.cityCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    self.cityCombox.textField.placeholder= @"市";
    self.cityCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.cityCombox.textField.tag = 99;
    [self.view addSubview:self.cityCombox];
    
    self.cityView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.cityView.backgroundColor = [UIColor clearColor];
    self.cityView.alpha = 0.5;
    UITapGestureRecognizer *cityTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden)];
    [self.cityView addGestureRecognizer:cityTouch];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    
    [self.cityCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"11"];
    
}

/**
 *  创建 区 下拉框 12
 */
- (void)createAreaCombox{
    
    self.areaCombox = [[WJCommboxView alloc]initWithFrame:CGRectMake((100+(80+10)*2) * kWidth / 375, 70 * kWidth / 375, 80 * kWidth / 375, 30 * kWidth / 375)];
    
    CGRect rect =  self.areaCombox.listTableView.frame;
    rect = CGRectMake(rect.origin.x - 10, rect.origin.y , rect.size.width + 20, rect.size.height);
    self.areaCombox.listTableView.frame = rect;
    
    self.areaCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    
    self.areaCombox.textField.placeholder= @"区";
    
    self.areaCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.areaCombox.textField.tag = 100;
    [self.view addSubview:self.areaCombox];
    
    self.areaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.areaView.backgroundColor = [UIColor clearColor];
    self.areaView.alpha = 0.5;
    UITapGestureRecognizer *areaTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden)];
    [self.areaView addGestureRecognizer:areaTouch];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    
    [self.areaCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"12"];
    
    
}


/**
 *  省
 */
//- (void)fetchProvinceData{
//    
//    /*
//     【获取省,城市,区】
//     
//     接口:
//     http://www.xingxingedu.cn/Global/provinces_city_area
//     
//     
//     传参:
//     action_type	//执行类型 1:获取省 , 2:获取城市, 3:获取区
//     fatherID	//父级id, 获取市和区需要, 获取省不需要
//     */
//    //路径
//    NSString *urlStr = @"http://www.xingxingedu.cn/Global/provinces_city_area";
//    
//    //请求参数  无
//    
//    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":XID, @"user_id":USER_ID, @"user_type":USER_TYPE, @"action_type":@"1"};
//    
//    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
//        provinceArr = [[NSMutableArray alloc] init];
//        provinceIDArray = [[NSMutableArray alloc] init];
//        //
//        //        NSLog(@"省---responseObj --- %@", responseObj);
//        /*
//         {
//         provinceID = 820000,
//         province = 澳门特别行政区
//         }
//         */
//        NSArray *dataSource = responseObj[@"data"];
//        
//        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
//        
//        if ([codeStr isEqualToString:@"1"]) {
//            
//            for (NSDictionary *dic in dataSource) {
//                
//                [provinceArr addObject:dic[@"province"]];
//                [provinceIDArray addObject:dic[@"provinceID"]];
//            }
//            
//        }else{
//            
//            
//        }
//        
//        
//        //     [self createProvinceCombox];
//        
//        //        NSLog(@"%@", provinceArr);
//        self.provinceCombox.dataArray = provinceArr;
//        [self.provinceCombox.listTableView reloadData];
//        
//    } failure:^(NSError *error) {
//        //
//        NSLog(@"%@", error);
//    }];
//}

//- (void)fetchProvinceData{
//    xxesc *redFlowerSentHistoryApi = [[XXERedFlowerSentHistoryApi alloc] initWithXid:XID user_id:USER_ID user_type:USER_TYPE page:pageStr];
//    [redFlowerSentHistoryApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        
//        //                NSLog(@"2222---   %@", request.responseJSONObject);
//        
//        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
//        
//        if ([codeStr isEqualToString:@"1"]) {
//            
//            NSDictionary *dict = request.responseJSONObject[@"data"];
//            //已赠花篮数量
//            _give_num = dict[@"give_num"];
//            
//            //剩余花篮 数量
//            _flower_able = dict[@"flower_able"];
//            
//            NSArray *modelArray = [XXERedFlowerSentHistoryModel parseResondsData:dict[@"list"]];
//            
//            [_dataSourceArray addObjectsFromArray:modelArray];
//        }else{
//            
//        }
//        
//        [self customContent];
//        
//    } failure:^(__kindof YTKBaseRequest *request) {
//        
//        [self showString:@"数据请求失败" forSecond:1.f];
//    }];
//
//
//}
//
//
///**
// *  市
// */
//- (void)fetchCityData{
//    
//    /*
//     【获取省,城市,区】
//     
//     接口:
//     http://www.xingxingedu.cn/Global/provinces_city_area
//     
//     
//     传参:
//     action_type	//执行类型 1:获取省 , 2:获取城市, 3:获取区
//     fatherID	//父级id, 获取市和区需要, 获取省不需要
//     */
//    //路径
//    NSString *urlStr = @"http://www.xingxingedu.cn/Global/provinces_city_area";
//    
//    //请求参数
//    
//    NSUInteger index;
//    NSString *fatherID;
//    
//    if (provinceStr) {
//        index = [provinceArr indexOfObject:provinceStr];
//        fatherID = provinceIDArray[index];
//    }
//    
//    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":XID, @"user_id":USER_ID, @"user_type":USER_TYPE, @"action_type":@"2", @"fatherID":fatherID};
//    
//    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
//        
//        cityArr = [[NSMutableArray alloc] init];
//        cityIDArray = [[NSMutableArray alloc] init];
//        //
//        //        NSLog(@"市----responseObj --- %@", responseObj);
//        /*
//         {
//         cityID = 110200,
//         city = 县
//         }
//         
//         */
//        NSArray *dataSource = responseObj[@"data"];
//        
//        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
//        
//        if ([codeStr isEqualToString:@"1"]) {
//            
//            for (NSDictionary *dic in dataSource) {
//                
//                [cityArr addObject:dic[@"city"]];
//                [cityIDArray addObject:dic[@"cityID"]];
//            }
//            
//        }else{
//            
//            
//        }
//        self.cityCombox.dataArray = cityArr;
//        [self.cityCombox.listTableView reloadData];
//        
//        //        //如果从 搜索界面 跳转过来  重新赋值
//        //        if (searchArray.count != 0) {
//        //         _cityCombox.textField.text = searchArray[1];
//        //         _cityCombox.textField.enabled = NO;
//        //        }
//        
//        
//    } failure:^(NSError *error) {
//        //
//        NSLog(@"%@", error);
//    }];
//    
//}
//
///**
// *  区
// */
//- (void)fetchAreaData{
//    
//    //    /*
//    //     【获取省,城市,区】
//    //
//    //     接口:
//    //     http://www.xingxingedu.cn/Global/provinces_city_area
//    //
//    //
//    //     传参:
//    //     action_type	//执行类型 1:获取省 , 2:获取城市, 3:获取区
//    //     fatherID	//父级id, 获取市和区需要, 获取省不需要
//    //     */
//    //路径
//    NSString *urlStr = @"http://www.xingxingedu.cn/Global/provinces_city_area";
//    NSUInteger index;
//    NSString *fatherID;
//    
//    if (cityStr) {
//        index = [cityArr indexOfObject:cityStr];
//        fatherID = cityIDArray[index];
//    }
//    
//    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":XID, @"user_id":USER_ID, @"user_type":USER_TYPE, @"action_type":@"3", @"fatherID":fatherID};
//    
//    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
//        
//        areaArr = [[NSMutableArray alloc] init];
//        areaIDArray = [[NSMutableArray alloc] init];
//        //
//        //                NSLog(@"区---responseObj --- %@", responseObj);
//        /*
//         {
//         areaID = 120110,
//         area = 东丽区
//         },
//         */
//        NSArray *dataSource = responseObj[@"data"];
//        
//        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
//        
//        if ([codeStr isEqualToString:@"1"]) {
//            
//            for (NSDictionary *dic in dataSource) {
//                
//                [areaArr addObject:dic[@"area"]];
//                [areaIDArray addObject:dic[@"areaID"]];
//            }
//            
//        }else{
//            
//            
//        }
//        
//        self.areaCombox.dataArray = areaArr;
//        [self.areaCombox.listTableView reloadData];
//        
//        //        //如果从 搜索界面 跳转过来  重新赋值
//        //        if (searchArray.count != 0) {
//        //            _areaCombox.textField.text = searchArray[2];
//        //            _areaCombox.textField.enabled = NO;
//        //        }
//        
//        
//    } failure:^(NSError *error) {
//        //
//        NSLog(@"%@", error);
//    }];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)submitButton:(UIButton *)sender {
    
    
}
@end
