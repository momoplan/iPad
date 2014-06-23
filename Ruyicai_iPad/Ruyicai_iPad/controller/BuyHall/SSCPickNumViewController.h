//
//  SSCPickNumViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-22.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 时时彩

#import "RootViewController.h"
#import "PickNumPlayKindSelectView.h"
#import "PickBallView.h"
#import "PickNumSelectResultView.h"
#import "PickNumBasketView.h"
#import "SSCBigSmallSingleDoubleView.h"
#import "LoginViewController.h"
#import "PlayIntroduceViewController.h"
#import "BuyLotteryNumberViewController.h"

@protocol SSCPickNumViewDelegate <NSObject>

- (void)SSCPickViewDisappear:(UIViewController *)viewController;

@end

@interface SSCPickNumViewController : RootViewController
<PickNumPlayKindSelectDelegate,PickBallViewDelegate,PickSelectResultViewDelegate,
BigSmallSingDoubleViewDelegate,PlayIntroduceViewDelegate,
BuyLotteryNumberViewDelegate,PickNumberBasketViewDelegate,
LoginViewControllerDelegate>
{
     UIButton * narViewBtn;
    PickNumPlayKindSelectView *playSelectView;//玩法选择
    PickNumBasketView * basketView; // 号码篮
    PickNumSelectResultView * selectResultView; // 选号结果
    UIView * messDetailView; //详情

    NSTimer * m_timer;
    
    UIView * ballView;// 球区
    UIView * oneStarBallView; // 一星 普通
    UIView * twoSelfSelectView;// 2星 自选
    UIView * twoGroupSelectView; // 2星 组选
    UIView * twoSumSelectView; // 2星 和值
    UIView * threeSelfSelectView; // 三星 自选
    UIView * threeGroupThView; // 三星 组三
    UIView * threeGroupSixView; // 三星 组六
    UIScrollView * fiveSelfSelectView; // 五星 自选
    UIScrollView * fiveGeneralSelectView; // 五星通选
    SSCBigSmallSingleDoubleView * bigSmallSelectView; // 大小单双
    
    NSMutableArray * millViewArray;
    NSMutableArray * thouViewArray;
    NSMutableArray * hundViewArray;
    NSMutableArray * decaViewArray;
    NSMutableArray * indiViewArray;
    
    
    NSString * playTypeString; // 玩法标示
    NSDictionary * itemDic; // 注数信息
    NSString * issueString;     // 当前期号
}
@property (nonatomic,assign) id<SSCPickNumViewDelegate>delegate;

@property (nonatomic,retain) NSString * batchEndTime; // 剩余时间

@end
