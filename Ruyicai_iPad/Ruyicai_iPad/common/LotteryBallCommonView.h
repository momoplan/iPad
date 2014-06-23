//
//  LotteryBallCommonView.h
//  Ruyicai_iPad
//
//  Created by huangxin on 13-7-18.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef struct{
    int redBallCount;
    int blueBallCount;
    
}BallBlock;

@interface LotteryBallCommonView : UIView
{
    
}
//画小球
- (void) drawBallWithLotteryCode:(NSString*) lotteryCode
                    lotteryTitle:(NSString*)lotTitle
                           scope:(float)scope;
//获得中奖号码的数组
- (NSArray*) getLotteryNoArrayWithString:(NSString*)lottery lotteryTitle:(NSString*)lotTitle;

//获得彩种红蓝球的个数
- (BallBlock) getBallCount:(NSString*) lotTitle;

//判断是否要取int
- (BOOL) isChangedCodeIntWithCodeString:(NSString *)lotTitle;

@end
