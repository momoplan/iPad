//
//  LotteryDatailView.h
//  Ruyicai_iPad
//
//  Created by huangxin on 13-7-24.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LotteryBallCommonView.h"
#import "CustomFormView.h"

@interface LotteryDatailView : UIView
{
    NSString              *m_lotNo;
    NSDictionary          *m_detailData;
    
    UILabel               *m_batchCodeLabel;
    UILabel               *m_openPrizeDateLabel;
    LotteryBallCommonView *m_ballView;
    
    UILabel               *m_xiaoLiangLabel;//销量
    UILabel               *m_jiangChiLabel;//奖池
    
    UIView                *m_formHeadView;//表头
    CustomFormView        *m_formView;//表格
    UIScrollView          *m_myScrollView;//scrollView
}
@property (nonatomic,retain) NSString *lotNo;

@property (nonatomic,retain) NSDictionary *detailData;

@property (nonatomic,retain) UILabel *batchCodeLabel;
@property (nonatomic,retain) UILabel *openPrizeDateLabel;
@property (nonatomic,retain) LotteryBallCommonView *ballView;

@property (nonatomic,retain) UILabel *xiaoLiangLabel;
@property (nonatomic,retain) UILabel *jiangChiLabel;

@property (nonatomic,retain) CustomFormView *formView;
@property (nonatomic,retain) UIView *formHeadView;
@property (nonatomic,retain) UIScrollView *myScrollView;

- (void) refleshView;

@end
