//
//  CTCourt.h
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/4.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTCourt : NSObject


@property (nonatomic,copy) NSString *p_alter_adv_ref;
@property (nonatomic,copy) NSString *p_alter_book_no;
@property (nonatomic,copy) NSString *p_annual_pass;
@property (nonatomic,copy) NSString *p_cfm_book_no;
@property (nonatomic,copy) NSString *p_choice;
@property (nonatomic,copy) NSString *p_court;
@property (nonatomic,copy) NSString *p_date;
@property (nonatomic,copy) NSString *p_duration;
@property (nonatomic,copy) NSString *p_enq;

@property (nonatomic,copy) NSString *p_facility_ref;
@property (nonatomic,copy) NSString *p_fee_amount;
@property (nonatomic,copy) NSString *p_fee_new;
@property (nonatomic,copy) NSString *p_fee_old;

@property (nonatomic,copy) NSString *p_stime;
@property (nonatomic,copy) NSString *p_venue;

@property (nonatomic,copy) NSString *bookingReferer;
@end
