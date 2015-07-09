//
//  CTMyBookingCell.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/5.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTMyBookingCell.h"
#import "CTMyBoooking.h"

@interface CTMyBookingCell ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *facilityLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeOfUseLabel;

//@property (weak, nonatomic) IBOutlet UILabel *venueLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;

@end
@implementation CTMyBookingCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setMyBooking:(CTMyBoooking *)myBooking{
    _myBooking = myBooking;
    
    self.facilityLabel.text = _myBooking.facility;
    //self.venueLabel.text = _myBooking.venue;
    self.dateLabel.text = _myBooking.date;
    self.timeOfUseLabel.text = _myBooking.timeOfUse;
    self.deadlineLabel.text = _myBooking.deadline;
}

- (IBAction)deleteBooking:(id)sender {
    self.block(self.myBooking);
}

@end
