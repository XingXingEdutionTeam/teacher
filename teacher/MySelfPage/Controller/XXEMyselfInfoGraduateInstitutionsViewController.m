//
//  XXEMyselfInfoGraduateInstitutionsViewController.m
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoGraduateInstitutionsViewController.h"
#import "XXEMyselfInfoModifyGraduateSchoolNameApi.h"
#import "LMContainsLMComboxScrollView.h"
#import "XXEMyselfInfoGraduateInstitutionsApi.h"
#import "XXEMyselfInfoGetSchoolProviceApi.h"
#import "XXEMyselfInfoGraduateInstitutionsModel.h"
#import "LMComBoxView.h"
#import "WJCommboxView.h"



@interface XXEMyselfInfoGraduateInstitutionsViewController ()<LMComBoxViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    LMContainsLMComboxScrollView *bgScrollView;
    UIView *bgView;
    
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
    //学校
    NSMutableArray *schoolModelArray;
    NSMutableArray *schoolNameArray;
    
    
    //
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@property(nonatomic, strong)WJCommboxView *provinceCombox;
//@property(nonatomic, strong)WJCommboxView *cityCombox;
//@property(nonatomic, strong)WJCommboxView *areaCombox;
@property(nonatomic, strong)WJCommboxView *schoolNameCombox;

@property(nonatomic,strong)UIView *provinceView;
@property(nonatomic,strong)UIView *cityView;
@property(nonatomic,strong)UIView *areaView;
@property(nonatomic,strong)UIView *schoolNameView;

@property (nonatomic, strong) UILabel *provinceLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *areaLabel;
@property (nonatomic, strong) UILabel *schoolNameLabel;


@end

@implementation XXEMyselfInfoGraduateInstitutionsViewController

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//
//
//}


- (void)viewDidLoad {
    [super viewDidLoad];

    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    bgScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    bgScrollView.backgroundColor = UIColorFromRGB(255, 255, 255);
    bgScrollView.showsHorizontalScrollIndicator =NO;
    bgScrollView.showsVerticalScrollIndicator =NO;
    [self.view addSubview:bgScrollView];
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    bgView.backgroundColor =UIColorFromRGB(222, 225, 226);
    [bgScrollView addSubview:bgView];
    
    
    [self fetchProvinceData];
    
    [self commBoxInfo];
    bgView.userInteractionEnabled = YES;
}


-(void)commBoxInfo{
    
    /**省   98  */
    
    [self createProvinceCombox];
    
    /**市   99  */
//    [self createCityCombox];
    
    /**区   100  */
//    [self createAreaCombox];
    
    /**
     学校名称 102
     */
    [self createSchoolNameCombox];
    
    /**
     确定按钮
     */
    [self createDefineBtn];
    
    
}
/**
 *  创建 省 下拉框 10
 */
- (void)createProvinceCombox{
    _provinceLabel=[[UILabel alloc]initWithFrame:CGRectMake(30 * kScreenRatioWidth, 40 * kScreenRatioHeight, 70 * kScreenRatioWidth, 30 * kScreenRatioHeight)];
    _provinceLabel.text=@"省";
    _provinceLabel.font = [UIFont systemFontOfSize:14];
    [bgScrollView addSubview:_provinceLabel];

    self.provinceCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(100 * kScreenRatioWidth, 40 * kScreenRatioHeight, 260 * kScreenRatioWidth, 30 * kScreenRatioHeight)];

    self.provinceCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    self.provinceCombox.textField.placeholder= @"省";
    self.provinceCombox.textField.textAlignment = NSTextAlignmentCenter;
    self.provinceCombox.textField.tag = 98;
    self.provinceCombox.dataArray = provinceArr;
    [self.provinceCombox.listTableView reloadData];
    //    }
    
    [bgScrollView addSubview:self.provinceCombox];
    
    self.provinceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.provinceView.backgroundColor = [UIColor clearColor];
    self.provinceView.alpha = 0.5;
    UITapGestureRecognizer *provinceTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden)];
    [self.provinceView addGestureRecognizer:provinceTouch];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    
    [self.provinceCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"10"];
    
    
}


