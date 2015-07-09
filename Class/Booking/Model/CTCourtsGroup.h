//
//  CTCourtsGroup.h
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/4.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTCourtsGroup : NSObject

@property (nonatomic,copy) NSString *timePeriod;
@property (nonatomic,strong) NSMutableArray *courts;
@end
