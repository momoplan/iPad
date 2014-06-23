//
//  AccountDetailViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-23.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 账户明细

#import "RootViewController.h"
#import "AccountDetailTabelViewCell.h"
#import "PullUpRefreshView.h"
@class AccountDetailViewController;
@protocol AccountDetailViewControllerDelegate <NSObject>

- (void)accountDetailViewDisappear:(AccountDetailViewController *)viewController;

@end


@interface AccountDetailViewController : RootViewController
<UITableViewDataSource,UITableViewDelegate>
{
    UITableView                 * accTableView;     // 明细显示列表
    
    PullUpRefreshView           * refreshView;          // 下拉刷新view
    int                         totalPageCount;         // 数据总页数
    int                         curPageIndex;           // 当前加载页数
    float                       startY;
    float                       centerY;
    
    UIView                      * noRecordView;         // 没有记录

}
@property (nonatomic,assign) id<AccountDetailViewControllerDelegate>delegate;

@property (nonatomic,retain) NSMutableArray * accDataArray;
@property (nonatomic,retain) NSString       * accTypeString;    // 明细类型标示

@end
