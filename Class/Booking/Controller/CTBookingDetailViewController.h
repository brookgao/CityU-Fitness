//
//  CTBookingDetailViewController.h
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/3.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CTBookingDate;

@interface CTBookingDetailViewController : UITableViewController

@property (nonatomic,strong) CTBookingDate *bookingDate;
@end
