//
//  DNAPaymentViewController.h
//  Ruyicai_iPad
//
//  Created by Zhang Xiaofeng on 13-7-24.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  银联语音充值

#import <UIKit/UIKit.h>

#import "RootViewController.h"
#import "PickerViewController.h"

@protocol DNAChangedViewDelegate;

@interface DNAPaymentViewController : RootViewController<UITextFieldDelegate, UIWebViewDelegate, PickerViewControllerDelegate, UIPopoverControllerDelegate>
{
    UIScrollView*  m_scrollBind;
	UIScrollView*  m_scrollNoBind;
    
    UITextField*   m_bindAmountTextField;
    UILabel*       m_bindCardNoLabel;
    UITextField*   m_bindPhonenumTextField;
    
    UITextField*   m_noBindAmountTextField;
    UIButton*      m_bankNameButton;
    UITextField*   m_cardNoTextField;
    UITextField*   m_userNameTextField;
    UITextField*   m_certidTextField;
    UITextField*   m_certidAddressTextField;
    UITextField*   m_cardAddressTextField;
    UITextField*   m_phonenumTextField;
    
    BOOL           m_hasBind;
    NSString*      m_bankName;
    NSString*      m_bindName;
    NSString*      m_bindBankCardNo;
    NSString*      m_bindCertId;
    NSString*      m_bindDate;
    NSString*      m_bindAddressName;
    NSString*      m_bindBankAddress;
    NSString*      m_bindPhonenum;
    
    UIPopoverController *m_popoverView;
    NSInteger            pickViewSelectNum;
    
    id<DNAChangedViewDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollBind;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollNoBind;
@property (nonatomic, retain) IBOutlet UITextField *bindAmountTextField;
@property (nonatomic, retain) IBOutlet UILabel *bindCardNoLabel;
@property (nonatomic, retain) IBOutlet UITextField *bindPhonenumTextField;
@property (nonatomic, retain) IBOutlet UITextField *noBindAmountTextField;
@property (nonatomic, retain) IBOutlet UIButton *bankNameButton;
@property (nonatomic, retain) IBOutlet UITextField *cardNoTextField;
@property (nonatomic, retain) IBOutlet UITextField *userNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *certidTextField;
@property (nonatomic, retain) IBOutlet UITextField *certidAddressTextField;
@property (nonatomic, retain) IBOutlet UITextField *cardAddressTextField;
@property (nonatomic, retain) IBOutlet UITextField *phonenumTextField;
@property (nonatomic, retain) NSString* bankName;

@property (nonatomic, retain) NSString* bindName;
@property (nonatomic, retain) NSString* bindBankCardNo;
@property (nonatomic, retain) NSString* bindCertId;
@property (nonatomic, retain) NSString* bindDate;
@property (nonatomic, retain) NSString* bindAddressName;
@property (nonatomic, retain) NSString* bindBankAddress;
@property (nonatomic, retain) NSString* bindPhonenum;

@property (nonatomic,assign) id<DNAChangedViewDelegate> delegate;

- (IBAction)selectBankAction;
- (void)hideKeyboard;

- (void)showBindStatus:(BOOL)hasBind;
@end

@protocol DNAChangedViewDelegate
- (void)dismissMyView:(DNAPaymentViewController*)viewcontroller;
@end
