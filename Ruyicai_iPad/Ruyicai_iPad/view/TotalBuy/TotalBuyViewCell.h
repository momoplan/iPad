//
//  TotalBuyViewCell.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-18.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  合买大厅 列表cell

#import <UIKit/UIKit.h>
#import "TotalBuyViewCellModel.h"
#import "GoalBarView.h"
#import "RYCImageNamed.h"
@interface TotalBuyViewCell : UITableViewCell
{
    UILabel         * perLabel;//保底进度
        
    UILabel         * everyLabel;// 认购金额
    UILabel         * surpiusLabel;//保底金额
    UILabel         * allCostLabel;//方案总金额
    UILabel         * originatorLabel;//发起人
    UILabel         * kindLabel;//彩种名称
    UILabel         * numLabel;//合买进度
    UIImageView     * progressImage;//进度 图片
    GoalBarView     * goalProgressView;
    UIImageView     * topImg;
    
    //金冠，金杯，金钻，金星，灰冠，灰杯，灰钻，灰星
    UIView  *   m_honorView;//荣誉
    
    int             icoHeightIndex;
}
@property (nonatomic,retain) TotalBuyViewCellModel * model; //数据模型
//根据数据 刷新
- (void)totalBuyCellRefresh;
@end
