//
//  CTXMLParser.h
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/2.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTHTMLParser : NSObject

//1.获取sessionID
+(NSString *)getSessionIDFromHtml:(NSString *)htmlStr;

//2.获取student no
+(NSString *)getStudentIDFromHtml:(NSString *)htmlStr;

//3.获取User type
+(NSString *)getUserTypeFromHtml:(NSString *)htmlStr;

//4.获取场地信息和会员信息
+(NSDictionary *)getFacilityParamsAndMemeberInfoFromHtml:(NSString *)htmlStr;

//5.获取空余位置
+(NSArray *)getCourtsTableFromHtml:(NSString *)htmlStr facility:(NSDictionary *)facility;

//6.查询已定的场地
+(NSArray *)getMyBookingsFromHtml:(NSString *)htmlStr;

//7.确实confirm，如果此场地可用，返回p_so，即p_session;
+(NSString *)getBookingConfirmSNOFromHtml:(NSString *)htmlStr;

+(NSString *)getBookingComfirmMsgFromHtml:(NSString *)htmlStr;


//8.
+(NSString *)getCancelComfirmSessionFromHtml:(NSString *)htmlStr;

@end
