//
//  CTTabBarViewController.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/2.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTTabBarViewController.h"
#import "CTNavigationController.h"

#import "CTBookingViewController.h"
#import "CTMeViewController.h"
#import "CTSettingViewController.h"
#import "CTEnquireViewController.h"

@interface CTTabBarViewController ()

@end

@implementation CTTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setChildViewControllers];
    
}

-(void)setChildViewControllers{
    //1.
    CTBookingViewController *bookingVC = [[CTBookingViewController alloc] init];
    CTNavigationController *bookingNav = [[CTNavigationController alloc] initWithRootViewController:bookingVC];
  
    bookingVC.navigationItem.title = @"Date";
    bookingNav.tabBarItem.title = @"Booking";
    bookingNav.tabBarItem.image = [UIImage imageNamed:@"bookingTabBar"];
    
    //2.
    CTEnquireViewController *enquireVC= [[CTEnquireViewController alloc] initWithStyle:UITableViewStyleGrouped];
    CTNavigationController *enquireNav = [[CTNavigationController alloc] initWithRootViewController:enquireVC];
    
    enquireVC.navigationItem.title = @"My Booking";
    enquireNav.tabBarItem.title = @"Enquire";
    enquireNav.tabBarItem.image = [UIImage imageNamed:@"enquireTabBar"];
   
    //3.
    CTMeViewController *recordVC = [[CTMeViewController alloc] init];
    CTNavigationController *recordNav = [[CTNavigationController alloc] initWithRootViewController:recordVC];
    
    recordVC.navigationItem.title = @"Me";
    recordVC.tabBarItem.title = @"Me";
    recordVC.tabBarItem.image = [UIImage imageNamed:@"userTabBar"];

    
    [self addChildViewController:bookingNav];
    [self addChildViewController:enquireNav];
    [self addChildViewController:recordNav];
}

@end
