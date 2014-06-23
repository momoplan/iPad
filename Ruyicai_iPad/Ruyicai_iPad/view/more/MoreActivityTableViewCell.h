//
//  MoreActivityTableViewCell.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-9-3.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  更多活动列表cell

#import <UIKit/UIKit.h>
#import "MoreActivityTitleModel.h"
@interface MoreActivityTableViewCell : UITableViewCell
{
    UILabel *introduceLabel;
    UILabel * titleLabel;
    UILabel * timeLabel;
}
@property (nonatomic,retain) MoreActivityTitleModel *tModel;

- (void)activityTitleCellRefresh;
@end
