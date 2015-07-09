//
//  CTAboutViewController.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/8.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTAboutViewController.h"

#import "CTTableItem.h"
#import "CTTableItemGroup.h"

@interface CTAboutViewController ()

@end

@implementation CTAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    self.tableView.tableHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"CTAboutHeaderView" owner:nil options:nil] lastObject];
    [self addGroup0];
}


-(void)addGroup0{
    CTTableItem *author = [CTTableItem tableItemWithTitle:@"Author" icon:nil];
    author.subText = @"brookgao";
    CTTableItem *email = [CTTableItem tableItemWithTitle:@"E-mail" icon:nil];
    email.subText = @"gaojianbocs1991@163.com";
    
    CTTableItemGroup *group0 = [[CTTableItemGroup alloc] init];
    group0.tablesItems = @[author,email];
    [self.itemGroups addObject:group0];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}
@end
