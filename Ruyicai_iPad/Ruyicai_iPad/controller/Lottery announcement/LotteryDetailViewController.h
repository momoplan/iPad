//
//  LotteryDetailViewController.h
//  Ruyicai_iPad
//
//  Created by huangxin on 13-7-23.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LotteryDatailView.h"
#import "PullUpRefreshView.h"

@class LotteryDetailViewController;
@protocol LotteryDetailViewDelegate <NSObject>

- (void)LotteryDetailViewDisappear:(LotteryDetailViewController*)viewController;

@end

@interface LotteryDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, RYCNetworkManagerDelegate>
{
    LotteryDatailView   *m_lotteryDetailView;
    
    NSString            *m_lotTitle;
    UITableView         *m_myTableView;
    NSString            *m_detailBatchCode;
    
    NSMutableArray      *m_historyLotteryData;//历史开奖数据
    NSDictionary        *m_lotteryDetailData;//开奖详情页面数据
    
    PullUpRefreshView           * refreshView;          // 下拉刷新view
    int                         totalPageCount;         // 数据总页数
    int                         curPageIndex;           // 当前加载页数
    float                       startY;
    float                       centerY;
}
@property (nonatomic,retain) LotteryDatailView              *lotteryDetailView;
@property (nonatomic,retain) NSDictionary                   *lotteryDetailData;
@property (nonatomic,retain) NSMutableArray                        *historyLotteryData;
@property (nonatomic,retain) NSString                       *lotTitle;
@property (nonatomic,assign) id<LotteryDetailViewDelegate>   delegate;
@property (nonatomic,retain) UITableView                    *myTableView;
@property (nonatomic,retain) NSString                       *detailBatchCode;
//刷新数据
- (void) refreshView;

@end
