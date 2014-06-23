//
//  PickBallView.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-20.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  球区绘制

typedef enum Ball_type
{
    Ball_Red = 1,
	Ball_Blue ,
    
} Ball_Type;
#import "RYView.h"
@class PickBallView;
@protocol PickBallViewDelegate <NSObject>

- (void)ballViewResultArray:(NSMutableArray *)array selectView:(PickBallView *)ballView;

@end

@interface PickBallView : RYView
{
    UIView  *autoListView;
    UIButton * autoButton;
   

    
}
@property (nonatomic,retain) id<PickBallViewDelegate>delegate;
@property (nonatomic,retain)  NSMutableArray * ballStateArray;//彩球状态
@property (nonatomic,assign)  NSInteger currentPickIndex;//当前选择的index
/*
    选球区 布局
 */
- (void)ballViewCreateStartValue:(int)startValue ballCount:(int)ballCount perLine:(int)line leastNum:(int)leastNum selectMaxNum:(int)maxNum ballType:(Ball_Type)type;
/*
    自动 机选按钮分布
 */
- (void)ballViewAutoSelectWithStart:(int)startNum maxNum:(int)maxNum perLine:(int)perLine;
/*
  福彩3D 组三 单式
 */
- (void)differentBallGroupNumberArray:(NSArray *)numArray;
/*
 防止选择相同的号码 
 */
- (void)ballViewDifferentNumber:(NSMutableArray *)numArray;
- (BOOL)stateForIndex:(int)index;
- (void)resetStateForIndex:(int)index;
/* 
 选球区标题
 */
- (void)ballVIewTitle:(NSString *)string;
/*
 选球区文字提示
 */
- (void)ballSumViewTitle:(NSString *)title;
/*
    清空选球信息
 */
- (void)clearBallState;
@end
