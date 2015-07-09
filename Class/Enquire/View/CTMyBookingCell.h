//
//  CTMyBookingCell.h
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/5.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CTMyBoooking;

typedef void(^CTMyBookingCellBlock)(CTMyBoooking *myBooking);
@interface CTMyBookingCell : UITableViewCell

@property (nonatomic, strong) CTMyBoooking *myBooking;
@property (nonatomic,strong) CTMyBookingCellBlock block;

@end
