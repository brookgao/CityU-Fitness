//
//  CTXMLParser.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/2.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTHTMLParser.h"
#import "HTMLReader.h"

#import "CTCourt.h"
#import "CTCourtsGroup.h"
#import "CTMyBoooking.h"

@implementation CTHTMLParser

+(NSString *)getSessionIDFromHtml:(NSString *)htmlStr{
    HTMLDocument *htmlDoc = [HTMLDocument documentWithString:htmlStr];
    HTMLElement *htmlEle =  [htmlDoc firstNodeMatchingSelector:@"input[name='p_session']"];
    if (htmlEle == nil) {
        return nil;
    }
    return [htmlEle objectForKeyedSubscript:@"value"];
}

+(NSString *)getStudentIDFromHtml:(NSString *)htmlStr{
    HTMLDocument *document = [HTMLDocument documentWithString:htmlStr];
    HTMLElement *userInfoFrame = [document firstNodeMatchingSelector:@"frame[name='main_win']"];
    if (userInfoFrame == nil) {
        return nil;
    }
    NSString * src = [userInfoFrame.attributes valueForKey:@"src"];
    NSArray * userInfoTokens = [src componentsSeparatedByString:@"&"];
    for (NSString * userInfoToken in userInfoTokens) {
        if ([userInfoToken rangeOfString:@"p_user_no"].location != NSNotFound) {
            NSArray * tokens = [userInfoToken componentsSeparatedByString:@"/"];
            if ([tokens count] > 1) {
                return tokens[1];
            }
        }
    }
    return nil;
}

+(NSString *)getUserTypeFromHtml:(NSString *)htmlStr{
    HTMLDocument *document = [HTMLDocument documentWithString:htmlStr];
    HTMLElement *frame = [document firstNodeMatchingSelector:@"frame[name = 'opt_left_win']"];
    NSString *src = [frame.attributes valueForKey:@"src"];
    NSArray *params = [src componentsSeparatedByString:@"&"];
    for (NSString *param in params) {
        if ([param rangeOfString:@"p_user_type_no"].location != NSNotFound) {
            NSArray *typeArray = [param componentsSeparatedByString:@"="];
            return typeArray[1];
        }
    }
    return nil;
}


//1.get p_annual_pass, p_duration, p_jsc_closed, p_fee_amount,p_open_hr,p_close_hr,p_fac_label_list,_fac_label_list_all,p_fee_old,p_fee_new
+(NSDictionary *)getFacilityParamsAndMemeberInfoFromHtml:(NSString *)htmlStr  {
    HTMLDocument *document = [HTMLDocument documentWithString:htmlStr];
    HTMLElement *frame = [document firstNodeMatchingSelector:@"frame[name = 'body_win']"];
    NSString *src = [frame.attributes valueForKey:@"src"];
    NSArray *params = [src componentsSeparatedByString:@"&"];
    NSMutableDictionary *facility = [NSMutableDictionary dictionary];
    for (NSString *param in params) {
        NSArray *array = [param componentsSeparatedByString:@"="];
        [facility setObject:array[1] forKey:array[0]];
    }
    return facility;
}


+(NSArray *)getCourtsTableFromHtml:(NSString *)htmlStr facility:(NSDictionary *)facility{
    NSMutableArray *courtsGroups = [NSMutableArray array];
    HTMLDocument *document = [HTMLDocument documentWithString:htmlStr];
    NSArray *nodes = [document nodesMatchingSelector:@"a"];
    
    NSString *lastTime = nil;
    for (HTMLElement *element in nodes) {
        NSString *href   = [element.attributes valueForKey:@"href"];
        HTMLElement *IMG = [element firstNodeMatchingSelector:@"img"];
        
        //1.找到每个位置对应的方块
        if (IMG == nil) continue;
        
        NSString *courtName = [IMG.attributes valueForKey:@"name"];  //c271800
        NSString *timePeriod = [courtName substringWithRange:NSMakeRange(3, 2)];  //时间段, 取18

        CTCourtsGroup *courtsGroup = nil;
        //2.判断此场地是否跟上一个为同一时间段
        if ([timePeriod isEqualToString:lastTime]) {
             courtsGroup = [courtsGroups lastObject];
        }else{
            courtsGroup = [[CTCourtsGroup alloc] init];
            [courtsGroups addObject:courtsGroup];
            courtsGroup.timePeriod = timePeriod;
            lastTime = timePeriod;
        }
        
        //3.判断是否被预定
        if ([href rangeOfString:@"Facility Already"].location != NSNotFound) continue;
        //4.判断此位置是否可用
        if ([href rangeOfString:@"Not available"].location != NSNotFound) continue;
        
        //5.如果当日已经预定一个小时则返回
        if ([href rangeOfString:@"You have already had"].location != NSNotFound){
            NSString *alreadAlert = [href componentsSeparatedByString:@"alert"][1];
            alreadAlert = [alreadAlert stringByReplacingOccurrencesOfString:@"('" withString:@""];
            alreadAlert = [alreadAlert stringByReplacingOccurrencesOfString:@"');" withString:@""];
            //系统关于重复的提示
            NSArray *alreadBookingArray = @[alreadAlert];
            return alreadBookingArray;
        }
        //分解场地参数
        NSString *subdataOfHref = [href componentsSeparatedByString:@"sub_data"][1];
        if (subdataOfHref == nil) continue;
        
        subdataOfHref = [subdataOfHref stringByReplacingOccurrencesOfString:@"'" withString:@""];
        subdataOfHref = [subdataOfHref stringByReplacingOccurrencesOfString:@"(" withString:@""];
        subdataOfHref = [subdataOfHref stringByReplacingOccurrencesOfString:@")" withString:@""];
        subdataOfHref = [subdataOfHref stringByReplacingOccurrencesOfString:@";" withString:@""];
        NSArray *subData = [subdataOfHref componentsSeparatedByString:@","];
        
        
        CTCourt *court = [[CTCourt alloc] init];
        court.p_date = subData[0];
        court.p_court = subData[1];
        court.p_venue = subData[2];
        court.p_facility_ref = subData[3];
        court.p_stime = subData[4];
        
        court.p_alter_adv_ref = facility[@"p_alter_adv_ref"];
        court.p_alter_book_no = facility[@"p_alter_book_no"];
        court.p_annual_pass = facility[@"p_annual_pass"];
        court.p_choice = @"PF";
        court.p_duration = facility[@"p_duration"];
        court.p_enq = facility[@"p_enq"];
        court.p_fee_amount = facility[@"p_fee_amount"];
        court.p_fee_new = facility[@"p_fee_new"];
        court.p_fee_old = facility[@"p_fee_old"];
        
        [courtsGroup.courts addObject:court];
    }
    return courtsGroups;
}


