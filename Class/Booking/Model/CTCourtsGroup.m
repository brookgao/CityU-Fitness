//
//  CTCourtsGroup.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/4.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTCourtsGroup.h"

@implementation CTCourtsGroup


-(NSMutableArray *)courts{
    if (_courts == nil) {
        _courts = [[NSMutableArray alloc] init];
    }
    return _courts;
}
@end
