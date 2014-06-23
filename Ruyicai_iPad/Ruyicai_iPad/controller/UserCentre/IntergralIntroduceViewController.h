//
//  IntergralIntroduceViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-11-13.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 如何兑换积分
 
#import "RootViewController.h"


@protocol IntergralIntroduceViewDelegate <NSObject>

- (void)intergralIntroduceViewDisappear:(UIViewController *)viewController;

@end

@interface IntergralIntroduceViewController : RootViewController
{
    UITextView * contentTextView;
}
@property (nonatomic,retain) id<IntergralIntroduceViewDelegate>delegate;
@end
