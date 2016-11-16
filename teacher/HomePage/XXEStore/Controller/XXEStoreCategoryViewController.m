
//
//  XXEStoreCategoryViewController.m
//  teacher
//
//  Created by Mac on 16/11/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStoreCategoryViewController.h"
#import "XXEStoreGoodClassApi.h"
#import "XXEStoreGoodClassModel.h"
#import "XXEStoreGoodInfoModel.h"
#import "MultilevelMenu.h"

@interface XXEStoreCategoryViewController ()<UISearchBarDelegate>
{

    //
    NSMutableArray *classModelArray;
    //
    NSMutableArray *goodInfoModelArray;
    //
    UISearchBar *_searchBar;
    //
    NSString *rowStr;
    //
    MultilevelMenu * menuView;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@end

@implementation XXEStoreCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XXEBackgroundColor;
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    classModelArray = [[NSMutableArray alloc] init];
    goodInfoModelArray = [[NSMutableArray alloc] init];
    
    //请求 所有 数据
    [self fetchAllNetData];

   //创建 搜索框
    [self createScearchBar];


}

#pragma mark =========== 请求 所有 数据 ==========
- (void)fetchAllNetData{

    XXEStoreGoodClassApi *storeGoodClassApi = [[XXEStoreGoodClassApi alloc] initWithXid:parameterXid user_id:parameterUser_Id];
    [storeGoodClassApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
//        NSLog(@"%@", request.responseJSONObject);
        
        NSString *codeStr = request.responseJSONObject[@"code"];
        if ([codeStr integerValue] == 1) {
            NSArray *arr = [[NSArray alloc] init];
            arr = [XXEStoreGoodClassModel parseResondsData:request.responseJSONObject[@"data"]];
            [classModelArray addObjectsFromArray:arr];
        }
        //接受通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectIndex:) name:@"selectIndex" object:nil];
        
        XXEStoreGoodClassModel *model = classModelArray[0];
        [self pickUpCategoryDetailed:model.category_id search:@""];
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"获取数据失败!" forSecond:1.5];
    }];

}

//通知相应事件
-(void)selectIndex:(NSNotification *)text{
    
    [_searchBar resignFirstResponder];
    
    NSString *teacherName =[NSString stringWithFormat:@"%@", text.userInfo[@"selectIndex"]];
    
    XXEStoreGoodClassModel *model = classModelArray[[teacherName integerValue]];
    [self pickUpCategoryDetailed:model.category_id search:@""];
    rowStr = teacherName;
    MultilevelMenu *menu = [[MultilevelMenu alloc] init];
    [menu.rightCollection reloadData];
}
#pragma mark ********** 请求 搜索 数据 ************
- (void)pickUpCategoryDetailed:(NSString *)class search:(NSString *)searchWords{
    if (goodInfoModelArray.count != 0) {
        [goodInfoModelArray removeAllObjects];
    }
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/coin_goods";
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"class":class,
                           @"search_words":searchWords,
                           };
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
//                NSLog(@"vvvv %@", responseObj);
        if ([responseObj[@"code"]  integerValue] == 1) {
            
            NSArray *array = [[NSArray alloc] init];
            array  = [XXEStoreGoodInfoModel parseResondsData:responseObj[@"data"]];
            [goodInfoModelArray addObjectsFromArray:array];
            
        }else if ([responseObj[@"code"]  integerValue] == 3){
        
            [self showHudWithString:@"暂无数据!" forSecond:1.5];
        }
        
        [self createContent];
        
    } failure:^(NSError *error) {
        //
        [self showHudWithString:@"网络不通,请检查网络!" forSecond:1.5];
    }];
}


- (void)createScearchBar{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 48)];
    bgImageView.image = [UIImage imageNamed:@"lightgraybg"];
    
    bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:bgImageView];
    
    //搜索框
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(8, 9, WinWidth-16, 30)];
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.placeholder =@"寻找喜欢的商品";
    _searchBar.delegate = self;
    _searchBar.userInteractionEnabled = YES;
    [_searchBar setShowsCancelButton:YES];
    _searchBar.returnKeyType = UIReturnKeyDone;
    [[[[ _searchBar.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
    [ _searchBar setBackgroundColor :[ UIColor clearColor]];
    [self.view addSubview:_searchBar];

}


#pragma mark ---------- 创建 分类 -----------
- (void)createContent{
    
    if (goodInfoModelArray.count == 0) {
        
        if (menuView.rightCollection) {
            [menuView.rightCollection removeFromSuperview];
        }
        
        //暂无数据
        UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth / 3 * 2 - myImageWidth / 2, (KScreenHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];

    }else{
        //展示 数据
        [self searchResultShow];
        
    }
    

}

//分类类目====================================================
- (void)searchResultShow{
    
    if (menuView) {
        [menuView removeFromSuperview];
    }
    
    NSMutableArray * lis=[NSMutableArray arrayWithCapacity:0];
    
    NSLog(@"classModelArray == %@", goodInfoModelArray);
    
    NSInteger countMax= classModelArray.count;
    for (int i=0; i<countMax; i++) {
        rightMeun * meun=[[rightMeun alloc] init];
        XXEStoreGoodClassModel *model = classModelArray[i];
        meun.meunName = model.category_name;
        NSMutableArray * sub=[NSMutableArray arrayWithCapacity:0];
        for ( int j=0; j <1; j++) {
            rightMeun * meun1=[[rightMeun alloc] init];
            
            XXEStoreGoodClassModel *model1 = classModelArray[j];
            meun1.meunName = model1.category_name;
            [sub addObject:meun1];
            
            NSMutableArray *zList=[NSMutableArray arrayWithCapacity:0];
            for ( int z=0; z <goodInfoModelArray.count; z++) {
                rightMeun * meun2=[[rightMeun alloc] init];
                XXEStoreGoodInfoModel *model2 = goodInfoModelArray [z];
                
                meun2.meunName = model2.title;
                meun2.urlName = [NSString stringWithFormat:@"%@%@", kXXEPicURL, model2.goods_pic];
                meun2.price = model2.price;
                meun2.sale_num = model2.sale_num;
                meun2.ID = model2.good_id;
                
                [zList addObject:meun2];
            }
            meun1.nextArray=zList;
        }
        meun.nextArray = sub;
        [lis addObject:meun];
        ;
    }
    
    
    /**
     *  适配 ios 7 和ios 8 的 坐标系问题
     */
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    /**
     默认是 选中第一行
     */
//    if (menuView) {
//        [menuView removeFromSuperview];
//    }
    
    menuView =[[MultilevelMenu alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, KScreenHeight-50) WithData:lis withSelectIndex:^(NSInteger left, NSInteger right,rightMeun* info) {
        
        //        ArticleInfoViewController*vc=  [[ArticleInfoViewController alloc]init];
        //        vc.orderNum = info.ID;
        //        [self.navigationController pushViewController:vc animated:YES];
    }];
    menuView.leftSelectColor=UIColorFromRGB(133, 199, 1);
    menuView.leftUnSelectBgColor=[UIColor whiteColor];
    menuView.leftBgColor=[UIColor whiteColor];
    menuView.needToScorllerIndex = [rowStr intValue];
    menuView.isRecordLastScroll = YES;
    [self.view addSubview:menuView];


}
                           
 -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   [self.view endEditing:YES];
}
                           
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self pickUpCategoryDetailed:@"" search:searchBar.text];
    
    [_searchBar resignFirstResponder];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
