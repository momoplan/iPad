//
//  FC3DPickViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-19.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 福彩3D 投注

#import "RootViewController.h"
#import "PickBallView.h"
#import "PickNumPlayKindSelectView.h"
#import "PickNumBasketView.h"
#import "PickNumSelectResultView.h"
#import "PlayIntroduceViewController.h"
#import "BuyLotteryNumberViewController.h"
#import "LoginViewController.h"
@protocol FC3DPickViewDelegate <NSObject>


- (void)FC3DPickViewDisappear:(UIViewController *)controller;

@end

@interface FC3DPickViewController : RootViewController
<PickBallViewDelegate,PickNumPlayKindSelectDelegate,
PlayIntroduceViewDelegate,
BuyLotteryNumberViewDelegate,PickNumberBasketViewDelegate,
PickSelectResultViewDelegate,LoginViewControllerDelegate>
{
    UIButton * narViewBtn;//
    
    
    PickNumPlayKindSelectView *playSelectView;//玩法选择
    PickNumSelectResultView * selectResult;
    
    UIView * ballWholeView;//球区
    
    UIView * ballGeneralView;//自选普通
    UIView * ballGeneralSumView;//自选 和值
    UIView * ballGroupThSingleView;//组三 单式
    UIView * ballGroupThComplexView;// 组三 复式
    UIView * ballGroupThSumView;//组三 和值
    UIView * ballGroupSixSingleView;//组六 普通
    UIView * ballGroupSixSumView;//组六 和值
    
    NSString            * playTypeString; // 玩法标示
    PickNumBasketView   * pickBaesketView; // 号码篮
    NSDictionary        * itemDic; // 注数信息
    
    NSMutableArray *generalHunArray; // 自选普通 百位
    NSMutableArray *generalDecArray; // 自选普通 十位
    NSMutableArray *generalIndArray; // 自选普通 个位
    
    NSTimer     * m_timer;
    UIView      * messDetailView; //详情
    NSString    * issueString;  // 当前期号他str

}
@property (nonatomic,assign) id<FC3DPickViewDelegate>delegate;
@property (nonatomic,assign) NSMutableArray * numberDataArray;
@property (nonatomic,retain) NSString * batchEndTime; // 剩余时间

@end
