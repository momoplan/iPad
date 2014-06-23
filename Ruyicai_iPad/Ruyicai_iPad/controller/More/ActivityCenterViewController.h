//
//  ActivityCenterViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-9-3.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  活动中心

#import "RootViewController.h"
#import "MoreActivityTableViewCell.h"
#import "PullUpRefreshView.h"
@protocol ActivityCenterViewDelegate <NSObject>

- (void)activityCenterViewDisappear:(UIViewController *)viewController;

@end

@interface ActivityCenterViewController : RootViewController
{
    UITableView             * acTableView;
    
    PullUpRefreshView       * refreshView;    // 下拉刷新view
    int                     totalPageCount; // 数据总页数
    int                     curPageIndex;   // 当前加载页数
    float                   startY;
    float                   centerY;

}
@property (nonatomic,assign) id<ActivityCenterViewDelegate>delegate;
@property (nonatomic,retain) NSMutableArray * acTitleArray;
@end
