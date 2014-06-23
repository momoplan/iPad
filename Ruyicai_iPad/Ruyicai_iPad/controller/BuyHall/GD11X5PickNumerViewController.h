//
//  GD11X5PickNumerViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-26.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  广东11选5

#import "RootViewController.h"
#import "PickBallView.h"
#import "PickNumBasketView.h"
#import "PickNumPlayKindSelectView.h"
#import "PickNumSelectResultView.h"
#import "LoginViewController.h"
#import "PlayIntroduceViewController.h"
#import "BuyLotteryNumberViewController.h"

@protocol GD11X5PickNumberViewDelegate <NSObject>

- (void)GD11X5PickNumberViewDisappear:(UIViewController *)viewController;

@end

@interface GD11X5PickNumerViewController : RootViewController
<PickBallViewDelegate,PickNumPlayKindSelectDelegate,
PickSelectResultViewDelegate,PlayIntroduceViewDelegate,
BuyLotteryNumberViewDelegate,PickNumberBasketViewDelegate,
LoginViewControllerDelegate>
{
    UIButton *narViewBtn;
    PickNumPlayKindSelectView   * playKindSelectView; // 玩法选择
    PickNumBasketView           * basketView;  // 号码篮
    PickNumSelectResultView     * selectResultView; //选球结果

    
    UIView *ballAreaView;
    UIView *optionSelectFiveView; // 普通 任选五
    UIView *normalSelectTwoView; // 普通 任选二
    UIView *normalSelectThreeView; // 普通 任选三
    UIView *normalSelectFourView; // 普通 任选四
    UIView *normalSelectSixView; // 普通 任选六
    UIView *normalSelectSevenView; // 普通 任选七
    UIView *normalSelectEightView; // 普通 任选八
    UIView *normalFrontOneView; // 普通 前一
    UIView *normalFrontTwoSelectView; // 普通 前二直选
    UIView *normalFrontTwoGroupView; // 普通 前二组选
    UIView *normalFrontThreeSelectView; // 普通 前三直选
    UIView *normalFrontThreeGroupView; // 普通 前三组选
    
    UIView *dragSelectTwoView; //  胆拖 任选二
    UIView *dragSelectThreeView; // 胆拖 任选三
    UIView *dragSelectFourView; // 胆拖 任选四
    UIView *dragSelectFiveView; // 胆拖 任选五
    UIView *dragSelectSixView; // 胆拖 任选六
    UIView *dragSelectSevenView; // 胆拖 任选七
    UIView *dragFrontTwoGroupView; // 胆拖 前二组选
    UIView *dragFrontThreeGroupView; // 胆拖 前三组选
    
    NSTimer * m_timer;
    
    NSMutableArray * optionBallArray;
    NSMutableArray * dragFirstArray;
    NSMutableArray * dragSecondArray;
    
    NSDictionary * itemDic; // 注数信息
    NSString * playTypeString;
    UIView * messDetailView; //详情
    NSString * issueString;  // 当前期号

}
@property (nonatomic,retain) id<GD11X5PickNumberViewDelegate>delegate;
@property (nonatomic,retain) NSString * batchEndTime; // 剩余时间
@end
