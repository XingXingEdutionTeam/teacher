


//
//  XXESchoolAddressModifyViewController.m
//  teacher
//
//  Created by Mac on 16/8/25.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolAddressModifyViewController.h"
#import "XXEModifySchoolAddressApi.h"
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
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
    NSString *newShoolAddressStr;
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
    
    newShoolAddressStr = @"";
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

    [self fetchProvinceData];
    [self customContent];
    
}

- (void)customContent{
    UILabel *areaLable = [[UILabel alloc]initWithFrame:CGRectMake(10 * kWidth / 375,40 * kWidth / 375, 50 * kWidth / 375, 30 * kWidth / 375)];
    areaLable.textAlignment = NSTextAlignmentLeft;
    areaLable.text = @"区 域";
    areaLable.font = [UIFont systemFontOfSize:14 * kWidth / 375];
    [self.view addSubview:areaLable];
    
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
    self.provinceCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(50 * kWidth / 375+(100+5)*0, 40 * kWidth / 375, 100 * kWidth / 375, 30 * kWidth / 375)];
    CGRect rect =  self.provinceCombox.listTableView.frame;
    rect = CGRectMake(rect.origin.x - 10, rect.origin.y , rect.size.width + 20, rect.size.height);
    self.provinceCombox.listTableView.frame = rect;
    
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
    UITapGestureRecognizer *provinceTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden1)];
    [self.provinceView addGestureRecognizer:provinceTouch];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    
    [self.provinceCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"10"];
    
    
}


/**
 *  创建 市 下拉框 11
 */
- (void)createCityCombox{
    
    self.cityCombox = [[WJCommboxView alloc]initWithFrame:CGRectMake((50+(100+5)*1) * kWidth / 375, 40 * kWidth / 375, 100 * kWidth / 375, 30 * kWidth / 375)];
    
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
    UITapGestureRecognizer *cityTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden2)];
    [self.cityView addGestureRecognizer:cityTouch];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    
    [self.cityCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"11"];
    
}

/**
 *  创建 区 下拉框 12
 */
- (void)createAreaCombox{
    
    self.areaCombox = [[WJCommboxView alloc]initWithFrame:CGRectMake((50+(100+5)*2) * kWidth / 375, 40 * kWidth / 375, 100 * kWidth / 375, 30 * kWidth / 375)];
    
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
    UITapGestureRecognizer *areaTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden3)];
    [self.areaView addGestureRecognizer:areaTouch];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    
    [self.areaCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"12"];
}


- (void)commboxAction:(NSNotification *)notif{
    switch ([notif.object integerValue]) {
        case 98:
        {
            
            [self.provinceCombox removeFromSuperview];
            
            [self.view addSubview:self.provinceView];
            [self.view addSubview:self.provinceCombox];
            
        }
            break;
        case 99:
        {
            
            [self.cityCombox removeFromSuperview];
            [self.view addSubview:self.cityView];
            [self.view addSubview:self.cityCombox];
        }
            break;
        case 100:
        {
            
            [self.areaCombox removeFromSuperview];
            [self.view addSubview:self.areaView];
            [self.view addSubview:self.areaCombox];
        }
            break;
        default:
            break;
    }
    
}


- (void)commboxHidden1{
    [self.provinceView removeFromSuperview];
    [self.provinceCombox setShowList:NO];
    self.provinceCombox.listTableView.hidden = YES;
}
- (void)commboxHidden2{
    [self.cityView removeFromSuperview];
    [self.cityCombox setShowList:NO];
    self.cityCombox.listTableView.hidden = YES;
    
}

- (void)commboxHidden3{
    [self.areaView removeFromSuperview];
    [self.areaCombox setShowList:NO];
    self.areaCombox.listTableView.hidden = YES;

}


/**
 *  省
 */
- (void)fetchProvinceData{

    /*
     【获取省,城市,区】

     接口:
     http://www.xingxingedu.cn/Global/provinces_city_area


     传参:
     action_type	//执行类型 1:获取省 , 2:获取城市, 3:获取区
     fatherID	//父级id, 获取市和区需要, 获取省不需要
     */
    
    XXESchoolAddressApi *schoolAddressApi = [[XXESchoolAddressApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE action_type:@"1" fatherID:@""];
    [schoolAddressApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        NSLog(@"%@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        provinceArr = [[NSMutableArray alloc] init];
        provinceIDArray = [[NSMutableArray alloc] init];
        
        if ([codeStr isEqualToString:@"1"]) {
             NSArray *dataSource = request.responseJSONObject[@"data"];
            for (NSDictionary *dic in dataSource) {
                
                [provinceArr addObject:dic[@"province"]];
                [provinceIDArray addObject:dic[@"provinceID"]];
            }
        }else{
        
        
        }
        self.provinceCombox.dataArray = provinceArr;
        [self.provinceCombox.listTableView reloadData];
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"数据请求失败" forSecond:1.5];
    }];
    
}


