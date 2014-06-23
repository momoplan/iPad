//
//  SSCPickNumViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-22.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "SSCPickNumViewController.h"

#define TagTwoSelfSelectView150 150
#define TagTwoGroupSelectView200 200
#define TagTwoSumSelectView250 250

#define TagThreeSelfSelectView300 300
#define TagThreeGroupThView350 350
#define TagThreeGroupSixView400 400

#define TagFiveSelfSelectView450 450
#define TagFiveGeneralSelectView500 500
@interface SSCPickNumViewController ()

@end

@implementation SSCPickNumViewController
@synthesize delegate;
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
    [batchEndTime release],batchEndTime = nil;
    
    [playSelectView release];
    [basketView release];
    [selectResultView release];
    [messDetailView release];

    [ballView release];
    [oneStarBallView release];
    [twoSelfSelectView release];
    [twoGroupSelectView release];
    [twoSumSelectView release];
    [threeSelfSelectView release];
    [threeGroupThView release];
    [threeGroupSixView release];
    [fiveSelfSelectView release];
    [fiveGeneralSelectView release];
    [bigSmallSelectView release];

    [millViewArray release];
    [thouViewArray release];
    [hundViewArray release];
    [decaViewArray release];
    [indiViewArray release];
    
    [itemDic release];
    [issueString release];
    [super dealloc];

}
#pragma mark =============== controller
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super tabBarBackgroundImageViewWith:self.view];
   
    
    [self SSCSetTitleView];
    [self SSCsetHeaderView];
    [self SSCSetBallView];
    
    selectResultView =[[PickNumSelectResultView alloc]initWithFrame:CGRectMake(0, 612, BallViewWidth, 107)];
    selectResultView.delegate = self;
    [self.view addSubview:selectResultView];
    
    basketView = [[PickNumBasketView alloc]initWithFrame:CGRectMake(600, 147, 309, 574)];
    basketView.delegate = self;
    [basketView pickNumberBasketViewItem:@[@"投注",@"追号"]];
    [self.view addSubview:basketView];
    
    [self requestQueryLot];
    [self sendRequestLotteryInfoWithLotNo:kLotNoSSC];
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

#pragma mark =============== view
- (void)SSCSetTitleView
{
    narViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    narViewBtn.frame = CGRectMake(335, 15, 238, 40);
    [narViewBtn setTitle:@"1星-普通 ▼" forState:UIControlStateNormal];
    narViewBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [narViewBtn setBackgroundImage:RYCImageNamed(@"top_qiehuan.png") forState:btnNormal];
    [narViewBtn setTitleColor:[UIColor whiteColor] forState:btnNormal];
    [narViewBtn addTarget:self action:@selector(SSCnarViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:narViewBtn];
    
    
    
    UIButton * playBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame = CGRectMake(self.view.frame.size.height-200, 10, 50, 50);
    [playBtn setImage:RYCImageNamed(@"pickNum_right.png") forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
}
- (void)SSCsetHeaderView
{
    // 头部视图
    UIView * headView =[[UIView alloc]initWithFrame:CGRectMake(0, 68, 908, 77)];
    headView.backgroundColor = RGBCOLOR(244, 244, 244);
    [self.view addSubview:headView];
    [headView release];
    
    UIImageView * kindImg               = [[UIImageView alloc]initWithFrame:CGRectMake(80, 10, 60, 60)];
    kindImg.image = RYCImageNamed(@"ssc");
    [headView addSubview:kindImg];
    
    //返回按钮
    UIButton * backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 1, 75, 76);
    [backBtn setImage:RYCImageNamed(@"viewback") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(pickViewBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:backBtn];
#define TagBeIssueLabel997 997
#define TagBePrizeLebel996 996
    // 上期开奖
    UILabel * beforeIssueLaebl =[[UILabel alloc]initWithFrame:CGRectMake(250, 10, 250, 30)];
    beforeIssueLaebl.backgroundColor = [UIColor clearColor];
    beforeIssueLaebl.tag = TagBeIssueLabel997;
    [headView addSubview:beforeIssueLaebl];
    [beforeIssueLaebl release];
    
    UILabel * bePrizeLabel =[[UILabel alloc]initWithFrame:CGRectMake(beforeIssueLaebl.frame.origin.x+beforeIssueLaebl.frame.size.width+20, beforeIssueLaebl.frame.origin.y, 150, 30)];
    bePrizeLabel.backgroundColor = [UIColor clearColor];
    bePrizeLabel.tag = TagBePrizeLebel996;
    bePrizeLabel.textColor = [UIColor redColor];
    [headView addSubview:bePrizeLabel];
    [bePrizeLabel release];
    
#define TagThisIssueLabel999 999
    //这期倒计时
    UILabel * thisIssueLabel =[[UILabel alloc]initWithFrame:CGRectMake(beforeIssueLaebl.frame.origin.x, 40, beforeIssueLaebl.frame.size.width, 30)];
    thisIssueLabel.backgroundColor = [UIColor clearColor];
    thisIssueLabel.tag = TagThisIssueLabel999;
    [headView addSubview:thisIssueLabel];
    [thisIssueLabel release];
#define TagThisEndLabel998 998
    UILabel * thisEndLabel =[[UILabel alloc]initWithFrame:CGRectMake(thisIssueLabel.frame.origin.x + thisIssueLabel.frame.size.width +20, thisIssueLabel.frame.origin.y, 200, 30)];
    thisEndLabel.backgroundColor = [UIColor clearColor];
    thisEndLabel.tag = TagThisEndLabel998;
    thisEndLabel.textColor = [UIColor redColor];
    [headView addSubview:thisEndLabel];
    [thisEndLabel  release];
}
/* 球区*/
- (void)SSCSetBallView
{
    ballView = [[UIView alloc]initWithFrame:CGRectMake(0, 145, BallViewWidth, 473)];
    ballView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:ballView];
#define TagOneStarBall100 100
    playTypeString = @"1";
    if (!oneStarBallView) {
        oneStarBallView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
        [ballView addSubview:oneStarBallView];
        UILabel * messLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 530, 50)];
        messLabel.numberOfLines = 0;
        messLabel.textColor = [UIColor redColor];
        messLabel.text = @"至少选择1个号码投注，命中开奖号码的个位即中奖！\n 奖金:10元";
        [oneStarBallView addSubview:messLabel];
        [messLabel release];
        
        PickBallView *pickView =[[PickBallView alloc]initWithFrame:CGRectMake(0, 60, BallViewWidth, 150)];
        [pickView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:1 selectMaxNum:10 ballType:Ball_Red];
        [pickView ballVIewTitle:@"个位区"];
        pickView.delegate = self;
        pickView.tag = TagOneStarBall100 +1;
        [oneStarBallView addSubview:pickView];
        [pickView release];
 
    }
       
}
#define TagMessageDetail160 160
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
            introButton.tag = TagMessageDetail160 + i;
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
    [mDic setObject:kLotNoSSC forKey:@"lotno"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeLeftTime showProgress:NO];
}

- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkRequestTypeLeftTime:
        {
            [self SSCIssueAndTimeDataRequest:dataDic];
            
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
    UILabel *issuelabel = (UILabel *)[self.view viewWithTag:TagBeIssueLabel997];
    issuelabel.text = [NSString stringWithFormat:@"第%@期开奖号码:", oldBatchCode];
    
    NSString * winCodeStr = KISDictionaryHaveKey(dic, @"winCode");
    
    
    
    NSArray * ballAry = [super lotteryCellBallSingleNumberString:winCodeStr];
    NSMutableString  * beRedString = [[NSMutableString alloc]init];
    for (int i=0; i<ballAry.count; i++) {
        [beRedString appendFormat:@"%@,",[ballAry objectAtIndex:i]];
    }
    UILabel * prizeLabel = (UILabel *)[self.view viewWithTag:TagBePrizeLebel996];
    prizeLabel.text = [beRedString substringToIndex:9];
    [beRedString release];
}
- (void)SSCIssueAndTimeDataRequest:(NSDictionary *)mDic
{
    DLog(@"FC3DIssueAndTim %@",mDic)
    if (![KISDictionaryHaveKey(mDic, @"lotNo") isEqualToString:kLotNoSSC]) {
        issueString = @"";
        return;
    }
    issueString = [[NSString alloc]initWithString:KISDictionaryHaveKey(mDic, @"batchcode")];
    self.batchEndTime = KISDictionaryHaveKey(mDic, @"time_remaining");
    
    UILabel * thisIssLabel = (UILabel *)[self.view viewWithTag:TagThisIssueLabel999];
    thisIssLabel.text = [NSString stringWithFormat:@"离%@期截止还剩：",issueString];
    
    [basketView getThisLotNoString:kLotNoSSC andThisBatchString:issueString];

    
    basketView.thisBatchCode = issueString;
    basketView.lotNo = kLotNoSSC;
    
    UILabel *thisEndLabel = (UILabel *)[self.view viewWithTag:TagThisEndLabel998];
    
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
		m_timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(SSCRefreshLeftTime)
												 userInfo:nil repeats:YES];
	}
    
}
- (void)SSCRefreshLeftTime
{
    if (0 == self.batchEndTime.length)
    {
        return;
    }
    UILabel *thisEndLabel = (UILabel *)[self.view viewWithTag:TagThisEndLabel998];
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
        //
        NSMutableDictionary *mDict =[[NSMutableDictionary alloc]init];
        [mDict setObject:kLotNoSSC forKey:@"lotno"];
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
#pragma mark =============== selectResult delegate

- (void)pickResultLabelRefresh:(int)count
{
    [selectResultView resultLabelRefreshCount:count];
}
- (void)pickSelectResultRefreshAction:(id)sender
{
    int typeIndex =[playTypeString intValue];
    switch (typeIndex) {
        case 1: // 一星 普通
        {
            PickBallView * indPickView =(PickBallView *)[self.view viewWithTag:TagOneStarBall100+1];
            [indPickView clearBallState];
        }
            break;
        case 2: // 二星 自选
        {
            PickBallView * decPickView = (PickBallView *)[self.view viewWithTag:TagTwoSelfSelectView150+1];
            [decPickView clearBallState];
            PickBallView * indPickView = (PickBallView *)[self.view viewWithTag:TagTwoSelfSelectView150+2];
            [indPickView clearBallState];
            
        }
            break;
        case 3: // 二星 组选
        {
            PickBallView *pickView =(PickBallView *)[self.view viewWithTag:TagTwoGroupSelectView200+1];
            [pickView clearBallState];
        }
            break;
        case 4: // 二星 和值
        {
            PickBallView * numPickView = (PickBallView *)[self.view viewWithTag:TagTwoSumSelectView250+1];
            [numPickView clearBallState];
        }
            break;
        case 5: //  三星 自选
        {
            PickBallView *hunPickView = (PickBallView *)[self.view viewWithTag:TagThreeSelfSelectView300+1];
            [hunPickView clearBallState];
            PickBallView *decPickView = (PickBallView *)[self.view viewWithTag:TagThreeSelfSelectView300+2];
            [decPickView clearBallState];
            PickBallView *indPickView = (PickBallView *)[self.view viewWithTag:TagThreeSelfSelectView300+3];
            [indPickView clearBallState];
        }
            break;
            
        case 6: // 三星 组选
        {
            PickBallView * numPickView = (PickBallView *)[self.view viewWithTag:TagThreeGroupThView350+1];
            [numPickView clearBallState];
        }
            break;
        case 7: // 三星 组六
        {
            PickBallView * numPickView = (PickBallView *)[self.view viewWithTag:TagThreeGroupSixView400+1];
            [numPickView clearBallState];

        }
            break;
        case 8: // 五星 自选
        {
            PickBallView *milPickView = (PickBallView *)[self.view viewWithTag:TagFiveSelfSelectView450+1];
            [milPickView clearBallState];
            PickBallView *thoPickView = (PickBallView *)[self.view viewWithTag:TagFiveSelfSelectView450+2];
            [thoPickView clearBallState];
            PickBallView *hunPickView = (PickBallView *)[self.view viewWithTag:TagFiveSelfSelectView450+3];
            [hunPickView clearBallState];
            PickBallView *decPickView = (PickBallView *)[self.view viewWithTag:TagFiveSelfSelectView450+4];
            [decPickView clearBallState];
            PickBallView *indPickView = (PickBallView *)[self.view viewWithTag:TagFiveSelfSelectView450+5];
            [indPickView clearBallState];
        }
            break;
        case 9: // 五星 通选
        {
            PickBallView *milPickView = (PickBallView *)[self.view viewWithTag:TagFiveGeneralSelectView500+1];
            [milPickView clearBallState];
            PickBallView *thoPickView = (PickBallView *)[self.view viewWithTag:TagFiveGeneralSelectView500+2];
            [thoPickView clearBallState];
            PickBallView *hunPickView = (PickBallView *)[self.view viewWithTag:TagFiveGeneralSelectView500+3];
            [hunPickView clearBallState];
            PickBallView *decPickView = (PickBallView *)[self.view viewWithTag:TagFiveGeneralSelectView500+4];
            [decPickView clearBallState];
            PickBallView *indPickView = (PickBallView *)[self.view viewWithTag:TagFiveGeneralSelectView500+5];
            [indPickView clearBallState];
        }
            break;
        case 10: // 大小单双
        {
            [bigSmallSelectView clearAllSelectState];
        }
            break;
        default:
            break;
    }
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
    if ([[itemDic objectForKey:@"count"] intValue] > 10000) {
        [self showAlertWithMessage:@"单笔投注不能超过10000注!"];
        return;
    }
    [basketView pickTableViewArrayAddItem:itemDic];
    [self pickSelectResultRefreshAction:sender];
    itemDic = nil;
}
#pragma mark ============== methods
/* 玩法切换 */
- (void)SSCnarViewButtonAction:(id)sender
{
    if (! playSelectView ) {
        NSArray * kindAry = @[@[@"普通"],@[@"直选",@"组选",@"和值"],@[@"直选",@"组三",@"组六"],@[@"五星直选",@"五星通选"],@[@"大小单双"]];
        NSArray * titltArray = @[@"1星",@"2星",@"3星",@"5星",@"普通"];
        
        playSelectView =[[PickNumPlayKindSelectView alloc]initWithFrame:CGRectMake(200, 60, 470, 324) titleArray:titltArray kindArray:kindAry];
        playSelectView.delegate = self;
        [self.view addSubview:playSelectView];
        playSelectView.hidden= YES;
    }
//    CATransition *transition = [CATransition animation];
//    transition.duration = .5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    if(playSelectView.hidden)
//    {
//        transition.subtype = kCATransitionFromBottom;
//        [playSelectView.layer addAnimation:transition forKey:nil];
//        playSelectView.hidden = NO;
//    }
//    else
//    {
//        transition.subtype = kCATransitionFromTop;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
//        [playSelectView.layer addAnimation:transition forKey:nil];
        playSelectView.hidden = !playSelectView.hidden;
//    }

    
}
/* 玩法介绍 */
- (void)playButtonAction:(id)sender
{
//    CATransition *transition = [CATransition animation];
//    transition.duration = .5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    if(messDetailView.hidden)
//    {
//        transition.subtype = kCATransitionFromBottom;
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
    [self playButtonAction:sender];
    UIButton * button = (UIButton *)sender;
    switch (button.tag -TagMessageDetail160) {
        case 0:
        {
            PlayIntroduceViewController *introduce =[[PlayIntroduceViewController alloc]init];
            introduce.introduceLotNo = kLotNoSSC;
            introduce.delegate = self;
            introduce.view.frame = CGRectMake(463, 0, 467, 735);
            [self.view addSubview:introduce.view];
            messageView = introduce.view;
        }
            break;
        case 1:
        {
            BuyLotteryNumberViewController * buyLottery =[[BuyLotteryNumberViewController alloc]init];
            buyLottery.numLotNo = kLotNoSSC;
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
/* 返回 */
- (void)pickViewBackButtonAction:(id)sender
{
    [self.delegate SSCPickViewDisappear:self];
}
#pragma mark =============== playSelect delegate
- (void)pickPlayKindSelectLine:(int)line row:(int)row title:(NSString *)title
{
    playSelectView.hidden =YES;
    for (UIView * selectView in ballView.subviews) {
        for (UIView *view in selectView.subviews) {
            if ([view isKindOfClass:[PickBallView class]]) {
                PickBallView *pickView = (PickBallView*)view;
                [pickView clearBallState];
            }
        }
        [selectView removeFromSuperview];
    }
    switch (line) {
        case 0: // 一星
        {
            [ballView addSubview:oneStarBallView];
            playTypeString = @"1";
        }
            break;
        case 1: // 2星
        {
            switch (row) {
                case 0: // 自选
                {
                    if (! twoSelfSelectView)
                    {
                        twoSelfSelectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 540, 70)];
                        messLabel.text = @"个、十位各选1个号码投注，按位置分别命中开奖号码的个、十位即中奖！\n奖金:100元";
                        messLabel.textColor = [UIColor redColor];
                        messLabel.numberOfLines = 0;
                        [twoSelfSelectView addSubview:messLabel];
                        [messLabel release];
                        PickBallView * decadeView = [[PickBallView alloc]initWithFrame:CGRectMake(0, 80, BallViewWidth, 150)];
                        decadeView.delegate = self;
                        decadeView.tag = TagTwoSelfSelectView150 +1;
                        [decadeView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:1 selectMaxNum:10 ballType:Ball_Red];
                        [decadeView ballVIewTitle:@"十位区"];
                        [twoSelfSelectView addSubview:decadeView];
                        [decadeView release];
                        
                        PickBallView *unitView = [[PickBallView alloc]initWithFrame:CGRectMake(0, 230, BallViewWidth, 150)];
                        [unitView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:1 selectMaxNum:10 ballType:Ball_Red];
                        unitView.tag = TagTwoSelfSelectView150 +2;
                        unitView.delegate = self;
                        [unitView ballVIewTitle:@"个位区"];
                        [twoSelfSelectView addSubview:unitView];
                        [unitView release];
                        
                    }
                    [ballView addSubview:twoSelfSelectView];
                    playTypeString = @"2";
                }
                    break;
                case 1: // 组选
                {
                    if (! twoGroupSelectView)
                    {
                        twoGroupSelectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 540, 70)];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"选择2个或多个号码投注,命中开奖号码的个、十位号码即中奖！（开出对子号不逢中奖）\n奖金：50元";
                        messLabel.numberOfLines = 0;
                        [twoGroupSelectView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * numView =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.origin.y+messLabel.frame.size.height, BallViewWidth, 150)];
                        [numView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:2 selectMaxNum:10 ballType:Ball_Red];
                        numView.tag = TagTwoGroupSelectView200 +1;
                        numView.delegate = self;
                        [numView ballVIewTitle:@"球区"];
                        [twoGroupSelectView addSubview:numView];
                        [numView release];
                    }
                    [ballView addSubview:twoGroupSelectView];
                    playTypeString = @"3";
                }
                    break;
                case 2: // 和值
                {
                    if (! twoSumSelectView)
                    {
                        twoSumSelectView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 540, 50)];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"至少选择一个号码投注,命中开奖号码后面两位的数字相加之和即中奖！\n奖金: 100/50元";
                        messLabel.numberOfLines = 0;
                        [twoSumSelectView addSubview:messLabel];
                        [messLabel release];

                        PickBallView * numView =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.origin.y+messLabel.frame.size.height, BallViewWidth, 150)];
                        [numView ballViewCreateStartValue:0 ballCount:19 perLine:12 leastNum:1 selectMaxNum:19 ballType:Ball_Red];
                        numView.delegate = self;
                        numView.tag = TagTwoSumSelectView250 +1;
                        [numView ballVIewTitle:@"球区"];
                        [twoSumSelectView addSubview:numView];
                        [numView release];

                    }
                    [ballView addSubview:twoSumSelectView];
                    playTypeString = @"4";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2: // 三星
        {

            switch (row) {
                case 0: // 自选
                {
                    if (! threeSelfSelectView)
                    {
                        threeSelfSelectView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 540, 70)];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"个、十、百位各选1个或多个号码投注,按位置分别命中开奖号码的个、十、百位即中奖！\n奖金: 1000元";
                        messLabel.numberOfLines = 0;
                        [threeSelfSelectView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * numView =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.origin.y+messLabel.frame.size.height, BallViewWidth, 120)];
                        [numView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:1 selectMaxNum:10 ballType:Ball_Red];
                        numView.tag = TagThreeSelfSelectView300+1;
                        numView.delegate = self;
                        [numView ballVIewTitle:@"百位区"];
                        [threeSelfSelectView addSubview:numView];
                        [numView release];
                        
                        PickBallView * decaView =[[PickBallView alloc]initWithFrame:CGRectMake(0, numView.frame.origin.y+numView.frame.size.height, BallViewWidth, 120)];
                        [decaView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:1 selectMaxNum:10 ballType:Ball_Red];
                        decaView.tag = TagThreeSelfSelectView300+2;
                        [decaView ballVIewTitle:@"十位区"];
                        decaView.delegate = self;
                        [threeSelfSelectView addSubview:decaView];
                        [decaView release];
                        
                        PickBallView *unitView = [[PickBallView alloc]initWithFrame:CGRectMake(0, decaView.frame.origin.y+decaView.frame.size.height, BallViewWidth, 120)];
                        [unitView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:1 selectMaxNum:10 ballType:Ball_Red];
                        unitView.tag = TagThreeSelfSelectView300 +3;
                        unitView.delegate = self;
                        [unitView ballVIewTitle:@"个位区"];
                        [threeSelfSelectView addSubview:unitView];
                        [unitView release];
                    }
                    [ballView addSubview:threeSelfSelectView];
                    playTypeString = @"5";
                }
                    break;
                case 1: // 组三
                {
                    if (! threeGroupThView)
                    {
                        threeGroupThView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 540, 70)];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"选择2个或以上号码进行投注,与开奖号码的连续后3位数字相同并且包含两个相同号码,即为中奖,顺序不限！\n奖金: 320元";
                        messLabel.numberOfLines = 0;
                        [threeGroupThView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * numView =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.origin.y+messLabel.frame.size.height, BallViewWidth, 150)];
                        [numView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:1 selectMaxNum:10 ballType:Ball_Red];
                        numView.tag = TagThreeGroupThView350+1;
                        numView.delegate = self;
                        [numView ballSumViewTitle:@"球区"];
                        [threeGroupThView addSubview:numView];
                        [numView release];
                    }
                    [ballView addSubview:threeGroupThView];
                    playTypeString = @"6";
                }
                    break;
                case 2: // 组六
                {
                    if (! threeGroupSixView)
                    {
                        threeGroupSixView  =[[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 540, 70)];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"选择3个或以上号码进行投注,与开奖号码的连续后3位数字相同并且包含两个相同号码,即为中奖,顺序不限！\n奖金: 160元";
                        messLabel.numberOfLines = 0;
                        [threeGroupSixView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * numView =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.origin.y+messLabel.frame.size.height, BallViewWidth, 150)];
                        [numView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:1 selectMaxNum:10 ballType:Ball_Red];
                        numView.tag = TagThreeGroupSixView400 +1;
                        numView.delegate = self;
                        [numView ballSumViewTitle:@"球区"];
                        [threeGroupSixView addSubview:numView];
                        [numView release];

                    }
                    [ballView addSubview:threeGroupSixView];
                    playTypeString = @"7";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 3: // 5星
        {
         switch (row) {
                case 0: // 五星自选
                {
                    if (! fiveSelfSelectView)
                    {
                    fiveSelfSelectView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                    fiveSelfSelectView.contentSize = CGSizeMake(BallViewWidth, 650);
                    UILabel * messLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 540, 50)];
                    messLabel.textColor = [UIColor redColor];
                    messLabel.text = @"每位各选1个或多个号码投注，按位置全部命中即中奖！\n奖金: 100000元";
                    messLabel.numberOfLines = 0;
                    [fiveSelfSelectView addSubview:messLabel];
                    [messLabel release];
                        
                        PickBallView * millView =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.origin.y + messLabel.frame.size.height, BallViewWidth, 120)];
                        [millView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:1 selectMaxNum:10     ballType:Ball_Red];
                        [millView ballVIewTitle:@"万位区"];
                        millView.tag =TagFiveSelfSelectView450 +1;
                        millView.delegate = self;
                        [fiveSelfSelectView addSubview:millView];
                        [millView release];
                    
                        PickBallView *thodView = [[PickBallView alloc]initWithFrame:CGRectMake(0, millView.frame.size.height+millView.frame.origin.y, BallViewWidth, 120)];
                        [thodView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:1 selectMaxNum:10 ballType:Ball_Red];
                        [thodView ballVIewTitle:@"千位区"];
                        thodView.tag = TagFiveSelfSelectView450 +2;
                        thodView.delegate = self;
                        [fiveSelfSelectView addSubview:thodView];
                        [thodView release];
                        
                        PickBallView *hundView = [[PickBallView alloc]initWithFrame:CGRectMake(0, thodView.frame.size.height+thodView.frame.origin.y, BallViewWidth, 120)];
                        [hundView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:1 selectMaxNum:10 ballType:Ball_Red];
                        [hundView ballVIewTitle:@"百位区"];
                        hundView.tag = TagFiveSelfSelectView450 +3;
                        hundView.delegate = self;
                        [fiveSelfSelectView addSubview:hundView];
                        [hundView release];
                        
                        PickBallView *decadeView = [[PickBallView alloc]initWithFrame:CGRectMake(0, hundView.frame.size.height+hundView.frame.origin.y, BallViewWidth, 120)];
                        [decadeView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:1 selectMaxNum:10 ballType:Ball_Red];
                        [decadeView ballVIewTitle:@"十位区"];
                        decadeView.tag = TagFiveSelfSelectView450+4;
                        decadeView.delegate = self;
                        [fiveSelfSelectView addSubview:decadeView];
                        [decadeView release];
                        
                        PickBallView *unitView = [[PickBallView alloc]initWithFrame:CGRectMake(0, decadeView.frame.size.height+decadeView.frame.origin.y, BallViewWidth, 120)];
                        [unitView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:1 selectMaxNum:10 ballType:Ball_Red];
                        [unitView ballVIewTitle:@"个位区"];
                        unitView.tag = TagFiveSelfSelectView450 + 5;
                        unitView.delegate = self;
                        [fiveSelfSelectView addSubview:unitView];
                        [unitView release];
                    }
                    [ballView addSubview:fiveSelfSelectView];
                    playTypeString = @"8";
                }
                    break;
                case 1: // 五星通选
                {
                    if (! fiveGeneralSelectView)
                    {
                        fiveGeneralSelectView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        fiveGeneralSelectView.contentSize = CGSizeMake(BallViewWidth, 680);
                        UILabel * messLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 540, 70)];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"每位选1个或多个号码投注，按顺序全部猜中，猜中前三或后三、前二或后二都可中奖！\n奖金: 20000/200/20元";
                        messLabel.numberOfLines = 0;
                        [fiveGeneralSelectView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * millView =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.origin.y + messLabel.frame.size.height, BallViewWidth, 120)];
                        [millView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:1 selectMaxNum:10 ballType:Ball_Red];
                        [millView ballVIewTitle:@"万位区"];
                        millView.tag = TagFiveGeneralSelectView500 + 1;
                        millView.delegate = self;
                        [fiveGeneralSelectView addSubview:millView];
                        [millView release];
                        
                        PickBallView *thodView = [[PickBallView alloc]initWithFrame:CGRectMake(0, millView.frame.size.height+millView.frame.origin.y, BallViewWidth, 120)];
                        [thodView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:1 selectMaxNum:10 ballType:Ball_Red];
                        [thodView ballVIewTitle:@"千位区"];
                        thodView.tag = TagFiveGeneralSelectView500 +2;
                        thodView.delegate = self;
                        [fiveGeneralSelectView addSubview:thodView];
                        [thodView release];
                        
                        PickBallView *hundView = [[PickBallView alloc]initWithFrame:CGRectMake(0, thodView.frame.size.height+thodView.frame.origin.y, BallViewWidth, 120)];
                        [hundView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:1 selectMaxNum:10 ballType:Ball_Red];
                        [hundView ballVIewTitle:@"百位区"];
                        hundView.tag = TagFiveGeneralSelectView500 +3;
                        hundView.delegate = self;
                        [fiveGeneralSelectView addSubview:hundView];
                        [hundView release];
                        
                        PickBallView *decadeView = [[PickBallView alloc]initWithFrame:CGRectMake(0, hundView.frame.size.height+hundView.frame.origin.y, BallViewWidth, 120)];
                        [decadeView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:1 selectMaxNum:10 ballType:Ball_Red];
                        [decadeView ballVIewTitle:@"十位区"];
                        decadeView.tag = TagFiveGeneralSelectView500+4;
                        decadeView.delegate = self;
                        [fiveGeneralSelectView addSubview:decadeView];
                        [decadeView release];
                        
                        PickBallView *unitView = [[PickBallView alloc]initWithFrame:CGRectMake(0, decadeView.frame.size.height+decadeView.frame.origin.y, BallViewWidth, 120)];
                        [unitView ballViewCreateStartValue:0 ballCount:10 perLine:12 leastNum:1 selectMaxNum:10 ballType:Ball_Red];
                        [unitView ballVIewTitle:@"个位区"];
                        unitView.tag = TagFiveGeneralSelectView500+5;
                        unitView.delegate = self;
                        [fiveGeneralSelectView addSubview:unitView];
                        [unitView release];
                    }
                    [ballView addSubview:fiveGeneralSelectView];
                    playTypeString = @"9";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 4: // 大小单双
        {
#define TagBigSmallSelectView550 550
            if (! bigSmallSelectView)
            {
                bigSmallSelectView = [[SSCBigSmallSingleDoubleView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                bigSmallSelectView.delegate = self;
            }
            [ballView addSubview:bigSmallSelectView];
            playTypeString = @"10";
        }
            break;
        default:
            break;
    }
    [narViewBtn setTitle:[NSString stringWithFormat:@"%@  ▼",title] forState:btnNormal];
    [self pickResultLabelRefresh:0];
}
#pragma mark ============== ballSelelct delegate
-  (void)ballViewResultArray:(NSMutableArray *)array selectView:(PickBallView *)pickView
{
    int indexPick = pickView.tag/50;
    int indexArea = pickView.tag - indexPick*50;
    itemDic = nil;
    switch (indexPick) {
        case 2: // 一星普通
        {
            if (indexArea == 1) {
                indiViewArray = [array retain];
            }
            [self SSCPickOneStarViewSelectResult];
        }
            break;
        case 3: // 二星直选
        {
            if (indexArea == 1) {
                decaViewArray = [array retain];
            }
            if (indexArea == 2) {
                indiViewArray = [array retain];
            }
            [self SSCPickTwoStarViewSelectResult];
        }
            break;
        case 4: // 二星 组选
        {
            if (indexArea == 1)
            {
                indiViewArray = [array retain];
            }
            [self SSCPickTwoStarGroupViewSelectResult];
        }
            break;
        case 5: // 二星 和值
        {
            if (indexArea ==1) {
                indiViewArray = [array retain];
            }
            [self SSCPickTwoStarSumViewSelectResult];
        }
            break;
        case 6: // 三星 自选
        {
            if (indexArea ==1) {
                hundViewArray = [array retain];
            }
            if (indexArea == 2) {
                decaViewArray = [array retain];
            }
            if (indexArea == 3) {
                indiViewArray = [array retain];
            }
            [self SSCPickThreeStarViewSelectResult];
        }
            break;
        case 7: //三星 组三
        {
            if (indexArea ==1) {
                hundViewArray = [array retain];
            }
            [self SSCPickThStarGroupThViewSelectResult];
        }
            break;
        case 8: // 三星 组六
        {
            if (indexArea == 1) {
                hundViewArray = [array retain];
            }
            [self SSCPickThStarGroupSixViewSelectResult];
            
        }
            break;
        case 9: // 五星 自选
        {
            switch (indexArea) {
                case 1:
                    millViewArray = [array retain];
                    break;
                case 2:
                    thouViewArray = [array retain];
                    break;
                case 3:
                    hundViewArray = [array retain];
                    break;
                case 4:
                    decaViewArray = [array retain];
                    break;
                case 5:
                    indiViewArray = [array retain];
                    break;
                default:
                    break;
            }
            [self SSCPickFiveStarViewSelectResult];
        }
            break;
        case 10: // 五星 通选
        {
            switch (indexArea) {
                case 1:
                    millViewArray = [array retain];
                    break;
                case 2:
                    thouViewArray = [array retain];
                    break;
                case 3:
                    hundViewArray = [array retain];
                    break;
                case 4:
                    decaViewArray = [array retain];
                    break;
                case 5:
                    indiViewArray = [array retain];
                    break;
                default:
                    break;
            }
            [self SSCPickFiveStarGeneralViewSelectResult];
        }
            break;
        default:
            break;
    }
}
- (void)bigSmallSingDoubleViewSelectResultDecArray:(NSMutableArray *)decAry indArray:(NSMutableArray *)indAry
{
    NSArray * decArray =[self convertArrayWithStateArray:decAry];
    NSArray * indArray =[self convertArrayWithStateArray:indAry];
    if (decArray.count ==0 ||indArray.count==0) {
        [self pickResultLabelRefresh:0];
        return;
    }
    
    
    int noteCount=0;
    noteCount = decArray.count * indArray.count;
    [self pickResultLabelRefresh:noteCount];
    if (noteCount==0) {
        return;
    }
    int decValue =[[decArray objectAtIndex:0] intValue];
    int indValue =[[indArray objectAtIndex:0] intValue];
    NSArray * strAry =@[@"大",@"小",@"单",@"双"];
    NSString * redString =[NSString stringWithFormat:@"%@%@",[strAry objectAtIndex:decValue],[strAry objectAtIndex:indValue]];
    NSArray * codeAry =@[@"2",@"1",@"5",@"4"];
    NSString *codeString =[NSString stringWithFormat:@"DD|%@%@",[codeAry objectAtIndex:decValue],[codeAry objectAtIndex:indValue]];
    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
              redString,@"red",
              [NSNumber numberWithInt: noteCount],@"count",
              codeString,@"codeString",
              nil];
}
/*  一星普通 */ //bet_code":"1D|-,-,-,-,234_1_200_600 bet_code":"1D|-,-,-,-,12_1_200_400
- (void)SSCPickOneStarViewSelectResult
{
    NSArray *  numAry = [self convertArrayWithStateArray:indiViewArray];
    if (numAry.count == 0) {
        [self pickResultLabelRefresh:0];
        return;
    }
    NSString * redString =[NSString stringWithFormat:@"-,-,-,-,%@",[numAry componentsJoinedByString:@""]];
    NSString * codeString =[NSString stringWithFormat:@"1D|-,-,-,-,%@",[numAry componentsJoinedByString:@""]];
    int noteCount = numAry.count;
    
    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
              redString,@"red",
              [NSNumber numberWithInt: noteCount],@"count",
              codeString,@"codeString",
              nil];
    [self pickResultLabelRefresh:noteCount];
}
/* 二星直选 */ //bet_code":"2D|-,-,-,2,3_1_200_200" bet_code":"2D|-,-,-,345,345_1_200_1800"
- (void)SSCPickTwoStarViewSelectResult
{
    NSArray * decAry = [self convertArrayWithStateArray:decaViewArray];
    NSArray * indAry = [self convertArrayWithStateArray:indiViewArray];
    if (decAry.count==0 ||indAry.count==0) {
        [self pickResultLabelRefresh:0];
        return;
    }
    NSString *redString = [NSString stringWithFormat:@"-,-,-,%@,%@",[decAry componentsJoinedByString:@""],[indAry componentsJoinedByString:@""]];
    NSString *codeString = [NSString stringWithFormat:@"2D|-,-,-,%@,%@",[decAry componentsJoinedByString:@""],[indAry componentsJoinedByString:@""]];
    int noteCount = decAry.count * indAry.count;
    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
              redString,@"red",
              [NSNumber numberWithInt: noteCount],@"count",
              codeString,@"codeString",
              nil];
    [self pickResultLabelRefresh:noteCount];
}
/* 二星 组选*/
- (void)SSCPickTwoStarGroupViewSelectResult
{
    NSArray * numAry =[self convertArrayWithStateArray:indiViewArray];
    if (numAry.count < 2) {
        [self pickResultLabelRefresh:0];
        return;
    }
    NSString * redString =[NSString stringWithFormat:@"%@",[numAry componentsJoinedByString:@","]];
    NSString * codeString = [NSString stringWithFormat:@"F2|%@",[numAry componentsJoinedByString:@""]];
    int noteCount=0;
    NSArray * noteAry =@[@"1",@"3",@"6",@"10",@"15",@"21",@"28",@"36",@"45"];
    if (numAry.count>=2) {
        noteCount = [[noteAry objectAtIndex:numAry.count -2]intValue];
    }else{
        noteCount = 0;
    }
    
    [self pickResultLabelRefresh:noteCount];

    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
              redString,@"red",
              [NSNumber numberWithInt: noteCount],@"count",
              codeString,@"codeString",
              nil];
}
/*  二星 和值 */
- (void)SSCPickTwoStarSumViewSelectResult
{
    NSArray * numAry =[self convertArrayWithStateArray:indiViewArray];
    if (numAry.count == 0) {
        [self pickResultLabelRefresh:0];
        return;
    }
    NSString * redString =[numAry componentsJoinedByString:@","];
    NSString * codeString = [NSString stringWithFormat:@"S2|%@",[numAry componentsJoinedByString:@","]];
    int noteCount=0;
    NSArray * noteAry =@[@"1",@"1",@"2",@"2",@"3",@"3",@"4",@"4",@"5",@"5",@"5",@"4",@"4",@"3",@"3",@"2",@"2",@"1",@"1"];
    for (int i=0; i<numAry.count; i++) {
        int indexValue =[[numAry objectAtIndex:i] intValue];
        int numValue =[[noteAry objectAtIndex:indexValue] intValue];
        noteCount +=numValue;
    }
    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
              redString,@"red",
              [NSNumber numberWithInt: noteCount],@"count",
              codeString,@"codeString",
              nil];
    [self pickResultLabelRefresh:noteCount];
}
/* 三星  自选*/
- (void)SSCPickThreeStarViewSelectResult
{
    NSArray * hunAry =[self convertArrayWithStateArray:hundViewArray];
    NSArray *decAry =[self convertArrayWithStateArray:decaViewArray];
    NSArray *indAry =[self convertArrayWithStateArray:indiViewArray];
    if (hunAry.count ==0 || decAry.count ==0 ||indAry.count == 0) {
        [self pickResultLabelRefresh:0];
        return;
    }
    NSString * redString =[NSString stringWithFormat:@"-,-,%@,%@,%@",[hunAry componentsJoinedByString:@""],[decAry componentsJoinedByString:@""],[indAry componentsJoinedByString:@""]];
    NSString * codeString =[NSString stringWithFormat:@"3D|-,-,%@,%@,%@",[hunAry componentsJoinedByString:@""],[decAry componentsJoinedByString:@""],[indAry componentsJoinedByString:@""]];
    int noteCount = 0;
    noteCount = hunAry.count * decAry.count *indAry.count;
    if (noteCount ==0) {
        return;
    }
    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
              redString,@"red",
              [NSNumber numberWithInt: noteCount],@"count",
              codeString,@"codeString",
              nil];
    [self pickResultLabelRefresh:noteCount];
    
}
/*  三星 组三 */
- (void)SSCPickThStarGroupThViewSelectResult
{
    NSArray * numAry =[self convertArrayWithStateArray:hundViewArray];
    if (numAry.count < 2) {
        [self pickResultLabelRefresh:0];
        return;
    }
    NSString *redString =[NSString stringWithFormat:@"%@",[numAry componentsJoinedByString:@","]];
    NSString *codeString =[NSString stringWithFormat:@"Z3F|%@",[numAry componentsJoinedByString:@""]];
    
    int noteCount = 0;
    noteCount = numAry.count * (numAry.count -1);
    if (noteCount == 0) {
        return;
    }
    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
              redString,@"red",
              [NSNumber numberWithInt: noteCount],@"count",
              codeString,@"codeString",
              nil];
    [self pickResultLabelRefresh:noteCount];
}
/* 三星 组六 */
- (void)SSCPickThStarGroupSixViewSelectResult
{
    NSArray * numAry =[self convertArrayWithStateArray:hundViewArray];
    if (numAry.count <3) {
        [self pickResultLabelRefresh:0];
        return;
    }
    int noteCount = 0;
    NSArray * noteAry =@[@"1",@"4",@"10",@"20",@"35",@"56",@"84",@"120"];
    noteCount = [[noteAry objectAtIndex:numAry.count-3] intValue];
    [self pickResultLabelRefresh:noteCount];
    if (noteCount <0) {
        return;
    }
    NSString * redString = @"";
    NSString * codeString = @"";
    redString = [NSString stringWithFormat:@"%@",[numAry componentsJoinedByString:@","]];
    if (noteCount>1)
    {
        codeString =[NSString stringWithFormat:@"Z6F|%@",[numAry componentsJoinedByString:@""]];
    }else
    {
        codeString =[NSString stringWithFormat:@"6|%@",[numAry componentsJoinedByString:@""]];

    }
    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
              redString,@"red",
              [NSNumber numberWithInt: noteCount],@"count",
              codeString,@"codeString",
              nil];
}
/* 五星 自选 */
- (void)SSCPickFiveStarViewSelectResult
{
    NSArray * milAry =[self convertArrayWithStateArray:millViewArray];
    NSArray * thoAry =[self convertArrayWithStateArray:thouViewArray];
    NSArray * hunAry =[self convertArrayWithStateArray:hundViewArray];
    NSArray * decAry =[self convertArrayWithStateArray:decaViewArray];
    NSArray * indAry =[self convertArrayWithStateArray:indiViewArray];
    if (milAry.count ==0 ||thoAry.count ==0 ||hunAry.count ==0||decAry.count ==0||indAry.count == 0) {
        [self pickResultLabelRefresh:0];
        return;
    }
    NSString *redString =[NSString stringWithFormat:@"%@,%@,%@,%@,%@",[milAry componentsJoinedByString:@""],[thoAry componentsJoinedByString:@""],[hunAry componentsJoinedByString:@""],[decAry componentsJoinedByString:@""],[indAry componentsJoinedByString:@""]];
    NSString * codeString =[NSString stringWithFormat:@"5D|%@,%@,%@,%@,%@",[milAry componentsJoinedByString:@""],[thoAry componentsJoinedByString:@""],[hunAry componentsJoinedByString:@""],[decAry componentsJoinedByString:@""],[indAry componentsJoinedByString:@""]];
    int noteCount =0;
    noteCount = milAry.count *thoAry.count * hunAry.count * decAry.count *indAry.count;
    if (noteCount ==0 ) {
        return;
    }
    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
              redString,@"red",
              [NSNumber numberWithInt: noteCount],@"count",
              codeString,@"codeString",
              nil];
    [self pickResultLabelRefresh:noteCount];
}
/* 五星 通选 */
- (void)SSCPickFiveStarGeneralViewSelectResult
{
    NSArray * milAry =[self convertArrayWithStateArray:millViewArray];
    NSArray * thoAry =[self convertArrayWithStateArray:thouViewArray];
    NSArray * hunAry =[self convertArrayWithStateArray:hundViewArray];
    NSArray * decAry =[self convertArrayWithStateArray:decaViewArray];
    NSArray * indAry =[self convertArrayWithStateArray:indiViewArray];
    if (milAry.count ==0 ||thoAry.count ==0 ||hunAry.count ==0||decAry.count ==0||indAry.count == 0) {
        [self pickResultLabelRefresh:0];
        return;
    }
    NSString *redString =[NSString stringWithFormat:@"%@,%@,%@,%@,%@",[milAry componentsJoinedByString:@""],[thoAry componentsJoinedByString:@""],[hunAry componentsJoinedByString:@""],[decAry componentsJoinedByString:@""],[indAry componentsJoinedByString:@""]];
    NSString * codeString =[NSString stringWithFormat:@"5T|%@,%@,%@,%@,%@",[milAry componentsJoinedByString:@""],[thoAry componentsJoinedByString:@""],[hunAry componentsJoinedByString:@""],[decAry componentsJoinedByString:@""],[indAry componentsJoinedByString:@""]];
    int noteCount =0;
    noteCount = milAry.count *thoAry.count * hunAry.count * decAry.count *indAry.count;
    if (noteCount ==0 ) {
        return;
    }
    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
              redString,@"red",
              [NSNumber numberWithInt: noteCount],@"count",
              codeString,@"codeString",
              nil];
    [self pickResultLabelRefresh:noteCount];
}
/* 彩球选出 数字 */
- (NSArray *)convertArrayWithStateArray:(NSArray *)stateArray
{
    NSMutableArray *newArray =[[NSMutableArray alloc]init];
    for (int i=0; i<stateArray.count; i++) {
        if ([[stateArray objectAtIndex:i]isEqualToString:@"1"]) {
            [newArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return [newArray autorelease];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
