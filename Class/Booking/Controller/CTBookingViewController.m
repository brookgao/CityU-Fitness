//
//  CTBookingViewController.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/3.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTBookingViewController.h"
#import "CTBookingDetailViewController.h"

#import "CTTableItem.h"
#import "CTTableArrowItem.h"
#import "CTTableItemGroup.h"
#import "CTTableCell.h"

#import "CTBookingDate.h"
#import "CTHTTPRequestOperationManager.h"
#import "CTUser.h"

#import "MBProgressHUD+MJ.h"
@interface CTBookingViewController ()
@property (nonatomic,strong) NSArray *bookingDates;
@end

@implementation CTBookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addGroup0];
    [self getUserType];  //获取用户类型
}

-(NSArray *)bookingDates{
    if (_bookingDates == nil) {
        _bookingDates = [CTBookingDate bookingDates];
    }
    return _bookingDates;
}

-(void)getUserType{
    CTUser *user = [CTUser sharedUser];
    //1.如果有了就不请求
    if (user.p_user_type_no) return;
    
    //2. 发送请求
    CTHTTPRequestOperationManager *mgr = [CTHTTPRequestOperationManager manager];
    [MBProgressHUD showMessage:@"Requst Date List..." toView:self.view];
    [mgr getUserTypeDidSuccess:^{
        [MBProgressHUD hideHUDForView:self.view];
        
    } DidFailure:^{
        [MBProgressHUD hideHUDForView:self.view];
        
        NSLog(@"Failed to get user type");
    }];
}

#pragma mark - set table
-(void)addGroup0{
    //1.设置cell，从今日起八天.
    NSMutableArray *mArray = [NSMutableArray array];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    
    NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
    weekFormatter.dateFormat = @"EEEE";
    
    NSString *dateText = nil;
    
    int index = 0;
    for (CTBookingDate *bookingDate in self.bookingDates) {
        dateText = [dateFormatter stringFromDate:bookingDate.date];
        if (index++ == 0) dateText = [dateText stringByAppendingString:@" (Today)"];
        
        CTTableArrowItem *arrowItem = [CTTableArrowItem tableItemWithTitle:dateText icon:nil];
        arrowItem.subText = [weekFormatter stringFromDate:bookingDate.date];
        
        [mArray addObject:arrowItem];
    }
    
    CTTableItemGroup *group0 = [[CTTableItemGroup alloc] init];
    group0.tablesItems = mArray;
    [self.itemGroups addObject:group0];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CTBookingDetailViewController *bookingDeatailVC = [[CTBookingDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    bookingDeatailVC.bookingDate = self.bookingDates[indexPath.row];
    [self.navigationController pushViewController:bookingDeatailVC animated:YES];
}

@end
