//
//  XXESchoolAlbumViewController.h
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@class XXESchoolAlbumViewController;

@protocol XXESchoolAlbumViewControllerDelegate <NSObject>

- (void)contactsPickerViewControllerDidFinish:(XXESchoolAlbumViewController *)controller withSelectedContacts:(NSArray *)contacts;

@end


@interface XXESchoolAlbumViewController : XXEBaseViewController

@property (nonatomic, strong) NSString *schoolId;
@property (nonatomic, strong) NSString *classId;
@property (nonatomic, copy) NSString *flagStr;
@property (nonatomic, copy) NSString *position;

@property (nonatomic, strong) NSSet *selectedContactIds;
@property (nonatomic, strong) NSSet *disabledContactIds;
@property (nonatomic, strong) id<XXESchoolAlbumViewControllerDelegate>delegate;

@end
