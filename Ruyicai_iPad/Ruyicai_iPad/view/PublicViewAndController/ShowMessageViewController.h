//
//  ShowMessageViewController.h
//  Ruyicai_iPad
//
//  Created by Zhang Xiaofeng on 13-7-26.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowMessageViewController : UIViewController<UIWebViewDelegate>

@property(nonatomic, assign)BOOL         isTextView;//是tectView显示还是webView显示
@property(nonatomic, retain)NSString*    myTitle;
@property(nonatomic, retain)NSString*    contentStr;

@end
