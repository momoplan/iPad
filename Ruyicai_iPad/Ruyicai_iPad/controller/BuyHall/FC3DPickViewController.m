

#import "FC3DPickViewController.h"
#import "SetChaseStageTableView.h"
#import "PickNumberBasketTableCell.h"

#define TagBallGenralSumView200 200
#define TagGroupThSingleView300 300
#define TagGroupThComplexView400 400
#define TagGroupThSumView500 500
#define TagGroupSixSingleView600 600
#define TagGroupSixSumView700 700

@interface FC3DPickViewController ()

@end

@implementation FC3DPickViewController
@synthesize delegate;
@synthesize numberDataArray;
@synthesize batchEndTime;
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
    self.delegate = nil;
    [numberDataArray release],numberDataArray = nil;

    [playSelectView release];
    [selectResult release];
    
    [ballWholeView release];
    [ballGeneralView release];
    [ballGeneralSumView release];
    [ballGroupThSingleView release];
    [ballGroupThComplexView release];
    [ballGroupThSumView release];
    [ballGroupSixSingleView release];
    [ballGroupSixSumView release];
    
    [pickBaesketView release];
    [itemDic release];
    [generalHunArray release];
    [generalDecArray release];
    [generalIndArray release];
    
    [messDetailView release];
    [issueString release];
    
    [super dealloc];

}

