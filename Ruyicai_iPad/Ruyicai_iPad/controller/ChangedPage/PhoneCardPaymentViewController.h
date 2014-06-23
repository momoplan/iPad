//
//  PhoneCardPaymentViewController.h
//  Ruyicai_iPad
//
//  Created by Zhang Xiaofeng on 13-7-29.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 手机充值卡充值

#import <UIKit/UIKit.h>

#import "RootViewController.h"
#import "PickerViewController.h"

@protocol PhoneDissViewDelegate;

@interface PhoneCardPaymentViewController : RootViewController<UITextFieldDelegate, UIWebViewDelegate, UIPopoverControllerDelegate, PickerViewControllerDelegate>
{
    UIButton*           m_cardAmountButton;
    UITextField*        m_cardNoTextField;
    UITextField*        m_cardPasswordTextField;

    NSString*           m_cardAmount;
    
    UIPopoverController *m_popoverView;
    NSInteger            pickViewSelectNum;
}

@property (nonatomic, retain) IBOutlet UIButton* cardAmountButton;
@property (nonatomic, retain) IBOutlet UITextField* cardNoTextField;
@property (nonatomic, retain) IBOutlet UITextField* cardPasswordTextField;
@property (nonatomic, retain) NSString* cardAmount;
@property (nonatomic,assign) id<PhoneDissViewDelegate> delegate;

@end

@protocol PhoneDissViewDelegate
- (void)dismissPhoneCardView:(PhoneCardPaymentViewController*)viewcontroller;
@end