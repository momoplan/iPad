//
//  DrawMoneyViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-22.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 账户提现

#import "RootViewController.h"
#import "DrawMoneyRecordViewCell.h"
#import "PickerViewController.h"
#import "PullUpRefreshView.h"
@class DrawMoneyViewController;
@protocol DrawMoneyViewControllerDelegate <NSObject>

- (void)drawMoneyViewDisappear:(DrawMoneyViewController *)viewController;

@end

@interface DrawMoneyViewController : RootViewController
<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,PickerViewControllerDelegate,RecordViewTableCellDelegate,UIAlertViewDelegate>
{
    UIScrollView                * bankView;             //银行卡
    UIScrollView                * aliPayView;           //提现 支付宝
    
    UIPopoverController         * popoverView;          // 银行选择pop
    NSInteger                   pickViewSelectNum;      // 银行选择结果
    NSArray                     * bankArray;            // 银行名称
    NSString                    * typeString;           // 提现类型
    
    UITableView                 * recordTableView;      // 提现记录
    
    PullUpRefreshView           * refreshView;          // 下拉刷新view
    int                         totalPageCount;         // 数据总页数
    int                         curPageIndex;           // 当前加载页数
    float                       startY;
    float                       centerY;
    
    NSString                    * cancelCashId;         // 取消提现编号
}
@property (nonatomic, retain) NSDictionary  *DNADataDic;//是否绑定

@property (nonatomic,assign) id<DrawMoneyViewControllerDelegate>delegate;
@property (nonatomic,retain) NSString               * drawbalanceString;
@property (nonatomic,retain) NSMutableArray         * recordDataArray;
@end
