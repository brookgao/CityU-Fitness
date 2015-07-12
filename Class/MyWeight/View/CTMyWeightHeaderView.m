//
//  CTMyWeightHeaderView.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/12.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTMyWeightHeaderView.h"

@interface CTMyWeightHeaderView ()

@property (weak, nonatomic) IBOutlet UITextField *weightField;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
@implementation CTMyWeightHeaderView

-(void)awakeFromNib{
    self.addBtn.enabled = NO;
    [self.weightField addTarget:self action:@selector(weightFieldChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)weightFieldChange:(UITextField *)textField{
    self.addBtn.enabled = (textField.text.length > 0);
}

- (IBAction)addWeight {
    self.block(self.weightField.text.doubleValue);
    self.weightField.text = nil;
}


@end