///**
// *  创建 市 下拉框 11
// */
//- (void)createCityCombox{
//    _cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(30 * kScreenRatioWidth, 90 * kScreenRatioHeight, 70 * kScreenRatioWidth, 30 * kScreenRatioHeight)];
//    _cityLabel.text=@"市";
//    _cityLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
//    [bgScrollView addSubview:_cityLabel];
//    
//    self.cityCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(100 * kScreenRatioWidth, 90 * kScreenRatioWidth, 260 * kScreenRatioWidth, 30 * kScreenRatioHeight)];
//
//    self.cityCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
//    self.cityCombox.textField.placeholder= @"市";
//    self.cityCombox.textField.textAlignment = NSTextAlignmentCenter;
//    self.cityCombox.textField.tag = 99;
//    [bgScrollView addSubview:self.cityCombox];
//    
//    self.cityView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
//    self.cityView.backgroundColor = [UIColor clearColor];
//    self.cityView.alpha = 0.5;
//    UITapGestureRecognizer *cityTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden)];
//    [self.cityView addGestureRecognizer:cityTouch];
//    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
//    
//    [self.cityCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"11"];
//    
//}
//
//- (void)commboxHidden{
////    [self.schoolTypeView removeFromSuperview];
////    [self.schoolTypeCombox setShowList:NO];
////    self.schoolTypeCombox.listTableView.hidden = YES;
////    CGRect sf = self.schoolTypeCombox.frame;
////    sf.size.height = 30;
////    self.schoolTypeCombox.frame = sf;
////    CGRect frame = self.schoolTypeCombox.listTableView.frame;
////    frame.size.height = 0;
////    self.schoolTypeCombox.listTableView.frame = frame;
////    [self.schoolTypeCombox removeFromSuperview];
////    [bgScrollView addSubview:self.schoolTypeCombox];
////    
////    [self.schoolNameView removeFromSuperview];
////    [self.schoolNameCombox setShowList:NO];
////    self.schoolNameCombox.listTableView.hidden = YES;
////    CGRect sf2 = self.schoolNameCombox.frame;
////    sf2.size.height = 30;
////    self.schoolNameCombox.frame = sf2;
////    CGRect frame2 = self.schoolTypeCombox.listTableView.frame;
////    frame2.size.height = 0;
////    self.schoolNameCombox.listTableView.frame = frame2;
////    [self.schoolNameCombox removeFromSuperview];
////    [bgScrollView addSubview:self.schoolNameCombox];
//    
//}
//
///**
// *  创建 区 下拉框 12
// */
//- (void)createAreaCombox{
//    _areaLabel=[[UILabel alloc]initWithFrame:CGRectMake(30 * kScreenRatioWidth, 140 * kScreenRatioHeight, 70 * kScreenRatioWidth, 30 * kScreenRatioHeight)];
//    _areaLabel.text=@"区";
//    _areaLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
//    [bgScrollView addSubview:_areaLabel];
//
//    self.areaCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(100 * kScreenRatioWidth, 140 * kScreenRatioHeight, 260 * kScreenRatioWidth, 30 * kScreenRatioHeight)];
//
//    self.areaCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
//    
//    self.areaCombox.textField.placeholder= @"区";
//    
//    self.areaCombox.textField.textAlignment = NSTextAlignmentCenter;
//    self.areaCombox.textField.tag = 100;
//    [bgScrollView addSubview:self.areaCombox];
//    
//    self.areaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
//    self.areaView.backgroundColor = [UIColor clearColor];
//    self.areaView.alpha = 0.5;
//    UITapGestureRecognizer *areaTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden)];
//    [self.areaView addGestureRecognizer:areaTouch];
//    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
//    
//    [self.areaCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"12"];
//    
//    
//}


