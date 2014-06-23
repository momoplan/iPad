//
//  IntegralDetailViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-24.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "IntegralDetailViewController.h"

@interface IntegralDetailViewController ()
{
    NSString *isNight;
}
@end

@implementation IntegralDetailViewController
@synthesize delegate;
@synthesize userScore;
@synthesize integralDataArray;
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
   
    [userScore release],userScore = nil;
    [integralDataArray release],integralDataArray = nil;
    
    [refreshView release];
    [intTableView release];
    [useTextField release];
    [inteLabel release];
    [super dealloc];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRefresh:) name:@"startRefresh" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startRefresh" object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super tabBarBackgroundImageViewWith:self.view];
    isNight =@"night";
    
    [self integralTitleView];//标题
    [self integralTableView]; //积分列表
    [self integralMessageView];//积分信息
    [self sendRequestIntegralDetailWithPage:0];
    
   
}
#pragma mark ---------- integral view
/* 标题 返回 */
- (void)integralTitleView
{
     [self.view addSubview:getTopLableWithTitle(@"我的积分")];
       
    UIButton *integralBackBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
    integralBackBtn.frame       = CGRectMake(0, 0, 76, 76);
    [integralBackBtn setImage:[UIImage imageNamed:@"narBack.png"] forState:UIControlStateNormal];
    [integralBackBtn addTarget:self action:@selector(integralBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:integralBackBtn];
}
/*  积分列表 */
- (void)integralTableView
{
    self.integralDataArray  = [[NSMutableArray alloc]init];
    intTableView            = [[UITableView alloc]initWithFrame:CGRectMake(0, 75, 600, 645) style:UITableViewStylePlain];
    intTableView.delegate   = self;
    intTableView.dataSource = self;
    [self.view addSubview:intTableView];
    
    totalPageCount                      = 0;
    curPageIndex                        = 0;
    startY                              = 0;
    centerY                             = 0;
    refreshView                         = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, 710, 600, REFRESH_HEADER_HEIGHT)];
    [intTableView addSubview:refreshView];
    refreshView.myScrollView            = intTableView;
    [refreshView stopLoading:NO];
}
/* 积分信息 */
- (void)integralMessageView
{
    UIView *exchangeView =[[UIView alloc]initWithFrame:CGRectMake(600, 75, 300, 645)];
//    if ([isNight isEqualToString:@"night"]) {
//        exchangeView.backgroundColor =[UIColor whiteColor];
//    }else
//    {
//        exchangeView.backgroundColor =[UIColor darkGrayColor];
//    }
    exchangeView.backgroundColor = RGBCOLOR(244, 244, 244);
    [self.view addSubview:exchangeView];
    [exchangeView release];
    
    UIView *bgView          = [[UIView alloc]initWithFrame:CGRectMake(0, 0, exchangeView.frame.size.width, 43)];
    bgView.backgroundColor  = [UIColor colorWithPatternImage:RYCImageNamed(@"total_top_button_bg.png")];
    [exchangeView addSubview:bgView];
    [bgView release];
    
    
    UILabel *exLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 20)];
    exLabel.text = @"积分兑换";
    if ([isNight isEqualToString:@"night"]) {
        exLabel.textColor = [UIColor blackColor];
        exLabel.backgroundColor =[UIColor clearColor];
    }else{
        exLabel.textColor = [UIColor whiteColor];
        exLabel.backgroundColor =[UIColor blackColor];
    }
    [exchangeView addSubview:exLabel];
    [exLabel release];

    UILabel *curLabel= [[UILabel alloc]initWithFrame:CGRectMake(20,60, 120, 20)];
    curLabel.text = @"当前积分";
    if ([isNight isEqualToString:@"night"]) {
        curLabel.textColor = [UIColor blackColor];
        curLabel.backgroundColor =[UIColor clearColor];
    }else{
        curLabel.textColor = [UIColor whiteColor];
        curLabel.backgroundColor =[UIColor blackColor];
    }
    [exchangeView addSubview:curLabel];
    [curLabel release];
    
    numLabel =[[UILabel alloc]initWithFrame:CGRectMake(curLabel.frame.origin.x + curLabel.frame.size.width, curLabel.frame.origin.y, 150, 20)];
    numLabel.text = userScore;
    numLabel.textColor =[UIColor redColor];
    if ([isNight isEqualToString:@"night"]) {
        numLabel.backgroundColor =[UIColor clearColor];
    }else{
        numLabel.backgroundColor =[UIColor blackColor];
    }
    [exchangeView addSubview:numLabel];
    [numLabel release];
    
    UIView * lineView           = [[UIView alloc]initWithFrame:CGRectMake(0, 90, exchangeView.frame.size.width, 2)];
    lineView.backgroundColor    = [UIColor colorWithPatternImage:RYCImageNamed(@"space_line.png")];
    [exchangeView addSubview:lineView];
    [lineView release];
    
    UILabel *useLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 100, 250, 30)];
    useLabel.text = @"使用                        积分";
    if ([isNight isEqualToString:@"night"]) {
        useLabel.backgroundColor =[UIColor clearColor];
        useLabel.textColor =[UIColor blackColor];

    }else{
        useLabel.backgroundColor =[UIColor blackColor];
        useLabel.textColor =[UIColor clearColor];

    }
    [exchangeView addSubview:useLabel];
    [useLabel release];
    
    useTextField                =[[UITextField alloc]initWithFrame:CGRectMake(70, useLabel.frame.origin.y, 80, 30)];
    useTextField.placeholder    = @"积分数";
    useTextField.delegate       = self;
    useTextField.textColor      = [UIColor redColor];
    useTextField.borderStyle    = UITextBorderStyleLine;
    [useTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [exchangeView addSubview:useTextField];
    
    UILabel *handLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 150, 250,20)];
    handLabel.text = @"兑换                      元彩金";
    if ([isNight isEqualToString:@"night"]) {
        handLabel.backgroundColor =[UIColor clearColor];
        handLabel.textColor =[UIColor blackColor];
        
    }else{
        handLabel.backgroundColor =[UIColor blackColor];
        handLabel.textColor =[UIColor clearColor];
        
    }
    [exchangeView addSubview:handLabel];
    [handLabel release];
    
    inteLabel                   = [[UILabel alloc]initWithFrame:CGRectMake(55, 150, 80, 20)];
    DLog(@"self.userScore %@",self.userScore);
    inteLabel.text              = @"0";
    inteLabel.backgroundColor   = [UIColor clearColor];
    inteLabel.textColor         = [UIColor redColor];
    inteLabel.textAlignment     = NSTextAlignmentCenter;
    [exchangeView addSubview:inteLabel];
    
    
    UILabel *messLabel          = [[UILabel alloc]initWithFrame:CGRectMake(20, 200, 280, 40)];
    messLabel.numberOfLines     = 0;
    messLabel.backgroundColor   = [UIColor clearColor];
    messLabel.font              = [UIFont systemFontOfSize:15];
    messLabel.text              = @"500积分可兑换1元彩金 (请输入500的倍数)，存入您的如意彩账户";
    [exchangeView addSubview:messLabel];
    [messLabel release];
    
    UIButton *exchangeBtn       = [UIButton buttonWithType:UIButtonTypeCustom];
    [exchangeBtn setTitleColor:[UIColor blackColor] forState:btnNormal];
    exchangeBtn.frame           = CGRectMake(95, 260, 118, 41);
    [exchangeBtn setTitle:@"积分兑换" forState:UIControlStateNormal];
    [exchangeBtn setBackgroundImage:RYCImageNamed(@"userCenter_button_normal.png") forState:btnNormal];
     [exchangeBtn setBackgroundImage:RYCImageNamed(@"userCenter_button_click.png") forState:UIControlStateHighlighted];
    [exchangeBtn addTarget:self action:@selector(integralExchangeButton:) forControlEvents:UIControlEventTouchUpInside];
    [exchangeView addSubview:exchangeBtn];
    
    UIView * lineView1           = [[UIView alloc]initWithFrame:CGRectMake(0, 320, exchangeView.frame.size.width, 2)];
    lineView1.backgroundColor    = [UIColor colorWithPatternImage:RYCImageNamed(@"space_line.png")];
    [exchangeView addSubview:lineView1];
    [lineView1 release];
    
    UIButton * introdBtn        =[UIButton buttonWithType:UIButtonTypeCustom];
    introdBtn.frame             = CGRectMake(100, 330, 200, 30);
    [introdBtn setTitleColor:[UIColor blueColor] forState:btnNormal];
    [introdBtn setTitle:@"如何获得更多积分>>" forState:UIControlStateNormal];
