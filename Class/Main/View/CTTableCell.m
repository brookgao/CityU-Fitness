//
//  CTTableItemCell.m
//  CityU-Fitness
//
//  Created by GaoBrook on 15/7/3.
//  Copyright (c) 2015年 gao. All rights reserved.
//

#import "CTTableCell.h"

#import "CTTableItem.h"
#import "CTTableArrowItem.h"

@implementation CTTableCell
static NSString *ID = @"itemCell";


+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    CTTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    return self;
}


#pragma mark - cell setting
-(void)setTableItem:(CTTableItem *)tableItem{
    _tableItem = tableItem;
    [self setCellData];
    [self setCellStyle];
}

-(void)setCellData{
    self.textLabel.text = _tableItem.title;
    self.detailTextLabel.text = _tableItem.subText;
    if (_tableItem.icon) {
        self.imageView.image = [UIImage imageNamed:_tableItem.icon];
    }
}

-(void)setCellStyle{
    if ([_tableItem isKindOfClass:[CTTableArrowItem class]]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }else{
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

@end