//学校 名称 14
- (void)createSchoolNameCombox{
    
    //    self.schoolNameArr = [[NSArray alloc]initWithObjects:@"华高小学",@"希望中学",@"北京大学",@"清华大学",nil];
    _schoolNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(30 * kScreenRatioWidth, 90 * kScreenRatioHeight, 70 * kScreenRatioWidth, 30 * kScreenRatioHeight)];
    _schoolNameLabel.text=@"学校名称";
    _schoolNameLabel.font = [UIFont systemFontOfSize:14];
    [bgScrollView addSubview:_schoolNameLabel];
    
    
    UIImageView *starIgV =[[UIImageView alloc]initWithFrame:CGRectMake(5 * kWidth / 375,79 * kWidth / 375, 20 * kWidth / 375, 20 * kWidth / 375)];
    starIgV.image =[UIImage imageNamed:@"必填符号38x38"];
    [bgScrollView addSubview:starIgV];
    self.schoolNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(100 * kWidth / 375, 94 * kWidth / 375, 260 * kWidth / 375, 30 * kWidth / 375)];
    
    self.schoolNameCombox.textField.textAlignment = NSTextAlignmentCenter;
    self.schoolNameCombox.textField.tag = 102;
    //    self.schoolNameCombox.textField.delegate = self;
    self.schoolNameCombox.textField.placeholder =@"学校名称";
    
    //    self.schoolNameCombox.dataArray = self.schoolNameArr;
    [bgScrollView addSubview:self.schoolNameCombox];
    self.schoolNameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight+300)];
    self.schoolNameView.backgroundColor = UIColorFromRGB(246, 246, 246);
    self.schoolNameView.alpha = 0.5;
    
    [self.schoolNameCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"14"];
    
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
    XXEMyselfInfoGetSchoolProviceApi *myselfInfoGetSchoolProviceApi = [[XXEMyselfInfoGetSchoolProviceApi alloc] initWithXid:parameterXid user_id:parameterUser_Id action_type:@"1" fatherID:@" "];
    [myselfInfoGetSchoolProviceApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        provinceArr = [[NSMutableArray alloc] init];
        provinceIDArray = [[NSMutableArray alloc] init];
//        NSLog(@"fff%@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
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
        [self showHudWithString:@"获取数据失败!" forSecond:1.5];
    }];
}


