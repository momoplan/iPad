//
//  QueryTogetherViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-29.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  合买查询

#import "RootViewController.h"
#import "QueryTogetherTableViewCell.h"
#import "QueryTogetherDetailView.h"
#import "PullUpRefreshView.h"
#import "TogetherDocumentaryTableCell.h"
@class QueryTogetherViewController;

@protocol QueryTogetherViewControllerDelegate <NSObject>

- (void)queryTogetherViewDisappear:(QueryTogetherViewController *)viewController;

@end

@interface QueryTogetherViewController : RootViewController
<queryTogetherDetailViewDelegate,TogetherDocumentaryTableCellDelegate>
{
    QueryTogetherDetailView         * detailBgView;
    UITableView                     * togethTabelView;// h合买信息 列表
    
    PullUpRefreshView               * refreshView;          // 下拉刷新view
    int                             totalPageCount;         // 数据总页数
    int                             curPageIndex;           // 当前加载页数
    float                           startY;
    float                           centerY;
    
    NSString                        * togeTypeString;
}
@property (nonatomic,assign) id<QueryTogetherViewControllerDelegate>delegate;
@property (nonatomic,retain) NSMutableArray * queryTogeArray; //列表数据数组
@end
