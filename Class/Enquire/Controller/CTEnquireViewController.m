//
//  CTEnquireViewController.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/4.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTEnquireViewController.h"

#import "CTHTTPRequestOperationManager.h"
#import "CTUser.h"
#import "CTMyBoooking.h"
#import "CTMyBookingCell.h"
#import "CTSaveTool.h"

#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"


@interface CTEnquireViewController ()<UIActionSheetDelegate>
@property (nonatomic,copy) NSArray *myBookings;
@property (nonatomic,strong) CTMyBoooking *chosenMyBooking;
@end

@implementation CTEnquireViewController
static NSString *ID = @"myBookingCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpTableCell];
    [self setMJRefreshHeader];
}

-(NSArray *)myBookings{
    if (_myBookings == nil) {
        _myBookings = [[NSArray alloc] init];
    }
    return _myBookings;
}

-(void)setMJRefreshHeader{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(enquireMyBooking)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.autoChangeAlpha = YES;
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    // 马上进入刷新状态
    [header beginRefreshing];
    self.tableView.header = header;
}

-(void)setUpTableCell{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 140;
    [self.tableView registerNib:[UINib nibWithNibName:@"CTMyBookingCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
    
}

-(void)enquireMyBooking{
    CTHTTPRequestOperationManager *mgr = [CTHTTPRequestOperationManager manager];
    
    [mgr enquireMyBookingDidSuccess:^(NSArray *bookings) {
        self.myBookings = bookings;
        
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
    } DidFailure:^(NSString *error) {
        
        [self.tableView.header endRefreshing];
        [self showAlertViewWithTitle:@"Error" message:error];
    }];
}

-(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.myBookings.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CTMyBookingCell *cell  = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.myBooking = self.myBookings[indexPath.section];
    __weak typeof(self) weakSelf;
    
    cell.block = ^(CTMyBoooking *myBooking){
        self.chosenMyBooking = myBooking;
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Confirm to cancel?" delegate:self cancelButtonTitle:@"NO" destructiveButtonTitle:@"YES" otherButtonTitles:nil];
        [action showInView:weakSelf.view];
    };

    return cell;
}

#pragma mark - actionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        [MBProgressHUD showMessage:@"Trying to cancel..." toView:self.view];
        //1.尝试取消
        CTHTTPRequestOperationManager *mgr = [CTHTTPRequestOperationManager manager];
        [mgr makeCancelRequestWithBooking:self.chosenMyBooking DidSuccess:^(NSString *p_session) {
            //2.填写密码，确认取消.
            [mgr makeCancelConfirmRequestWithPSNO:p_session DidSuccess:^(NSString *success) {
                [MBProgressHUD hideHUDForView:self.view];
                //3.锻炼时间-1
                [CTSaveTool setTotalHoursForUser:[CTUser sharedUser].p_username change:-1];
                [self.tableView.header beginRefreshing];
                [MBProgressHUD showSuccess:@"Success"];
                
            } DidFailure:^(NSString *error) {
                [MBProgressHUD hideHUDForView:self.view];
                [self showAlertViewWithTitle:@"Error" message:error];
            }];
            
        } DidFailure:^(NSString *error) {
            [MBProgressHUD hideHUDForView:self.view];
            [self showAlertViewWithTitle:@"Error" message:error];
        }];
    }
}


#pragma mark - Table View delegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}


@end
