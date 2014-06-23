//
//  RegisterViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-6-28.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

- (IBAction)registerBingingSwitch:(id)sender;
- (IBAction)registerbackButton:(id)sender;
- (IBAction)registerNewUserButton:(id)sender;
- (IBAction)agreeRegisterButton:(id)sender;
- (IBAction)showRegisterDetailButton:(id)sender;

@end

@implementation RegisterViewController

@synthesize titleLabel;
@synthesize myScroll;
@synthesize addUserNameTextField        = _addUserNameTextField;
@synthesize addUserPassWordTextField    = _addUserPassWordTextField;
@synthesize againUserPassWordTextField  = _againUserPassWordTextField;
@synthesize bingingSwitch               = _bingingSwitch;
@synthesize userIDCardTextField         = _userIDCardTextField;
@synthesize userRealNameTextField       = _userRealNameTextField;
@synthesize agreeProButton;
@synthesize protocolView;
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];

    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowNotification:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideNotification:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    protocolView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark ---------- xib methods ------
//绑定身份证
- (IBAction)registerBingingSwitch:(id)sender {
    //判断 状态
    UISwitch * showSwitch = (UISwitch *)sender;
    if (showSwitch.on) {
        //显示 bingingView
        self.bingingView.hidden = NO;
        
    }else {
        //隐藏 bingView
        self.bingingView.hidden = YES;
    }
}
//返回
- (IBAction)registerbackButton:(id)sender {
    if (protocolView.hidden) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else
    {
        protocolView.hidden = YES;
        self.titleLabel.text = @"用户注册";
    }
}
//注册新用户
- (IBAction)registerNewUserButton:(id)sender {
    
    [self closeKeyBoard];
    
    
    if (0 == _addUserNameTextField.text.length || 0 ==_addUserPassWordTextField.text.length ||0 ==_againUserPassWordTextField.text.length) {
        [self showAlertWithMessage:@"有注册项未填,请输入！"];
        return;
    }
    /*  */
    if (11 != _addUserNameTextField.text.length) {
        [self showAlertWithMessage:@"注册手机号码为11位！"];
        return;
    }
    if (_addUserPassWordTextField.text.length <6 || _addUserPassWordTextField.text.length>16) {
        [self showAlertWithMessage:@"密码长度为6~16位！"];
        return;
    }
    if (![_addUserPassWordTextField.text isEqualToString:_againUserPassWordTextField.text]) {
        [self showAlertWithMessage:@"确认密码有误，请重新输入！"];
        return;
    }
   
    if (!self.agreeProButton.selected) {
        [self showAlertWithMessage:@"请勾选《用户注册协议》！"];
        return;
    }
    
    /* 绑定身份证检测 */
    if (![self isBingingCardID]) {
        return;
    }
    
   
    
    NSMutableDictionary* mDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [mDict setObject:@"register" forKey:@"command"];
    [mDict setObject:_addUserNameTextField.text forKey:@"phonenum"];
    [mDict setObject:_addUserPassWordTextField.text forKey:@"password"];
    if(_bingingSwitch.on)
    {
        [mDict setObject:_userIDCardTextField.text forKey:@"certid"];
        [mDict setObject:_userRealNameTextField.text forKey:@"name"];
    }
//    [mDict setObject:RecPhonenum forKey:@"recommender"];
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkRequestTypeUserReg showProgress:YES];
}
- (BOOL)isBingingCardID
{
    if (_bingingSwitch.on) {
        if (_userIDCardTextField.text.length != 15 && _userIDCardTextField.text.length != 18 && _userIDCardTextField.text.length != 10) {
            [self showAlertWithMessage:@"身份证号码位数不正确！"];
            return NO;
        }
        if (0 == _userRealNameTextField.text.length || [_userRealNameTextField.text isEqualToString:@" "]) {
            [self showAlertWithMessage:@"绑定身份证必须填写真实姓名！"];
            return NO;
        }
        
        if (_userIDCardTextField.text.length == 18) {
            if (![self identityIScorrect:_userIDCardTextField.text]) {
                [self showAlertWithMessage:@"您输入的身份证号格式有误，请重新输入！"];
                return NO;
            }
            if (![self nameIScorrect:_userRealNameTextField.text]) {
                [self showAlertWithMessage:@"您输入的姓名格式有误，请重新输入！"];
                return NO;
            }
        }
        return YES;
    }else{
        _userIDCardTextField.text = @"";
        _userRealNameTextField.text = @"";
        return YES;
    }

}
//同意协议
- (IBAction)agreeRegisterButton:(id)sender {
    agreeProButton.selected = !agreeProButton.selected;
}

//显示协议 详情 
- (IBAction)showRegisterDetailButton:(id)sender {
    [self closeKeyBoard];
    protocolView.hidden = NO;
    titleLabel.text = @"用户注册协议";
}

