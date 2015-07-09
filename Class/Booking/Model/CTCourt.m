//
//  CTCourt.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/4.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTCourt.h"

@implementation CTCourt



-(NSString *)description{
    return [NSString stringWithFormat:@"<%p,%@>,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",self,self.class,self.p_alter_adv_ref,self.p_alter_book_no,self.p_annual_pass,self.p_cfm_book_no,self.p_choice,self.p_court,self.p_date,self.p_duration,self.p_enq,self.p_facility_ref,self.p_fee_amount,self.p_fee_new,self.p_fee_old,self.p_stime,self.p_venue];
}

@end