///**
// *  市
// */
//- (void)fetchCityData{
//    
//    /*
//     【获取省,城市,区】
//     接口:
//     http://www.xingxingedu.cn/Global/provinces_city_area
//     传参:
//     action_type	//执行类型 1:获取省 , 2:获取城市, 3:获取区
//     fatherID	//父级id, 获取市和区需要, 获取省不需要
//     */
//    NSUInteger index;
//    NSString *fatherID;
//    
//    if (provinceStr) {
//        index = [provinceArr indexOfObject:provinceStr];
//        fatherID = provinceIDArray[index];
//    }
//    XXEMyselfInfoGetSchoolProviceApi *myselfInfoGetSchoolProviceApi = [[XXEMyselfInfoGetSchoolProviceApi alloc] initWithXid:parameterXid user_id:parameterUser_Id action_type:@"2" fatherID:fatherID];
//    [myselfInfoGetSchoolProviceApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        cityArr = [[NSMutableArray alloc] init];
//        cityIDArray = [[NSMutableArray alloc] init];
//        //        NSLog(@"fff%@", request.responseJSONObject);
//        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
//        
//        if ([codeStr isEqualToString:@"1"]) {
//            NSArray *dataSource = request.responseJSONObject[@"data"];
//            for (NSDictionary *dic in dataSource) {
//                [cityArr addObject:dic[@"city"]];
//                [cityIDArray addObject:dic[@"cityID"]];
//            }
//        }else{
//            
//        }
//        self.cityCombox.dataArray = cityArr;
//        [self.cityCombox.listTableView reloadData];
//    } failure:^(__kindof YTKBaseRequest *request) {
//        //
//        [self showHudWithString:@"获取数据失败!" forSecond:1.5];
//    }];
//    
//}
//
//
///**
// *  区
// */
//- (void)fetchAreaData{
//    
//    //    /*
//    //     【获取省,城市,区】
//    //     接口:
//    //     http://www.xingxingedu.cn/Global/provinces_city_area
//    //     传参:
//    //     action_type	//执行类型 1:获取省 , 2:获取城市, 3:获取区
//    //     fatherID	//父级id, 获取市和区需要, 获取省不需要
//    //     */
//    NSUInteger index;
//    NSString *fatherID;
//    
//    if (cityStr) {
//        index = [cityArr indexOfObject:cityStr];
//        fatherID = cityIDArray[index];
//    }
//    XXEMyselfInfoGetSchoolProviceApi *myselfInfoGetSchoolProviceApi = [[XXEMyselfInfoGetSchoolProviceApi alloc] initWithXid:parameterXid user_id:parameterUser_Id action_type:@"3" fatherID:fatherID];
//    [myselfInfoGetSchoolProviceApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        areaArr = [[NSMutableArray alloc] init];
//        areaIDArray = [[NSMutableArray alloc] init];
//        //        NSLog(@"fff%@", request.responseJSONObject);
//        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
//        
//        if ([codeStr isEqualToString:@"1"]) {
//            NSArray *dataSource = request.responseJSONObject[@"data"];
//            for (NSDictionary *dic in dataSource) {
//                [areaArr addObject:dic[@"area"]];
//                [areaIDArray addObject:dic[@"areaID"]];
//            }
//        }else{
//            
//        }
//        self.areaCombox.dataArray = areaArr;
//        [self.areaCombox.listTableView reloadData];
//    } failure:^(__kindof YTKBaseRequest *request) {
//        //
//        [self showHudWithString:@"获取数据失败!" forSecond:1.5];
//    }];
//    
//}


/**
 *  学校 名称
 */
- (void)fetchSchoolNameData{
    
    /*
     【获取大学(第一次登陆完善资料需要)】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Teacher/get_university
     传参:
     province	//省     search_words	//搜索关键词
     */
    NSLog(@"%@ ------ %@ ---- %@", parameterXid, parameterUser_Id, _provinceCombox.textField.text);
    
    XXEMyselfInfoGraduateInstitutionsApi *myselfInfoGraduateInstitutionsApi = [[XXEMyselfInfoGraduateInstitutionsApi alloc] initWithXid:parameterXid user_id:parameterUser_Id province:_provinceCombox.textField.text  search_words:@""];
    [myselfInfoGraduateInstitutionsApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        schoolModelArray = [[NSMutableArray alloc] init];
        schoolNameArray = [[NSMutableArray alloc] init];
        NSLog(@"ddd %@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            NSArray *modelArray = [XXEMyselfInfoGraduateInstitutionsModel parseResondsData:request.responseJSONObject[@"data"]];
            //
            [schoolModelArray addObjectsFromArray:modelArray];
            
            for (XXEMyselfInfoGraduateInstitutionsModel *model in schoolModelArray) {
                [schoolNameArray addObject:model.name];
            }
        }else{
            
        }
        self.schoolNameCombox.dataArray = schoolNameArray;
        [self.schoolNameCombox.listTableView reloadData];
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"数据请求失败!" forSecond:1.5];
    }];

}


