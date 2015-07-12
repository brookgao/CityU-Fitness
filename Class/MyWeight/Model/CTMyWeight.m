//
//  CTMyWeight.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/12.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTMyWeight.h"
#import "FMDatabase.h"

@interface CTMyWeight ()
@end
@implementation CTMyWeight

static FMDatabase *_db;

+(void)initialize{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"myweight.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    BOOL isOpen = [_db open];
    
    if (isOpen == false) {
        NSLog(@"Failed to open database");
    }
    
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS `t_weight` (`id` integer PRIMARY KEY, `username` text NOT NULL, `date` text NOT NULL, `weight` real NOT NULL);"];
}

-(instancetype)initWithUsername:(NSString *)username weight:(double)weight date:(NSString *)date{
    self = [super init];
    if (self) {
        self.username = username;
        self.weight = weight;
        self.date = date;
    }
    return self;
}

+(NSMutableArray *)myWeightsWithUser:(NSString *)username{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM `t_weight` WHERE `username`=%@ ORDER BY `id` DESC LIMIT 30;",username];
    
    NSMutableArray *myWeights = [NSMutableArray array];
    while (set.next ) {
        NSString *date = [set stringForColumn:@"date"];
        double weight = [set doubleForColumn:@"weight"];
        int keyID = [set intForColumn:@"id"];
        CTMyWeight *myWeight = [[CTMyWeight alloc] initWithUsername:username weight:weight date:date];
        myWeight.keyID = keyID;
        [myWeights addObject:myWeight];
    }
    return myWeights;
}

+(int)addMyWeight:(CTMyWeight *)myWeight{
    NSString *username = myWeight.username;
    NSString *recordingDate = myWeight.date;
    double weight = myWeight.weight;
    
    [_db executeUpdateWithFormat:@"INSERT INTO `t_weight`(username,date,weight) VALUES(%@,%@,%f)", username,recordingDate, weight];
    
    //获取刚插入的id号
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT `id` FROM `t_weight` WHERE `username`=%@ ORDER BY `id` DESC LIMIT 1;",myWeight.username];
    int newID = 0;
    while (set.next) {
        newID =  [set intForColumn:@"id"];
    }
    return newID;
}

+(void)deleteMyWeightWithID:(int)keyID{
    [_db executeUpdateWithFormat:@"DELETE FROM `t_weight` WHERE `id` = %d", keyID];
}

-(NSString *)description{
    return [NSString stringWithFormat:@"<%p,%@>,%f,%@", self,self.class,self.weight,self.date];
}
@end
