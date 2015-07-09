//
//  CTHTTPRequestOperationManager.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/2.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTHTTPRequestOperationManager.h"
#import "CTHTMLParser.h"
#import "CTUser.h"
#import "CTCourt.h"
#import "CTMyBoooking.h"

@implementation CTHTTPRequestOperationManager


-(instancetype)initWithBaseURL:(nullable NSURL *)url{
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        [self.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:38.0) Gecko/20100101 Firefox/38.0" forHTTPHeaderField:@"User-Agent"];
    }
    
    return self;
}


#pragma mark - login
-(void)getSessionDidSuccess:(void (^)(NSString *))success DidFailure:(void (^)(NSString *))failure{
    CTUser *user = [CTUser sharedUser];
    //1.获取sessionID
    NSDictionary *param = @{};
    [self makeRequstWithUrl:@"http://brazil.cityu.edu.hk:8754/fbi/owa/fbi_web_logon.show" parameters:param Referer:@"http://brazil.cityu.edu.hk:8754/fbi/owa/fbi_web_first.show" requestType:@"POST" DidSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //1.1成功获取sessionID
        NSString *htmlStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        user.p_session = [CTHTMLParser getSessionIDFromHtml:htmlStr];
        if (user.p_session) {
            success(user.p_session);
        }else{
            failure(@"Failed to get session");
        }
        
    } DidFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(@"Failed to get session");
    }];
}

//2.登陆
-(void)loginWithUsername:(NSString *)username password:(NSString *)pwd DidSuccess:(void (^)(NSString *))success DidFailure:(void (^)(NSString *))failure{
        CTUser *user = [CTUser sharedUser];
        NSMutableDictionary *loginParam = [NSMutableDictionary dictionary];
        loginParam[@"p_status_code"] = @"";
        loginParam[@"p_sno"] = @"";
        loginParam[@"p_session"] = user.p_session;
        loginParam[@"p_username"] = username;
        loginParam[@"p_password"] = pwd;

        [self makeRequstWithUrl:@"http://brazil.cityu.edu.hk:8754/fbi/owa/fbi_web_logon.show" parameters:loginParam Referer:@"http://brazil.cityu.edu.hk:8754/fbi/owa/fbi_web_logon.show" requestType:@"POST" DidSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            //2.1成功登陆
            NSString *htmlStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            user.p_user_no = [CTHTMLParser getStudentIDFromHtml:htmlStr];
            if (user.p_user_no) {
                user.p_username = username;
                user.p_password = pwd;
                success(user.p_user_no);
            }else{
                failure(@"Incorrect EID or Password");
            }
        } DidFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(@"Failed to connect server");
        }];
}


#pragma mark - user type
-(void)getUserTypeDidSuccess:(void (^)())success DidFailure:(void (^)())failure{
    CTUser *user = [CTUser sharedUser];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"p_session"] = user.p_session;
    param[@"p_username"] = user.p_username;
    param[@"p_user_no"] = user.p_user_no;

    NSString *referer = [NSString stringWithFormat:@"http://brazil.cityu.edu.hk:8754/fbi/owa/fbi_web_main.toc?p_session=%@&p_username=%@&p_user_no=/%@/",user.p_session,user.p_username,user.p_user_no];
    
    [self makeRequstWithUrl:@"http://brazil.cityu.edu.hk:8754/fbi/owa/fbi_web_book.show" parameters:param Referer:referer requestType:@"POST" DidSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *htmlStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *userType = [CTHTMLParser getUserTypeFromHtml:htmlStr];
        if (userType) {
            user.p_user_type_no = userType;
            success();
        }else{
            failure();
        }
    } DidFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
}

#pragma mark - request Facilities
-(void)getFacilityWithDate:(NSString *)date DidSuccess:(void (^)(NSDictionary *))success DidFailure:(void(^)(NSString *))failure{
    CTUser *user = [CTUser sharedUser];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"p_session"] = user.p_session;
    param[@"p_username"] = user.p_username;
    param[@"p_user_no"] = user.p_user_no;
    param[@"p_user_type_no"] = user.p_user_type_no;
    param[@"p_date"] = date;
    param[@"p_choice"] = @"PF";

    [self makeRequstWithUrl:@"http://brazil.cityu.edu.hk:8754/fbi/owa/fbi_web_book_conf.show" parameters:param Referer:@"http://brazil.cityu.edu.hk:8754/fbi/owa/fbi_web_opt_fac_types.show" requestType:@"POST" DidSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *htmlStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *facility = [CTHTMLParser getFacilityParamsAndMemeberInfoFromHtml:htmlStr];
        if (facility) {
            success(facility);
        }else{
            failure(@"Failed to get facility parameters");
        }
    } DidFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(@"Failed to connect server");
    }];
}

