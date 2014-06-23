//
//  integralDetailViewContollerCell.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-24.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "integralDetailCellModel.h"
@interface integralDetailViewContollerCell : UITableViewCell
{
    UILabel *messLabel;
    UILabel *timeLabel;
    UILabel * addLabel;
}
- (void)integralContentViewCell;
@property (nonatomic,retain) integralDetailCellModel *model;
@end
