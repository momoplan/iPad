//
//  QueryChaseDetailView.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-26.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  追号详情

#import <UIKit/UIKit.h>
#import "QueryChaseDetailTableCell.h"
#import "QueryChaseCellModel.h"

@protocol QueryChaseDetailViewDelegate <NSObject>

- (void)queryChaseDetailCloseButton:(UIView *)view;

@end
@interface QueryChaseDetailView : UIView
<UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView    * chaseScroll;
    UITableView     * detTableView;
}
@property (nonatomic,retain) QueryChaseCellModel * chaseModel;
@property (nonatomic,retain) id<QueryChaseDetailViewDelegate>delegate;
@property (nonatomic,retain) NSMutableArray  * chaseDataAry;

- (void)chaseDetailDataChaseModel:(QueryChaseCellModel *)model;
- (void)chaseDetailTableViewCellArray:(NSArray *)dataArray;
@end
