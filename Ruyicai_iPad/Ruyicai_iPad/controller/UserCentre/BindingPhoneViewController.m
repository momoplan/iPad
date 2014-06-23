//
//  BindingPhoneViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-8.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "BindingPhoneViewController.h"

@interface BindingPhoneViewController ()

@end

@implementation BindingPhoneViewController
@synthesize bingPhoneNumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark ----------------  ibaction methods
- (IBAction)bingingPhoneCacelButton:(id)sender {    //取消
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)bingingPhoneConfirmButton:(id)sender {  //确定
    
    [_bingPhoneTextField resignFirstResponder];
    if (_bingPhoneTextField.text.length != 11) {
        [self showAlertWithMessage:@"请输入正确的手机号！"];
        return;
    }
    
    NSMutableDictionary * mDic =[[NSMutableDictionary alloc]init];
    [mDic setObject:@"updateUserInfo" forKey:@"command"];
    [mDic setObject:@"bindPhoneSecurityCode" forKey:@"type"];
    [mDic setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    [mDic setObject:_bingPhoneTextField.text forKey:@"bindPhoneNum"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkReqestTypeBindPhoneSecurity showProgress:YES];
    [mDic release];
}
- (IBAction)backBingPhoneButton:(id)sender {    //返回验证界面
    [_bingPhoneView removeFromSuperview];
    [self.view addSubview:_sendAuthcodeView];
     _sendAuthcodeView.center = CGPointMake(500, 250);
}

- (IBAction)againAchieveAuthButton:(id)sender { //重新获取
    [self bingingPhoneConfirmButton:sender];
}
- (IBAction)ImmediateBingButton:(id)sender {    //立即绑定
    NSMutableDictionary * mDic =[[NSMutableDictionary alloc]init];
    [mDic setObject:@"updateUserInfo" forKey:@"command"];
    [mDic setObject:@"bindPhone" forKey:@"type"];
    [mDic setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    [mDic setObject:_bingPhoneTextField.text forKey:@"bindPhoneNum"];
    [mDic setObject:_bingAuthTextField.text forKey:@"securityCode"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkReqestTypeBindPhone showProgress:YES];
    [mDic release];
}
- (IBAction)cancelBingNumberButton:(id) sender {
    
    UIAlertView* alterView = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"是否确定解除手机号绑定？"
                              delegate:self
                              cancelButtonTitle:@"否"
                              otherButtonTitles:@"是", nil];
    [alterView show];
    alterView.tag       = 99;
    [alterView release];
}
#pragma mark -------------------  alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 99) {
        if (buttonIndex !=alertView.cancelButtonIndex) {
            NSMutableDictionary* mDict = [[NSMutableDictionary alloc]init];
            [mDict setObject:@"updateUserInfo" forKey:@"command"];
            [mDict setObject:@"removeBindPhone" forKey:@"type"];
            [mDict setObject:[UserLoginData sharedManager].userNo  forKey:@"userno"];
            
            [RYCNetworkManager sharedManager].netDelegate = self;
            [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkReqestTypeCancelBindPhone showProgress:YES];
            [mDict release];
        }
    }
}
#pragma mark --------- textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_bingPhoneTextField == textField) {
        if (range.length >11) {
            return NO;
        }
    }
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_bingPhoneTextField resignFirstResponder];
    [_bingAuthTextField resignFirstResponder];
}
#pragma mark ----------- view methods
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (![self.bingPhoneNumber isEqualToString:@""]) {
        [_sendAuthcodeView removeFromSuperview];
        [_bingPhoneView removeFromSuperview];
        [self.view addSubview: _bingPhoneNumView];
        _bingPhoneNumView.center = CGPointMake(500, 250);
        NSString * numString = [self.bingPhoneNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        _phoneNumberLabel.text = numString;
        _phoneNumberLabel.textColor = RGBCOLOR(51, 51, 51);
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_bingPhoneView removeFromSuperview];
    [_bingPhoneNumView removeFromSuperview];
    [self.view addSubview:_sendAuthcodeView];
    _sendAuthcodeView.center = CGPointMake(500, 250);
}

#pragma mark ------------ notification methods
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    DLog(@" 绑定手机号   -------- %@",dataDic);
    switch (requestTag) {
        case ASINetworkReqestTypeBindPhoneSecurity://获取手机验证号码
        {
            NSString * errorCode = KISDictionaryHaveKey(dataDic, @"error_code");
                if ([errorCode isEqualToString:@"0000"]) {//发送成功
                [_sendAuthcodeView removeFromSuperview];
                [self.view addSubview:_bingPhoneView];
                _bingPhoneView.center = CGPointMake(500, 250);
                }else{
                [self showAlertWithMessage:@"发送失败，请重新发送"];
                }
        }
            break;
        case ASINetworkReqestTypeBindPhone://绑定手机
        {
             NSString * errorCode = KISDictionaryHaveKey(dataDic, @"error_code");
            if ([errorCode isEqualToString:@"0000"]) {
                //绑定 成功
                 [self showAlertWithMessage:@"绑定成功"];
                [self.delegate bingingPhonebingSucceed];

                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }else
            {
                [self showAlertWithMessage:@"绑定失败"];
            }
            
        }
            break;
        case ASINetworkReqestTypeCancelBindPhone: // 解绑手机号
        {
            NSString * errorCode = KISDictionaryHaveKey(dataDic, @"error_code");
            if ([errorCode isEqualToString:@"0000"]) {
                
                [self showAlertWithMessage:@"解绑成功"];
                [self.delegate bingingPhoneNumberClearSucceed];

                [self dismissViewControllerAnimated:YES completion:^{
                }];
                
            }
          
        }
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.delegate           = nil;

    [_bingPhoneTextField    release];
    [_sendAuthcodeView      release];
    [_bingPhoneView         release];
    [_bingAuthTextField     release];
    [_bingPhoneNumView release];
    [_phoneNumberLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBingPhoneTextField:nil];
    [self setSendAuthcodeView:nil];
    [self setBingPhoneView:nil];
    [self setBingAuthTextField:nil];
    [self setBingPhoneNumView:nil];
    [self setPhoneNumberLabel:nil];
    [super viewDidUnload];
}
@end
