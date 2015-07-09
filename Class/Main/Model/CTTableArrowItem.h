//
//  CTTableArrowItem.h
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/3.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTTableItem.h"

@interface CTTableArrowItem : CTTableItem


@property (nonatomic) Class destClass;
+(instancetype)tableItemWithTitle:(NSString *)title icon:(NSString *)icon destination:(Class )destClass;


@end
