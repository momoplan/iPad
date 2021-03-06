//
//  QueryChaseViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-26.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  追号查询

#import "RootViewController.h"
#import "QueryChaseTableViewCell.h"
#import "QueryChaseDetailView.h"
#import "PullUpRefreshView.h"
@class QueryChaseViewController;
@protocol QueryChaseViewControllerDelegate <NSObject>

- (void)queryChaseViewDisappear:(QueryChaseViewController*)viewController;

@end

@interface QueryChaseViewController : RootViewController
<UITableViewDataSource,UITableViewDelegate,QueryChaseDetailViewDelegate>
{
    QueryChaseDetailView        *queryChaseView;
    UITableView                 *chaseTableView;// 追号查询列表
    
    PullUpRefreshView           * refreshView;          // 下拉刷新view
    int                         totalPageCount;         // 数据总页数
    int                         curPageIndex;           // 当前加载页数
    float                       startY;
    float                       centerY;

    
}
@property (nonatomic,retain)    id<QueryChaseViewControllerDelegate>delegate;
@property (nonatomic,retain)    NSMutableArray * chaseStateArray;

- (void)cancelChaseClick:(NSString*)idNo;

@end
