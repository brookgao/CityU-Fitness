//
//  CTMakeBookingCell.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/5.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTMakeBookingCell.h"
#import "CTCourtsGroup.h"

@implementation CTMakeBookingCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

-(void)setCourtsGroup:(CTCourtsGroup *)courtsGroup{
    _courtsGroup = courtsGroup;
    
    int nextHour = _courtsGroup.timePeriod.intValue + 1;
    NSString *title = [NSString stringWithFormat:@"%@:00-%02d:00",_courtsGroup.timePeriod, nextHour];
    self.textLabel.text = title;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)courtsGroup.courts.count];
    if (courtsGroup.courts.count < 1) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
}

@end
