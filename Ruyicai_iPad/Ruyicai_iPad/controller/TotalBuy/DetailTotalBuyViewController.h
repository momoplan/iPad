//
//  DetailTotalBuyViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-19.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  合买详情

#import "RootViewController.h"
#import "DetailTotalViewPartCell.h"
#import "QueryTogetherDetailModel.h"
#import "TotalBuyViewCellModel.h"
#import "TogetherParticipationModel.h"
#import "LoginViewController.h"
@class DetailTotalBuyViewController;
@protocol DetailTotalBuyViewDelegate <NSObject>
// 释放该控制器
- (void)detailTotalBuyViewDisappear:(DetailTotalBuyViewController*)viewController;

@end

@interface DetailTotalBuyViewController : RootViewController
<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,LoginViewControllerDelegate>
{
    UITableView     * partTableView;//参与人员
    UITextField     * subTextField;//认购输入框
    UILabel         * subPerLabel;// 认购占比例
    UITextField     * miniTextField;//保底
    
    int             icoHeightIndex;
    UIView          * headView;
    
    int         m_joinDataPageTotal;//参与人员页数
    int         m_currentJoinDataPage;
    PullUpRefreshView *m_refreshView;//跟单人员上拉加载
}
@property (nonatomic,assign) id<DetailTotalBuyViewDelegate>delegate;
@property (nonatomic,retain) QueryTogetherDetailModel   * togeModel;//详情model
@property (nonatomic,retain) TotalBuyViewCellModel      * cellModel;//合买model
@property (nonatomic,retain) NSMutableArray             * detailPartDataArray;//参与人员 数组
@property (nonatomic,assign) BOOL isJoinOK;//参与成功的返回
@end
