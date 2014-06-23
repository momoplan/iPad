//
//  BaseHelpViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-11-4.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  关于我们

#import "RootViewController.h"

@protocol BaseHelpViewDelegate <NSObject>

- (void)baseHelpViewDisappear:(UIViewController *)viewController;

@end



@interface BaseHelpViewController : RootViewController
<UIWebViewDelegate>
{
     UIWebView* m_webView;
}
@property (nonatomic, retain) NSString* htmlFileName;
@property (nonatomic,retain) id<BaseHelpViewDelegate>delegate;
- (void)refresh;
@end
