//
//  XXEFlowerbasketApi.m
//  teacher
//
//  Created by Mac on 16/8/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFlowerbasketApi.h"

@interface XXEFlowerbasketApi()

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *appkey;
@property (nonatomic, copy) NSString *backtype;
@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *page;



@end


@implementation XXEFlowerbasketApi

/**
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":XID, @"user_id":USER_ID, @"user_type":USER_TYPE, @"search_words":_searchController.searchBar.text};
 */
//- (instancetype)initWithUrlString:(NSString *)url appkey:(NSString *)  page:(NSString *)page {
//    self = [super init];
//    if (self) {
//        _url = url;
//        _page = page;
//    }
//    return self;
//}

- (instancetype)initWithUrlString:(NSString *)url appkey:(NSString *)appkey backtype:(NSString *)backtype xid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type page:(NSString *)page{

    if (self = [super init]) {
        _url = url;
        _appkey = appkey;
        _backtype = backtype;
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        _page = page;
    }
    return self;
}


- (NSString *)requestUrl{
    
//    return @"http://www.xingxingedu.cn/Teacher/give_fbasket_record";
    return [NSString stringWithFormat:@"http://www.xingxingedu.cn/Teacher/give_fbasket_record"];
    
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPost;
    
}


- (id)requestArgument{
    
    return @{@"url":self.url,
             @"page":_page
             };
    
}

@end
