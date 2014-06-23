//
//  BuyLotteryNumberViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-10-18.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  开奖号码

#import "RootViewController.h"
#import "BuyLotteryTableCell.h"
#import "PullUpRefreshView.h"
@protocol BuyLotteryNumberViewDelegate <NSObject>

- (void)buyLotteryNumberViewDisappear:(UIViewController *)viewController;

@end

@interface BuyLotteryNumberViewController : RootViewController
<UITableViewDataSource,UITableViewDelegate>
{
    UITableView       * lotNumTableView;
    
    PullUpRefreshView * refreshView;    // 下拉刷新view
    int                 totalPageCount; // 数据总页数
    int                 curPageIndex;   // 当前加载页数
    float               startY;
    float               centerY;
    
}
@property (nonatomic,retain) NSString * numLotNo;
@property (nonatomic,retain) NSMutableArray  * lotteryArray;
@property (nonatomic,assign) id<BuyLotteryNumberViewDelegate>delegate;
@end
