//
//  RYC_SSQBallView.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-2.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

typedef enum ball_type
{
    Red_Ball = 1,
	Blue_Ball = 2
    
} ball_Type;
@class RYC_SSQBallView;
@protocol SSQBallViewDelegate <NSObject>

@optional
- (void)ballSelcetResultArray:(NSMutableArray *)array ballView:(RYC_SSQBallView *)ballView;

@end

#import "RYView.h"

@interface RYC_SSQBallView : RYView
{
}

@property (nonatomic,assign) id<SSQBallViewDelegate>delegate;
/* 传入最大球数 num 每行可排球数 perline 至少选球数 */
- (void)numberOfRedBall:(int)num  withPerLine:(int)perLine selectBallCount:(int)count kindBall:(int)ballKind headTitle:(NSString *)headText;
/* 机选选区 */
- (void)ballAutoSelectWithStart:(int)startNum maxNum:(int)autoNum perLine:(int)perLine;
/* 防止选择相同的号码 */
- (void)ballViewDifferentNumber:(NSArray *)numArray;

- (void)clearBallState;
@end
