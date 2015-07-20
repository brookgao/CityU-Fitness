//
//  BOBaseTableViewController.m
//  BOLottery
//
//  Created by GaoBrook on 15/6/22.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTBaseTableViewController.h"

#import "CTTableItem.h"
#import "CTTableArrowItem.h"
#import "CTTableItemGroup.h"
#import "CTTableCell.h"

@interface CTBaseTableViewController ()

@end

@implementation CTBaseTableViewController
static NSString *ID = @"itemCell";

-(instancetype)init{
    return [super initWithStyle:UITableViewStyleGrouped];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.tableView registerClass:[CTTableCell class] forCellReuseIdentifier:ID];
}

#pragma mark - lazy loading
-(NSMutableArray *)itemGroups{
    if (_itemGroups == nil) {
        _itemGroups = [NSMutableArray array];
    }
    return _itemGroups;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CTTableItemGroup *itemGroup = self.itemGroups[section];
    return itemGroup.tablesItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CTTableCell *cell = [CTTableCell cellWithTableView:tableView indexPath:indexPath];
    
    CTTableItemGroup *itemGroup = self.itemGroups[indexPath.section];
    CTTableItem *tableItem = itemGroup.tablesItems[indexPath.row];
    cell.tableItem = tableItem;
    return cell;
}

#pragma mark - Table view delegate
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    CTTableItemGroup *itemGroup = self.itemGroups[section];
    return itemGroup.headerTitle;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    CTTableItemGroup *itemGroup = self.itemGroups[section];
    return itemGroup.footerTitle;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CTTableItemGroup *itemGroup = self.itemGroups[indexPath.section];
    CTTableItem *tableItem = itemGroup.tablesItems[indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //1.执行block
    if (tableItem.operation) {
        tableItem.operation();
        return;
    }
    
    //2.跳转
    if ([tableItem isKindOfClass:[CTTableArrowItem class]]) {
        CTTableArrowItem *arrowItem = (CTTableArrowItem *)tableItem;
        [self.navigationController pushViewController:[[arrowItem.destClass alloc] init] animated:YES];
    }
}


@end
