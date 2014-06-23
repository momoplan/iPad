//
//  IntegralDetailViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-24.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  我的积分

#import "RootViewController.h"
#import "integralDetailViewContollerCell.h"
#import "PullUpRefreshView.h"
#import "IntergralIntroduceViewController.h"
@class IntegralDetailViewController;
@protocol IntegralDetailViewContorollerDelegate <NSObject>

- (void)integralDetailViewDisappear:(IntegralDetailViewController *)viewController;

@end


@interface IntegralDetailViewController : RootViewController
<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,IntergralIntroduceViewDelegate>
{
    UITableView         * intTableView;
    UITextField         * useTextField;//积分输入框
    UILabel             * inteLabel;
    UILabel             * numLabel;
    
    PullUpRefreshView           * refreshView;          // 下拉刷新view
    int                         totalPageCount;         // 数据总页数
    int                         curPageIndex;           // 当前加载页数
    float                       startY;
    float                       centerY;
}
@property (nonatomic,retain) NSString * userScore;
@property (nonatomic,retain) NSMutableArray * integralDataArray;

@property (nonatomic,assign) id<IntegralDetailViewContorollerDelegate>delegate;
@end
