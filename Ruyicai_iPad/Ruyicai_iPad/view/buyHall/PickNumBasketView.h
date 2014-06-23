//
//  PickNumBasketView.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-22.
//  Copyright (c) 2013年 baozi. All rights reserved.
//   号码篮

#import "RYView.h"
#import "SetChaseStageTableView.h"
#import "PickerViewController.h"
#import "PickNumberBasketTableCell.h"


#define BetMaxMulCount (10000)
#define BetMaxStageCount (200)

@protocol PickNumberBasketViewDelegate <NSObject>

@optional
- (BOOL)isPickNumCanBuy;

@end

@interface PickNumBasketView : RYView
<PickerViewControllerDelegate,
UIAlertViewDelegate,
UITextViewDelegate,
PickNumberBasketCellDelegate>
{
 
    UIScrollView        * basketView;
    UIView              * basketBetView;            //投注
    UIView              * basketChaseView;          //追号
    UIView              * basketTogethoerView;      //合买
    UIView              * basketSendView;           //赠送
    UITableView         * numTableView;             //号码篮显示列表
    
    SetChaseStageTableView  *stageTableView;        // 设置追期
    
    
    int                 allCount;                   // 总注数
    int                 allCostMoney;               // 总金额
    NSString            * betType;                  // 投注类型
    int                 mulCount;                   // 倍数
    int                 stageCount;                 // 期数
    NSString            * isPrizeend;               // 中奖后是否停止追号
    int                 buyAmt;                     // 认购金额
    int                 minAmt;                     // 最低跟单
    int                 safeAmt;                    // 保底金额
    NSString            * commisionRation;          // 提成比例
    BOOL                isSumTure;                // 全额保底
    UIPopoverController * popover;                   //
    NSInteger            openState;             // 公开状态
    
}

@property (nonatomic,retain) NSMutableArray      * numDataArray;             //号码篮 显示数组
@property (nonatomic,retain) NSString * lotNo; //彩种
@property (nonatomic,retain) NSString * thisBatchCode; // 期号
@property (nonatomic,assign) id<PickNumberBasketViewDelegate>delegate;

- (void)pickNumberBasketViewItem:(NSArray *)itemArray;
- (void)pickTableViewArrayAddItem:(NSDictionary *)item;
- (void)getThisLotNoString:(NSString *)lotNoStr andThisBatchString:(NSString *)batchCode;
@end
