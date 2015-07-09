//
//  CTTableItemGroup.h
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/3.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTTableItemGroup : NSObject

@property (nonatomic,copy) NSString *headerTitle;
@property (nonatomic,copy) NSString *footerTitle;
@property (nonatomic,strong) NSArray *tablesItems;
@end
