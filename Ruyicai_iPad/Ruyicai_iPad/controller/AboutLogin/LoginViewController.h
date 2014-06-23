//
//  LoginViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-6-28.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "RootViewController.h"
#import "RegisterViewController.h"


@protocol LoginViewControllerDelegate <NSObject>

@optional
- (void)loginViewSuccessLogin;

@end

@interface LoginViewController : RootViewController
<UITextFieldDelegate, RegisterViewDelegate>

@property (retain, nonatomic) IBOutlet UILabel*     titleLabel;
@property (retain, nonatomic) IBOutlet UITextField *loginUserNameTextFiled;
@property (retain, nonatomic) IBOutlet UITextField *loginUserPassWordTextFiled;
@property (retain, nonatomic) IBOutlet UISwitch *loginSwitch;

@property (retain, nonatomic) IBOutlet UIView *myLoginView;
@property (nonatomic,assign) id<LoginViewControllerDelegate>delegate;
@end
