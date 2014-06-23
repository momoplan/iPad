//
//  BingingNickNameViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-10-30.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "BingingNickNameViewController.h"

@interface BingingNickNameViewController ()

@end

@implementation BingingNickNameViewController
@synthesize nickNameTextField;
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)nickNameSetButton:(id)sender {
   
    NSString  *nickName = nickNameTextField.text;
    if (!KISEmptyOrEnter(nickName)) {
        for (int i = 0 ; i < [nickName length]; i++) {
            UniChar chr = [nickName characterAtIndex:i];
            if (chr == ' ')//是空格
            {
                [self showAlertWithMessage:@"昵称不能包含空格"];
                return;
            }
        }
        
        if ([self  asciiLengthOfString:nickName]<4) {
            [self showAlertWithMessage:@"昵称最少两个汉字或四个字符"];
            return;
        }
        if ([self  asciiLengthOfString:nickName] > 16) {
            [self showAlertWithMessage:@"昵称最多八个汉字或十六个字符"];
            return;
        }
        NSMutableDictionary* mDict = [[[NSMutableDictionary alloc]init]autorelease];
        [mDict setObject:@"updateUserInfo" forKey:@"command"];
        [mDict setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
        [mDict setObject:@"updateNickName" forKey:@"type"];
        [mDict setObject:nickName forKey:@"nickName"];
        
        [RYCNetworkManager sharedManager].netDelegate = self;
        [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkRequestTypeNickName showProgress:YES];
    }else
    {
        [self showAlertWithMessage:@"请输入昵称！"];
    }
    
    
}
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    DLog(@" 设置昵称   -------- %@",dataDic);
    switch (requestTag) {
        case ASINetworkRequestTypeNickName:
        {
            NSString * errorCode =KISDictionaryHaveKey(dataDic, @"error_code");
            if ([errorCode isEqualToString:@"0000"]) {
                [self nickNameBackButton:nil];
                [self.delegate bingNickNameSetSucceed];
            }
            [self showAlertWithMessage:KISDictionaryHaveKey(dataDic, @"message")];
        }
            break;
        default:
            break;
    }
}
- (IBAction)nickNameBackButton:(id)sender {
    
     [self dismissViewControllerAnimated:YES completion:^{
         
     }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [nickNameTextField release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNickNameTextField:nil];
    [super viewDidUnload];
}
@end
