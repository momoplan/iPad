//
//  PickNumSelectResultView.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-22.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  选球结果注数

#import "RYView.h"

@protocol PickSelectResultViewDelegate <NSObject>

@optional
- (void)pickSelectResultRefreshAction:(id)sender;
- (void)pickselectResultAddToBaskAction:(id)sender;
@end

@interface PickNumSelectResultView : RYView
{
    UILabel * resultLabel;
}
@property (nonatomic,assign)id<PickSelectResultViewDelegate>delegate;
- (void)resultLabelRefreshCount:(int)noteCount;
@end
