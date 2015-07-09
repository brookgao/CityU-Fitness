//
//  CTMyBoooking.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/5.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTMyBoooking.h"

@implementation CTMyBoooking


-(NSString *)description{
    return [NSString stringWithFormat:@"<%p,%@>,%@,%@,%@,%@,%@,%@,%@",self,self.class,self.p_choice,self.p_enq,self.date,self.timeOfUse,self.venue,self.facility,self.deadline];
}
@end
