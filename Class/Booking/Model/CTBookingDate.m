//
//  CTBookingDate.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/3.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTBookingDate.h"

@implementation CTBookingDate


+(NSArray *)bookingDates{
    NSMutableArray *mArray = [NSMutableArray array];
    
    NSTimeInterval day = 24*60*60;
    NSDate *currentDate = [NSDate date];
    //1.今天起8天之内.
    for (int i = 0; i<8; i++) {
        NSDate *date = [NSDate dateWithTimeInterval:i*day sinceDate:currentDate];
        CTBookingDate *bookingDate = [[CTBookingDate alloc] init];
        bookingDate.date = date;
        [mArray addObject:bookingDate];
    }
    
    return mArray;
}

@end
