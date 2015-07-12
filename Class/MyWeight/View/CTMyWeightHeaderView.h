//
//  CTMyWeightHeaderView.h
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/12.
//  Copyright (c) 2015年 gao. All rights reserved.
//
typedef void(^CTMyWeightHeaderViewBlock)(double weight);
#import <UIKit/UIKit.h>
@interface CTMyWeightHeaderView : UIView

@property (nonatomic,strong) CTMyWeightHeaderViewBlock block;
@end
