//
//  DetailTotalViewPartCell.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-19.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 合买想起 参与人

#import <UIKit/UIKit.h>
#import "TogetherParticipationModel.h"
@interface DetailTotalViewPartCell : UITableViewCell
{
    UILabel *nameLabel;//名字
    UILabel *timeLabel;//时间
    UILabel *moneyLabel;//金钱
}

@property (nonatomic,retain) TogetherParticipationModel * model;
- (void)detailTotalPartCellRefresh;
@end
