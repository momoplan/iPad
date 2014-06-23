//
//  LotteryTableViewCell.h
//  Ruyicai_iPad
//
//  Created by huangxin on 13-7-17.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LotteryBallCommonView.h"

@interface LotteryTableViewCell : UITableViewCell
{
    NSString                    *cell_lotTitle;//彩种
    NSString                    *cell_batchCode;//期号
    NSString                    *cell_lotteryDate;//开奖时间
    NSString                    *cell_lotteryNo;//开奖号码
    NSString                    *cell_lotteryTryNo;//试机号
    BOOL                         cell_isOpenPrize;//判断今日是否开奖
    
    UIImageView                 *cell_logoImage;
    UIImageView                 *cell_kaijiangImage;
    UILabel                     *cell_logoTitleLabel;
    UILabel                     *cell_batchCodeLabel;
    UILabel                     *cell_lotteryDateLabel;
    UILabel                     *cell_lotteryTryCodeLabel;//福彩3d的试机号
    LotteryBallCommonView       *cell_lotteryBallView;//开奖小球的显示
    UILabel                     *cell_openPrizeWeek;//一周的哪几天开奖
}
@property (nonatomic,retain) UILabel    *openPrizeWeek;
@property (nonatomic,retain) UIImageView *kaijiangImage;
@property (nonatomic,assign) BOOL        isOpenPrize;
@property (nonatomic,retain) UIImageView *logoImage;
@property (nonatomic,retain) NSString    *lotTitle;
@property (nonatomic,retain) UILabel     *logoTitleLabel;
@property (nonatomic,retain) NSString    *batchCode;
@property (nonatomic,retain) NSString    *lotteryDate;
@property (nonatomic,retain) UILabel     *batchCodeLabel;
@property (nonatomic,retain) UILabel     *lotteryDateLabel;
@property (nonatomic,retain) NSString    *lotteryNo;
@property (nonatomic,retain) NSString    *lotteryTryNo;
@property (nonatomic,retain) UILabel     *lotteryTryCodeLabel;
@property (nonatomic,retain) LotteryBallCommonView *lotteryBallView;

- (void)refreshCell;

@end
