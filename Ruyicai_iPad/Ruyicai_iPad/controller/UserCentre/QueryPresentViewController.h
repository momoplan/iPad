//
//  QueryPresentViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-29.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 赠彩 查询

 
#import "RootViewController.h"
#import "QueryPresentTableViewCell.h"
#import "PullUpRefreshView.h"
@class QueryPresentViewController;

@protocol QueryPresentViewControllerDelegate <NSObject>

- (void)queryPresentViewDisappear:(QueryPresentViewController *)viewController;

@end

@interface QueryPresentViewController : RootViewController
{
    UIView                      * presentDetailView;
    UIView                      * presentBackView;
    UITableView                 * presentTableView;// 赠彩 查询列表
    UILabel                     * cLabel;//无记录
    NSString                    * isGift;
    
    PullUpRefreshView           * refreshView;          // 下拉刷新view
    int                         totalPageCount;         // 数据总页数
    int                         curPageIndex;           // 当前加载页数
    float                       startY;
    float                       centerY;
}

@property (nonatomic,assign) id<QueryPresentViewControllerDelegate>delegate;
@property (nonatomic,retain) NSMutableArray * queryGiftArray;
@end
