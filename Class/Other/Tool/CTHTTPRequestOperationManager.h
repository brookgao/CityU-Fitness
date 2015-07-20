//
//  CTHTTPRequestOperationManager.h
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/2.
//  Copyright (c) 2015年 gao. All rights reserved.
//
typedef void(^CTHTTPRequestOperationManagerSuccessBlock)();
typedef void(^CTHTTPRequestOperationManagerSuccessBlock)();
#import "AFHTTPRequestOperationManager.h"

@class CTCourt;
@class CTMyBoooking;
@interface CTHTTPRequestOperationManager : AFHTTPRequestOperationManager

@property (nonatomic,weak) CTHTTPRequestOperationManagerSuccessBlock successBlock;

//请求session
-(void)getSessionDidSuccess:(void (^)(NSString *session))success DidFailure:(void (^)(NSString *error))failure;

//登陆
-(void)loginWithUsername:(NSString *)username password:(NSString *)pwd DidSuccess:(void (^)(NSString *p_user_no))success DidFailure:(void (^)(NSString *error))failure;

//用户类别
-(void)getUserTypeDidSuccess:(void (^)())success DidFailure:(void (^)())failure;

//场地参数
-(void)getFacilityWithDate:(NSString *)date DidSuccess:(void (^)(NSDictionary *facility))success DidFailure:(void(^)(NSString *error))failure;

//空余位置信息
-(void)getCourtsTableWithDate:(NSString *)date facilityInfo:(NSDictionary *)facility DidSuccess:(void (^)(NSArray *courtsGroups))success DidFailure:(void (^)(NSString *error))failure;

//预定场地
-(void)makeBookingRequestWithCourt:(CTCourt *)court facilityInfo:(NSDictionary *)facility DidSuccess:(void (^)(NSString *p_sno))success DidFailure:(void (^)(NSString *error))failure;

-(void)makeBookingConfirmWithPSNO:(NSString *)p_sno DidSuccess:(void (^)(NSString *confrimMsg))success DidFailure:(void (^)(NSString *error))failure;

//查询我的订单
-(void)enquireMyBookingDidSuccess:(void (^)(NSArray *bookings))success DidFailure:(void (^)(NSString *error))failure;

//取消场地
-(void)makeCancelRequestWithBooking:(CTMyBoooking *)myBooking  DidSuccess:(void (^)(NSString *p_session))success DidFailure:(void (^)(NSString *error))failure;

-(void)makeCancelConfirmRequestWithPSNO:(NSString *)p_sno  DidSuccess:(void (^)(NSString *success))success DidFailure:(void (^)(NSString *error))failure;
@end
