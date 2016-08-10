//
//  XXEFlowerbasketApi.h
//  teacher
//
//  Created by Mac on 16/8/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//


#import <YTKNetwork/YTKRequest.h>

@interface XXEFlowerbasketApi : YTKRequest


 /**
 NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":XID, @"user_id":USER_ID, @"user_type":USER_TYPE, @"search_words":_searchController.searchBar.text};
 */

- (instancetype)initWithUrlString:(NSString *)url appkey:(NSString *)appkey backtype:(NSString *)backtype xid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type page:(NSString *)page;

@end
