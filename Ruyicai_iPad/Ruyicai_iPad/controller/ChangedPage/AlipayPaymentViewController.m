//
//  AlipayPaymentViewController.m
//  Ruyicai_iPad
//
//  Created by Zhang Xiaofeng on 13-7-23.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "AlipayPaymentViewController.h"
#import "RYCCommon.h"

@interface AlipayPaymentViewController ()

- (IBAction)sureClick:(id)sender;
- (IBAction)backClick:(id)sender;
@end

@implementation AlipayPaymentViewController

@synthesize amountField;

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
    [amountField release], amountField = nil;
    [super dealloc];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSMutableDictionary* mDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [mDict setObject:@"information" forKey:@"command"];
    [mDict setObject:@"messageContent" forKey:@"newsType"];
    [mDict setObject:@"zfbChargeDescriptionHtml" forKey:@"keyStr"];//描述语
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkReqestTypeChargePage showProgress:NO];
    
    amountField.delegate = self;
}

- (IBAction)backClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark －－－－点击充值
- (IBAction)sureClick:(id)sender
{
    if (KISEmptyOrEnter(self.amountField.text))
    {
        [self showAlertWithMessage:@"请输入充值金额"];
        return;
    }
    [self.amountField resignFirstResponder];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:@"recharge" forKey:@"command"];
    [dict setObject:@"05" forKey:@"rechargetype"];
	[dict setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    [dict setObject:@"0300" forKey:@"cardtype"];
    [dict setObject:@"" forKey:@"subchannel"];
    NSString* amtValue = [NSString stringWithFormat:@"%d", [self.amountField.text intValue] * 100];
    [dict setObject:amtValue  forKey:@"amount"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:dict withRequestType:ASINetworkRequestTypeChargeAlipay showProgress:YES];

}

#pragma mark －－－－联网成功
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkReqestTypeChargePage:
            [self setDescriptionViewWithContent:KISDictionaryHaveKey(dataDic, @"content")];
            break;
        case ASINetworkRequestTypeChargeAlipay:
            if ([KISDictionaryHaveKey(dataDic, @"error_code") isEqualToString:@"0000"]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:KISDictionaryHaveKey(dataDic, @"return_url")]];
            }
            else
                [self showAlertWithMessage:KISDictionaryHaveKey(dataDic, @"message")];
            break;
        default:
            break;
    }
}

- (void)setDescriptionViewWithContent:(NSString*)contentStr
{
    NSString *html = [NSString stringWithFormat:@"<body style='background-color:#EEEEEE'>%@</body>", contentStr];
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(267, 392, 474, 170)];
    webView.layer.cornerRadius = 3;
    webView.layer.masksToBounds = YES;
    UIScrollView *scroller = [webView.subviews objectAtIndex:0];//去掉阴影
    if (scroller) {
        for (UIView *v in [scroller subviews]) {
            if ([v isKindOfClass:[UIImageView class]]) {
                [v removeFromSuperview];
            }
        }
    }
    webView.delegate = self;
    webView.backgroundColor = [UIColor clearColor];
    webView.dataDetectorTypes = UIDataDetectorTypeLink|UIDataDetectorTypePhoneNumber;//下划线类型
    [webView loadHTMLString:html baseURL:nil];
    [self.view addSubview:webView];
    [webView release];
}

- (BOOL)webView:(UIWebView *)webViewLocal shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSString *myURL = [[request URL] absoluteString];
    NSLog(@"%@", myURL);//进来时：about:blank  http://www.ruyicai.com/
    if([myURL hasPrefix:@"http:"] || [myURL hasPrefix:@"tel:"])
	{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:myURL]];
        return NO;
    }
	return YES;
}

#pragma mark textField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string//只允许输入数字所以，(限制输入英文和数字的话，就可以把这个定义为：#define kAlphaNum   @”ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789″)。
{
    if (self.amountField.text.length >= 5 && range.length == 0)
    {
        return  NO;
    }
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    BOOL canChange = [string isEqualToString:filtered];
    
    return canChange;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.amountField resignFirstResponder];
}
@end
