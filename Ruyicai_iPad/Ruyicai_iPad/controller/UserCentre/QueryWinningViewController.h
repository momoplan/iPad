//
//  QueryWinningViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-25.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  中奖查询

#import "RootViewController.h"
#import "QueryWinningTableViewCell.h"
#import "PullUpRefreshView.h"


@protocol  QueryWinningViewControllerDelegate;

@interface QueryWinningViewController : RootViewController
<UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView                * queryDetailView;//中奖详情 
    UITableView                 * winTabelView;// 中奖信息 列表
    
    PullUpRefreshView           * refreshView;          // 下拉刷新view
    int                         totalPageCount;         // 数据总页数
    int                         curPageIndex;           // 当前加载页数
    float                       startY;
    float                       centerY;
    UIView                      * noRecordView;         // 没有记录
    
}
@property (nonatomic,assign)    id<QueryWinningViewControllerDelegate>delegate;
@property (nonatomic,retain)    NSMutableArray * queryWinDataArray;
@property (nonatomic,retain)    NSString* clickLotNo;//查看详情的彩种
@end


@protocol QueryWinningViewControllerDelegate <NSObject>

- (void)queryWinningViewDisappear:(QueryWinningViewController *)viewController;

@end