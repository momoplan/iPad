//
//  LotteryAnnouncementViewController.h
//  Ruyicai_iPad
//
//  Created by huangxin on 13-7-17.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RootViewController.h"
#import "LotteryDetailViewController.h"

@interface LotteryAnnouncementViewController : RootViewController<LotteryDetailViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSUInteger                 m_cellCount;
    
    UITableView               *m_myTableView;
    NSMutableArray            *m_lotNameArray;
    NSMutableArray            *m_lotteryNoArray;
    
    NSDictionary              *m_netData;
    NSArray                   *m_todayOpenPrizeLotNoArray;//今日开奖的彩种
    
    LotteryDetailViewController *m_lotteryViewController;
    
    NSString                  *m_openPrizeBatchCode;
}
@property (nonatomic,retain) NSString *openPrizeBatchCode;
@property (nonatomic,retain) NSDictionary *netData;
@property (nonatomic,assign) NSUInteger cellCount;
@property (nonatomic,retain) UITableView *myTableView;
@property (nonatomic,retain) NSMutableArray *lotNameArray;
@property (nonatomic,retain) NSMutableArray *lotteryNoArray;
@property (nonatomic,retain) NSArray *todayOpenPrizeLotNoArray;


@end
