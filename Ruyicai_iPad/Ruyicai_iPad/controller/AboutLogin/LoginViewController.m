//
//  LoginViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-6-28.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "LoginViewController.h"
#import "RYCImageNamed.h"
#import "UserLoginData.h"

@interface LoginViewController ()
{
    IBOutlet UIView        *againSetPassView;
    IBOutlet UITextField   *findPasUserName;
    IBOutlet UITextField   *findPasPhoneNum;
}
- (IBAction)findPasClick:(id)sender;
@end

@implementation LoginViewController

@synthesize titleLabel;
@synthesize loginUserNameTextFiled,loginUserPassWordTextFiled,loginSwitch;
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [titleLabel release], titleLabel = nil;

    [_myLoginView release];
    [loginUserNameTextFiled release], loginUserNameTextFiled= nil;
    [loginUserPassWordTextFiled release], loginUserPassWordTextFiled = nil;
    [loginSwitch release], loginSwitch = nil;
    
    [againSetPassView release], againSetPassView = nil;
    [findPasUserName release], findPasUserName = nil;
    [findPasPhoneNum release], findPasPhoneNum = nil;
    
    self.delegate = nil;
    
    [super dealloc];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.loginUserNameTextFiled.text = [[NSUserDefaults standardUserDefaults] objectForKey:KSaveUserNameKey];
    self.loginSwitch.on = [[[NSUserDefaults standardUserDefaults] objectForKey:kSaveRandomSate] boolValue];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loginUserNameTextFiled.text = [[NSUserDefaults standardUserDefaults] objectForKey:KSaveUserNameKey];
    self.loginSwitch.on = [[[NSUserDefaults standardUserDefaults] objectForKey:kSaveRandomSate] boolValue];

    againSetPassView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark －－－－联网成功
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)reqType
{
    switch (reqType) {
        case ASINetworkRequestTypeUserLogin:
        case ASINetworkRequestTypeUserReg://注册成功后的登录
        {
            if ([[dataDic objectForKey:@"error_code"] isEqualToString:@"0000"]) {
                [self dismissViewControllerAnimated:YES completion:^{}];
                
                [UserLoginData sharedManager].hasLogin = YES;
                [UserLoginData sharedManager].userNo = KISDictionaryHaveKey(dataDic, @"userno");
                [UserLoginData sharedManager].userPass = self.loginUserPassWordTextFiled.text;
                [UserLoginData sharedManager].userRealName = KISDictionaryHaveKey(dataDic, @"name");
                [UserLoginData sharedManager].userRealCard = KISDictionaryHaveKey(dataDic, @"certid");
                
                [[UserLoginData sharedManager] saveUserName:KISDictionaryHaveKey(dataDic, @"userName") AndrandomNumber:KISDictionaryHaveKey(dataDic, @"randomNumber") andUserPassword:self.loginUserPassWordTextFiled.text];
                [[UserLoginData sharedManager] saveUserRealName:KISDictionaryHaveKey(dataDic, @"name") andUserRealCardId:KISDictionaryHaveKey(dataDic, @"certid")];
                
                [[NSUserDefaults standardUserDefaults] setObject:self.loginSwitch.on ? @"1" : @"0" forKey:kSaveRandomSate];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                if (reqType != ASINetworkRequestTypeUserReg) {
                    [self showAlertWithMessage:KISDictionaryHaveKey(dataDic, @"message")];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(loginViewSuccessLogin)]) {
                    [self.delegate loginViewSuccessLogin];//登录成功
                }
            }
            else
            {
                [UserLoginData sharedManager].hasLogin = NO;
                [self showAlertWithMessage:KISDictionaryHaveKey(dataDic, @"message")];
            }
        }   break;
        case ASINetworkRequestTypeFindPsw://找回密码
            if ([[dataDic objectForKey:@"error_code"] isEqualToString:@"0000"]) {
                [self showAlertWithMessage:@"密码已经成功发送到您绑定的手机上，请注意查收并及时修改密码！"];

                againSetPassView.hidden = YES;
                self.titleLabel.text = @"用户登录";
            }
            else
                [self showAlertWithMessage:KISDictionaryHaveKey(dataDic, @"message")];
            break;
        default:
            break;
    }
}