+(NSArray *)getMyBookingsFromHtml:(NSString *)htmlStr{
    NSMutableArray *bookings = [NSMutableArray array];
    HTMLDocument *document = [HTMLDocument documentWithString:htmlStr];
   
    NSArray *bookingNodes = [document nodesMatchingSelector:@"tr"];
    
    for (HTMLElement *element in bookingNodes) {
        //显示booking的table
        if ([element.attributes valueForKey:@"bgcolor"] == nil) continue;
        
        NSArray *fonts = [element nodesMatchingSelector:@"font"];
        //去除标题栏
        if(fonts.count != 4) continue;
        
        //0.获取p_enq,p_choice
        HTMLElement *href = [element firstNodeMatchingSelector:@"a"];
        NSString *hrefString = [[href.attributes valueForKey:@"href"] componentsSeparatedByString:@"submit_msgdel"][1];
        hrefString = [hrefString stringByReplacingOccurrencesOfString:@"(" withString:@""];
        hrefString = [hrefString stringByReplacingOccurrencesOfString:@"'" withString:@""];
        hrefString = [hrefString stringByReplacingOccurrencesOfString:@");" withString:@""];
        NSArray *p_choiceAndp_enq = [hrefString componentsSeparatedByString:@","];
        
        //1.时间
        HTMLElement *dateTimeFont = fonts[0];
        NSString *date = @"";
        NSString *timeOfUse = @"";
        NSArray *dateTimeArray = [dateTimeFont nodesMatchingSelector:@"small"];
        int index = 0;
        for (HTMLElement *subDate in dateTimeArray) {
            if (index == 0) {
                date = subDate.textContent;
            }else{
                timeOfUse = [timeOfUse stringByAppendingString:subDate.textContent];
            }
            index++;
        }
        

        //2.场地号码
        HTMLElement *facilityFont = fonts[1];
        NSArray *facilityArray = [facilityFont nodesMatchingSelector:@"small"];
        NSString *facility = @"";
        for (HTMLElement *subFac in facilityArray) {
            facility = [facility stringByAppendingString:subFac.textContent];
            facility = [facility stringByAppendingString:@" "];
        }
        
        //3.PF
        HTMLElement *venueFont = fonts[2];
        NSString *venue = [venueFont firstNodeMatchingSelector:@"small"].textContent;
        
        //4.缴费deadline
        HTMLElement *deadlineFont = fonts[3];
        NSString *deadline = [deadlineFont firstNodeMatchingSelector:@"small"].textContent;
        
        CTMyBoooking *myBooking = [[CTMyBoooking alloc] init];
        myBooking.date = date;
        myBooking.timeOfUse = timeOfUse;
        myBooking.facility = facility;
        myBooking.venue = venue;
        myBooking.deadline = deadline;
        myBooking.p_choice = p_choiceAndp_enq[0];
        myBooking.p_enq = p_choiceAndp_enq[1];
        [bookings addObject:myBooking];
    }
    
    return bookings;
}


+(NSString *)getBookingConfirmSNOFromHtml:(NSString *)htmlStr{
    HTMLDocument *document = [HTMLDocument documentWithString:htmlStr];
    HTMLElement *element = [document firstNodeMatchingSelector:@"input[name='p_sno']"];
    NSString *p_sno = nil;
    if (element) {
        p_sno = [element.attributes valueForKey:@"value"];
    }
    return p_sno;
}


+(NSString *)getBookingComfirmMsgFromHtml:(NSString *)htmlStr{
    HTMLDocument *document = [HTMLDocument documentWithString:htmlStr];
    NSString *confirmMsg = @"";
    NSArray *fontArray = [document nodesMatchingSelector:@"font[face='Arial']"];
    
    HTMLElement *lastFont = [fontArray lastObject];
    NSArray *smallArray = [lastFont nodesMatchingSelector:@"small"];
    for (HTMLElement *small in smallArray) {
        confirmMsg = [confirmMsg stringByAppendingString:small.textContent];
    }
    NSLog(@"%@",confirmMsg);
    return confirmMsg;
}


+(NSString *)getCancelComfirmSessionFromHtml:(NSString *)htmlStr{
    HTMLDocument *document = [HTMLDocument documentWithString:htmlStr];
    HTMLElement *element = [document firstNodeMatchingSelector:@"input[name='p_session']"];
    NSString *p_session = nil;
    if (element) {
        p_session = [element.attributes valueForKey:@"value"];
    }
    return p_session;
}
@end
