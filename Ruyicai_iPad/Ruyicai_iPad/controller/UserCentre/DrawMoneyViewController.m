//
//  DrawMoneyViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-22.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "DrawMoneyViewController.h"

@interface DrawMoneyViewController ()
{
    NSString *isNight;
}
@end

#define TagDrawKindButton100 100
#define TagBankTextField110 110


@implementation DrawMoneyViewController
@synthesize delegate;
@synthesize drawbalanceString;
@synthesize recordDataArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRefresh:) name:@"startRefresh" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startRefresh" object:nil];
    
    [super viewWillDisappear:animated];

}
- (void)dealloc
{
    
    [drawbalanceString release],drawbalanceString = nil;
    [recordDataArray release],recordDataArray = nil;

    [bankView release];
    [aliPayView release];
    
    [bankArray release];
    [typeString release];
    [recordTableView release];
    [refreshView release];
    [cancelCashId release];
    [super dealloc];

}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    isNight = @"night";
    [self drawTitleView];
    
//    if ([self.drawbalanceString isEqualToString:@""]) { // 可提现金额 为空
        NSMutableDictionary * mDic =[[[NSMutableDictionary alloc]init]autorelease];
        [mDic setObject:@"AllQuery" forKey:@"command"];
        [mDic setObject:@"balance" forKey:@"type"];
        [mDic setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
        
        [RYCNetworkManager sharedManager].netDelegate = self;
        [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeQueryBalance showProgress:YES];
//    }
    
    [self drawBankCardView];//银行卡
    [self drawAlipayViewCreate];//支付宝
    [self drawRecordFormViewCreate];//记录
    
    [self drawAttentionMatterView];
}
#pragma mark ------------- view create
/* 标题信息 */
- (void)drawTitleView
{
    [super tabBarBackgroundImageViewWith:self.view];
    
    [self.view addSubview:getTopLableWithTitle(@"账户提现")];
    
    UIView * headView               = [[UIView alloc]initWithFrame:CGRectMake(0, 68, 908, 77)];
    headView.backgroundColor        = [UIColor colorWithPatternImage:RYCImageNamed(@"total_detail_top_bg.png")];
    [self.view addSubview:headView];
    [headView release];
    
    UIButton *drawBackBtn           = [UIButton buttonWithType:UIButtonTypeCustom];
    drawBackBtn.frame               = CGRectMake(0, 0, 76, 76);
    [drawBackBtn setImage:[UIImage imageNamed:@"viewback.png"] forState:UIControlStateNormal];
    [drawBackBtn addTarget:self action:@selector(drawBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:drawBackBtn];
    
    NSArray *array                  = [[NSArray alloc]initWithObjects:@"提现到银行卡",@"提现到支付宝",@"提现记录", nil];
    for (int i=0; i<array.count; i++) {
        UIButton *button            =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame                = CGRectMake(100+(132*i), 20, 132, 57);
        button.tag                  = TagDrawKindButton100  +i;
        [button setTitleColor:[UIColor blackColor] forState:btnNormal];
        [button setBackgroundImage:RYCImageNamed(@"draw_cell_tab_btn.png") forState:UIControlStateSelected];
        if (i == 0) {
            button.selected = YES;
        }

        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(drawMoneyKindButton:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:button];
        
    }
    [array release];
    
}
/*  银行卡提现 */
- (void)drawBankCardView
{
    bankView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 145, 600, 575)];
    bankView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bankView];
   
    typeString  = @"1";
    
    NSArray *nameAry =[[NSArray alloc]initWithObjects:@"可提现金额:",@"持卡人名:",@"开卡银行:",@"银行卡号:", @"提现金额:",@"登录密码:",nil];
    for (int i=0; i<nameAry.count; i++) {
        UILabel *nameLabel  = [[UILabel alloc]initWithFrame:CGRectMake(30, 30+(50*i), 120, 40)];
        nameLabel.text      = [nameAry objectAtIndex:i];
        nameLabel.font      = [UIFont boldSystemFontOfSize:18];
        if ([isNight isEqualToString:@"night"]) {
            nameLabel.backgroundColor =[UIColor clearColor];
            nameLabel.textColor = [UIColor blackColor];
        }else
        {
            nameLabel.backgroundColor = [UIColor darkGrayColor];
            nameLabel.textColor = [UIColor whiteColor];
        }
        [bankView addSubview:nameLabel];
        [nameLabel release];
    }
    [nameAry release];
    
    UILabel * balanceLabel              = [[UILabel alloc]initWithFrame:CGRectMake(150,35, 180, 30)];
    balanceLabel.backgroundColor        = [UIColor clearColor];
    if ([self.drawbalanceString isEqualToString:@""]) {
        balanceLabel.text               = @"查询中..";

    }else
    {
        balanceLabel.text               = self.drawbalanceString;

    }
    balanceLabel.tag                    = TagBankTextField110;
    balanceLabel.textAlignment          = NSTextAlignmentCenter;
    balanceLabel.textColor              = [UIColor redColor];
    [bankView addSubview:balanceLabel];
    [balanceLabel release];
    
    UITextField *nameTextField  = [[UITextField alloc]initWithFrame:CGRectMake(150,85, 250, 40)];
    nameTextField.placeholder   = @"银行开户人真实姓名";
    nameTextField.tag           = TagBankTextField110 + 1;
    nameTextField.borderStyle   = UITextBorderStyleRoundedRect;
    nameTextField.delegate      = self;
    nameTextField.text = KISDictionaryHaveKey(self.DNADataDic, @"name");
    [bankView addSubview:nameTextField];
    [nameTextField release];
    
    UIButton * cardButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cardButton.frame            = CGRectMake(nameTextField.frame.origin.x, nameTextField.frame.origin.y+50, nameTextField.frame.size.width, 40);
    [cardButton setTitle:@"选择银行" forState:UIControlStateNormal];
    [cardButton setBackgroundImage:RYCImageNamed(@"select_long_click.png") forState:btnNormal];
    cardButton.tag              = TagBankTextField110 + 6;
    [cardButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cardButton addTarget:self action:@selector(drawSelectBankCardButton:) forControlEvents:UIControlEventTouchUpInside];
    [cardButton setTitle:KISDictionaryHaveKey(self.DNADataDic, @"bankname") forState:UIControlStateNormal];
    [bankView addSubview:cardButton];
    
    UITextField *cardTextField  =[[UITextField alloc]initWithFrame:CGRectMake(cardButton.frame.origin.x, cardButton.frame.origin.y+50, nameTextField.frame.size.width, 40)];
    cardTextField.placeholder   = @"输入准确的银行卡号";
    cardTextField.tag           = TagBankTextField110 + 2;
    cardTextField.borderStyle   = UITextBorderStyleRoundedRect;
    cardTextField.delegate      = self;
    cardTextField.text = KISDictionaryHaveKey(self.DNADataDic, @"bankcardno") ;
    [bankView addSubview:cardTextField];
    [cardTextField release];
    
    UITextField *monTextField   = [[UITextField alloc]initWithFrame:CGRectMake(cardTextField.frame.origin.x,cardTextField.frame.origin.y+50, nameTextField.frame.size.width, 40)];
    monTextField.text           = @"10";
    monTextField.tag            = TagBankTextField110 + 3;
    monTextField.delegate       = self;
    monTextField.borderStyle    = UITextBorderStyleRoundedRect;
