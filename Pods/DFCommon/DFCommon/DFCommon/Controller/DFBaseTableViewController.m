//
//  HCBaseTableViewController.m
//  Heacha
//
//  Created by Allen Zhong on 15/1/12.
//  Copyright (c) 2015年 Datafans Inc. All rights reserved.
//

#import "DFBaseTableViewController.h"


@implementation DFBaseTableViewController

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.style = UITableViewStylePlain;
        self.refreshControlType = DFTableViewRefreshControlTypeMJ;
        self.bAddHeader = NO;
        self.bAddFooter = NO;
        
        self.topOffset=0;
        self.bottomOffset=0;
        
        _refreshControlDic = [NSMutableDictionary dictionary];
        
        [_refreshControlDic setObject:[DFTableViewNativeRefreshControl class] forKey:[NSNumber numberWithInteger:DFTableViewRefreshControlTypeNative]];
        [_refreshControlDic setObject:[DFTableViewMJRefreshControl class] forKey:[NSNumber numberWithInteger:DFTableViewRefreshControlTypeMJ]];
        [_refreshControlDic setObject:[DFTableViewMJRefreshPlainControl class] forKey:[NSNumber numberWithInteger:DFTableViewRefreshControlTypeMJPlain]];
        [_refreshControlDic setObject:[DFTableViewODRefreshControl class] forKey:[NSNumber numberWithInteger:DFTableViewRefreshControlTypeOD]];
    }
    return self;
}


-(void)dealloc
{
    
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self initTableView];
    
}


-(void) initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:_style];
    if (_tableBackgroudColor) {
        _tableView.backgroundColor = _tableBackgroudColor;
    }
    
    _tableView.contentInset = UIEdgeInsetsMake(_topOffset, 0.0, _bottomOffset, 0.0);
    _tableView.scrollIndicatorInsets=UIEdgeInsetsMake(_topOffset, 0.0, _bottomOffset, 0.0);
    
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    //顶部刷新 底部加载更多
    [self initRefreshControl];
}


-(void) initRefreshControl
{
    if (_refreshControl == nil && ( _bAddFooter || _bAddHeader)) {
        _refreshControl = [self getRefreshControl: self.refreshControlType];
    }

    if (self.refreshControlType == DFTableViewRefreshControlTypeOD) {
        ((DFTableViewODRefreshControl *)_refreshControl).topOffset = self.topOffset+64;
    }
    _refreshControl.tableView = _tableView;
    _refreshControl.delegate = self;
    
    
    if (_bAddHeader) {
        
        [_refreshControl addHeader];
        
    }
    
    if (_bAddFooter) {
        [_refreshControl addFooter];
    }
    
}


-(DFTableViewRefreshControl *) getRefreshControl:(DFTableViewRefreshControlType) type
{
    Class clazz = [_refreshControlDic objectForKey:[NSNumber numberWithInteger:type]];
    
    DFTableViewRefreshControl  *control = (DFTableViewRefreshControl *)[[clazz alloc] init];
    
    return control;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_bAutoRefresh) {
        [self autoRefresh];
    }
    
    if (_bAutoLoadMore) {
    }
}


-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
    
}

#pragma mark - Method

-(void) autoRefresh
{
    [_refreshControl autoRefresh];
    
}

-(void) startRefresh
{
    
}


-(void) startLoadMore
{
    
}

-(void) endRefresh
{
    [_refreshControl endRefresh];
}
-(void) endLoadMore
{
    [_refreshControl endLoadMore];
}


-(void) loadOver
{
    [_refreshControl loadOver];
    
}




#pragma - mark DFDataServiceDelegate


-(void)onRequestError:(NSError *)error dataService:(DFBaseDataService *)dataService
{
    [super onRequestError:error dataService:dataService];
    
    //BOOL reload = self.refreshFooterControlType == DFTableViewRefreshControlTypeEGO?YES:NO;
    [self onEnd:NO];
}

-(void)onStatusError:(DFBaseResponse *)response dataService:(DFBaseDataService *)dataService
{
    [super onStatusError:response dataService:dataService];
    
    //BOOL reload = self.refreshFooterControlType == DFTableViewRefreshControlTypeEGO?YES:NO;
    [self onEnd:NO];
}

- (void)onStatusOk:(DFBaseResponse *)response dataService:(DFBaseDataService *)dataService
{
    [super onStatusOk:response dataService:dataService];
    
    [self onEnd:YES];
    
}


-(void) onEnd:(BOOL)reload
{
    if (_bAddHeader) {
        [self endRefresh];
    }
    
    if (_bAddFooter) {
        [self endLoadMore];
    }
    
    if (reload) {
        [self.tableView reloadData];
    }
}



@end
