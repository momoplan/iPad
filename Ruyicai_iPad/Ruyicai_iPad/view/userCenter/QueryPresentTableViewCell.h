//
//  QueryPresentTableViewCell.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-29.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 增彩记录

#import <UIKit/UIKit.h>
#import "QueryGiftTableCellModel.h"
@interface QueryPresentTableViewCell : UITableViewCell
{
    UILabel *kindLabel;//彩种
    UILabel *sendLabel;//赠送人
    UILabel *monLabel;//金额
    UILabel *timeLabel;//时间
    
}
@property (nonatomic,retain) QueryGiftTableCellModel * giftModel;

- (void)queryPresentCellRefresh;
@end
