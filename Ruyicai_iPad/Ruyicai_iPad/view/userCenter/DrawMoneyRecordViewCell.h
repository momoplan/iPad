//
//  DrawMoneyRecordViewCell.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-23.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  提现记录cell

#import <UIKit/UIKit.h>
#import "UserCashRecordModel.h"

@protocol RecordViewTableCellDelegate <NSObject>

- (void)drawMoneyRecordCancelCashId:(NSString *)cashId;

@end


@interface DrawMoneyRecordViewCell : UITableViewCell
<UIAlertViewDelegate>
{
    UILabel             * stateLabel;
    UIButton            * cancelBtn;
    UILabel             * dateLabel;
    UILabel             * sumLabel;
}
@property (nonatomic,retain) NSString               * cellState;
@property (nonatomic,retain) UserCashRecordModel    * cashModel;
@property (nonatomic,retain) id <RecordViewTableCellDelegate>delegate;

- (void)refreshCellView;
@end
