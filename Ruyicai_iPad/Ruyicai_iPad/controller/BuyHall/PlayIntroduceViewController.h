//
//  PlayIntroduceViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-17.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  玩法介绍

#import "RootViewController.h"
@class PlayIntroduceViewController;
@protocol PlayIntroduceViewDelegate <NSObject>

- (void)playIntroduceViewDisappear:(PlayIntroduceViewController *)viewController;

@end

@interface PlayIntroduceViewController : RootViewController
@property (nonatomic,retain) id<PlayIntroduceViewDelegate>delegate;
@property (nonatomic,retain) NSString *introduceLotNo; // 彩种类型 
@end
