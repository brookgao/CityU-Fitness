//
//  CTTableItemCell.h
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/3.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CTTableItem;
@interface CTTableCell : UITableViewCell


@property (nonatomic,strong) CTTableItem *tableItem;

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
