//
//  CTTableArrowItem.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/3.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTTableArrowItem.h"

@implementation CTTableArrowItem


+(instancetype)tableItemWithTitle:(NSString *)title icon:(NSString *)icon destination:(Class)destClass{
    CTTableArrowItem *arrowItem = [[CTTableArrowItem alloc] init];
    arrowItem.title = title;
    arrowItem.icon = icon;
    arrowItem.destClass = destClass;
    return arrowItem;
}
@end
