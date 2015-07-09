//
//  CTSettingViewController.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/3.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTSettingViewController.h"
#import "CTLoginViewController.h"
#import "CTNavigationController.h"
#import "CTAboutViewController.h"

#import "CTTableItem.h"
#import "CTTableArrowItem.h"
#import "CTTableItemGroup.h"
#import "CTTableCell.h"

#import "CTSaveTool.h"
@interface CTSettingViewController ()<UIActionSheetDelegate>
@end

@implementation CTSettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addGroup0];
    [self addGroup1];
    [self addGroup2];
}

-(void)addGroup0{
    CTTableArrowItem *recommend = [CTTableArrowItem tableItemWithTitle:@"app recommendation" icon:@"appIcon"];

    CTTableItemGroup *group0 = [[CTTableItemGroup alloc] init];
    group0.tablesItems = @[recommend];
    [self.itemGroups addObject:group0];
}

-(void)addGroup1{
    CTTableItem *version = [CTTableItem tableItemWithTitle:@"Version" icon:@"versionIcon"];
    version.subText = @"1.0";
    CTTableArrowItem *about = [CTTableArrowItem tableItemWithTitle:@"About" icon:@"aboutIcon" destination:[CTAboutViewController class]];
    
    CTTableItemGroup *group1 = [[CTTableItemGroup alloc] init];
    group1.tablesItems = @[version,about];
    [self.itemGroups addObject:group1];
}

-(void)addGroup2{
    CTTableArrowItem *logout = [CTTableArrowItem tableItemWithTitle:@"Log Out" icon:@"logoutIcon"];
    
    __weak typeof(self) weakVC;
    logout.operation = ^{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Comfirm to logout?" delegate:self cancelButtonTitle:@"NO" destructiveButtonTitle:@"YES" otherButtonTitles:nil];
        [actionSheet showInView:weakVC.view];;
    };
    CTTableItemGroup *group2 = [[CTTableItemGroup alloc] init];
    group2.tablesItems = @[logout];
    [self.itemGroups addObject:group2];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [CTSaveTool logout];
        
        CTLoginViewController *loginVC = [[CTLoginViewController alloc] init];
        CTNavigationController *navVC = [[CTNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:navVC animated:YES completion:nil];
    }
}
@end