-(void)getCourtsTableWithDate:(NSString *)date facilityInfo:(NSDictionary *)facility DidSuccess:(void (^)(NSArray *))success DidFailure:(void (^)(NSString *))failure{
    CTUser *user = [CTUser sharedUser];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"p_alter_adv_ref"] = facility[@"p_alter_adv_ref"];
    param[@"p_alter_book_no"] = facility[@"p_alter_book_no"];
    param[@"p_annual_pass"] = facility[@"p_annual_pass"];
    param[@"p_choice"] = @"PF";
    param[@"p_close_hr"] = facility[@"p_close_hr"];
    param[@"p_date"] = date;
    param[@"p_duration"] = facility[@"p_duration"];
    param[@"p_enq"] = facility[@"p_enq"];
    
    param[@"p_fac_label_list"] = facility[@"p_fac_label_list"];
    param[@"p_fac_label_list_all"] = facility[@"p_fac_label_list_all"];
    param[@"p_fac_label_list_other"] = facility[@"p_fac_label_list_other"];
    param[@"p_fee_amount"] = facility[@"p_fee_amount"];
    param[@"p_fee_new"] = facility[@"p_fee_new"];
    param[@"p_fee_old"] = facility[@"p_fee_old"];
    param[@"p_icourt"] = facility[@"p_icourt"];
    
    param[@"p_jsc_closed"] = facility[@"p_jsc_closed"];
    param[@"p_jsc_exception"] = facility[@"p_jsc_exception"];
    param[@"p_open_hr"] = facility[@"p_open_hr"];
    param[@"p_session"] = user.p_session;
    param[@"p_username"] = user.p_username;
    param[@"p_user_no"] = user.p_user_no;
    param[@"p_user_type_no"] = user.p_user_type_no;
    
    [self makeRequstWithUrl:@"http://brazil.cityu.edu.hk:8754/fbi/owa/fbi_web_book_conf.timetable_body" parameters:param Referer:@"http://brazil.cityu.edu.hk:8754/fbi/owa/fbi_web_book_conf.show" requestType:@"GET" DidSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *htmlStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSArray *courtsGroups = [CTHTMLParser getCourtsTableFromHtml:htmlStr facility:facility];
            if (courtsGroups == nil) {
                failure(@"Failed to connect server");
            }else if([courtsGroups[0] isKindOfClass:[NSString class]]) {
                failure(courtsGroups[0]);
            }else if(courtsGroups.count == 0){
                failure(@"No remaining courts");
            }else{
                success(courtsGroups);
            }
        
     } DidFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(@"Failed to connect server");
     }];
}

#pragma mark - 预定场地
-(void)makeBookingRequestWithCourt:(CTCourt *)court facilityInfo:(NSDictionary *)facility DidSuccess:(void (^)(NSString *))success DidFailure:(void (^)(NSString *))failure{
    CTUser *user = [CTUser sharedUser];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"p_alter_adv_ref"] = court.p_alter_adv_ref;
    param[@"p_alter_book_no"] = court.p_alter_book_no;
    param[@"p_annual_pass"] = court.p_annual_pass;
  //  param[@"p_cfm_book_no"] = court.p_cfm_book_no;
    param[@"p_choice"] = court.p_choice;
    param[@"p_court"] = court.p_court;
    param[@"p_date"] = court.p_date;
    param[@"p_duration"] = court.p_duration;
    param[@"p_enq"] = court.p_enq;
    param[@"p_facility_ref"] = court.p_facility_ref;
    param[@"p_fee_amount"] = court.p_fee_amount;
    param[@"p_fee_new"] = court.p_fee_new;
    param[@"p_fee_old"] = court.p_fee_old;
    param[@"p_stime"] = court.p_stime;
    param[@"p_venue"] = court.p_venue;
    
    param[@"p_session"] = user.p_session;
    param[@"p_username"] = user.p_username;
    param[@"p_user_no"] = user.p_user_no;
    NSLog(@"SESSION_ID=%@",user.p_session);
    
    NSString *referer = [NSString stringWithFormat:@"http://brazil.cityu.edu.hk:8754/fbi/owa/fbi_web_book_conf.timetable_body?p_session=%@&p_username=%@&p_user_no=%@&p_user_type_no=%@&p_choice=%@&p_date=%@&p_icourt=%@&p_annual_pass=%@&p_duration=%@&p_jsc_closed=%@&p_fee_amount=%@&p_open_hr=%@&p_close_hr=%@&p_fac_label_list=%@&p_fac_label_list_other=%@&p_fac_label_list_all=%@&p_alter_adv_ref=%@&p_alter_book_no=%@&p_jsc_exception=%@&p_fee_old=%@&p_fee_new=%@&p_enq=%@",user.p_session,user.p_username,user.p_user_no,user.p_user_type_no,court.p_choice,court.p_date,facility[@"p_icourt"],court.p_annual_pass,court.p_duration,facility[@"p_close_hr"],court.p_fee_amount,facility[@"p_open_hr"],facility[@"p_close_hr"],facility[@"p_fac_label_list"],facility[@"p_fac_label_list_other"],facility[@"p_fac_label_list_all"],court.p_alter_adv_ref,court.p_alter_book_no,facility[@"p_jsc_exception"],court.p_fee_old,court.p_fee_new,facility[@"p_enq"]];
    
    
    [self makeRequstWithUrl:@"http://brazil.cityu.edu.hk:8754/fbi/owa/fbi_web_conf_msg.show" parameters:param Referer:referer requestType:@"POST" DidSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *htmlStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *p_son = [CTHTMLParser getBookingConfirmSNOFromHtml:htmlStr];
        if (p_son) {
            success(p_son);
        }else{
            failure(@"This court is not avaliable. Please try again.");
        }
    } DidFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(@"Failed to connect server");
    }];
}


