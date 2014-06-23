//
//  DNAPaymentViewController.m
//  Ruyicai_iPad
//
//  Created by Zhang Xiaofeng on 13-7-24.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "DNAPaymentViewController.h"
#import "RYCImageNamed.h"

@interface DNAPaymentViewController ()

- (IBAction)okClick:(id)sender;
- (IBAction)backClick:(id)sender;
@end

@implementation DNAPaymentViewController

@synthesize	scrollBind = m_scrollBind;
@synthesize	scrollNoBind = m_scrollNoBind;
@synthesize bindAmountTextField = m_bindAmountTextField;
@synthesize bindCardNoLabel = m_bindCardNoLabel;
@synthesize bindPhonenumTextField = m_bindPhonenumTextField;
@synthesize noBindAmountTextField = m_noBindAmountTextField;
@synthesize bankNameButton = m_bankNameButton;
@synthesize cardNoTextField = m_cardNoTextField;
@synthesize userNameTextField = m_userNameTextField;
@synthesize certidTextField = m_certidTextField;
@synthesize certidAddressTextField = m_certidAddressTextField;
@synthesize cardAddressTextField = m_cardAddressTextField;
@synthesize phonenumTextField = m_phonenumTextField;
@synthesize bankName = m_bankName;
@synthesize bindName = m_bindName;
@synthesize bindBankCardNo = m_bindBankCardNo;
@synthesize bindCertId = m_bindCertId;
@synthesize bindDate = m_bindDate;
@synthesize bindAddressName = m_bindAddressName;
@synthesize bindBankAddress = m_bindBankAddress;
@synthesize bindPhonenum = m_bindPhonenum;
@synthesize delegate;

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
	[m_scrollBind release];
	[m_scrollNoBind release];
    [m_bindAmountTextField release];
    [m_bindCardNoLabel release];
    [m_bindPhonenumTextField release];
    [m_noBindAmountTextField release];
    [m_bankNameButton release];
    [m_cardNoTextField release];
    [m_userNameTextField release];
    [m_certidTextField release];
    [m_certidAddressTextField release];
    [m_cardAddressTextField release];
    [m_phonenumTextField release];
    [super dealloc];
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
    
    [self.view addSubview:getTopLableWithTitle(@"银联语音充值")];

    m_hasBind = NO;

    m_bindAmountTextField.delegate = self;
    m_bindPhonenumTextField.delegate = self;
    m_noBindAmountTextField.delegate = self;
    m_cardNoTextField.delegate = self;
    m_userNameTextField.delegate = self;
    m_certidTextField.delegate = self;
    m_certidAddressTextField.delegate = self;
    m_cardAddressTextField.delegate = self;
    m_phonenumTextField.delegate = self;
    
    [self.bankNameButton setTitle:@"中国工商银行" forState:UIControlStateNormal];

    NSMutableDictionary* mDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [mDict setObject:@"information" forKey:@"command"];
    [mDict setObject:@"messageContent" forKey:@"newsType"];
    [mDict setObject:@"dnaChargeDescriptionHtml" forKey:@"keyStr"];//描述语
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkReqestTypeChargePage showProgress:NO];
}

- (IBAction)backClick:(id)sender
{
    [self hideKeyboard];
    [self.delegate dismissMyView:self];
}

- (void)showBindStatus:(BOOL)hasBind
{
    m_hasBind = hasBind;
   if (m_hasBind)
    {
        self.scrollBind.hidden = NO;
        self.scrollNoBind.hidden = YES;
        self.bindCardNoLabel.text = self.bindBankCardNo;
        self.bindPhonenumTextField.text = self.bindPhonenum;
    }
    else
    {
        self.scrollBind.hidden = YES;
        self.scrollNoBind.hidden = NO;
    }
}