//    if ([isNight isEqualToString:@"night"]) {
//        monTextField.backgroundColor = [UIColor darkGrayColor];
//    }else{
//        monTextField.backgroundColor = [UIColor whiteColor];
//    }
    monTextField.textColor      = [UIColor redColor];
    [bankView addSubview:monTextField];
    [monTextField release];
    
  
    UITextField *passTextField  = [[UITextField alloc]initWithFrame:CGRectMake(cardTextField.frame.origin.x,monTextField.frame.origin.y+50, nameTextField.frame.size.width, 40)];
    passTextField.placeholder   = @"输入如意彩登录密码";
    passTextField.tag           = TagBankTextField110 + 4;
    passTextField.borderStyle   = UITextBorderStyleRoundedRect;
    passTextField.secureTextEntry = YES;
    passTextField.delegate      = self;
    [bankView addSubview:passTextField ];
    [passTextField release];
    
    UIButton * drawBtn          = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [drawBtn setBackgroundImage:[UIImage imageNamed:@"yellow_button_normal.png"] forState:UIControlStateNormal];
    drawBtn.frame               = CGRectMake(50, 340, 300,50);
    drawBtn.tag                 = TagBankTextField110 + 5;
    [drawBtn setTitle:@"提 现" forState:UIControlStateNormal];
    [drawBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    drawBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [drawBtn addTarget:self action:@selector(drawMoneyToBankCardButton:) forControlEvents:UIControlEventTouchUpInside];
    [bankView addSubview:drawBtn];
    
}