//    [introdBtn setBackgroundImage:RYCImageNamed(@"userCenter_button_normal.png") forState:btnNormal];
    [introdBtn addTarget:self action:@selector(integralIntrodButton:) forControlEvents:UIControlEventTouchUpInside];
    [exchangeView addSubview:introdBtn];
    
}
#pragma mark ---------- RYCNetManager delegate
- (void)sendRequestIntegralDetailWithPage:(int) pageIndex
{
    /* 积分明细查询 */
    NSMutableDictionary * mDic =[[NSMutableDictionary alloc]init];
    [mDic setObject:@"updateUserInfo" forKey:@"command"];
    [mDic setObject:@"scoreDetail" forKey:@"type"];
    [mDic setObject:@"20" forKey:@"maxresult"];
    [mDic setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"pageindex"];
    [mDic setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeIntegralInfo showProgress:YES];
    [mDic release];
}

- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkRequestTypeIntegralInfo://
        {
            [self integralDetailTableData:dataDic];
        }
            break;
        case ASINetworkRequestTypeTransIntegral://兑换积分
        {
            [self integralDetailConvertDictionary:dataDic];
        }
            break;
        default:
            break;
    }
}
/* 请求 积分 数据 数组化 */
- (void)integralDetailTableData:(NSDictionary *)mDic
{
    NSMutableArray *array =[[NSMutableArray alloc]init];
    NSArray *result = [mDic objectForKey:@"result"];
    for (int i=0; i<result.count; i++) {
        NSDictionary *dic =[result objectAtIndex:i];
        integralDetailCellModel *model =[[integralDetailCellModel alloc]init];
        model.score         = [dic objectForKey:@"score"];
        model.createTime    = KISDictionaryHaveKey(dic, @"createTime");
        model.scoreSource   = KISDictionaryHaveKey(dic, @"scoreSource");
        model.blsign        = KISDictionaryHaveKey(dic, @"blsign");
        [array addObject:model];
        [model release];
    }
    [self.integralDataArray addObjectsFromArray:array] ;
    [array release];
    [intTableView reloadData];
    
    totalPageCount              = [KISDictionaryHaveKey(mDic, @"totalPage") intValue];
    startY                      = intTableView.contentSize.height;
    
    centerY                     = intTableView.contentSize.height - 44*15;
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
/* 积分兑换 */
- (void)integralDetailConvertDictionary:(NSDictionary *)mDic
{
    NSString * errCode = KISDictionaryHaveKey(mDic, @"error_code");
    NSString * message = KISDictionaryHaveKey(mDic, @"message");
    if ([errCode isEqualToString:@"0000"]) {
        int score = [userScore floatValue];
        self.userScore = [NSString stringWithFormat:@"%0.0f",score - [useTextField.text floatValue]];
        numLabel.text = userScore;
        useTextField.text   = @"";
        inteLabel.text      = @"0";
        [self showAlertWithMessage:@"兑换成功"];
        curPageIndex = 0;
        [self sendRequestIntegralDetailWithPage:curPageIndex];
    }else
    {
        [self showAlertWithMessage:message];
    }
}
#pragma mark --------- integral methods
/* 返回消除*/
- (void)integralBackButtonClick:(id)sender
{
    [self.delegate integralDetailViewDisappear:self];
}
/* 积分兑换 */
- (void)integralExchangeButton:(id)sender
{
    [useTextField resignFirstResponder];

    if (KISEmptyOrEnter(useTextField.text)) {
        [self showAlertWithMessage:@"请输入正确积分数！"];
        return ;
    }
    if([useTextField.text doubleValue] > [userScore doubleValue])
    {
        [self showAlertWithMessage:@"积分不足！"];
        return;
    }
    
    for (int i = 0; i < useTextField.text.length; i++)
    {
        UniChar chr = [useTextField.text characterAtIndex:i];
        if ('0' == chr && 0 == i)
        {
            [self showAlertWithMessage:@"积分数格式不规范"];
            return;
        }
        else if (chr < '0' || chr > '9')
        {
            [self showAlertWithMessage:@"积分数须为数字"];
            return;
        }
    }
  
    
    int useCount = [useTextField.text intValue];
    if (useCount%500 !=0 && useCount == 0) {
        [self showAlertWithMessage:@"请输入积分值为500的倍数！"];
        return;
    }
  
    NSMutableDictionary * mDict =[[NSMutableDictionary alloc]init];
    [mDict setObject:@"updateUserInfo" forKey:@"command"];
    [mDict setObject:[UserLoginData sharedManager].userNo forKey:@"userno"];
    [mDict setObject:@"transScore2Money" forKey:@"type"];
    [mDict setObject:useTextField.text forKey:@"score"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkRequestTypeTransIntegral showProgress:YES];
    [mDict release];
}
- (void)integralIntrodButton:(id)sender
{
    IntergralIntroduceViewController *introduce =[[IntergralIntroduceViewController alloc]init];
    introduce.delegate = self;
    introduce.view.frame = CGRectMake(463, 0, 467, 735);
    [self.view addSubview:introduce.view];

    CATransition *transition = [CATransition animation];
    transition.duration = .5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;//{ kCATransitionPush, kCATransitionMoveIn, kCATransitionReveal, kCATransitionFade }
    transition.subtype = kCATransitionFromRight;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
    [introduce.view.layer addAnimation:transition forKey:nil];
}
- (void)intergralIntroduceViewDisappear:(UIViewController *)viewController
{
    [self rootViewControllerDisappear:viewController];
}
#pragma mark ---------------- textField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    int numCount = [textField.text intValue]/500;
    if (numCount !=0) {
        inteLabel.text = [NSString stringWithFormat:@"%d",numCount];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    int numCount = [textField.text intValue]/500;
    if (numCount !=0) {
        inteLabel.text = [NSString stringWithFormat:@"%d",numCount];
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    if([useTextField.text doubleValue] > [userScore doubleValue])
    {
        [self showAlertWithMessage:@"积分不足！"];
        textField.text = @"";
        NO;
    }
    int numCount = [textField.text intValue]/500;
    if (numCount !=0) {
        inteLabel.text = [NSString stringWithFormat:@"%d",numCount];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [useTextField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string//只允许输入数字所以，(限制输入英文和数字的话，就可以把这个定义为：#define kAlphaNum   @”ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789″)。
{
    if (useTextField.text.length >= userScore.length && range.length == 0)
    {
        return  NO;
    }
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    BOOL canChange = [string isEqualToString:filtered];
    
    return canChange;
}


- (void)textFieldChanged:(UITextField*)field
{
    if (field == useTextField) {
        double tempValue = [useTextField.text doubleValue];
        useTextField.text = [NSString stringWithFormat:@"%.lf", tempValue];
        
        inteLabel.text = [NSString stringWithFormat:@"%.lf",tempValue/500];
    }
}
#pragma mark -------- tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.integralDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * dequeCell =@"celled";
    integralDetailViewContollerCell * cell = (integralDetailViewContollerCell*) [tableView dequeueReusableCellWithIdentifier:dequeCell];
    if (cell == nil) {
        cell =[[[integralDetailViewContollerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dequeCell]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = [self.integralDataArray objectAtIndex:indexPath.row];
    [cell integralContentViewCell];
    return cell;
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
        [self sendRequestIntegralDetailWithPage:curPageIndex];
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