#pragma mark ============= controller
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [super tabBarBackgroundImageViewWith:self.view];
    
	// Do any additional setup after loading the view.
    [self FC3DSetTitleView]; //标题
    [self fC3DsetHeaderView]; //顶部
    [self FC3DSetBallView]; //球区
    [self FC3DPickNumSelectResultView];
    
    pickBaesketView =[[PickNumBasketView alloc]initWithFrame:CGRectMake(600, 147, 308, 574)];
    NSArray * itemArray =@[@"投注",@"追号",@"合买",@"赠送",];
    pickBaesketView.delegate = self;
    [pickBaesketView pickNumberBasketViewItem:itemArray];
    [self.view addSubview:pickBaesketView];
    
    [self requestQueryLot];
    [self sendRequestLotteryInfoWithLotNo:kLotNoFC3D];
    [self setMessageDetailView];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    if([m_timer isValid])
	{
		[m_timer invalidate];
		m_timer = nil;
	}
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark =============== view
- (void)FC3DSetTitleView
{
    
    narViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    narViewBtn.frame = CGRectMake(335, 15, 238, 40);
    [narViewBtn setTitle:@"直选-普通 ▼" forState:UIControlStateNormal];
    narViewBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [narViewBtn setBackgroundImage:RYCImageNamed(@"top_qiehuan.png") forState:btnNormal];
    [narViewBtn setTitleColor:[UIColor whiteColor] forState:btnNormal];
    [narViewBtn addTarget:self action:@selector(FC3DnarViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:narViewBtn];

    
    UIButton * playBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame = CGRectMake(self.view.frame.size.height-200, 10, 50, 50);
    [playBtn setImage:RYCImageNamed(@"pickNum_right.png") forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
}
- (void)fC3DsetHeaderView
{
    // 头部视图
    UIView * headView =[[UIView alloc]initWithFrame:CGRectMake(0, 69, 908, 77)];
    headView.backgroundColor = RGBCOLOR(244, 244, 244);
    [self.view addSubview:headView];
    [headView release];
    
    UIImageView * kindImg               = [[UIImageView alloc]initWithFrame:CGRectMake(80, 10, 60, 60)];
    kindImg.image = RYCImageNamed(@"fc3d");
    [headView addSubview:kindImg];
    
    //返回按钮
    UIButton * backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 1, 76, 76);
    [backBtn setImage:RYCImageNamed(@"backBtn-nor.png") forState:btnNormal];
    [backBtn setImage:RYCImageNamed(@"backBtn-click.png") forState:btnSelect];
    [backBtn addTarget:self action:@selector(pickViewBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:backBtn];
#define TagBeIssueLabel996 996
#define TagBePrizeLabel995 995
#define TagBeBlueLabel994 994
    // 上期开奖
    UILabel * beforeIssueLaebl =[[UILabel alloc]initWithFrame:CGRectMake(250, 10, 200, 30)];
    beforeIssueLaebl.backgroundColor = [UIColor clearColor];
    beforeIssueLaebl.tag = TagBeIssueLabel996;
    [headView addSubview:beforeIssueLaebl];
    [beforeIssueLaebl release];
    
    UILabel * bePrizeLabel =[[UILabel alloc]initWithFrame:CGRectMake(beforeIssueLaebl.frame.origin.x+beforeIssueLaebl.frame.size.width+20, beforeIssueLaebl.frame.origin.y, 122, 30)];
    bePrizeLabel.backgroundColor = [UIColor clearColor];
    bePrizeLabel.tag = TagBePrizeLabel995;
    bePrizeLabel.textColor = [UIColor redColor];
    [headView addSubview:bePrizeLabel];
    [bePrizeLabel release];
    
    UILabel * blueLabel = [[UILabel alloc]initWithFrame:CGRectMake(bePrizeLabel.frame.size.width+bePrizeLabel.frame.origin.x, bePrizeLabel.frame.origin.y, 40, bePrizeLabel.frame.size.height)];
    blueLabel.textColor = [UIColor blueColor];
    blueLabel.backgroundColor = [UIColor clearColor];
    blueLabel.tag = TagBeBlueLabel994;
    [headView addSubview:blueLabel];
    [blueLabel release];
    
#define TagIssueLabel998 998
    //这期倒计时
    UILabel * thisIssueLabel =[[UILabel alloc]initWithFrame:CGRectMake(beforeIssueLaebl.frame.origin.x, 40, beforeIssueLaebl.frame.size.width, 30)];
    thisIssueLabel.backgroundColor = [UIColor clearColor];
    thisIssueLabel.tag = TagIssueLabel998;
    [headView addSubview:thisIssueLabel];
    [thisIssueLabel release];
#define TagEndLable997 997
    UILabel * thisEndLabel =[[UILabel alloc]initWithFrame:CGRectMake(thisIssueLabel.frame.origin.x + thisIssueLabel.frame.size.width +20, thisIssueLabel.frame.origin.y, 200, 30)];
    thisEndLabel.backgroundColor = [UIColor clearColor];
    thisEndLabel.tag = TagEndLable997;
    thisEndLabel.textColor = [UIColor redColor];
    [headView addSubview:thisEndLabel];
    [thisEndLabel  release];
}
/* 球区 */
- (void)FC3DSetBallView
{
    ballWholeView =[[UIView alloc]initWithFrame:CGRectMake(0, 145, BallViewWidth, 470)];
    ballWholeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:ballWholeView];
    
    ballGeneralView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
    ballGeneralView.backgroundColor =[UIColor whiteColor];
    [ballWholeView addSubview:ballGeneralView];
    
#define TagBalGeneralView100 100
    playTypeString = @"1";
    
    PickBallView * hundredBallView =[[PickBallView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 150)];
    [hundredBallView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:1 selectMaxNum:10 ballType:Ball_Red];
    [hundredBallView ballVIewTitle:@"百位区"];
    hundredBallView.delegate = self;
    hundredBallView.tag = TagBalGeneralView100 +1;
    [ballGeneralView addSubview:hundredBallView];
    [hundredBallView release];

    PickBallView * decadeView = [[PickBallView alloc]initWithFrame:CGRectMake(0, 150, BallViewWidth, 150)];
    [decadeView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:1 selectMaxNum:10 ballType:Ball_Red];
    [decadeView ballVIewTitle:@"十位区"];
    decadeView.delegate = self;
    decadeView.tag = TagBalGeneralView100 +2;
    [ballGeneralView addSubview:decadeView];
    [decadeView release];

    PickBallView * individualView =[[PickBallView alloc]initWithFrame:CGRectMake(0, 300, BallViewWidth, 150)];
    [individualView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:1 selectMaxNum:10 ballType:Ball_Red];
    [individualView ballVIewTitle:@"个位区"];
    individualView.delegate = self;
    individualView.tag = TagBalGeneralView100 + 3;
    [ballGeneralView addSubview:individualView];
    [individualView release];
    
    
}
/* 选球结果 */
- (void)FC3DPickNumSelectResultView
{
    selectResult =[[PickNumSelectResultView alloc]initWithFrame:CGRectMake(0, 612, BallViewWidth, 107)];
    selectResult.delegate = self;
    [self.view addSubview:selectResult];
}
#define TagMessageDetail150 150
- (void)setMessageDetailView
{
    if (! messDetailView) {
        messDetailView = [[UIView alloc]initWithFrame:CGRectMake(670, 70, 223, 119)];
        messDetailView.backgroundColor =[UIColor clearColor];
        [self.view addSubview:messDetailView];
        
        
        
        UIImageView* imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, messDetailView.frame.size.width, messDetailView.frame.size.height)];
        imgBg.image = RYCImageNamed(@"jcchooselist_2.png");
        [imgBg setBackgroundColor:[UIColor clearColor]];
        [messDetailView addSubview:imgBg];
        [imgBg release];
        
        NSArray * narArray =[[NSArray alloc]initWithObjects:@"玩法介绍",@"历史开奖", nil];
        NSArray * imgAry = @[@"introduce_play.png",@"history_lottery.png"];
        for (int i=0; i<narArray.count; i++) {
            
            UIButton* introButton = [[[UIButton alloc] initWithFrame:CGRectMake(30, 20+(50*i), 150, 42)]  autorelease];
            UIImageView *intro_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 25, 25)];
            intro_icon.image = RYCImageNamed([imgAry objectAtIndex:i]);
            [introButton addSubview:intro_icon];
            [intro_icon release];
            introButton.contentEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
            [introButton setBackgroundImage:RYCImageNamed(@"caidanbutton_bg_click.png") forState:UIControlStateHighlighted];
            [introButton setTitle:[narArray objectAtIndex:i] forState:UIControlStateNormal];
            introButton.tag = TagMessageDetail150 + i;
            [introButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            introButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            [introButton addTarget:self action:@selector(playIntroButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [messDetailView addSubview:introButton];
            
        }
        [narArray release];
    }
    messDetailView.hidden =YES;
}
#pragma mark ============ notification

