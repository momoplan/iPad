//
//  QueryWinningTableViewCell.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-25.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  kaix

#import <UIKit/UIKit.h>
#import "QueryWinningCellModel.h"
#import "QueryBetCellModel.h"
@interface QueryWinningTableViewCell : UITableViewCell
{
    UILabel *winMoneyLabel;
    UILabel *moneyLabel;
    UILabel *kindLabel;
    UILabel *issueLabel;
    UILabel *timeLabel;
    
}
// 开奖状态 0： 未中奖  1：未开奖 2：中奖金额
@property (nonatomic,retain) NSString * winState;

@property (nonatomic,retain) QueryWinningCellModel *winModel;
@property (nonatomic,retain) QueryBetCellModel *betModel;
//内容布局
- (void)queryWinContentViewCreate;
@end
