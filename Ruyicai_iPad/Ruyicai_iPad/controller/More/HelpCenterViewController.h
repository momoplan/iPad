//
//  HelpCenterViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-9-2.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  帮助中心

#import "RootViewController.h"
#import "PullUpRefreshView.h"
@protocol HelpCenterViewDelegate <NSObject>

- (void)helpCenterViewDisappear:(UIViewController *)viewController;

@end

@interface HelpCenterViewController : RootViewController
{
    UITableView                 * leftTabelView;
    
    NSString                    * typeString;
    
    PullUpRefreshView           * refreshView;    // 下拉刷新view
    int                         totalPageCount; // 数据总页数
    int                         curPageIndex;   // 当前加载页数
    float                       startY;
    float                       centerY;
}
@property (assign,nonatomic) id<HelpCenterViewDelegate>delegate;
@property (nonatomic,retain) NSMutableArray * titleArray;
@end