- (void)requestQueryLot
{
    NSMutableDictionary * mDic =[[[NSMutableDictionary alloc]init]autorelease];
    [mDic setObject:@"QueryLot" forKey:@"command"];
    [mDic setObject:@"highFrequency" forKey:@"type"];
    [mDic setObject:kLotNoFC3D forKey:@"lotno"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeLeftTime showProgress:NO];
}

- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkRequestTypeLeftTime:
        {
            [self FC3DIssueAndTimeDataRequest:dataDic];

        }
            break;
        case ASINetworkRequestTypeGetLotteryInfo:
        {
            [self getBeforeIssueMessageInfo:dataDic];
        }
            break;
        default:
            break;
    }
}
- (void)getBeforeIssueMessageInfo:(NSDictionary *)infoDic
{
    NSArray * resultAry = KISDictionaryHaveKey(infoDic, @"result");
    NSDictionary * dic = [resultAry objectAtIndex:0];
    NSString * oldBatchCode = KISDictionaryHaveKey(dic, @"batchCode");
    UILabel *issuelabel = (UILabel *)[self.view viewWithTag:TagBeIssueLabel996];
    issuelabel.text = [NSString stringWithFormat:@"第%@期开奖号码:", oldBatchCode];
    
    NSString * winCodeStr = KISDictionaryHaveKey(dic, @"winCode");
    NSArray * ballAry = [super lotteryCellBallDoubleNumberString:winCodeStr];
    NSMutableString  * beRedString = [[NSMutableString alloc]init];
    for (int i=0; i<ballAry.count; i++) {
        int number = [[ballAry objectAtIndex:i] intValue];
        [beRedString appendFormat:@"%@,",[NSString stringWithFormat:@"%d",number]];
    }
    UILabel * prizeLabel = (UILabel *)[self.view viewWithTag:TagBePrizeLabel995];
    prizeLabel.text = [beRedString substringToIndex:5];
    [beRedString release];
}
- (void)FC3DIssueAndTimeDataRequest:(NSDictionary *)mDic
{
    if (![KISDictionaryHaveKey(mDic, @"lotNo") isEqualToString:kLotNoFC3D]) {
        issueString = @"";
        return;
    }
    issueString = [[NSString alloc]initWithString:KISDictionaryHaveKey(mDic, @"batchcode")];
    self.batchEndTime = KISDictionaryHaveKey(mDic, @"time_remaining");
    
    UILabel * thisIssLabel = (UILabel *)[self.view viewWithTag:TagIssueLabel998];
    thisIssLabel.text = [NSString stringWithFormat:@"离%@期截止还剩：",issueString];
    
    [pickBaesketView getThisLotNoString:kLotNoFC3D andThisBatchString:issueString];

    
    pickBaesketView.thisBatchCode = issueString;
    pickBaesketView.lotNo = kLotNoFC3D;
    
    UILabel *thisEndLabel = (UILabel *)[self.view viewWithTag:TagEndLable997];
    
    int leftTime = [self.batchEndTime intValue];
	if (leftTime > 0)
	{
        int numHour = (int)(leftTime / 3600.0);
        leftTime -= numHour * 3600.0;
	    int numMinute = (int)(leftTime / 60.0);
		leftTime -= numMinute * 60.0;
		int numSecond = (int)(leftTime);
	    thisEndLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",
                             numHour, numMinute, numSecond];
    }
    if(m_timer != nil)
	{
		[m_timer invalidate];
		m_timer = nil;
	}
	else
	{
		m_timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(DLTRefreshLeftTime)
												 userInfo:nil repeats:YES];
	}
    
}
- (void)DLTRefreshLeftTime
{
    if (0 == self.batchEndTime.length)
    {
        return;
    }
    UILabel *thisEndLabel = (UILabel *)[self.view viewWithTag:TagEndLable997];
	thisEndLabel.text = @"00:00:00";
	int leftTime = [self.batchEndTime intValue];
	if (leftTime > 0)
	{
        int numHour = (int)(leftTime / 3600.0);
        leftTime -= numHour * 3600.0;
	    int numMinute = (int)(leftTime / 60.0);
		leftTime -= numMinute * 60.0;
		int numSecond = (int)(leftTime);
	    thisEndLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",
                             numHour, numMinute, numSecond];
        self.batchEndTime = [NSString stringWithFormat:@"%d",[self.batchEndTime intValue]-1];
    }
	else if(leftTime == 0)//防止过期彩种
	{
		if([m_timer isValid])
		{
			[m_timer invalidate];
			m_timer = nil;
		}
                [self showAlertWithMessage:[NSString stringWithFormat:@"%@期已截止，投注时请确认您的选择期号",issueString]];
        
        NSMutableDictionary *mDict =[[NSMutableDictionary alloc]init];
        [mDict setObject:kLotNoFC3D forKey:@"lotno"];
        [mDict setObject:@"highFrequency" forKey:@"type"];
        [mDict setObject:@"QueryLot" forKey:@"command"];
        
        [RYCNetworkManager sharedManager].netDelegate = self;
        [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkRequestTypeLeftTime showProgress:NO];//获取期号
        [mDict release];
	}
	else //时间为负时，停止调用
	{
		if([m_timer isValid])
		{
			[m_timer invalidate];
			m_timer = nil;
		}
	}
}

