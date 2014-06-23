//
//  QueryTogetherTableViewCell.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-29.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  合买记录

#import <UIKit/UIKit.h>
#import "QueryTogetherCellModel.h"
@interface QueryTogetherTableViewCell : UITableViewCell
{
    UILabel *monLabel;//金额
    UILabel *numberLabel;//编号
    UILabel *timeLabel;//时间
    UILabel *kindLabel;//彩种
    UILabel* stateLabel;//状态
    UILabel* winCountLabel;//中奖金额
}
@property (nonatomic,retain) QueryTogetherCellModel * togeModel;

- (void)queryTogetherCellRefresh;
@end
