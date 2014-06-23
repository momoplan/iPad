//
//  UserFeedbackViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-9-5.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "UserFeedbackViewController.h"

@interface UserFeedbackViewController ()

@end

@implementation UserFeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)feedBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)sendMessageButton:(id)sender {
    [_feedMessTextView resignFirstResponder];
    [_contentTextField resignFirstResponder];
    
    [self sendRequestFeedBackMessage];
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
-  (void)sendRequestFeedBackMessage
{
    NSString * contentStr = _contentTextField.text;//联系方式
    NSString * messageStr = [_feedMessTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (KISEmptyOrEnter(messageStr)) {
        [self showAlertWithMessage:@"请填写反馈意见，谢谢！"];
        return;
    }
    
    NSMutableDictionary* mDict = [[[NSMutableDictionary alloc]init]autorelease];
    [mDict setObject:@"feedback" forKey:@"command"];
    [mDict setObject:messageStr forKey:@"content"];
    [mDict setObject:contentStr?contentStr : @"" forKey:@"contactway"];
    [mDict setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkRequestTypeFeedback showProgress:YES];
    
}
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkRequestTypeFeedback://
        {
            [self showAlertWithMessage:KISDictionaryHaveKey(dataDic, @"message")];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
            break;
        default:
            break;
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _feedView.center = CGPointMake(550, 200);

}
- (void)textViewDidEndEditing:(UITextView *)textView
{
 
    _feedView.center = CGPointMake(550, 350);

}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _feedView.center = CGPointMake(550, 201);

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    _feedView.center = CGPointMake(550, 350);

    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [_feedMessTextView release];
    [_contentTextField release];
    [_feedView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setFeedMessTextView:nil];
    [self setContentTextField:nil];
    [self setFeedView:nil];
    [super viewDidUnload];
}
@end