/*  提现到支付宝 */
- (void)drawAlipayViewCreate
{
    aliPayView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 145, 600, 575)];
    aliPayView.backgroundColor = [UIColor whiteColor];
    
    
    NSArray *nameAry =[[NSArray alloc]initWithObjects:@"可提现金额:",@"支付宝账号:",@"真实姓名:",@"提现金额:",@"登录密码:", nil];
    for (int i=0; i<nameAry.count; i++) {
        UILabel *tetLabel   = [[UILabel alloc]initWithFrame:CGRectMake(30, 30+(50*i), 120, 30)];
        tetLabel.text       = [nameAry objectAtIndex:i];
        tetLabel.font       = [UIFont boldSystemFontOfSize:18];
        tetLabel.backgroundColor =[UIColor clearColor];
//        if ([isNight isEqualToString:@"night"]) {
//            tetLabel.backgroundColor =[UIColor darkGrayColor];
//            tetLabel.textColor =[UIColor whiteColor];
//        }else
//        {
//        tetLabel.backgroundColor =[UIColor darkGrayColor];
//        tetLabel.textColor  = [UIColor whiteColor];
//        }
        [aliPayView addSubview:tetLabel];
        [tetLabel release];
    }
    [nameAry release];
#define TagAlipayView120 120
    
    UILabel *remLabel           = [[UILabel alloc]initWithFrame:CGRectMake(160, 35, 180, 30)];
    if ([self.drawbalanceString isEqualToString:@""]) {
        remLabel.text               = @"查询中..";
    }else{
        remLabel.text               = self.drawbalanceString;
    }
    remLabel.textColor          = [UIColor redColor];
    remLabel.backgroundColor    = [UIColor clearColor];
    remLabel.textAlignment      = NSTextAlignmentCenter;
    remLabel.tag                = TagAlipayView120;
    [aliPayView addSubview:remLabel];
    [remLabel release];
    
    UITextField *accTextField   =[[UITextField alloc]initWithFrame:CGRectMake(160, 80, 250, 40)];
    accTextField.placeholder    = @"支付宝账号";
    accTextField.font           = [UIFont systemFontOfSize:17];
    accTextField.tag            = TagAlipayView120 + 1;
    accTextField.borderStyle    = UITextBorderStyleRoundedRect;
    accTextField.delegate       = self;