#pragma mark ============== methods
/* 玩法切换 */
- (void)FC3DnarViewButtonAction:(id)sender
{
    if (! playSelectView ) {
        NSArray * kindAry = @[@[@"普通",@"和值"],@[@"单式",@"复式",@"和值"],@[@"普通",@"和值"]];
        NSArray * titltArray = @[@"直选",@"组三",@"组六"];
        
        playSelectView =[[PickNumPlayKindSelectView alloc]initWithFrame:CGRectMake(220, 60, 450, 234) titleArray:titltArray kindArray:kindAry];
        playSelectView.delegate = self;
        [self.view addSubview:playSelectView];
        playSelectView.hidden= YES;
    }
    playSelectView.hidden = !playSelectView.hidden ;
//    CATransition *transition = [CATransition animation];
//    transition.duration = .5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;//{ kCATransitionPush, kCATransitionMoveIn, kCATransitionReveal, kCATransitionFade }
//    if(playSelectView.hidden)
//    {
//        transition.subtype = kCATransitionFromBottom;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
//        [playSelectView.layer addAnimation:transition forKey:nil];
//        playSelectView.hidden = NO;
//    }
//    else
//    {
//        transition.subtype = kCATransitionFromTop;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
//        [playSelectView.layer addAnimation:transition forKey:nil];
//        playSelectView.hidden = YES;
//    }

    
}
/* 玩法介绍 */
- (void)playButtonAction:(id)sender
{
//    CATransition *transition = [CATransition animation];
//    transition.duration = .5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;//{ kCATransitionPush, kCATransitionMoveIn, kCATransitionReveal, kCATransitionFade }
//    if(messDetailView.hidden)
//    {
//        transition.subtype = kCATransitionFromBottom;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
//        [messDetailView.layer addAnimation:transition forKey:nil];
//        messDetailView.hidden = NO;
//    }
//    else
//    {
//        transition.subtype = kCATransitionFromTop;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
//        [messDetailView.layer addAnimation:transition forKey:nil];
        messDetailView.hidden = !messDetailView.hidden;
//    }
    
}
- (void)playIntroButtonClick:(id)sender
{
    UIView * messageView =nil;
    messDetailView.hidden = YES;

    UIButton * button = (UIButton *)sender;
    switch (button.tag -TagMessageDetail150) {
        case 0:
        {
            PlayIntroduceViewController *introduce =[[PlayIntroduceViewController alloc]init];
            introduce.introduceLotNo = kLotNoFC3D;
            introduce.delegate = self;
            introduce.view.frame = CGRectMake(463, 0, 467, 735);
            [self.view addSubview:introduce.view];
            messageView = introduce.view;
        }
            break;
        case 1:
        {
            BuyLotteryNumberViewController * buyLottery =[[BuyLotteryNumberViewController alloc]init];
            buyLottery.numLotNo = kLotNoFC3D;
            buyLottery.delegate = self;
            buyLottery.view.frame = CGRectMake(463, 0, 467, 735);
            [self.view addSubview:buyLottery.view];
            messageView = buyLottery.view;
        }
            break;
        default:
            break;
    }
    
    CATransition *transition = [CATransition animation];
    transition.duration = .5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;//{ kCATransitionPush, kCATransitionMoveIn, kCATransitionReveal, kCATransitionFade }
    transition.subtype = kCATransitionFromRight;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
    [messageView.layer addAnimation:transition forKey:nil];
}
#pragma mark ----------- pickNumDelegate
- (BOOL)isPickNumCanBuy
{
    if (![self isSuccessLogin]) {
        LoginViewController *login =[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        login.delegate = self;
        login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:login animated:YES completion:^{
            
        }];
        [login release];
        return NO;
    }else
    {
        return YES;
    }
}
#pragma mark =================== resultSelect
- (void)pickResultLabelRefresh:(int)count
{
    [selectResult resultLabelRefreshCount:count];
}
- (void)pickSelectResultRefreshAction:(id)sender
{
    int typeIndex = [playTypeString intValue];
    switch (typeIndex) {
        case 1:
        {
            PickBallView * hundView = (PickBallView *)[self.view viewWithTag:TagBalGeneralView100+1];
            [hundView clearBallState];
            PickBallView *decView = (PickBallView *)[self.view viewWithTag:TagBalGeneralView100+2];
            [decView clearBallState];
            PickBallView *indView = (PickBallView *) [self.view viewWithTag:TagBalGeneralView100+3];
            [indView clearBallState];
        }
            break;
        case 2:
        {
            PickBallView * hundView = (PickBallView *)[self.view viewWithTag:TagBallGenralSumView200+1];
            [hundView clearBallState];
            
        }
            break;
        case 3:
        {
            PickBallView * hundView = (PickBallView *)[self.view viewWithTag:TagGroupThSingleView300+1];
            [hundView clearBallState];
            PickBallView *decView = (PickBallView *)[self.view viewWithTag:TagGroupThSingleView300+2];
            [decView clearBallState];
            
        }
            break;
        case 4: // 组三 复式
        {
            PickBallView * hundView = (PickBallView *)[self.view viewWithTag:TagGroupThComplexView400+1];
            [hundView clearBallState];
            
        }
            break;
        case 5: // 组三和值
        {
            PickBallView * hundView = (PickBallView *)[self.view viewWithTag:TagGroupThSumView500+1];
            [hundView clearBallState];
            
        }
            break;
        case 6: // 组六 普通
        {
            PickBallView * hundView = (PickBallView *)[self.view viewWithTag:TagGroupSixSingleView600+1];
            [hundView clearBallState];
        }
            break;
        case 7: // 组六 和值
        {
            PickBallView * hundView = (PickBallView *)[self.view viewWithTag:TagGroupSixSumView700+1];
            [hundView clearBallState];
        }
            break;
        default:
            break;
    }
    itemDic = nil;
    [self pickResultLabelRefresh:0];
}
- (void)pickselectResultAddToBaskAction:(id)sender
{
    if (itemDic ==nil) {
        [self showAlertWithMessage:@"请至少选择一注进行添加!"];
        return;
    }
    if ([[itemDic objectForKey:@"count"] intValue]==0) {
        [self showAlertWithMessage:@"请至少选择一注进行添加!"];
        return;
    }
    [pickBaesketView pickTableViewArrayAddItem:itemDic];
    [self pickSelectResultRefreshAction:sender];
    itemDic = nil;
}
#pragma mark ------------ playIntroduce
- (void)playIntroduceViewDisappear:(PlayIntroduceViewController *)viewController
{
    [self viewContollerDisappear:viewController];
}
- (void)buyLotteryNumberViewDisappear:(UIViewController *)viewController
{
    [self viewContollerDisappear:viewController];
}

