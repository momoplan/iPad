//
//  BuyLotteryTableCell.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-10-18.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  开奖号码 cell

#import <UIKit/UIKit.h>

@interface BuyLotteryTableCell : UITableViewCell
{
    UILabel * stageLabel ;
    UILabel * openTimeLabel ;
    UILabel * tryNoLabel;//试机号
}
@property (nonatomic,retain) NSString       * cellLotNo;
@property (nonatomic,retain) NSDictionary   * cellDataDic;

- (void)lotteryCellBallRefresh;
@end