//    if ([isNight isEqualToString:@"night"]) {
//        accTextField.backgroundColor =[UIColor darkGrayColor];
//        accTextField.textColor =[UIColor whiteColor];
//    }else{
//        accTextField.backgroundColor =[UIColor clearColor];
//        accTextField.textColor = [UIColor blackColor];
//    }
    [aliPayView addSubview:accTextField];
    [accTextField release];
    
    UITextField * nameTextField     =[[UITextField alloc]initWithFrame:CGRectMake(accTextField.frame.origin.x, accTextField.frame.origin.y+50, accTextField.frame.size.width, 40)];
    nameTextField.placeholder       = @"认证的真实姓名";
    nameTextField.borderStyle       = UITextBorderStyleRoundedRect;
    nameTextField.font              = [UIFont systemFontOfSize:17];
    nameTextField.tag               = TagAlipayView120 + 2;
    nameTextField.delegate          = self;
    [aliPayView addSubview:nameTextField];
    [nameTextField release];
    
    UITextField *monTextField       =[[UITextField alloc]initWithFrame:CGRectMake(accTextField.frame.origin.x, nameTextField.frame.origin.y+50, accTextField.frame.size.width, 40)];
    monTextField.textColor          =[UIColor redColor];
    monTextField.borderStyle        = UITextBorderStyleRoundedRect;
    monTextField.font               = [UIFont systemFontOfSize:17];
    monTextField.tag                = TagAlipayView120 + 3;
    monTextField.text               = @"10";
    monTextField.delegate           = self;
    [aliPayView addSubview:monTextField ];
    [monTextField release];
    
    UITextField *passTextField      =[[UITextField alloc]initWithFrame:CGRectMake(accTextField.frame.origin.x, monTextField.frame.origin.y+50, accTextField.frame.size.width, 40)];
    passTextField.placeholder       = @"如意彩登录密码";
    passTextField.borderStyle       = UITextBorderStyleRoundedRect;
    passTextField.font              = [UIFont systemFontOfSize:17];
    passTextField.tag               = TagAlipayView120 + 4;
    passTextField.delegate          = self;
    passTextField.secureTextEntry   = YES;
    [aliPayView addSubview:passTextField];
    [passTextField release];
    
    UIButton * drawBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [drawBtn setBackgroundImage:[UIImage imageNamed:@"yellow_button_normal.png"] forState:UIControlStateNormal];
    drawBtn.frame = CGRectMake(50, 300, 300,50);
    [drawBtn setTitle:@"提 现" forState:UIControlStateNormal];
    [drawBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    drawBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [drawBtn addTarget:self action:@selector(drawMoneyToBankCardButton:) forControlEvents:UIControlEventTouchUpInside];
    [aliPayView addSubview:drawBtn];
}
/*  提现记录 */
- (void)drawRecordFormViewCreate
{
    
    self.recordDataArray                = [[NSMutableArray alloc]init];
    recordTableView                     =[[UITableView alloc]initWithFrame:CGRectMake(0, 145, 600, 575) style:UITableViewStylePlain];
    recordTableView.delegate            = self;
    recordTableView.dataSource          = self;
    recordTableView.backgroundColor     = [UIColor whiteColor];
    recordTableView.separatorStyle      = UITableViewCellSeparatorStyleNone;
    
    totalPageCount                      = 0;
    curPageIndex                        = 0;
    startY                              = 0;
    centerY                             = 0;
    refreshView                         = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, 710, 600, REFRESH_HEADER_HEIGHT)];
    [recordTableView addSubview:refreshView];
    refreshView.myScrollView            = recordTableView;
    [refreshView stopLoading:NO];
}
/* 注意事项 */
- (void)drawAttentionMatterView
{
    UIView *attView             =[[UIView alloc]initWithFrame:CGRectMake(600, 145, 308, 575)];
    attView.backgroundColor     = RGBCOLOR(240, 240, 240);
    [self.view addSubview:attView];
    [attView release];
    UITextView * attTextView    = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, attView.frame.size.width, attView.frame.size.height)];
    attTextView.font            = [UIFont systemFontOfSize:17];
    attTextView.backgroundColor = [UIColor clearColor];
    attTextView.textColor       = [UIColor orangeColor];
    attTextView.text            = @"提现注意事项: \n1.持卡人名必须与用户信息绑定的真实姓名一致！提现只能提到银行卡上，暂不支持信用卡提现。 \n2.可提现余额大于等于10元时，单笔提现金额不能少于10元；可提现金额小于10元时，需要一次性提清。\n3.为了防止少数用户利用信用卡套现和洗钱行为，保证正常用户的资金安全，本站针对提款做出以下规定：累计充值资金消费未满30%，可提现金额为累计充值资金的70%；累计充值资金消费达到30%，不受此限制。\n4.提款到账时间：使用中国工商银行、中国农业银行、中国建设银行、中国招商银行的银行卡进行提现，16:00前的提款申请：当天到账；16:00后的提款申请：第二天到账。使用其它银行卡进行提现，16:00前的提款申请：第二天到账；16:00后的提款申请，第三天到账。如有疑问，请致电客服热线：400-665-1000 。   ";
    attTextView.editable        = NO;
    [attView addSubview:attTextView];
    [attTextView release];
}


#pragma mark --------- draw menthods
/* 返回按钮 */
- (void)drawBackButtonClick:(id)sender
{
    [self.delegate drawMoneyViewDisappear:self];
}
/* 提现种类 */
- (void)drawMoneyKindButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;

    if ((btn.tag -TagDrawKindButton100) == 1 && [[self.DNADataDic objectForKey:@"bindstate"] isEqualToString:@"1"]) {
        [self showAlertWithMessage:@"由于您使用DNA充值已绑定了提现银行卡，故无法提现到支付宝账号!"];
        return;
    }
    [self drawViewRemove];
    [self refreshButtonImg:btn.tag];
    switch (btn.tag -TagDrawKindButton100) {
        case 0:
        {
            [self.view addSubview:bankView];
            typeString  = @"1";
        }
            break;
         case 1:
        {
            [self.view addSubview:aliPayView];
            typeString  = @"2";
        }
            break;
        case 2:
        {
            [self.view addSubview:recordTableView];
            typeString = @"3";
            if (curPageIndex == 0) {
                [self sendRequestCashRecordWithPage:curPageIndex];
            }
            
        }
            break;
        default:
            break;
    }
}

