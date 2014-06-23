//
//  TotalBuyViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-6-27.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  合买大厅

#import "RootViewController.h"
#import "TotalBuyViewCell.h"
#import "DetailTotalBuyViewController.h"
@interface TotalBuyViewController : RootViewController
<UITableViewDataSource,UITableViewDelegate,DetailTotalBuyViewDelegate>
{
    UITableView         * totalTableView;
    NSString            * orderString;
    BOOL                isProgressOrder;
    BOOL                isParticipantCountOrder; //顺序标示
    BOOL                isTotalAmtOrder;
    
    PullUpRefreshView * refreshView;    // 下拉刷新view
    int                 totalPageCount; // 数据总页数
    int                 curPageIndex;   // 当前加载页数
}
@property (nonatomic,retain) NSMutableArray  *totalDataArray;
@end