/**
 *  市
 */
- (void)fetchCityData{

    NSUInteger index;
    NSString *fatherID;
    
    if (provinceStr) {
        index = [provinceArr indexOfObject:provinceStr];
        fatherID = provinceIDArray[index];
    }
    XXESchoolAddressApi *schoolAddressApi = [[XXESchoolAddressApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE action_type:@"2" fatherID:fatherID];
    [schoolAddressApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        NSLog(@"市 -- %@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        cityArr = [[NSMutableArray alloc] init];
        cityIDArray = [[NSMutableArray alloc] init];
        
        if ([codeStr isEqualToString:@"1"]) {
            NSArray *dataSource = request.responseJSONObject[@"data"];
            for (NSDictionary *dic in dataSource) {
                
                [cityArr addObject:dic[@"city"]];
                [cityIDArray addObject:dic[@"cityID"]];
            }
        }else{
            
            
        }
        self.cityCombox.dataArray = cityArr;
        [self.cityCombox.listTableView reloadData];
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"数据请求失败" forSecond:1.5];
    }];

}

/**
 *  区
 */
- (void)fetchAreaData{

    NSUInteger index;
    NSString *fatherID;
    
    if (cityStr) {
        index = [cityArr indexOfObject:cityStr];
        fatherID = cityIDArray[index];
    }
    XXESchoolAddressApi *schoolAddressApi = [[XXESchoolAddressApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE action_type:@"3" fatherID:fatherID];
    [schoolAddressApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//                NSLog(@"区 --  %@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        areaArr = [[NSMutableArray alloc] init];
        areaIDArray = [[NSMutableArray alloc] init];
        
        if ([codeStr isEqualToString:@"1"]) {
            NSArray *dataSource = request.responseJSONObject[@"data"];
            for (NSDictionary *dic in dataSource) {
                
                [areaArr addObject:dic[@"area"]];
                [areaIDArray addObject:dic[@"areaID"]];
            }
        }else{
            
            
        }
        self.areaCombox.dataArray = areaArr;
        [self.areaCombox.listTableView reloadData];
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"数据请求失败" forSecond:1.5];
    }];

    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    switch ([[NSString stringWithFormat:@"%@",context] integerValue]) {
        case 10:
        {
            //省
            if ([keyPath isEqualToString:@"text"]) {
                NSString * newName=[change objectForKey:@"new"];
                if (newName) {
                    provinceStr = newName;
                }
                //获取 城市 数据
                [self fetchCityData];

            }else{
            
            }
            
        }
            break;
        case 11:
        {
            //市
            
            if (_provinceCombox.textField.text) {
                if ([keyPath isEqualToString:@"text"]) {
                    NSString * newName=[change objectForKey:@"new"];
                    if (newName) {
                        cityStr = newName;
                    }
                        
                 //获取 区 数据
                 [self fetchAreaData];
                }
            }else{
            [self showHudWithString:@"请先完善“省”信息" forSecond:1.5];
            }
            
        }
            break;

        default:
            break;
    }
    
}



- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.provinceCombox.textField removeObserver:self forKeyPath:@"text"];
    
    [self.cityCombox.textField removeObserver:self forKeyPath:@"text"];
    
    [self.areaCombox.textField removeObserver:self forKeyPath:@"text"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)submitButton:(UIButton *)sender {
    
    if ([_provinceCombox.textField.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善省" forSecond:1.5];
    }else if ([_cityCombox.textField.text isEqualToString:@""]){
        [self showHudWithString:@"请完善市" forSecond:1.5];
    }else if ([_areaCombox.textField.text isEqualToString:@""]){
        [self showHudWithString:@"请完善区" forSecond:1.5];
    }else if ([_schoolAddressTextView.text isEqualToString:@""]){
    
        [self showHudWithString:@"请完善详细信息" forSecond:1.5];
    }else{
        newShoolAddressStr = [NSString stringWithFormat:@"%@%@%@%@", _provinceCombox.textField.text, _cityCombox.textField.text, _areaCombox.textField.text, _schoolAddressTextView.text];
    
        [self submitNewSchoolAddressInfo];
    }
    
    
}

- (void)submitNewSchoolAddressInfo{
    XXEModifySchoolAddressApi *modifySchoolAddressApi = [[XXEModifySchoolAddressApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE school_id:_schoolId position:_position province:_provinceCombox.textField.text city:_cityCombox.textField.text district:_areaCombox.textField.text address:_schoolAddressTextView.text];
    

    [modifySchoolAddressApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"提交成功!" forSecond:1.5];
                        
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //
                self.returnStrBlock(newShoolAddressStr);
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            
        }

    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"提交失败" forSecond:1.5];
    }];


}

- (void)returnStr:(ReturnStrBlock)block{
    self.returnStrBlock = block;
}


@end