- (void)hideKeyboard
{
    if (m_hasBind)
    {
        [m_bindAmountTextField resignFirstResponder];
        [m_bindPhonenumTextField resignFirstResponder];
    }
    else
    {
        [m_noBindAmountTextField resignFirstResponder];
        [m_cardNoTextField resignFirstResponder];
        [m_userNameTextField resignFirstResponder];
        [m_certidTextField resignFirstResponder];
        [m_certidAddressTextField resignFirstResponder];
        [m_cardAddressTextField resignFirstResponder];
        [m_phonenumTextField resignFirstResponder];
    }
}
- (IBAction)okClick:(id)sender
{
    [self hideKeyboard];
    if (m_hasBind) {
        if(KISEmptyOrEnter(m_bindPhonenumTextField.text) || KISEmptyOrEnter(m_bindAmountTextField.text))
        {
            [self showAlertWithMessage:@"请把信息填写完整！"];
            return;
        }
        else if([m_bindAmountTextField.text intValue] < 20)
        {
            [self showAlertWithMessage:@"最低充值20元！"];
            return;
        }
    }
    else
    {
        if (KISEmptyOrEnter(m_noBindAmountTextField.text) || KISEmptyOrEnter(m_cardNoTextField.text) || KISEmptyOrEnter(m_userNameTextField.text) || KISEmptyOrEnter(m_certidTextField.text) || KISEmptyOrEnter(m_certidAddressTextField.text) || KISEmptyOrEnter(m_cardAddressTextField.text) || KISEmptyOrEnter(m_phonenumTextField.text)) {
            [self showAlertWithMessage:@"请把信息填写完整！"];
            return;
        }
        else if([m_noBindAmountTextField.text intValue] < 20)
        {
            [self showAlertWithMessage:@"最低充值20元！"];
            return;
        }
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:@"recharge" forKey:@"command"];
    [dict setObject:@"01" forKey:@"rechargetype"];
    [dict setObject:@"" forKey:@"subchannel"];
    if (m_hasBind)
    {
        [dict setObject:self.bindPhonenumTextField.text forKey:@"phonenum"];
        NSString* amtValue = [NSString stringWithFormat:@"%d", [self.bindAmountTextField.text intValue] * 100];
        [dict setObject:amtValue  forKey:@"amount"];
        [dict setObject:self.bindBankCardNo forKey:@"cardno"];
        [dict setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
        [dict setObject:@"0101" forKey:@"cardtype"];
        [dict setObject:self.bindName forKey:@"name"];
        [dict setObject:self.bindCertId forKey:@"certid"];
        [dict setObject:self.bindBankAddress forKey:@"bankaddress"];
        [dict setObject:self.bindAddressName forKey:@"addressname"];
        [dict setObject:@"true" forKey:@"iswhite"];
    }
    else
    {
        [dict setObject:self.phonenumTextField.text forKey:@"phonenum"];
        NSString* amtValue = [NSString stringWithFormat:@"%d", [self.noBindAmountTextField.text intValue] * 100];
        [dict setObject:amtValue  forKey:@"amount"];
        [dict setObject:self.cardNoTextField.text forKey:@"cardno"];
        [dict setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
        [dict setObject:@"0101" forKey:@"cardtype"];  //待定，根据银行名称来设置
        [dict setObject:self.userNameTextField.text forKey:@"name"];
        [dict setObject:self.certidTextField.text forKey:@"certid"];
        [dict setObject:self.cardAddressTextField.text forKey:@"bankaddress"];
        [dict setObject:self.certidAddressTextField.text forKey:@"addressname"];
        [dict setObject:@"false" forKey:@"iswhite"];
    }
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:dict withRequestType:ASINetworkRequestTypeChargeDNA showProgress:YES];
}

#pragma mark －－－－选择银行名
- (IBAction)selectBankAction
{
    PickerViewController * viewController =[[PickerViewController alloc]init];
    viewController.delegate = self;
    viewController.pViewWidch = 350;
    m_popoverView =[[UIPopoverController alloc]initWithContentViewController:viewController];
    m_popoverView.popoverContentSize = CGSizeMake(350, 260);
    [m_popoverView presentPopoverFromRect:CGRectMake(125, 150, 350, 100) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    NSArray * array =[[NSArray alloc]initWithObjects:@"中国工商银行",@"中国农业银行",@"中国建设银行",@"招商银行",@"中国邮政储蓄银行",@"华厦银行",@"兴业银行",@"中信银行",@"中国光大银行",@"上海浦东发展银行" ,@"深圳发展银行", nil];
    [viewController setPickerViewDataArray:array selectNum:pickViewSelectNum];
    [array release];

    [viewController release];
}

- (void)pickViewCancelClick
{
    [m_popoverView dismissPopoverAnimated:YES];
}

- (void)pickerViewController:(PickerViewController *)viewController
                selectRowNum:(NSString*)selectRow
{
    NSLog(@"%@", selectRow);
    pickViewSelectNum = viewController.pickerSelectNum;
    [self.bankNameButton setTitle:selectRow forState:UIControlStateNormal];
}
//－－－－－－释放
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [m_popoverView release], m_popoverView = nil;
}

#pragma mark 键盘消息
- (void)keyboardDidShowNotification:(NSNotification*)notification
{
    if (!m_hasBind) {
        self.scrollNoBind.contentSize = CGSizeMake(620, 800);
    }
}

- (void)keyboardDidHideNotification:(NSNotification*)notification
{
    if (!m_hasBind) {
        self.scrollNoBind.contentSize = CGSizeMake(620, 578);
    }
}
#pragma mark －－－－联网成功
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkReqestTypeChargePage:
            [self setDescriptionViewWithContent:KISDictionaryHaveKey(dataDic, @"content")];
            break;
        case ASINetworkRequestTypeChargeDNA:
            [self showAlertWithMessage:KISDictionaryHaveKey(dataDic, @"message")];
            break;
        default:
            break;
    }
}

- (void)setDescriptionViewWithContent:(NSString*)contentStr
{
//    NSString *html = [NSString stringWithFormat:@"<body style='background-color:#EEEEEE'>%@</body>", contentStr];
    NSString* html = [NSString stringWithFormat:@"<style type=\"text/css\">body{line-height:30px; background-color:#EEEEEE}</style>%@", contentStr];
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(510, 141, 400, 578)];
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
#pragma mark textField and touch delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string//只允许输入数字所以，(限制输入英文和数字的话，就可以把这个定义为：#define kAlphaNum   @”ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789″)。
{
    if (textField == self.bindAmountTextField || textField == self.noBindAmountTextField) {
        if (textField.text.length >= 5 && range.length == 0)
        {
            return  NO;
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        BOOL canChange = [string isEqualToString:filtered];
        
        return canChange;
    }
    else if(textField == self.bindPhonenumTextField || textField == self.cardNoTextField || textField == self.phonenumTextField)
    {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        BOOL canChange = [string isEqualToString:filtered];
        
        return canChange;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}
@end
