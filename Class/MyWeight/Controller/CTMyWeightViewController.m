//
//  CTMyWeightViewController.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/12.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTMyWeightViewController.h"

#import "CTUser.h"
#import "CTMyWeight.h"
#import "CTMyWeightHeaderView.h"

@interface CTMyWeightViewController ()
@property (nonatomic) int index;
@property (nonatomic,strong) NSMutableArray *myWeights;
@property (nonatomic,strong) CTUser *user;
@end

@implementation CTMyWeightViewController
static NSString *ID = @"myWeightCell";

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setUpHeaderView];
    self.navigationItem.title = @"My Weight";
   
}

-(instancetype)init{
    return [super initWithStyle:UITableViewStyleGrouped];
}

#pragma mark - lazy loading
-(CTUser *)user{
    if (_user == nil) {
        _user = [CTUser sharedUser];
    }
    return _user;
}

-(NSMutableArray *)myWeights{
    if (_myWeights == nil) {
        _myWeights = [CTMyWeight myWeightsWithUser:self.user.p_username];
    }
    return _myWeights;
}

#pragma mark - setup
-(void)setUpHeaderView{
    CTMyWeightHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"CTMyWeightHeaderView" owner:nil options:nil] lastObject];
    
    __weak typeof(self) weakVC = self;
    headerView.block = ^(double weight){
        //1.插入数据
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"YYYY-MM-dd";
        NSString *recordingDate = [formatter stringFromDate:[NSDate date]];
        CTMyWeight *myWeight = [[CTMyWeight alloc] initWithUsername:self.user.p_username weight:weight date:recordingDate];
        
        
        int newID = [CTMyWeight addMyWeight:myWeight];//获取刚入的此数据的id号
        myWeight.keyID = newID;
        NSLog(@"%d", newID);
        
        //更新tableView
        [self.myWeights insertObject:myWeight atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [weakVC.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };

    self.tableView.tableHeaderView = headerView;
}

#pragma mark - close KB
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myWeights.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CTMyWeight *myWeight = self.myWeights[indexPath.row];
    cell.textLabel.text = myWeight.date;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2f",myWeight.weight];
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CTMyWeight *myWeight = self.myWeights[indexPath.row];
        [CTMyWeight deleteMyWeightWithID:myWeight.keyID];
        
        [self.myWeights removeObject:myWeight];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Recent";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}


@end
