//
//  QueryChaseTableViewCell.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-26.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  追号详情cell

#import <UIKit/UIKit.h>
#import "QueryChaseCellModel.h"

@class QueryChaseViewController;

@interface QueryChaseTableViewCell : UITableViewCell
{
    UILabel *stateLabel;
    UILabel *kindLabel;
    UILabel *totelLabel;
    UILabel * stageLabel;
    UILabel * alStateLabel;
}
@property (nonatomic,retain) NSString * chaseState;
@property (nonatomic,retain) QueryChaseCellModel * model;
@property (nonatomic,retain) UIButton* cancelChase;//取消追期
@property (nonatomic,retain) QueryChaseViewController* mySuperViewController;

- (void)queryChaseTableCellRefresh;
@end
