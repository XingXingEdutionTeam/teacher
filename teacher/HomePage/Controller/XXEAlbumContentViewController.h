//
//  XXEAlbumContentViewController.h
//  teacher
//
//  Created by codeDing on 16/8/15.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"
#import "XXEMySelfAlbumModel.h"

@class XXEAlbumContentViewController;
@protocol XXEAlbumContentViewControllerDelegate <NSObject>

- (void)contactsPickerViewControllerDidFinish:(XXEAlbumContentViewController *)controller withSelectedContacts:(NSArray *)contacts;

@end


@interface XXEAlbumContentViewController : XXEBaseViewController
@property (nonatomic, strong)XXEMySelfAlbumModel *contentModel;
@property (nonatomic, copy)NSString *albumTeacherXID;

/** 学校Id */
@property (nonatomic, copy)NSString *myAlbumUpSchoolId;
/** 班级id */
@property (nonatomic, copy)NSString *myAlbumUpClassId;

@property (nonatomic,strong)NSMutableArray *datasource;

@property (nonatomic, strong) NSSet *selectedContactIds;
@property (nonatomic, strong) NSSet *disabledContactIds;
@property (nonatomic, strong) id<XXEAlbumContentViewControllerDelegate>delegate;


@end
