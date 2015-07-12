//
//  CTRecordViewController.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/3.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTMeViewController.h"

#import "CTSettingViewController.h"
#import "CTNavigationController.h"
#import "CTMyWeightViewController.h"

#import "CTTableItem.h"
#import "CTTableArrowItem.h"
#import "CTTableItemGroup.h"
#import "CTTableCell.h"
#import "CTUser.h"
#import "CTSaveTool.h"

@interface CTMeViewController ()

@end

@implementation CTMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settingBarButton"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoSettingVC)];

    [self addGroup0];
    [self addGroup1];
    [self addGroup2];
}

-(void)addGroup0{
    CTUser *user = [CTUser sharedUser];
    CTTableItem *eid = [CTTableItem tableItemWithTitle:@"Electric ID" icon:@"eidIcon"];
    eid.subText = user.p_username;
    CTTableItemGroup *group0 = [[CTTableItemGroup alloc] init];
    group0.tablesItems = @[eid];
    [self.itemGroups addObject:group0];
}

-(void)addGroup1{
    CTTableItem *total = [CTTableItem tableItemWithTitle:@"Total Hours" icon:@"totalIcon"];
    NSInteger totalHours = [CTSaveTool getTotalHoursForUser:[CTUser sharedUser].p_username];
    total.subText = [NSString stringWithFormat:@"%d",totalHours];
    CTTableItemGroup *group1 = [[CTTableItemGroup alloc] init];
    group1.tablesItems = @[total];
    group1.headerTitle = @"Hours spent in Fitness Room";
    [self.itemGroups addObject:group1];
}

-(void)addGroup2{
    CTTableArrowItem *weight = [CTTableArrowItem tableItemWithTitle:@"My Weight" icon:@"weightIcon" destination:[CTMyWeightViewController class]];
    CTTableItemGroup *group2 = [[CTTableItemGroup alloc] init];
    group2.tablesItems = @[weight];
    [self.itemGroups addObject:group2];
}


-(void)gotoSettingVC{
    CTSettingViewController *settingVC = [[CTSettingViewController alloc] init];
    settingVC.navigationItem.title = @"Setting";
    [self.navigationController pushViewController:settingVC animated:YES];
}
@end