#pragma mark --------- methods
- (IBAction)loginUserButton:(id)sender
{//登录
    [self.loginUserPassWordTextFiled resignFirstResponder];
    [self.loginUserNameTextFiled resignFirstResponder];
    
    if (KISEmptyOrEnter(self.loginUserNameTextFiled.text) || KISEmptyOrEnter(self.loginUserPassWordTextFiled.text)) {
        [self showAlertWithMessage:@"请输入正确信息！"];
    }
    else
    {
        NSMutableDictionary* mDict = [NSMutableDictionary dictionaryWithCapacity:1];
        [mDict setObject:@"login" forKey:@"command"];
        [mDict setObject:self.loginUserNameTextFiled.text forKey:@"phonenum"];
        [mDict setObject:self.loginUserPassWordTextFiled.text forKey:@"password"];
        if([CommonRecordStatus commonRecordStatusManager].deviceToken)
        {
            [mDict setObject:[CommonRecordStatus commonRecordStatusManager].deviceToken forKey:@"token"];
            [mDict setObject:kTokenType forKey:@"type"];
        }
        if (self.loginSwitch.on)
        {
            [mDict setObject:@"1" forKey:@"isAutoLogin"];
        }
        else
        {
            [mDict setObject:@"0" forKey:@"isAutoLogin"];
        }
        
        [RYCNetworkManager sharedManager].netDelegate = self;
        [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkRequestTypeUserLogin showProgress:YES];
    }
}

- (IBAction)registerNewUserButton:(id)sender {//注册用户
     
    RegisterViewController * registerV = [[RegisterViewController alloc]init]; //实例化注册vc
    registerV.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    registerV.delegate = self;
    [self presentViewController:registerV animated:YES completion:^{
        
    }]; //推出新的窗口
    [registerV release]; //释放

}
- (IBAction)loginBackButton:(id)sender {//返回
    if (againSetPassView.hidden) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else
    {
        againSetPassView.hidden = YES;
        self.titleLabel.text = @"用户登录";
    }
}

//注册成功后
- (void)registerViewSuccessRegisterUserName:(NSString *)userName passWord:(NSString *)passWord
{
    NSMutableDictionary* mDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [mDict setObject:@"login" forKey:@"command"];
    [mDict setObject:userName forKey:@"phonenum"];
    [mDict setObject:passWord forKey:@"password"];
    if([CommonRecordStatus commonRecordStatusManager].deviceToken)
    {
        [mDict setObject:[CommonRecordStatus commonRecordStatusManager].deviceToken forKey:@"token"];
        [mDict setObject:kTokenType forKey:@"type"];
    }
    if (self.loginSwitch.on)
    {
        [mDict setObject:@"1" forKey:@"isAutoLogin"];
    }
    else
    {
        [mDict setObject:@"0" forKey:@"isAutoLogin"];
    }
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkRequestTypeUserReg showProgress:YES];
}
#pragma mark -----------  找回密码
//找回密码
- (IBAction)agianSetPassWordButton:(id)sender {
    againSetPassView.hidden = NO;
    self.titleLabel.text = @"找回密码";
}

- (IBAction)findPasClick:(id)sender
{
    [findPasPhoneNum resignFirstResponder];
    [findPasUserName resignFirstResponder];
    if(KISEmptyOrEnter(findPasUserName.text) || KISEmptyOrEnter(findPasPhoneNum.text))
    {
        [self showAlertWithMessage:@"用户名或手机号未填，请输入！"];
        return;
    }
    if(findPasPhoneNum.text.length != 11)
    {
        [self showAlertWithMessage:@"有效的手机号码为11位，请重新输入！"];
        return;
    }
    
    NSMutableDictionary* mDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [mDict setObject:@"updateUserInfo" forKey:@"command"];
    [mDict setObject:@"retrievePassword" forKey:@"type"];
    [mDict setObject:findPasUserName.text forKey:@"phonenum"];
    [mDict setObject:findPasPhoneNum.text forKey:@"bindPhoneNum"];

    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkRequestTypeFindPsw showProgress:YES];
}

#pragma mark 键盘消息
- (void)keyboardDidShowNotification:(NSNotification*)notification
{
//    if (self.myLoginView.center.y == 341) {
//        [UIView beginAnimations:@"movement" context:nil];
////        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//        [UIView setAnimationDuration:0.3f];
//        [UIView setAnimationRepeatCount:1];
//        [UIView setAnimationRepeatAutoreverses:NO];
//        self.myLoginView.center = CGPointMake(self.myLoginView.center.x, self.myLoginView.center.y - 100);
//        [UIView commitAnimations];
//    }
}

- (void)keyboardDidHideNotification:(NSNotification*)notification
{
//    if (self.myLoginView.center.y == 241) {
//        [UIView beginAnimations:@"movements" context:nil];
////        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//        [UIView setAnimationDuration:0.3f];
//        [UIView setAnimationRepeatCount:1];
//        [UIView setAnimationRepeatAutoreverses:NO];
//        self.myLoginView.center = CGPointMake(self.myLoginView.center.x, self.myLoginView.center.y + 100);
//        [UIView commitAnimations];
//    }
}
#pragma mark ------------  textFiled delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"%f", self.myLoginView.center.y);

    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
//关闭键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.loginUserNameTextFiled resignFirstResponder];
    [self.loginUserPassWordTextFiled resignFirstResponder];
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
