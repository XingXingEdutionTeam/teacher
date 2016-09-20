//
//  XXELocationAddController.m
//  teacher
//
//  Created by codeDing on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXELocationAddController.h"
#import "XXELocationModel.h"

@interface XXELocationAddController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    UITableView *_tableView;
    NSMutableArray *dataArray;
    NSMutableArray *titleArray;
    NSString *localText;
}
/** 城市的数据源 */
@property (nonatomic, strong)NSMutableArray *locationDatasource;
/** 经度 */
@property (nonatomic, copy)NSString *longitudeString;
/** 纬度 */
@property (nonatomic, copy)NSString *latitudeString;

/** 城市名字 */
@property (nonatomic, copy)NSString *cityName;

@property (nonatomic, strong)CLLocationManager *locationManager;

@end

@implementation XXELocationAddController

- (NSMutableArray *)locationDatasource
{
    if (!_locationDatasource) {
        _locationDatasource = [NSMutableArray array];
    }
    return _locationDatasource;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    //获取经纬度或者城市
    [self setupCityName];
}

- (void)setupCityName
{
    //    判断定位操作是否允许
        if ([CLLocationManager locationServicesEnabled])
        {
            //定位初始化
            _locationManager = [[CLLocationManager alloc]init];
            _locationManager.delegate = self;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            _locationManager.distanceFilter = 10000;//横向移动距离更新
            [_locationManager requestWhenInUseAuthorization];
            //定位开始
            [_locationManager startUpdatingLocation];
        }else{
            //提示用户无法定位操作
            [self initAlertWithTitle:@"温馨提醒" Message:@"您尚未开启定位是否开启" ActionTitle:@"开启" CancelTitle:@"取消" URLS:@"prefs:root=LOCATION_SERVICES"];
        }
}
    
- (void)initAlertWithTitle:(NSString *)title Message:(NSString *)message ActionTitle:(NSString *)actionTitle CancelTitle:(NSString *)cancelTitle URLS:(NSString *)urls
    {
        //提示用户无法定位操作
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"确定操作");
            NSURL*url=[NSURL URLWithString:urls];
            [[UIApplication sharedApplication] openURL:url];
        }];
        if (cancelTitle==nil) {
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消操作");
            }];
            [alert addAction:okAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
#pragma mark - CoreLocationdelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
    {
        CLLocation *currentLocation = [locations lastObject];
        NSLog(@"经度%f",currentLocation.coordinate.longitude);
        NSLog(@"纬度%f",currentLocation.coordinate.latitude);
        _longitudeString = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
        _latitudeString = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
        //获取当前所在城市的名字
        CLGeocoder *geocoder = [[CLGeocoder alloc]init];
        //根据经纬度反向地理编译出地址信息
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (placemarks.count>0) {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                //获取城市
                NSString *city = placemark.locality;
                NSLog(@"#######%@",city);
                if (!city) {
                    //直辖市的城市信息不能通过locality获得，只能获取省份的方法获得如果city为nil 就知道是直辖市
                    city = placemark.administrativeArea;
                }
                _cityName = city;
                NSLog(@"定位完成%@",_cityName);
                //系统会一致更新数据，直到选择停止更新，因为只需要一次经纬度就可以，获取后就停止刷新
                [manager stopUpdatingLocation];
//                //获取数据
                [self locationPlaceMessage];
            }else if (error == nil && [placemarks count] == 0){
                NSLog(@"定位不成功");
            }else if (error != 0){
                NSLog(@"哈哈%@",error);
            }
        }];

}
/** 这两个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0, 170, 42);
   
    self.title =@"所在位置";
    // Do any additional setup after loading the view.
    [self createTableView];
    
}

#pragma mark - 获取数据
- (void)locationPlaceMessage
{
    NSString *strngXid;
    NSString *homeUserId;
    if ([XXEUserInfo user].login) {
        strngXid = [XXEUserInfo user].xid;
        homeUserId = [XXEUserInfo user].user_id;
    }else {
        strngXid = XID;
        homeUserId = USER_ID;
    }
    NSDictionary *dict = @{@"lng":_longitudeString,
                           @"lat":_latitudeString,
                           @"city":_cityName,
                           @"xid":strngXid,
                           @"user_id":homeUserId,
                           @"appkey":APPKEY,
                           @"user_type":USER_TYPE,
                           @"backtype":BACKTYPE
                           };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://www.xingxingedu.cn/Global/mycircle_nearby" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"%@",responseObject);
        NSLog(@"%@",[responseObject objectForKey:@"msg"]);
        NSString *code = [responseObject objectForKey:@"code"];
        if ([code integerValue]==1) {
            NSArray *data = [responseObject objectForKey:@"data"];
            for (int i =0; i<data.count; i++) {
                XXELocationModel *model = [[XXELocationModel alloc]initWithDictionary:data[i] error:nil];
                [self.locationDatasource addObject:model];
            }
//            [_tableView reloadData];
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

- (void)createTableView{
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64) style:UITableViewStylePlain];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];

}

- (void)upBtn{
    //    NSLog(@"搜索");
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.locationDatasource.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString *cellID =@"cellID";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    if (indexPath.row==0) {
        cell.textLabel.text =@"不显示位置";
    }
    else{
        XXELocationModel *model = self.locationDatasource[indexPath.row]
        ;
        cell.textLabel.text = model.address;
        cell.detailTextLabel.text = model.name;
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        localText =@"所在位置";
    }
    else{
        XXELocationModel *model = self.locationDatasource[indexPath.row];
        localText = model.address;
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)returnText:(ReturnTextBlock)block{
    self.returnTextBlock =block;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    self.returnTextBlock(localText);
    
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
