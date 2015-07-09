//
//  CTTableItem.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/3.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTTableItem.h"

@implementation CTTableItem


+(instancetype)tableItemWithTitle:(NSString *)title icon:(NSString *)icon{
    CTTableItem *item = [[self alloc] init];
    item.title = title;
    item.icon = icon;
    return item;
}

@end
