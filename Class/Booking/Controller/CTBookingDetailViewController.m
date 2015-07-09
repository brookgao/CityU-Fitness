//
//  CTBookingDetailViewController.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/3.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTBookingDetailViewController.h"

#import "CTTableItem.h"
#import "CTTableArrowItem.h"
#import "CTTableItemGroup.h"
#import "CTMakeBookingCell.h"

#import "CTBookingDate.h"
#import "CTHTTPRequestOperationManager.h"
#import "CTUser.h"
#import "CTCourt.h"
#import "CTCourtsGroup.h"
#import "CTSaveTool.h"

#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"

@interface CTBookingDetailViewController ()<UIActionSheetDelegate>

@property (nonatomic,copy) NSDictionary *facility;
@property (nonatomic,copy) NSArray *courtsGroups;
@property (nonatomic,strong) CTCourt *chosenCourt;
@end

@implementation CTBookingDetailViewController
static NSString *ID = @"makeBooingCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpApperance];
    [self setMJRefreshHeader];
    
    [self.tableView registerClass:[CTMakeBookingCell class] forCellReuseIdentifier:ID];
}

//设置导航栏
-(void)setUpApperance{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM-dd";
    self.navigationItem.title = [formatter stringFromDate:self.bookingDate.date];
}

-(void)setMJRefreshHeader{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCourt)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.autoChangeAlpha = YES;
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    self.tableView.header = header;
}

-(void)setHeaderView{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    label.text = @"Remaining";
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor grayColor];
    self.tableView.tableHeaderView = label;
}

-(void)getCourt{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYYMMdd0000";
    NSString *dateStr = [dateFormatter stringFromDate:self.bookingDate.date];

    CTHTTPRequestOperationManager *mgr = [CTHTTPRequestOperationManager manager];
    
    //1.获取场地参数
    [mgr getFacilityWithDate:dateStr DidSuccess:^(NSDictionary *facility) {
        self.facility = facility;
        
      //2.获取空余座位
        [mgr getCourtsTableWithDate:dateStr facilityInfo:facility DidSuccess:^(NSArray *courtsGroups) {
            self.courtsGroups = courtsGroups;
            [self.tableView.header endRefreshing];
         //   [self setHeaderView];
            [self.tableView reloadData];
        } DidFailure:^(NSString *error){
            [MBProgressHUD hideHUDForView:self.view];
            [self showAlertViewWithTitle:@"Error" message:error];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } DidFailure:^(NSString *error){
        [self showAlertViewWithTitle:@"Error" message:error];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - table data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.courtsGroups.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CTCourtsGroup *courtsGroup = self.courtsGroups[indexPath.row];
    CTMakeBookingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.courtsGroup = courtsGroup;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CTCourtsGroup *courtsGroup = self.courtsGroups[indexPath.row];
    if (courtsGroup.courts.count < 1) {
        return;
    }
    
    CTCourt *court = [courtsGroup.courts lastObject];
    self.chosenCourt = court;
    
    int nextHour = courtsGroup.timePeriod.intValue + 1;
    NSString *comfirmTitle = [@"Comfirm to book " stringByAppendingString:[NSString stringWithFormat:@"%@:00-%02d:00", courtsGroup.timePeriod, nextHour]];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:comfirmTitle delegate:self cancelButtonTitle:@"NO" destructiveButtonTitle:@"YES" otherButtonTitles: nil];
    [actionSheet showInView:self.view];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        CTHTTPRequestOperationManager *mgr = [CTHTTPRequestOperationManager manager];
    
        //1.开始预定
        [MBProgressHUD showMessage:@"Trying to book..." toView:self.view];
        [mgr makeBookingRequestWithCourt:self.chosenCourt facilityInfo:self.facility DidSuccess:^(NSString *p_sno){
            
            //2.输入密码确认.
            [mgr makeBookingConfirmWithPSNO:p_sno DidSuccess:^(NSString *confirmMsg) {
                [MBProgressHUD hideHUDForView:self.view];
                
                //预定时间+1;
                [CTSaveTool setTotalHoursForUser:[CTUser sharedUser].p_username change:1];
                [self showAlertViewWithTitle:@"Success" message:confirmMsg];
                [self.navigationController popViewControllerAnimated:YES];
                
            } DidFailure:^(NSString *error) {
                [MBProgressHUD hideHUDForView:self.view];
                
                [self showAlertViewWithTitle:@"Error" message:error];
                [self.tableView.header beginRefreshing];
            }];
        } DidFailure:^(NSString *error) {
            [MBProgressHUD hideHUDForView:self.view];
            
            [self showAlertViewWithTitle:@"Error" message:error];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        
    }
}





@end
