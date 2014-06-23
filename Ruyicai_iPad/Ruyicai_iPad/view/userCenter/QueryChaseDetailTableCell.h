//
//  QueryChaseDetailTableCell.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-29.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChaseDetailCellModel.h"

@interface QueryChaseDetailTableCell : UITableViewCell
{
    UILabel * stageLabel;
    UILabel * sumLabel;
    UILabel * numLabel;
    UILabel * winLabel;
    UILabel * mulLabel;// 倍数
    UILabel *stateLabel;// 状态
}
@property (nonatomic,retain) ChaseDetailCellModel * detModel;
- (void)getDetailCellDataRefresh;
@end