//确定 按钮
- (void)createDefineBtn{
    
    UIButton * defineBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 150 * kScreenRatioHeight, self.view.frame.size.width-20, 36)];
    [defineBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [defineBtn setTitleColor:UIColorFromRGB(255, 255, 255) forState:UIControlStateNormal];
    defineBtn.backgroundColor = UIColorFromRGB(0, 169, 66);
    defineBtn.layer.cornerRadius =18;
    defineBtn.layer.masksToBounds =YES;
    [defineBtn addTarget:self action:@selector(defineBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bgScrollView addSubview:defineBtn];
    
}

- (void)defineBtnPressed:(UIButton *)button{
    //学校 名称
    
//    NSLog(@"ss%@", _provinceCombox.textField.text);
    
     if([_provinceCombox.textField.text isEqualToString:@""]) {
       [self showHudWithString:@"请先完善“省”信息" forSecond:1.5];
      }else if([_schoolNameCombox.textField.text isEqualToString:@""]){
       [self showHudWithString:@"请先完善“学校”信息" forSecond:1.5];
      }else{
          [self modifySchoolNameInfo];
      }
}

- (void)modifySchoolNameInfo{
      NSInteger index = [schoolNameArray indexOfObject:_schoolNameCombox.textField.text];
        XXEMyselfInfoGraduateInstitutionsModel *model = schoolModelArray[index];
    
//    NSLog(@"%@", model.graduateInstitutionId);
    XXEMyselfInfoModifyGraduateSchoolNameApi *myselfInfoModifyGraduateSchoolNameApi = [[XXEMyselfInfoModifyGraduateSchoolNameApi alloc] initWithXid:parameterXid user_id:parameterUser_Id graduate_sch_id:model.graduateInstitutionId];
    
    [myselfInfoModifyGraduateSchoolNameApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//                NSLog(@"%@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"提交成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //
                self.returnStrBlock(_schoolNameCombox.textField.text);
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
//                    [self fetchCityData];
                
                //获取 学校 名称
                [self fetchSchoolNameData];

            }else{
                
                
            }
            
        }
            break;
//        case 11:
//        {
//            //市
//            if (_provinceCombox.textField.text) {
//                if ([keyPath isEqualToString:@"text"]) {
//                    NSString * newName=[change objectForKey:@"new"];
//                    if (newName) {
//                        cityStr = newName;
//                    }
//                        //获取 区 数据
//                        [self fetchAreaData];
//                }
//            }else{
//                [self showHudWithString:@"请先完善“省”信息" forSecond:1.5];
//            }
//            
//        }
//            break;
//        case 12:
//        {
//            //区
//            if (_cityCombox.textField.text) {
//                if ([keyPath isEqualToString:@"text"]) {
//                    NSString * newName=[change objectForKey:@"new"];
//                    if (newName) {
//                        areaStr = newName;
//                    }
//                    [self fetchSchoolNameData];
//                    
//                }
//            }else{
//            [self showHudWithString:@"请先完善“市”信息" forSecond:1.5];
//                
//            }
//        }
//            break;
//            
//                case 14:
//        {
//
//            
//        }
//            break;
        default:
            break;
    }
    
    
}




- (void)commboxAction:(NSNotification *)notif{
//    switch ([notif.object integerValue]) {
//        case 101:
//            [self.self.schoolTypeCombox removeFromSuperview];
//            [bgScrollView addSubview:self.schoolTypeView];
//            [bgScrollView addSubview:self.schoolTypeCombox];
//            break;
//        case 102:
//            [self.self.schoolNameCombox removeFromSuperview];
//            [bgScrollView addSubview:self.schoolNameCombox];
//            [bgScrollView addSubview:self.schoolNameCombox];
//            break;
//        case 105:
//            [self.self.trainSubjectCombox removeFromSuperview];
//            [bgScrollView addSubview:self.trainSubjectCombox];
//            [bgScrollView addSubview:self.trainSubjectCombox];
//            break;
//        default:
//            break;
//    }
    
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.provinceCombox.textField removeObserver:self forKeyPath:@"text"];
    
//    [self.cityCombox.textField removeObserver:self forKeyPath:@"text"];
//    
//    [self.areaCombox.textField removeObserver:self forKeyPath:@"text"];
    
    [self.schoolNameCombox.textField removeObserver:self forKeyPath:@"text"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
