//
//  DLT_PickNumberViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-14.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 大乐透 选球

#import "RootViewController.h"
#import "PickNumberBasketTableCell.h"
#import "PickerViewController.h"
#import "PickBallView.h"
#import "PickNumBasketView.h"
#import "PickNumSelectResultView.h"
#import "PlayIntroduceViewController.h"
#import "BuyLotteryNumberViewController.h"
#import "LoginViewController.h"
@protocol DLT_PickNumberViewDelegate <NSObject>

- (void)DLT_PickNumberViewDisappear:(UIViewController *)viewController;

@end

@interface DLT_PickNumberViewController : RootViewController
<PickBallViewDelegate,PlayIntroduceViewDelegate,
BuyLotteryNumberViewDelegate,PickSelectResultViewDelegate,
PickNumberBasketViewDelegate,LoginViewControllerDelegate>
{
    
    UIView      * DLTBallView;
    UIScrollView * DLTOptionalView;//自选
    UIScrollView * DLTDragView;//拖胆
    
    UIButton    * narViewBtn;  // 玩法显示
    UIView      * playSelectView; // 玩法选择view
    NSString    * viewShowType; // 玩法标示
    
    PickNumSelectResultView *selectResultView;
    
    PickNumBasketView *numBasketView; // 号码篮
    
    PickBallView * beforeAreaView; // 前区
    PickBallView * behindAreaView; // 后区
    
    PickBallView * beforeD;//前区胆码
    PickBallView * beforeG;//前区拖码
    PickBallView * behindDView;// 后区胆码
    PickBallView * behindGView;//后区 拖码
    
    NSMutableArray *optionalBeforeArray; //自选前区数组
    NSMutableArray *optionalBehindArray; //自选后区数组
    
    NSMutableArray *dragBeforeDanmaArray; //拖胆前区胆码数组
    NSMutableArray *dragBeforeTuomaArray; //拖胆前区拖码数组
    
    NSMutableArray *dragBehindDanmaArray; //拖码后区胆码数组
    NSMutableArray *dragBehindTuomaArray; //拖码后区拖码数组
    NSDictionary    *itemDic;
    
    NSTimer * m_timer; //定时器
    
    UIView * messDetailView; //详情
    
    NSString * issueString; // 当前期号

}

@property (nonatomic,assign) id<DLT_PickNumberViewDelegate>delegate;
@property (nonatomic,retain) NSMutableArray * numberDataArray;
@property (nonatomic,retain) NSString * batchEndTime; // 剩余时间

@end
