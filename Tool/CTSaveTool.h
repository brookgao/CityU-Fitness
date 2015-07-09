//
//  CTSaveTool.h
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/6.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTSaveTool : NSObject

+(void)setAutologinState:(BOOL)isAuto;
+(BOOL)getAutologinState;

+(void)setAutoUsername:(NSString *)username;
+(NSString *)getAutoUsername;

+(void)setAutoPassword:(NSString *)password;
+(NSString *)getAutoPassword;

+(void)logout;

+(NSInteger)getTotalHoursForUser:(NSString *)username;
+(void)setTotalHoursForUser:(NSString *)username change:(NSInteger)change;
//
//+(void)setConstantDaysForUser:(NSString *)username;
//+(NSInteger)getConstantDaysForUser:(NSString *)username;


@end
