//
//  LotteryInformationViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-29.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  彩票资讯

#import "RootViewController.h"
#import "PullUpRefreshView.h"

@protocol LotteryInfoViewDelegate  <NSObject>

- (void)lotteryInfoViewDisappear:(UIViewController *)viewController;

@end

@interface LotteryInformationViewController : RootViewController
<UITableViewDataSource,UITableViewDelegate>
{
    UIView                  * contentView;
    UITableView             * titleTableView;
    
    NSString                * typeString;
}

@property (nonatomic,assign) id<LotteryInfoViewDelegate>delegate;
@property (nonatomic,retain) NSMutableArray * newsTitleAry;
@end