//确认预定
-(void)makeBookingConfirmWithPSNO:(NSString *)p_sno DidSuccess:(void (^)(NSString *))success DidFailure:(void (^)(NSString *))failure{
    CTUser *user = [CTUser sharedUser];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"p_password"] = user.p_password;
    param[@"p_sno"] = p_sno;
    param[@"p_username"] = user.p_username;

        [self makeRequstWithUrl:@"http://brazil.cityu.edu.hk:8754/fbi/owa/fbi_web_conf_msg.show" parameters:param Referer:@"http://brazil.cityu.edu.hk:8754/fbi/owa/fbi_web_conf_msg.show" requestType:@"POST" DidSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *htmlStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            success([CTHTMLParser getBookingComfirmMsgFromHtml:htmlStr]);
        } DidFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(@"Failed to connect server");
        }];
}


#pragma mark - 查询我的booking
-(void)enquireMyBookingDidSuccess:(void (^)(NSArray *))success DidFailure:(void (^)(NSString *))failure{
    CTUser *user = [CTUser sharedUser];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"p_session"] = user.p_session;
    param[@"p_username"] = user.p_username;
    param[@"p_user_no"] = user.p_user_no;
    
    NSString *referer = [NSString stringWithFormat:@"http://brazil.cityu.edu.hk:8754/fbi/owa/fbi_web_main.toc?p_session=%@&p_username=%@&p_user_no=/%@/",user.p_session,user.p_username,user.p_user_no];
    
    [self makeRequstWithUrl:@"http://brazil.cityu.edu.hk:8754/fbi/owa/fbi_web_enqbook.show" parameters:param Referer:referer requestType:@"POST" DidSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *htmlStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSArray *myBookings = [CTHTMLParser getMyBookingsFromHtml:htmlStr];
        if(myBookings.count == 0){
            success(nil);
        }else{
            success(myBookings);
        }
    } DidFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(@"Failed to enquire");
    }];
}


#pragma mark - 取消我的booking

-(void)makeCancelRequestWithBooking:(CTMyBoooking *)myBooking  DidSuccess:(void (^)(NSString *))success DidFailure:(void (^)(NSString *))failure{
    CTUser *user = [CTUser sharedUser];

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"p_choice"] = myBooking.p_choice;
    param[@"p_enq"] = myBooking.p_enq;
    param[@"p_session"] = user.p_session;
    param[@"p_user_no"] = user.p_user_no;
    param[@"p_username"] = user.p_username;
    
    [self makeRequstWithUrl:@"http://brazil.cityu.edu.hk:8754/fbi/owa/fbi_web_conf_msg_del.show" parameters:param Referer:@"http://brazil.cityu.edu.hk:8754/fbi/owa/fbi_web_enqbook.show" requestType:@"POST" DidSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *htmlStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *p_session = [CTHTMLParser getCancelComfirmSessionFromHtml:htmlStr];
        if(p_session == nil){
            failure(@"Failed to get session");
        }else{
            success(p_session);
        }
        
    } DidFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(@"Failed to connect server");
    }];
}

-(void)makeCancelConfirmRequestWithPSNO:(NSString *)p_sno DidSuccess:(void (^)(NSString *))success DidFailure:(void (^)(NSString *))failure{
    CTUser *user = [CTUser sharedUser];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"p_sno"] = p_sno;
    param[@"p_password"] = user.p_password;
    param[@"p_username"] = user.p_username;
    NSLog(@"%@",param);
    
    [self makeRequstWithUrl:@"http://brazil.cityu.edu.hk:8754/fbi/owa/fbi_web_conf_msg_del.show" parameters:param Referer:@"http://brazil.cityu.edu.hk:8754/fbi/owa/fbi_web_conf_msg_del.show" requestType:@"POST" DidSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(@"Success");
    } DidFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(@"Failed to cancel");
    }];
}

-(void)makeRequstWithUrl:(NSString *)url parameters:(NSDictionary *)parameters Referer:(NSString *)referer requestType:(NSString *)requestType DidSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success DidFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    //1.设置来源
    [self.requestSerializer setValue:referer forHTTPHeaderField:@"Referer"];
    
    if ([requestType isEqualToString:@"POST"]) {
        [self POST:url parameters:parameters success:success failure:failure];
    }else{
        [self GET:url parameters:parameters success:success failure:failure];
    }
    
}
@end
