//
//  BindingPhoneViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-8.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "RootViewController.h"

@protocol bingingPhoneViewDelegete <NSObject>

- (void)bingingPhonebingSucceed;
- (void)bingingPhoneNumberClearSucceed;

@end

@interface BindingPhoneViewController : RootViewController
<UITextFieldDelegate,UIAlertViewDelegate>
{
    
}

@property (nonatomic,assign) id<bingingPhoneViewDelegete>delegate;

@property (retain, nonatomic) IBOutlet UITextField  * bingPhoneTextField;
@property (retain, nonatomic) IBOutlet UIView       * sendAuthcodeView;
@property (retain, nonatomic) IBOutlet UIView       * bingPhoneView;
@property (retain, nonatomic) IBOutlet UITextField  * bingAuthTextField;
@property (retain,nonatomic)  NSString              * bingPhoneNumber;
@property (retain, nonatomic) IBOutlet UIView       * bingPhoneNumView;
@property (retain, nonatomic) IBOutlet UILabel      * phoneNumberLabel;
@end
