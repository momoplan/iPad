//
//  QueryBetViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-25.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  投注查询

#import "RootViewController.h"
#import "QueryWinningTableViewCell.h"
#import "PullUpRefreshView.h"
@class QueryBetViewController;
@protocol QuetyBetViewControllerDelegate <NSObject>

- (void)queryBetViewDisappear:(QueryBetViewController *)viewController;

@end

@interface QueryBetViewController : RootViewController
<UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView                * queryDetailView;
    UITableView                 * betTableView;//查询 信息
    
    PullUpRefreshView           * refreshView;          // 下拉刷新view
    int                         totalPageCount;         // 数据总页数
    int                         curPageIndex;           // 当前加载页数
    float                       startY;
    float                       centerY;
    UIView                      * noRecordView;         // 没有记录
}

@property (nonatomic,assign) id<QuetyBetViewControllerDelegate>delegate;
@property (nonatomic,retain) NSMutableArray * quetyBetArray;
@end
