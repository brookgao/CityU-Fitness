//
//  CTUser.h
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/2.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTUser : NSObject<NSCopying>

@property (nonatomic,copy) NSString *p_status_code;
@property (nonatomic,copy) NSString *p_sno;
@property (nonatomic,copy) NSString *p_session;
@property (nonatomic,copy) NSString *p_username; //EID
@property (nonatomic,copy) NSString *p_password;  //密码
@property (nonatomic, copy) NSString *p_user_no;  //学号
@property (nonatomic, copy) NSString *p_user_type_no; //用户类型


+(instancetype)sharedUser; //单例对象

@end