- (void)viewContollerDisappear:(UIViewController *)viewController
{
    [UIView animateWithDuration:1.0 animations:^(void){
        CGPoint point = viewController.view.center;
        point.x += 1000;
        viewController.view.center = point;
    }completion:^(BOOL isFinish){
        if (isFinish) {
            [viewController.view removeFromSuperview];
            [viewController release];
        }
    }];
    
}
/* 返回上级页面*/
- (void)pickViewBackButtonAction:(id)sender
{
    [self.delegate FC3DPickViewDisappear:self];
}

/* 彩球选出 数字 */
- (NSArray *)convertArrayWithStateArray:(NSArray *)stateArray
{
    NSMutableArray *newArray =[[NSMutableArray alloc]init];
    for (int i=0; i<stateArray.count; i++) {
        if ([[stateArray objectAtIndex:i]isEqualToString:@"1"]) {
            [newArray addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    return [newArray autorelease];
}
#pragma mark =================== playselect delegate
- (void)pickPlayKindSelectLine:(int)line row:(int)row title:(NSString *)title
{
    [narViewBtn setTitle:[NSString stringWithFormat:@"%@  ▼",title] forState:btnNormal];
    playSelectView.hidden = YES;
    for (UIView * selectView in ballWholeView.subviews) {
        for (UIView *view in selectView.subviews) {
            if ([view isKindOfClass:[PickBallView class]]) {
                PickBallView *pickView = (PickBallView*)view;
                [pickView clearBallState];
            }
        }
        [selectView removeFromSuperview];
    }
    switch (line) {
        case 0: // 自选
        {
            switch (row) {
                case 0: //普通
                {
                    [ballWholeView addSubview:ballGeneralView];
                    playTypeString =@"1";
                }
                    
                    break;
                case 1: // 和值
                {
                    if (! ballGeneralSumView) {
                        ballGeneralSumView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                       
                        PickBallView * sumballView =[[PickBallView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 200)];
                        [sumballView ballViewCreateStartValue:0 ballCount:28 perLine:12 leastNum:1 selectMaxNum:1 ballType:Ball_Red];
                        [sumballView ballSumViewTitle:@"选择和值:"];
                        sumballView.delegate = self;
                        sumballView.tag = TagBallGenralSumView200 +1;
                        [ballGeneralSumView addSubview:sumballView];
                        [sumballView release];
                        
                    }
                     [ballWholeView addSubview:ballGeneralSumView];
                    playTypeString = @"2";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: // 组三
        {
            switch (row) {
                case 0: // 单式
                {
                    if (! ballGroupThSingleView) {
                        ballGroupThSingleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        PickBallView *singleView =[[PickBallView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 150)];
                        [singleView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:1 selectMaxNum:1 ballType:Ball_Red];
                        [singleView ballSumViewTitle:@"出现两次号码:"];
                        singleView.delegate = self;
                        singleView.tag = TagGroupThSingleView300 + 1;
                        [ballGroupThSingleView addSubview:singleView];
                        [singleView release];
                        
                        PickBallView  *onceView =[[PickBallView alloc]initWithFrame:CGRectMake(0, 150, BallViewWidth, 150)];
                        [onceView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:1 selectMaxNum:1 ballType:Ball_Red];
                        [onceView ballSumViewTitle:@"出现一次号码:"];
                        onceView.tag = TagGroupThSingleView300 + 2;
                        onceView.delegate = self;
                        [ballGroupThSingleView addSubview:onceView];
                        [onceView release];

                    }
                    [ballWholeView addSubview:ballGroupThSingleView];
                    playTypeString = @"3";
                }
                    break;
                case 1: // 复式
                {
                    if (! ballGroupThComplexView) {
                        ballGroupThComplexView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        
                        PickBallView *singleView =[[PickBallView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 150)];
                        [singleView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:2 selectMaxNum:10 ballType:Ball_Red];
                        [singleView ballVIewTitle:@"选择号码"];
                        singleView.delegate = self;
                        singleView.tag = TagGroupThComplexView400 + 1;
                        [ballGroupThComplexView addSubview:singleView];
                        [singleView release];
                        
                    }
                    [ballWholeView addSubview:ballGroupThComplexView];
                    playTypeString = @"4";
                }
                    break;
                case 2: // 和值
                {
                    if (! ballGroupThSumView) {
                        ballGroupThSumView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        PickBallView *singleView =[[PickBallView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 200)];
                        [singleView ballViewCreateStartValue:1 ballCount:26 perLine:12 leastNum:1 selectMaxNum:1 ballType:Ball_Red];
                        [singleView ballSumViewTitle:@"选择和值:"];
                        singleView.delegate = self;
                        singleView.tag = TagGroupThSumView500 + 1;
                        [ballGroupThSumView addSubview:singleView];
                        [singleView release];
 
                    }
                    [ballWholeView addSubview:ballGroupThSumView];
                    playTypeString = @"5";
                }
                    break;
                default:
                    break;
            }
        }
            break;

        case 2: // 组六
        {
            switch (row) {
                case 0: // 普通
                {
                    if (! ballGroupSixSingleView) {
                        ballGroupSixSingleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        PickBallView *singleView =[[PickBallView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 150)];
                        [singleView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:3 selectMaxNum:9 ballType:Ball_Red];
                        [singleView ballVIewTitle:@"选择号码"];
                        singleView.delegate = self;
                        singleView.tag = TagGroupSixSingleView600 + 1;
                        [ballGroupSixSingleView addSubview:singleView];
                        [singleView release];

                    }
                    [ballWholeView addSubview:ballGroupSixSingleView];
                    playTypeString = @"6";
                }
                    break;
                case 1: // 和值
                {
                    if (! ballGroupSixSumView) {
                        ballGroupSixSumView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        PickBallView *singleView =[[PickBallView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 200)];
                        [singleView ballViewCreateStartValue:3 ballCount:22 perLine:12 leastNum:1 selectMaxNum:1 ballType:Ball_Red];
                        [singleView ballSumViewTitle:@"选择和值:"];
                        singleView.delegate = self;
                        singleView.tag = TagGroupSixSumView700 + 1;
                        [ballGroupSixSumView addSubview:singleView];
                        [singleView release];
                        
                    }
                    [ballWholeView addSubview:ballGroupSixSumView];
                    playTypeString = @"7";

                }
                    break;
                default:
                    break;
            }
        }
        default:
            break;
    }
    [self pickResultLabelRefresh:0];
    DLog(@" line%d  row%d",line,row)
}
#pragma mark ============== ballView delegate
- (void)ballViewResultArray:(NSMutableArray *)array selectView:(PickBallView *)ballView
{
    int viewIndex = ballView.tag /100;
    int areaIndex = ballView.tag - viewIndex*100;
    itemDic = nil;
    switch (viewIndex) {
        case 1: // 直选
        {
            switch (areaIndex) {
                case 1: // 百位区
                {
                    generalHunArray = [array retain];
                    
                }
                    break;
                case 2:  // 十位区
                {
                    generalDecArray =[array retain];
                    
                }
                    break;
                case 3: // 个位区
                {
                    generalIndArray = [array retain];
                }
                    break;
                default:
                    break;
            }
            [self FC3DGGeneralViewSelect];
        }
            break;
        case 2: // 自选和值
        {
            if (areaIndex == 1) {
                generalHunArray = [array retain];
                [self FC3DGeneralSumViewSelectBall];
            }
            
        }
            break;
        case 3: // 组三 单式
        {
            if (areaIndex == 1) {
                generalHunArray = [array retain];
            
                if ([generalHunArray isEqualToArray:generalDecArray]) {
                    NSArray * numAry=[self convertArrayWithStateArray:generalDecArray];
                    PickBallView *hunPickView = (PickBallView *)[self.view viewWithTag:TagGroupThSingleView300+2];
                    [hunPickView differentBallGroupNumberArray:numAry];
                }
            }else
            {
              
                generalDecArray = [array retain];
                if ([generalHunArray isEqualToArray:generalDecArray]) {
                    NSArray * numAry=[self convertArrayWithStateArray:generalHunArray];
                      PickBallView *decPickView = (PickBallView *)[self.view viewWithTag:TagGroupThSingleView300+1];
                    [decPickView differentBallGroupNumberArray:numAry];
                }
            }
            [self FC3DGroupThSingleViewSelectBall];
        }
            break;
        case 4: // 组三 复式
        {
            if (areaIndex ==1) {
                generalDecArray = [array retain];
                [self FC3DGroupThComplexViewSelectBall];
            }
            
        }
            break;
        case 5: // 组三 和值
        {
          
            generalHunArray = [array retain];
            [self FC3DGroupThSumViewSelectResult];
        }
            break;
        case 6: //组六 
        {
            if (areaIndex == 1) { //普通
                generalHunArray = [array retain];
                
                [self FC3DGroupSixSingleViewSelectResult];
            }
           
        }
            break;
        case 7: // 组六 和值
        {
            if (areaIndex == 1) {
                generalDecArray  = [array retain];
                
                [self FC3DGroupSixSumViewSelectResult];
            }
        }
            break;
        default:
            break;
    }
    
}
/* 普通自选 */
- (void)FC3DGGeneralViewSelect
{
    int noteCount = 0;
    NSString * redString = nil;
    NSString * codeString = @"";
    NSArray *hundAry = nil;
    NSArray *decAry = nil;
    NSArray *indAry = nil;
    
    hundAry = [self convertArrayWithStateArray:generalHunArray];
    decAry =[self convertArrayWithStateArray:generalDecArray];
    indAry =[self convertArrayWithStateArray:generalIndArray];
    if (hundAry.count ==0 || decAry.count ==0 || indAry.count ==0) {
        [self pickResultLabelRefresh:0];
        return;
    }

    noteCount = (hundAry.count)*(decAry.count)*(indAry.count);
    [self pickResultLabelRefresh:noteCount];
    if (noteCount == 0) {
        return;
    }
    redString =[NSString stringWithFormat:@"%@|%@|%@",[hundAry componentsJoinedByString:@""],[decAry componentsJoinedByString:@""],[indAry componentsJoinedByString:@""]];
    codeString =[codeString stringByAppendingString:@"2001"];
    NSArray * codeHundAry =[self convertArrayWithStateArray:generalHunArray];
    NSArray * codeDecAry = [self convertArrayWithStateArray:generalDecArray];
    NSArray * codeIndAry = [self convertArrayWithStateArray:generalIndArray];
    codeString = [codeString stringByAppendingFormat:@"%02d%@^",codeHundAry.count,[codeHundAry componentsJoinedByString:@""]];
    codeString = [codeString stringByAppendingFormat:@"%02d%@^",codeDecAry.count,[codeDecAry componentsJoinedByString:@""]];
    codeString = [codeString stringByAppendingFormat:@"%02d%@^",codeIndAry.count,[codeIndAry componentsJoinedByString:@""]];
    if (redString == nil || noteCount == 0 ||codeString ==nil) {
        return;
    }
    
    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
              redString,@"red",
              [NSNumber numberWithInt: noteCount],@"count",
              codeString,@"codeString",
              nil];
    
}
/* 自选和值 */
- (void)FC3DGeneralSumViewSelectBall
{
    NSArray * numAry =[self convertArrayWithStateArray:generalHunArray];
    if (numAry.count == 0) {
        [self pickResultLabelRefresh:0];
        return;
    }
    int selectNum = [[numAry objectAtIndex:0]intValue];
    NSArray * zhuAry =@[@"1",@"3",@"6",@"10",@"15",@"21",@"28",@"36",@"45",@"55",@"63",@"69",@"73",@"75",@"75",@"73",@"69",@"63",@"55",@"45",@"36",@"28",@"21",@"15",@"10",@"6",@"3",@"1"];
    int noteCount = [[zhuAry objectAtIndex:selectNum]intValue];
    [self pickResultLabelRefresh:noteCount];
    if (noteCount == 0) {
        return;
    }
    NSString *redString =[numAry componentsJoinedByString:@""];
    NSString *codeString = @""; //bet_code":"100105^_10_200_4200"
    codeString = [codeString stringByAppendingString:@"1001"];
    codeString =[codeString stringByAppendingFormat:@"%02d^",selectNum];
    
    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
              redString,@"red",
              [NSNumber numberWithInt: noteCount],@"count",
              codeString,@"codeString",
              nil];
}
/* 组三 单式 */
- (void)FC3DGroupThSingleViewSelectBall
{
    NSArray *hunAry =[self convertArrayWithStateArray:generalHunArray];
    NSArray *decAry = [self convertArrayWithStateArray:generalDecArray];
    if (hunAry.count ==0 || decAry.count ==0) {
        [self pickResultLabelRefresh:0];
        return;
    }
    int hunValue =[[hunAry objectAtIndex:0]intValue];
    int oneValue =[[decAry objectAtIndex:0]intValue];
    int noteCount = 1;

    [self pickResultLabelRefresh:noteCount];
    
    NSString *redString = @"";
    redString = [redString stringByAppendingFormat:@"%d,%d,%d",hunValue,hunValue,oneValue];
    NSString *codeString = @"";
    codeString = [codeString stringByAppendingString:@"0101"];
    if (hunValue<oneValue) {
        codeString = [codeString stringByAppendingFormat:@"%02d%02d%02d^", hunValue, hunValue, oneValue];
    }
    else
    {
        codeString = [codeString stringByAppendingFormat:@"%02d%02d%02d^", oneValue, oneValue, hunValue];
    }
    
    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
              redString,@"red",
              [NSNumber numberWithInt: noteCount],@"count",
              codeString,@"codeString",
              nil];
    //"bet_code":"0101020203^_10_200_200"
}
/* 组三 复试 */ //bet_code":"3101020405^_1_200_400" bet_code":"310103010203^_1_200_1200"
- (void)FC3DGroupThComplexViewSelectBall
{
    NSArray * redAry =[self convertArrayWithStateArray:generalDecArray];
    DLog(@" %@ redAry",redAry);

    if (redAry.count ==0) {
        [self pickResultLabelRefresh:0];
        return;
    }
    NSString * redString =[redAry componentsJoinedByString:@","];
    
    NSArray * codeAry = [self convertArrayWithStateArray:generalDecArray];
    NSString * codeString = @"";
    codeString = [codeString stringByAppendingString:@"3101"];
    codeString = [codeString stringByAppendingFormat:@"%02d%@^",codeAry.count,[codeAry componentsJoinedByString:@""]];
    
    int noteCount = 0;
    noteCount = redAry.count * (redAry.count-1);
    [self pickResultLabelRefresh:noteCount];
    if (noteCount == 0) {
        return;
    }

    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
              redString,@"red",
              [NSNumber numberWithInt: noteCount],@"count",
              codeString,@"codeString",
              nil];
        
}
/* 组三 和值  */ // "bet_code":"110104^_1_200_600"
- (void)FC3DGroupThSumViewSelectResult
{
    NSArray * nunAry =[self convertArrayWithStateArray:generalHunArray];
    if (nunAry.count==0) {
        [self pickResultLabelRefresh:0];
        return;
    }
    
    int numValue =[[nunAry objectAtIndex:0] intValue];
    NSArray *codeAry = @[@"1",@"2",@"1",@"3",@"3",@"3",@"4",@"5",@"4",@"5",@"5",@"4",@"5",@"5",@"4",@"5",@"5",@"4",@"5",@"4",@"3",@"3",@"3",@"1",@"2",@"1"];
   
    int noteCount = [[codeAry objectAtIndex:numValue] intValue];
    [self pickResultLabelRefresh:noteCount];
    if (noteCount == 0) {
        return;
    }
    NSString * redString =[NSString stringWithFormat:@"%d",numValue+1];
    NSString * codeString =@"";
    codeString = [codeString stringByAppendingString:@"1101"];
    codeString =[codeString stringByAppendingFormat:@"%02d^",numValue+1];
    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
              redString,@"red",
              [NSNumber numberWithInt: noteCount],@"count",
              codeString,@"codeString",
              nil];
}
/* 组六 普通*/  //bet_code":"32010401020304^_1_200_800
- (void)FC3DGroupSixSingleViewSelectResult
{
    NSArray * redAry =[self convertArrayWithStateArray:generalHunArray];
    if (redAry.count <3) {
        [self pickResultLabelRefresh:0];
        return;
    }
    NSString *redString =[redAry componentsJoinedByString:@","];
    NSArray *codeAry =[self convertArrayWithStateArray:generalHunArray];
    NSArray * countAry =@[@"1",@"4",@"10",@"20",@"35",@"56",@"84",@"120"];
    int noteCount = 0;
    if (codeAry.count>=3) {
        noteCount = [[countAry objectAtIndex:codeAry.count-3]intValue];
    }
    [self pickResultLabelRefresh:noteCount];
    if (noteCount == 0) {
        return;
    }
    NSString *codeString = @"";
    if (redAry.count>3) {
        codeString = [codeString stringByAppendingString:@"3201"];
        codeString = [codeString stringByAppendingFormat:@"%02d",redAry.count];
    }else
    {
        codeString = [codeString stringByAppendingString:@"0201"];
        
    }
    for (int i=0; i<redAry.count; i++) {
        int value =[[redAry objectAtIndex:i]intValue];
        codeString = [codeString stringByAppendingFormat:@"%02d",value];
    }
    codeString = [codeString stringByAppendingString:@"^"];

    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
              redString,@"red",
              [NSNumber numberWithInt: noteCount],@"count",
              codeString,@"codeString",
              nil];
}
/* 组六 和值*/ // bet_code":"120107^_1_200_800
- (void)FC3DGroupSixSumViewSelectResult
{
    NSArray * redAry =[self convertArrayWithStateArray:generalDecArray];
    if (redAry.count ==0) {
        [self pickResultLabelRefresh:0];
        return;
    }
    int numValue =[[redAry objectAtIndex:0] intValue];
    
    NSArray * countAry = @[@"1",@"1",@"2",@"3",@"4",@"5",@"7",@"8",@"9",@"10",@"10",@"10",@"10",@"9",@"8",@"7",@"5",@"4",@"3",@"2",@"1",@"1"];
    int noteCount = [[countAry objectAtIndex:numValue] intValue];
    [self pickResultLabelRefresh:noteCount];
    if (noteCount == 0) {
        return;
    }
    NSString *redString =[NSString stringWithFormat:@"%d",numValue+3];
    NSString *codeString = [NSString stringWithFormat:@"1201%02d^",numValue+3];
    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
          redString,@"red",
          [NSNumber numberWithInt: noteCount],@"count",
          codeString,@"codeString",
          nil];
}
@end
