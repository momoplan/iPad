//
//  LotteryDetailTableViewCell.h
//  Ruyicai_iPad
//
//  Created by huangxin on 13-7-24.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LotteryBallCommonView.h"

@interface LotteryDetailTableViewCell : UITableViewCell
{
    NSString                *cell_lotTitle;
    NSString                *cell_batchCode;
    NSString                *cell_openPrizeDate;
    NSString                *cell_openPrizeCode;
    NSString                *cell_lotteryTryNo;
    
    UILabel                 *cell_batchCodeLabel;
    UILabel                 *cell_openPrizeDateLabel;
    UILabel                 *cell_lotteryTryCodeLabel;
    LotteryBallCommonView   *cell_ballView;
}
@property (nonatomic,retain) NSString* lotTitle;
@property (nonatomic,retain) NSString* batchCode;
@property (nonatomic,retain) NSString* openPrizeDate;
@property (nonatomic,retain) NSString* openPrizeCode;
@property (nonatomic,retain) NSString* lotteryTryNo;
@property (nonatomic,retain) UILabel* batchCodeLabel;
@property (nonatomic,retain) UILabel* openPrizeDateLabel;
@property (nonatomic,retain) UILabel* lotteryTryCodeLabel;
@property (nonatomic,retain) LotteryBallCommonView* ballView;

- (void) refleshTableCell;

@end
