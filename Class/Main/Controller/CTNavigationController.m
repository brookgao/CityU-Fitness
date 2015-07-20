//
//  CTNavigationController.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/1.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTNavigationController.h"

@interface CTNavigationController ()

@end

@implementation CTNavigationController


+(void)initialize{
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage imageNamed:@"NavBar"] forBarMetrics:UIBarMetricsDefault];
    [navBar setTintColor:[UIColor whiteColor]];
    [navBar setBarStyle:UIBarStyleBlackTranslucent];
    
    NSDictionary *dict = @{
                           NSFontAttributeName:[UIFont systemFontOfSize:18],
                           NSForegroundColorAttributeName:[UIColor whiteColor],
                           };
    [navBar setTitleTextAttributes:dict];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    return [super pushViewController:viewController animated:animated];
}



@end
