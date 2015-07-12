//
//  CTMyWeight.h
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/12.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CTMyWeight;
@interface CTMyWeight : NSObject

@property (nonatomic) int keyID;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,assign) double weight;
@property (nonatomic,copy) NSString *date;

-(instancetype)initWithUsername:(NSString *)username weight:(double )weight date:(NSString *)date;

+(int)addMyWeight:(CTMyWeight *)myWeight;
+(void)deleteMyWeightWithID:(int)keyID;
+(NSMutableArray *)myWeightsWithUser:(NSString *)username;
@end
