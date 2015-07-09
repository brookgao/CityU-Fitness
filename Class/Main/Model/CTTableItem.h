//
//  CTTableItem.h
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/3.
//  Copyright (c) 2015年 gao. All rights reserved.
//

typedef void(^CTTableItemBlock)();
#import <Foundation/Foundation.h>
@interface CTTableItem : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *subText;

@property (nonatomic,strong) CTTableItemBlock operation;

+(instancetype)tableItemWithTitle:(NSString *)title icon:(NSString *)icon;

@end
