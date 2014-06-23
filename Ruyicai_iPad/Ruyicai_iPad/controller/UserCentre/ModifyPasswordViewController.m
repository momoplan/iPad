//
//  ModifyPasswordViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-31.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController ()

@end

@implementation ModifyPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    [_oldPassTextField release];
    [_newPassTextField release];
    [_againPassTextField release];
    [_modifyView release];
    [super dealloc];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------------ xib methods
/* 取消*/
- (IBAction)modifyPasswordCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
/* 确定 */
- (IBAction)modifyPasswordConfirmButton:(id)sender {
    if (0 == _oldPassTextField.text.length ||0== _newPassTextField.text.length || 0==_againPassTextField.text.length) {
        [self showAlertWithMessage:@"各项不能为空！"];
        return;
    }
    if (![_newPassTextField.text isEqualToString:_againPassTextField.text]) {
        [self showAlertWithMessage:@"新密码和确认密码不一致！"];
        return;
    }
    if (_newPassTextField.text.length <6 ||_newPassTextField.text.length >16 ||_againPassTextField.text.length< 6 || _againPassTextField.text.length > 16) {
        [self showAlertWithMessage:@"密码必须为6－16位数字或字母组成！"];
        return;
    }
    NSMutableDictionary * mDic = [[NSMutableDictionary alloc]init];
    [mDic setObject:@"updatePass" forKey:@"command"];
    [mDic setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    [mDic setObject:_oldPassTextField.text forKey:@"old_pass"];
    [mDic setObject:_newPassTextField.text forKey:@"new_pass"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeUpdatePsw showProgress:YES];
    [mDic release];
}
#pragma mark ------------ notification methods
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    DLog(@" 修改密码  -------- %@",dataDic);
    switch (requestTag) {
        case ASINetworkRequestTypeUpdatePsw:
        {
            NSString * errorCode = KISDictionaryHaveKey(dataDic, @"error_code");
            NSString * message = KISDictionaryHaveKey(dataDic, @"message");
            if ([errorCode isEqualToString:@"0000"]) {
                [self showAlertWithMessage:@"修改成功"];
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }else{
                [self showAlertWithMessage:message];
            }
        }
            break;
        default:
            break;

    
    }
}
#pragma mark -------------- textField delegate
// 原密码 tag 100 新的密码：101 重新输入密码：102
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length > 16) {
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (102 == textField.tag) {
        CGRect rect = _modifyView.frame;
        rect.origin.y -=50;
        _modifyView.frame = rect;
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (102 == textField.tag) {
        CGRect rect = _modifyView.frame;
        rect.origin.y +=50;
        _modifyView.frame = rect;
    }
    return YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
- (void)viewDidUnload {
    [self setOldPassTextField:nil];
    [self setNewPassTextField:nil];
    [self setAgainPassTextField:nil];
    [self setModifyView:nil];
    [super viewDidUnload];
}
@end
