//
//  CTSaveTool.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/6.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTSaveTool.h"


@implementation CTSaveTool

+(void)setAutologinState:(BOOL)isAuto{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isAuto forKey:@"autoLogin"];
    [defaults synchronize];
}

+(BOOL)getAutologinState{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"autoLogin"];
}

+(void)setAutoUsername:(NSString *)username{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:username forKey:@"autoUsername"];
    [defaults synchronize];
}

+(NSString *)getAutoUsername{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"autoUsername"];
}


+(void)setAutoPassword:(NSString *)password{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:password forKey:@"autoPassword"];
    [defaults synchronize];
}

+(NSString *)getAutoPassword{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"autoPassword"];
}


+(void)setTotalHoursForUser:(NSString *)username change:(NSInteger)change{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [username stringByAppendingString:@"_totalHours"];
    
    NSInteger num = [defaults integerForKey:key];
    num = num + change;
    [defaults setInteger:num forKey:key];
}

+(NSInteger)getTotalHoursForUser:(NSString *)username{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [username stringByAppendingString:@"_totalHours"];
    
    return [defaults integerForKey:key];
}

////持续多少天
//+(void)setConstantDaysForUser:(NSString *)username date:(NSDate *)date{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *key = [username stringByAppendingString:@"_constantDays"];
//    
//    NSInteger constDay = [defaults integerForKey:key];
//    
//    NSDate *lastDate = [defaults objectForKey:@"lastDate"];
//    NSDate *currentDate = [NSDate date];
//    NSDate *yesterday = [NSDate dateWithTimeInterval:-60*60*24 sinceDate:currentDate];
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"YYYYMMday";
//    NSString *lastStr = [formatter stringFromDate:lastDate];
//    NSString *yestStr = [formatter stringFromDate:yesterday];
//    
//}
//
//
//+(NSInteger)getConstantDaysForUser:(NSString *)username{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *key = [username stringByAppendingString:@"_constantDays"];
//    
//    return [defaults integerForKey:key];
//}

+(void)logout{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"autoUsername"];
    [defaults setObject:@"" forKey:@"autoPassword"];
    [defaults setBool:NO forKey:@"autoLogin"];
    [defaults synchronize];
}

@end
