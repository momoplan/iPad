//
//  BingingIDCardViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-8.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "BingingIDCardViewController.h"

@interface BingingIDCardViewController ()

@end

@implementation BingingIDCardViewController
@synthesize delegate;
@synthesize cardNameText,cardNumText;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark ----------- view methods
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if ([self.cardNumText isEqualToString:@""]) {
//       
//    }else{
//        [_bingCardView removeFromSuperview];
//        [self.view addSubview:_showCardView];
//        _showCardView.center = CGPointMake(500, 250);
//    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad]; 
    // Do any additional setup after loading the view from its nib.
    if (![self.cardNumText isEqualToString:@""]) {
        
        [_bingCardView removeFromSuperview];
        [self.view addSubview:_showCardView];
        _showCardView.center = CGPointMake(500, 250);
        
        NSString * selfCardName = [[NSUserDefaults standardUserDefaults] objectForKey:kSaveRealName];
        NSString * selfCardNum = [[NSUserDefaults standardUserDefaults] objectForKey:kSaveRealCard];
        _showCardNameLabel.text = [selfCardName stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:@"*"];
        _showCardNumLabel.text = [selfCardNum stringByReplacingCharactersInRange:NSMakeRange(4, 10) withString:@"*****"];
    }else
    {
        [_showCardView removeFromSuperview];
        [self.view addSubview:_bingCardView];
        _bingCardView.center  = CGPointMake(500, 250);
    }
    
}
- (void)dealloc {
    [_bingCardTextField release];
    [_bingCardTextName release];
    self.delegate = nil;
    [_bingCardView release];
    [_showCardView release];
    [_showCardNameLabel release];
    [_showCardNumLabel release];
    [cardNumText release],cardNumText = nil;
    [cardNameText release],cardNameText = nil;
    [super dealloc];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------------- notification methods
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkReqestTypeBindCertid:
        {
            NSString * errorCode =KISDictionaryHaveKey(dataDic, @"error_code");
            NSString * message = KISDictionaryHaveKey(dataDic, @"message");
            if ([errorCode isEqualToString:@"0000"]) {
                [self  showAlertWithMessage:message];
                [[UserLoginData sharedManager] saveUserRealName:_bingCardTextName.text andUserRealCardId:_bingCardTextField.text];
                
                [self.delegate bingingIDCardOperateSucceed];
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }else
            {
                [self showAlertWithMessage:message];
            }
        }
            break;
        default:
            break;
    }
    
}
#pragma mark ------------- xib methods
- (IBAction)bingCDCardCancalButton:(id)sender {//取消

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)bingCDCardConfirmButton:(id)sender {//确定
    [_bingCardTextField resignFirstResponder];
    [_bingCardTextName resignFirstResponder];
    
    if (_bingCardTextField.text.length != 15 && _bingCardTextField.text.length !=18) {
            [self showAlertWithMessage:@"身份证号位数有误！\n请重新输入"];
            return;
        }
    
    if (_bingCardTextName.text.length == 0) {
        [self showAlertWithMessage:@"请输入真实姓名!"];
        return;
    }
    if (_bingCardTextField.text.length == 18) {
        if (![self identityIScorrect:_bingCardTextField.text]) {
            [self showAlertWithMessage:@"您输入的身份证号格式有误，请重新输入！"];
            return;
        }
    }
    if (![self nameIScorrect:_bingCardTextName.text]) {
        [self showAlertWithMessage:@"您输入的姓名格式有误，请重新输入！"];
        return;
    }
    
    NSMutableDictionary* mDict = [[NSMutableDictionary alloc]init];
    [mDict setObject:@"updateUserInfo" forKey:@"command"];
    [mDict setObject:_bingCardTextField.text forKey:@"certid"];
    [mDict setObject:_bingCardTextName.text forKey:@"name"];
	[mDict setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkReqestTypeBindCertid showProgress:YES];
    [mDict release];
    
}
/* 身份证 格式验证 */
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

/*  姓名格式 验证 */
- (BOOL)nameIScorrect:(NSString*)name
{
    //    int utfCode = 0;
    //    void *buffer = &utfCode;
    //    NSRange range = NSMakeRange(name.length - 1, 1);
    //    NSString *word = [name substringWithRange:range];
    //    BOOL b = [word getBytes:buffer maxLength:2 usedLength:NULL encoding:NSUTF16LittleEndianStringEncoding options:NSStringEncodingConversionExternalRepresentation range:range remainingRange:NULL];
    //    if (b && (utfCode >= 0x4e00 && utfCode <= 0x9fa5)) {//unicode中文编码范围是0x4e00~0x9fa5  也有用u4e00~u9fff
    //        return YES;
    //    }
    //    return NO;
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
            //            if (chr != 0x2022) {//不为分格符 •
            //                return NO;
            //            }
        }
    }
    return YES;
}
#pragma mark ------------- textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
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

- (void)viewDidUnload {
    [self setBingCardView:nil];
    [self setShowCardView:nil];
    [self setShowCardNameLabel:nil];
    [self setShowCardNumLabel:nil];
    [super viewDidUnload];
}
@end
