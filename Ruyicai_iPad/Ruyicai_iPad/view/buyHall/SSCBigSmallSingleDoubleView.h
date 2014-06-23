//
//  SSCBigSmallSingleDoubleView.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-26.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  时时彩大小单双

#import "RYView.h"

@protocol BigSmallSingDoubleViewDelegate <NSObject>

- (void)bigSmallSingDoubleViewSelectResultDecArray:(NSMutableArray *)decAry indArray:(NSMutableArray *)indAry;

@end

@interface SSCBigSmallSingleDoubleView : RYView
{
    NSMutableArray * decStateArray;
    NSMutableArray * indStateArray;
    int decSelectNum;
    int indSelectNum;
    UIView * decMessView;
    UIView * indMessView;
}
@property (nonatomic,assign) id<BigSmallSingDoubleViewDelegate>delegate;
- (void)clearAllSelectState;
@end
