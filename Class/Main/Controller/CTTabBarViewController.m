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
 
    [self addChildViewController:bookingVC navTitle:@"Date" tabBarTitle:@"Booking" image:@"bookingTabBar" selectedImage:@"bookingTabBar_selected"];
    
    //2.
    CTEnquireViewController *enquireVC= [[CTEnquireViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self addChildViewController:enquireVC navTitle:@"My Booking" tabBarTitle:@"Enquire" image:@"enquireTabBar" selectedImage:@"enquireTabBar_selected"];
   
    //3.
    CTMeViewController *meVC = [[CTMeViewController alloc] init];
    [self addChildViewController:meVC navTitle:@"Me" tabBarTitle:@"Me" image:@"userTabBar" selectedImage:@"userTabBar_selected"];
}


-(void)addChildViewController:(UIViewController *)childController navTitle:(NSString *)navTitle tabBarTitle:(NSString *)tabBarTitle image:(NSString *)image selectedImage:(NSString *)selectedImage{
    CTNavigationController *navVC = [[CTNavigationController alloc] initWithRootViewController:childController];
    
    childController.navigationItem.title = navTitle;
    navVC.tabBarItem.title = tabBarTitle;
    navVC.tabBarItem.image = [UIImage imageNamed:image];
    navVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSDictionary *titileDict = @{NSForegroundColorAttributeName:[UIColor colorWithRed:107/255.0 green:223/255.0 blue:196/255.0 alpha:1.0]};
    [navVC.tabBarItem setTitleTextAttributes:titileDict forState:UIControlStateSelected];
    
    [self addChildViewController:navVC];
}
@end