- (void)closeKeyBoard
{
    [_addUserNameTextField resignFirstResponder];
    [_addUserPassWordTextField resignFirstResponder];
    [_againUserPassWordTextField resignFirstResponder];
    [_userIDCardTextField resignFirstResponder];
    [_userRealNameTextField resignFirstResponder];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self closeKeyBoard];
}
- (void)clearTextFieldText
{
        _addUserNameTextField.text = @"";
        _addUserPassWordTextField.text = @"";
        _againUserPassWordTextField.text = @"";
        _userIDCardTextField.text = @"";
        _userRealNameTextField.text = @"";
}
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkRequestTypeUserReg:
            if ([[dataDic objectForKey:@"error_code"] isEqualToString:@"0000"]) {
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.delegate registerViewSuccessRegisterUserName:self.addUserNameTextField.text passWord:self.addUserPassWordTextField.text];
                    
                    [self showAlertWithMessage:KISDictionaryHaveKey(dataDic, @"message")];
                }];
            
            }else{
               [self showAlertWithMessage: [NSString stringWithFormat:@"%@,请重新输入。",KISDictionaryHaveKey(dataDic, @"message")] ];
            }
            break;
        default:
            break;
    }
}
/*
#pragma mark ------- textField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ((textField == self.userRealNameTextField || textField == self.userIDCardTextField) && _realRegisterView.center.y != 258)  {
        [UIView beginAnimations:@"movement" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint centerP =_realRegisterView.center ;
        centerP.y -= 100;
        _realRegisterView.center  =centerP;
        [UIView commitAnimations];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ((textField == self.userIDCardTextField) && _realRegisterView.center.y != 358)  {
        [UIView beginAnimations:@"movement" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint centerP =_realRegisterView.center ;
        centerP.y += 100;
        _realRegisterView.center  =centerP;
        [UIView commitAnimations];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}*/
#pragma mark -------------- 键盘消息
- (void)keyboardDidShowNotification:(NSNotification*)notification
{
    self.myScroll.contentSize = CGSizeMake(484, 500);
}

- (void)keyboardDidHideNotification:(NSNotification*)notification
{
    self.myScroll.contentSize = CGSizeMake(484, 367);
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 105 ||textField.tag == 104) {
        [self.myScroll setContentOffset:CGPointMake(0, 100) animated:YES];
    }
    return YES;
}
#pragma mark --------------- 格式验证
/* 身份证验证 */
- (BOOL)identityIScorrect:(NSString*)birthday
{
    int sum = 0;
    int weith[17] = {7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2};
    for (int i = 0; i < birthday.length - 1; i++) {
        NSString *itemString = [birthday substringWithRange:NSMakeRange(i,1)];
        sum += weith[i]*[itemString integerValue];
    }
    int num = sum%11;
    char checkCard[11] = {'1', '0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    char lastChar = [birthday characterAtIndex:birthday.length - 1];
    if (num == 2 && lastChar == 'x') {
        
        return YES;
    }
    if (checkCard[num] == lastChar) {
        return YES;
    }
    
    return NO;
}
/* 姓名验证 */
- (BOOL)nameIScorrect:(NSString*)name
{
     if (name.length > 16 || name.length < 2) {//长度2-16
        return NO;
    }
    for (int j = 0; j < name.length; j ++) {
        UniChar chr = [name characterAtIndex:j];
        if(chr < 0x4e00 || chr > 0x9fa5)
        {
            if (![[name substringWithRange:NSMakeRange(j, 1)] isEqualToString:@"•"] && ![[name substringWithRange:NSMakeRange(j, 1)] isEqualToString:@"·"]) {
                return NO;
            }
            //           if (chr != 0x2022) {//不为分格符 •,百度输入法这个点为b700 ·
            //               return NO;
            //           }
        }
    }
    return YES;
}

- (void)dealloc {
    
    [_addUserNameTextField release];
    [_addUserPassWordTextField release];
    [_againUserPassWordTextField release];
    [_userRealNameTextField release];
    [_userIDCardTextField release];
    [_bingingSwitch release];
    [_realRegisterView release];
    [_bingingView release];
    
    [titleLabel release], titleLabel = nil;
    [myScroll release], myScroll = nil;
    [protocolView release], protocolView = nil;
    [super dealloc];
}
- (void)viewDidUnload {
    [self setAddUserNameTextField:nil];
    [self setAddUserPassWordTextField:nil];
    [self setAgainUserPassWordTextField:nil];
    [self setUserRealNameTextField:nil];
    [self setUserIDCardTextField:nil];
    [self setBingingSwitch:nil];
    [self setRealRegisterView:nil];
    [self setBingingView:nil];
    [self setAgreeProButton:nil];
    
    [super viewDidUnload];
}

//  横屏显示
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight);
}

- (BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
@end
