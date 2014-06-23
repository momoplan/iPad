//
//  TicketKindViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-6-28.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  双色球

#import "RootViewController.h"
#import "RYNarBarView.h"

#import "MoreBetListTabelViewCell.h"
#import "BatchCodeCell.h"

//
#import "PickerViewController.h"
#import "PlayIntroduceViewController.h"
#import "PickBallView.h"
#import "PickNumBasketView.h"
#import "PickNumSelectResultView.h"
#import "PickNumPlayKindSelectView.h"
#import "BuyLotteryNumberViewController.h"
//登陆
#import "LoginViewController.h"

@class TicketKindViewController;
@protocol TicketKindDelegate <NSObject>

@optional
- (void)disMissTicketKindViewController:(TicketKindViewController*)controller;

@end

@interface TicketKindViewController : RootViewController
<RYNarBarViewDelegate,PickBallViewDelegate,
PlayIntroduceViewDelegate,PickSelectResultViewDelegate,BuyLotteryNumberViewDelegate,PickNumberBasketViewDelegate,LoginViewControllerDelegate>
{
    
    UILabel * numberLabel;              // 当前期号
    UILabel * thisEndLabel;             // 截止时间
    UILabel * beforeIssueLaebl;         // 上期期号label
    UILabel * bePrizeLabel;             // 上期中奖号码
    NSTimer * m_timer;                  // 定时器

    NSString * issueString;             // 当前期号str
    
    UIView * ballViewBg;
    UIScrollView *BallDirectView; //直选
    UIScrollView *BallDragView;//胆拖
    
    PickNumBasketView * pickBaesketView;
    PickNumSelectResultView *selectResult;
    NSMutableArray * redDanArray;
    NSMutableArray * redTuoArray;
    NSMutableArray * bluePickArray;
    NSDictionary *itemDic;
    NSString * playTypeString;
    
}
@property (nonatomic,assign) id<TicketKindDelegate>delegate;
@property (nonatomic,retain) NSString * batchEndTime; // 截止时间
@end
