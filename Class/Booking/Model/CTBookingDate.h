//
//  CTBookingDate.h
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/3.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTBookingDate : NSObject

@property (nonatomic,copy) NSDate *date;

+(NSArray *)bookingDates;
@end
