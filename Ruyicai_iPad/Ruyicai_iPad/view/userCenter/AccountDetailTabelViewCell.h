//
//  AccountDetailTabelViewCell.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-24.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "AccountDetailCellModel.h"
@interface AccountDetailTabelViewCell : UITableViewCell
{
    UILabel * typeLabel;
    UILabel * timeLabel;
    UILabel * monLabel;
}

@property (nonatomic,assign) AccountDetailCellModel *model;
- (void)accountCellContentView;
@end