- (void)refreshButtonImg:(int)buttpnTag
{
    for (int i = 0; i < 3; i++) {
        UIButton* tempButton = (UIButton*)[self.view viewWithTag:TagDrawKindButton100 + i];
        if (buttpnTag == tempButton.tag) {
            tempButton.selected = YES;
        }
        else
            tempButton.selected = NO;
    }
}
/* 银行卡选择 */
- (void)drawSelectBankCardButton:(id)sender
{
    [self bankViewTextFieldResignFirstResponder];
    PickerViewController * viewController =[[PickerViewController alloc]init];
    viewController.delegate = self;
    viewController.pViewWidch = 350;
    popoverView =[[UIPopoverController alloc]initWithContentViewController:viewController];
    popoverView.popoverContentSize = CGSizeMake(350, 260);
    [popoverView presentPopoverFromRect:CGRectMake(75, 210, 350, 100) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    bankArray =[[NSArray alloc]initWithObjects:@"中国工商银行",@"中国农业银行",@"中国建设银行",@"中国民生银行",@"招商银行",@"中国邮政储蓄银行",@"交通银行",@"兴业银行",@"中信银行",@"中国光大银行",@"广东发展银行",@"上海浦东发展银行" ,@"深圳发展银行",@"杭州银行", nil];
    [viewController setPickerViewDataArray:bankArray selectNum:pickViewSelectNum];
    
    [viewController release];
}
- (void)pickViewCancelClick
{
    [popoverView dismissPopoverAnimated:YES];
}

- (void)pickerViewController:(PickerViewController *)viewController
                selectRowNum:(NSString*)selectRow
{
    NSLog(@"%@", selectRow);
    pickViewSelectNum = viewController.pickerSelectNum;
    UIButton *button = (UIButton *)[bankView viewWithTag:TagBankTextField110 + 6];
    [button setTitle:selectRow forState:btnNormal];
}
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [popoverView release], popoverView = nil;
}
/* 提现到银行卡 */
- (void)drawMoneyToBankCardButton:(id)sender
{
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];

    if ([typeString isEqualToString:@"1"])
    {
        UITextField * nameText      = (UITextField *)[bankView viewWithTag:TagBankTextField110 + 1];
        UITextField * cardText      = (UITextField *)[bankView viewWithTag:TagBankTextField110 + 2];
        UITextField * monText       = (UITextField *)[bankView viewWithTag:TagBankTextField110 + 3];
        UITextField * passText      = (UITextField *)[bankView viewWithTag:TagBankTextField110 + 4];
        UIButton    * bankBtn       = (UIButton *)[bankView viewWithTag:TagBankTextField110 + 6];
        if (nameText.text.length == 0 ||cardText.text.length == 0 ||monText.text.length ==0 ||passText.text.length == 0 || [bankBtn currentTitle].length == 0) {
            [self showAlertWithMessage:@"请把信息填写完整"];
            return;
        }
        if (![self checkMoneyTextField:monText.text]) {
            return;
        }
        if (![self checkDrawbalanceTextFirld:monText.text]) {
            return;
        }

        if (![passText.text isEqualToString:[UserLoginData sharedManager].userPass]) {
            [self showAlertWithMessage:@"如意彩账号登录密码不正确！"];
            return;
        }


        NSString* bankNo = [cardText.text stringByReplacingOccurrencesOfString:@" " withString:@""];//剔除空格;
        
        [dict setObject:bankNo forKey:@"bankcardno"];
        [dict setObject:nameText.text forKey:@"name"];
        [dict setObject:[bankBtn currentTitle] forKey:@"bankname"];
        [dict setObject:passText.text forKey:@"password"];
        [dict setObject:[NSString stringWithFormat:@"%0.0lf", [monText.text doubleValue] * 100] forKey:@"amount"];
        [dict setObject:@"1" forKey:@"type"];
        passText.text = @"";

    }else
    {
        UITextField * accText      = (UITextField *)[aliPayView viewWithTag:TagAlipayView120 + 1];
        UITextField * nameText      = (UITextField *)[aliPayView viewWithTag:TagAlipayView120 + 2];
        UITextField * monText       = (UITextField *)[aliPayView viewWithTag:TagAlipayView120 + 3];
        UITextField * passText      = (UITextField *)[aliPayView viewWithTag:TagAlipayView120 + 4];

        if (nameText.text.length == 0 ||accText.text.length == 0 ||monText.text.length ==0 || passText.text.length == 0) {
            [self showAlertWithMessage:@"请把信息填写完整"];
            return;
        }
        if (![self checkMoneyTextField:monText.text]) {
            return;
        }
        if (![self checkDrawbalanceTextFirld:monText.text]) {
            return;
        }
        if (![passText.text isEqualToString:[UserLoginData sharedManager].userPass]) {
            [self showAlertWithMessage:@"如意彩账号登录密码不正确！"];
            return;
        }
        
        
        
        [dict setObject:@"2" forKey:@"type"];
        [dict setObject:accText.text forKey:@"bankcardno"];
        [dict setObject:nameText.text forKey:@"name"];
        [dict setObject:passText.text forKey:@"password"];
        [dict setObject:[NSString stringWithFormat:@"%0.0lf", [monText.text doubleValue] * 100] forKey:@"amount"];
        passText.text = @"";
    }
    
    [dict setObject:@"getCash" forKey:@"command"];
    [dict setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    [dict setObject:@"cash" forKey:@"cashtype"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
     [[RYCNetworkManager sharedManager] netRequestStartWith:dict withRequestType:ASINetworkRequestTypeGetCash showProgress:YES];

}
- (BOOL)checkMoneyTextField:(NSString *)monText
{
    for (int i=0; i<monText.length; i++) {
        UniChar chr = [monText characterAtIndex:i];
        if (chr >= '0' && chr <= '9')//是数字
        {
            
        }else if ('.' == chr)
        {
            if(0 == i)
            {
                [self showAlertWithMessage:@"提现金额填写不规范"];
                return NO;
            }
            
        }else
        {
            [self showAlertWithMessage:@"提现金额须为整数或小数"];
            return NO;
        }
    }
    if ([monText doubleValue] <=0) {
        [self  showAlertWithMessage:@"提现金额须需大于0"];
        return NO;
    }

    return YES;
}
- (BOOL)checkDrawbalanceTextFirld:(NSString *)monText
{
    NSString*  canBalanceStr = [self.drawbalanceString substringWithRange:NSMakeRange(0, drawbalanceString.length - 1)];
    double balance = [canBalanceStr doubleValue];
    if (balance < 10)//提现金额少于10元
    {
        if([monText doubleValue] != balance)
        {
            [self showAlertWithMessage: @"可提现金额不足10元，必需全部提现！"];
            return NO;
        }
    }else
    {
        if([monText doubleValue] < 10)
        {
            [self showAlertWithMessage: @"最低提现不小于10元！"];
            return NO;
        }
        else if([monText doubleValue] > balance)
        {
            [self showAlertWithMessage: @"提现金额不足！"];
            return NO;
        }
    }
    
    if([monText doubleValue] > 50000)
    {
        [self showAlertWithMessage:@"单笔提现金额最高50000元!"];
        return NO;
    }
    return YES;
}
- (void)drawViewRemove
{
    [aliPayView removeFromSuperview];
    [bankView removeFromSuperview];
    [recordTableView removeFromSuperview];
}
#pragma mark ---------- RYCNetManager delegate
- (void)sendRequestCashRecordWithPage:(int )pageIndex
{
    NSMutableDictionary* mDict = [[[NSMutableDictionary alloc]init]autorelease];
    [mDict setObject:@"getCash" forKey:@"command"];
    [mDict setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    [mDict setObject:@"cashRecord" forKey:@"cashtype"];
    [mDict setObject:@"8" forKey:@"maxresult"];
    [mDict setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"pageindex"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkRequestTypeQueryRecordCash showProgress:YES];
}
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkRequestTypeQueryBalance:     // 余额查询
        {
            if (ErrorCode(dataDic)) {
                self.drawbalanceString = KISDictionaryHaveKey(dataDic, @"drawbalance");
                [UserLoginData sharedManager].userDrawbalance = self.drawbalanceString;
                UILabel * bankLabel = (UILabel *)[bankView viewWithTag:TagBankTextField110];
                bankLabel.text = self.drawbalanceString;
                UILabel * aliLabel = (UILabel *)[aliPayView viewWithTag:TagAlipayView120];
                aliLabel.text = self.drawbalanceString;
            }
        }
            break;
        case ASINetworkRequestTypeGetCash:          // 申请提现
        {
            if (ErrorCode(dataDic)) {
                [self showAlertWithMessage:KISDictionaryHaveKey(dataDic, @"message")];
            }else
            {
                [self showAlertWithMessage:KISDictionaryHaveKey(dataDic, @"message")];
            }
        }
            break;
        case ASINetworkRequestTypeQueryRecordCash:  // 提现记录
        {
            [[self.view viewWithTag:1234] removeFromSuperview];
            if (ErrorCode(dataDic)) {
                [self getCaseRecordDataDictionary:dataDic];
            }else if(RecordCodeNull(dataDic)){
                [recordTableView removeFromSuperview];
                [self  requestNoDataDrawLabelWith:self.view rect:CGRectMake(200, 150, 200, 30)];
            }else{
                [self showAlertWithMessage:KISDictionaryHaveKey(dataDic, @"message")];
            }
        }
            break;
        case ASINetworkRequestTypeCancelCash:       // 取消提现
        {
            if (ErrorCode(dataDic)) {
                curPageIndex = 0;
                [self sendRequestCashRecordWithPage:curPageIndex];
                [self showAlertWithMessage:KISDictionaryHaveKey(dataDic, @"message")];
            }
        }
            break;
        default:
            break;
    }
}
- (void)requestNoDataDrawLabelWith:(UIView *)subView rect:(CGRect)viewRect
{
    UILabel * label =[[UILabel alloc]initWithFrame:viewRect];
    label.text = @"无记录";
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.tag = 1234;
    [subView addSubview:label];
    [label release];
}
- (void) getCaseRecordDataDictionary:(NSDictionary *)mDic
{
    
    NSArray * result =KISDictionaryHaveKey(mDic, @"result");
    NSMutableArray * array = [[NSMutableArray alloc]init];
    for (int i=0; i<result.count; i++) {
        NSDictionary *dic =[result objectAtIndex:i];
        UserCashRecordModel * model =[[UserCashRecordModel alloc]init];
        model.cashdetailid = KISDictionaryHaveKey(dic, @"cashdetailid");
        model.amount        = KISDictionaryHaveKey(dic, @"amount");
        model.cashTime      = KISDictionaryHaveKey(dic, @"cashTime");
        model.rejectReason  = KISDictionaryHaveKey(dic, @"rejectReason");
        model.stateMemo     = KISDictionaryHaveKey(dic, @"stateMemo");
        model.state         = KISDictionaryHaveKey(dic, @"state");
        [array addObject:model];
        [model release];
    }
    if (curPageIndex == 0) {
        [self.recordDataArray removeAllObjects];
    }
    [self.recordDataArray addObjectsFromArray:array];
    [array release];
    [recordTableView reloadData];
    
    
    totalPageCount              = [KISDictionaryHaveKey(mDic, @"totalPage") intValue];
    startY                      = recordTableView.contentSize.height;
    
    centerY                     = recordTableView.contentSize.height- 80*7;
    curPageIndex++;
    
    if(curPageIndex == totalPageCount)
    {
        [refreshView stopLoading:YES];
    }
    else
    {
        [refreshView stopLoading:NO];
    }
    [refreshView setRefreshViewFrame];
}
#pragma mark ---------------------- textField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (TagBankTextField110 +3 == textField.tag) {
        [self bankViewMonTextFieldEditingIsViewMoveUp:YES height:100];
    }else if (TagBankTextField110 +4 ==textField.tag)
    {
        [self bankViewMonTextFieldEditingIsViewMoveUp:YES height:150];
    }else if (TagBankTextField110 + 2 == textField.tag)
    {
        [self bankViewMonTextFieldEditingIsViewMoveUp:YES height:50];
    }
    
    
    if (TagAlipayView120 +3 ==textField.tag) {
        [self alipayViewTextFieldMoveUp:YES height:80];
    }else if(TagAlipayView120 + 4 ==textField.tag)
    {
        [self alipayViewTextFieldMoveUp:YES height:130];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (TagBankTextField110 + 3 == textField.tag) {
        [self bankViewMonTextFieldEditingIsViewMoveUp:NO height:100];
    }else if (TagBankTextField110 + 4  == textField.tag)
    {
        [self bankViewMonTextFieldEditingIsViewMoveUp:NO height:150];

    }else if (TagBankTextField110 + 2 == textField.tag)
    {
        [self bankViewMonTextFieldEditingIsViewMoveUp:NO height:50];
    }
    if (TagAlipayView120 +3 ==textField.tag) {
        [self alipayViewTextFieldMoveUp:NO height:80];
    }else if(TagAlipayView120 + 4 ==textField.tag)
    {
        [self alipayViewTextFieldMoveUp:NO height:130];
    }
    return YES;
}
- (void)bankViewMonTextFieldEditingIsViewMoveUp:(BOOL)isUp height:(CGFloat )moveHeight
{
    if (isUp) {
        
        bankView.contentSize = CGSizeMake(bankView.frame.size.width, bankView.frame.size.height+moveHeight);
        [bankView setContentOffset:CGPointMake(0, moveHeight)];
    }else{
        bankView.contentSize = CGSizeMake(bankView.frame.size.width, bankView.frame.size.height);
        
    }
}
- (void)alipayViewTextFieldMoveUp:(BOOL)isUp height:(CGFloat)moveHeight
{
    if (isUp) {
        aliPayView.contentSize = CGSizeMake(aliPayView.frame.size.width, bankView.frame.size.height+moveHeight);
        [aliPayView setContentOffset:CGPointMake(0, moveHeight)];
    }else
    {
         aliPayView.contentSize = CGSizeMake(aliPayView.frame.size.width, bankView.frame.size.height);
    }
}
- (void)bankViewTextFieldResignFirstResponder
{
    UITextField *textF1 = (UITextField *)[bankView viewWithTag:TagBankTextField110 +1];
    [textF1 resignFirstResponder];
    UITextField *textF2 = (UITextField *)[bankView viewWithTag:TagBankTextField110 +2];
    [textF2 resignFirstResponder];
    UITextField *textF3 = (UITextField *)[bankView viewWithTag:TagBankTextField110 +3];
    [textF3 resignFirstResponder];
    UITextField *textF4 = (UITextField *)[bankView viewWithTag:TagBankTextField110 +4];
    [textF4 resignFirstResponder];

}
#pragma mark -------------------- tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recordDataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * celled = @"celled";
    DrawMoneyRecordViewCell * cell =(DrawMoneyRecordViewCell*) [tableView dequeueReusableCellWithIdentifier:celled];
    if (cell == nil) {
        cell =[[DrawMoneyRecordViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:celled];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    cell.cashModel =[self.recordDataArray objectAtIndex:indexPath.row];
    
    [cell refreshCellView];
    return cell;
    
}
#pragma mark ---------------- tableViewCell delegate
- (void)drawMoneyRecordCancelCashId:(NSString *)cashId
{
    cancelCashId = cashId;
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您是否要取消提现" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    [alertView show];
    [alertView release];
    
   
}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        NSMutableDictionary * mDic =[[[NSMutableDictionary alloc]init]autorelease];
        [mDic setObject:@"getCash" forKey:@"command"];
        [mDic setObject:@"cancelCash" forKey:@"cashtype"];
        [mDic setObject:cancelCashId forKey:@"cashdetailid"];
        [mDic setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
        
        [RYCNetworkManager sharedManager].netDelegate = self;
        [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeCancelCash showProgress:YES];
    }
}
#pragma mark   ------------------------- scrollView  delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(curPageIndex == 0)
    {
        refreshView.viewMaxY = 0;
    }
    else
    {
        refreshView.viewMaxY = centerY;
    }
    [refreshView viewdidScroll:scrollView];
}
#pragma mark --------------------------  pull up refresh
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [refreshView viewWillBeginDragging:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [refreshView didEndDragging:scrollView];
}

- (void)startRefresh:(NSNotification *)notification
{
    NSLog(@"start");
    if(curPageIndex < totalPageCount)
    {
        [self sendRequestCashRecordWithPage:curPageIndex];
    }
}

- (void)netFailed:(NSNotification*)notification
{
	[refreshView stopLoading:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
