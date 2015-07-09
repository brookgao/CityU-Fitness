//
//  CTUser.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/2.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTUser.h"

@implementation CTUser
static id _instance;

+(instancetype)sharedUser{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

-(id)copyWithZone:(NSZone *)zone{
    return _instance;
}


-(NSString *)description{
    return [NSString stringWithFormat:@"<%@,%p>,%@,%@,%@",self.class,self,self.p_username,self.p_session,self.p_user_no];
}

-(void)dealloc{
    NSLog(@"CTUSER dealloc!!!");
}

@end
