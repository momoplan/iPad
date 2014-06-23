//
//  AlipayPaymentViewController.h
//  Ruyicai_iPad
//
//  Created by Zhang Xiaofeng on 13-7-23.
//  Copyright (c) 2013年 baozi. All rights reserved.
//   支付宝充值

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface AlipayPaymentViewController : RootViewController<UIWebViewDelegate, UITextFieldDelegate>

@property(nonatomic, retain)IBOutlet UITextField* amountField;

@end
