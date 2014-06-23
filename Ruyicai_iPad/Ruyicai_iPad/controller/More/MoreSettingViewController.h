//
//  MoreSettingViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-9-4.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 更多设置

#import "RootViewController.h"

@protocol moreSettingViewDelegate <NSObject>

- (void)moreSettingViewDisappear:(UIViewController *)viewController;

@end

@interface MoreSettingViewController : RootViewController
{
    
}
@property (nonatomic,assign) id<moreSettingViewDelegate>delegate;
@end
