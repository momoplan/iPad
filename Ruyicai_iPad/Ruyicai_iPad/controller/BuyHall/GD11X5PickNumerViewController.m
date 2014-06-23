//
//  GD11X5PickNumerViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-26.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "GD11X5PickNumerViewController.h"

#define TagNormalSelectView100 100
#define TagNormalFrontTwoSelectView150 150
#define TagNormalFrontThreeSelectView200 200
#define TagDragSelectTwoView300 300
#define TagDragSelectSixView350 350

@interface GD11X5PickNumerViewController ()

@end

@implementation GD11X5PickNumerViewController
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
#pragma mark ==================== viewController
- (void)dealloc
{
    self.delegate = nil;
    [batchEndTime release],batchEndTime = nil;

    [playKindSelectView release];
    [basketView release];
    [selectResultView release];
    
    [ballAreaView release];
    [optionSelectFiveView release];
    [normalSelectTwoView release];
    [normalSelectThreeView release];
    [normalSelectFourView release];
    [normalSelectSixView release];
    [normalSelectSevenView release];
    [normalSelectEightView release];
    [normalFrontOneView release];
    [normalFrontTwoSelectView release];
    [normalFrontTwoGroupView release];
    [normalFrontThreeSelectView release];
    [normalFrontThreeGroupView release];
    
    [dragSelectTwoView release];
    [dragSelectThreeView release];
    [dragSelectFourView release];
    [dragSelectFiveView release];
    [dragSelectSixView release];
    [dragSelectSevenView release];
    [dragFrontTwoGroupView release];
    [dragFrontThreeGroupView release];

    [optionBallArray release];
    [dragFirstArray release];
    [dragSecondArray release];
    
    [itemDic release];
    [playTypeString release];
    
    [super dealloc];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super tabBarBackgroundImageViewWith:self.view];
    
    [self setTitleView];
    [self setHeaderView];
    
    selectResultView =[[PickNumSelectResultView alloc]initWithFrame:CGRectMake(0, 612,  BallViewWidth, 107)];
    selectResultView.delegate = self;
    [self.view addSubview:selectResultView];
    
    basketView = [[PickNumBasketView alloc]initWithFrame:CGRectMake(600, 147, 309, 574)];
    basketView.delegate  = self;
    [basketView pickNumberBasketViewItem:@[@"投注",@"追号"]];
    [self.view addSubview:basketView];
    
    [self setBallView];
    [self requestQueryLot];
    [self sendRequestLotteryInfoWithLotNo:kLotNoGD115];
    [self setMessageDetailView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)setTitleView
{
    narViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    narViewBtn.frame = CGRectMake(335, 15, 238, 40);
    [narViewBtn setTitle:@"任选五-自选 ▼" forState:UIControlStateNormal];
    narViewBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [narViewBtn setBackgroundImage:RYCImageNamed(@"top_qiehuan.png") forState:btnNormal];
    [narViewBtn setTitleColor:[UIColor whiteColor] forState:btnNormal];
    [narViewBtn addTarget:self action:@selector(narViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:narViewBtn];
    
    
    UIButton * playBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame = CGRectMake(self.view.frame.size.height-200, 10, 50, 50);
    [playBtn setImage:RYCImageNamed(@"pickNum_right.png") forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
}
- (void)setHeaderView
{
    // 头部视图
    UIView * headView =[[UIView alloc]initWithFrame:CGRectMake(0, 68, 908, 77)];
    headView.backgroundColor = RGBCOLOR(244, 244, 244);
    [self.view addSubview:headView];
    [headView release];
    
    UIImageView * kindImg               = [[UIImageView alloc]initWithFrame:CGRectMake(80, 10, 60, 60)];
    kindImg.image = RYCImageNamed(@"gz11x5");
    [headView addSubview:kindImg];
    
    //返回按钮
    UIButton * backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 75, 75);
    [backBtn setImage:RYCImageNamed(@"viewback") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(pickViewBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:backBtn];
    
#define TagBeforeIssuerLabel997 997
#define TagBePrizeLabel996 996
    // 上期开奖
    UILabel * beforeIssueLaebl =[[UILabel alloc]initWithFrame:CGRectMake(250, 10, 250, 30)];
    beforeIssueLaebl.backgroundColor = [UIColor clearColor];
    beforeIssueLaebl.tag = TagBeforeIssuerLabel997;
    [headView addSubview:beforeIssueLaebl];
    [beforeIssueLaebl release];
    UILabel * bePrizeLabel =[[UILabel alloc]initWithFrame:CGRectMake(beforeIssueLaebl.frame.origin.x+beforeIssueLaebl.frame.size.width+20, beforeIssueLaebl.frame.origin.y, 200, 30)];
    bePrizeLabel.backgroundColor = [UIColor clearColor];
    bePrizeLabel.tag = TagBePrizeLabel996;
    bePrizeLabel.textColor = [UIColor redColor];
    [headView addSubview:bePrizeLabel];
    [bePrizeLabel release];
    
#define TagThisIssueLabel999 999
#define TagThisEndLabel998 998    
    //这期倒计时
    UILabel * thisIssueLabel =[[UILabel alloc]initWithFrame:CGRectMake(beforeIssueLaebl.frame.origin.x, 40, beforeIssueLaebl.frame.size.width, 30)];
    thisIssueLabel.backgroundColor = [UIColor clearColor];
    thisIssueLabel.tag = TagThisIssueLabel999;
    [headView addSubview:thisIssueLabel];
    [thisIssueLabel release];
    UILabel * thisEndLabel =[[UILabel alloc]initWithFrame:CGRectMake(thisIssueLabel.frame.origin.x + thisIssueLabel.frame.size.width +20, thisIssueLabel.frame.origin.y, 200, 30)];
    thisEndLabel.backgroundColor = [UIColor clearColor];
    thisEndLabel.tag = TagThisEndLabel998;
    thisEndLabel.textColor = [UIColor redColor];
    [headView addSubview:thisEndLabel];
    [thisEndLabel  release];
}
- (void)setBallView
{
    ballAreaView = [[UIView alloc]initWithFrame:CGRectMake(0, 145, BallViewWidth, 470)];
    ballAreaView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:ballAreaView];
    
    if (!optionSelectFiveView) {
        optionSelectFiveView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
        [ballAreaView addSubview:optionSelectFiveView];
        
        UILabel * messLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 560, 50)];
        messLabel.backgroundColor = [UIColor clearColor];
        messLabel.textColor = [UIColor redColor];
        messLabel.text = @"至少选择5个号码投注,全部命中即中奖！\n奖金:540元";
        messLabel.numberOfLines = 0;
        [optionSelectFiveView addSubview:messLabel];
        [messLabel release];
        
        PickBallView * pickBall =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.size.height, BallViewWidth, 150)];
        [pickBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:5 selectMaxNum:11 ballType:Ball_Red];
        pickBall.tag = TagNormalSelectView100+4;
        [pickBall ballVIewTitle:@"球区："];
        pickBall.delegate = self;
        [optionSelectFiveView addSubview:pickBall];
        [pickBall release];
        playTypeString = @"4";

    }
                                                                      
}
#define TagMessageDetail160 160
- (void)setMessageDetailView
{
    if (! messDetailView) {
        messDetailView = [[UIView alloc]initWithFrame:CGRectMake(670, 70, 223, 119)];
        messDetailView.backgroundColor = [UIColor clearColor];
        
        UIImageView* imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, messDetailView.frame.size.width, messDetailView.frame.size.height)];
        imgBg.image = RYCImageNamed(@"jcchooselist_2.png");
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
        [self.view addSubview:messDetailView];
        messDetailView.hidden = YES;
        }
    
}
#pragma mark ============ notification

- (void)requestQueryLot
{
    NSMutableDictionary * mDic =[[[NSMutableDictionary alloc]init]autorelease];
    [mDic setObject:@"QueryLot" forKey:@"command"];
    [mDic setObject:@"highFrequency" forKey:@"type"];
    [mDic setObject:kLotNoGD115 forKey:@"lotno"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeLeftTime showProgress:NO];
}

- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkRequestTypeLeftTime:
        {
            [self GD11X5IssueAndTimeDataRequest:dataDic];
            
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
    UILabel *issuelabel = (UILabel *)[self.view viewWithTag:TagBeforeIssuerLabel997];
    issuelabel.text = [NSString stringWithFormat:@"第%@期开奖号码:", oldBatchCode];
    
    NSString * winCodeStr = KISDictionaryHaveKey(dic, @"winCode");
    NSArray * ballAry = [super lotteryCellBallDoubleNumberString:winCodeStr];
    NSMutableString  * beRedString = [[NSMutableString alloc]init];
    for (int i=0; i<ballAry.count; i++) {
        [beRedString appendFormat:@"%@,",[ballAry objectAtIndex:i]];
    }
    UILabel * prizeLabel = (UILabel *)[self.view viewWithTag:TagBePrizeLabel996];
    prizeLabel.text = [beRedString substringToIndex:14];
    [beRedString release];
}
- (void)GD11X5IssueAndTimeDataRequest:(NSDictionary *)mDic
{
    if (![KISDictionaryHaveKey(mDic, @"lotNo") isEqualToString:kLotNoGD115]) {
        issueString = @"";
        return;
    }
    issueString = [[NSString alloc]initWithString:KISDictionaryHaveKey(mDic, @"batchcode")];
    self.batchEndTime = KISDictionaryHaveKey(mDic, @"time_remaining");
    
    UILabel * thisIssLabel = (UILabel *)[self.view viewWithTag:TagThisIssueLabel999];
    thisIssLabel.text = [NSString stringWithFormat:@"离%@期截止还剩：",issueString];
    
    [basketView getThisLotNoString:kLotNoGD115 andThisBatchString:issueString];
    
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
		m_timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(GD11X5RefreshLeftTime)
												 userInfo:nil repeats:YES];
	}
    
}
- (void)GD11X5RefreshLeftTime
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
        
        [self requestQueryLot];
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

#pragma mark ================ mothods
- (void)pickViewBackButtonAction:(id)sender
{
    [self.delegate GD11X5PickNumberViewDisappear:self];
}
/*  */
- (void)narViewButtonAction:(id)sender
{
    if (! playKindSelectView) {
        NSArray *title = @[@"自选",@"胆拖"];
        NSArray *kind = @[@[@"任选二",@"任选三",@"任选四",@"任选五",@"任选六",@"任选七",@"任选八",@"前一",@"前二直选",@"前二组选",@"前三直选",@"前三组选"],@[@"任选二",@"任选三",@"任选四",@"任选五",@"任选六",@"任选七",@"前二组选",@"前三组选"]];
        playKindSelectView = [[PickNumPlayKindSelectView alloc]initWithFrame:CGRectMake(200, 50, 470, 424) titleArray:title kindArray:kind];
        playKindSelectView.delegate = self;
        [self.view addSubview:playKindSelectView];
        playKindSelectView.hidden= YES;
    }
//    CATransition *transition = [CATransition animation];
//    transition.duration = .5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;//{ kCATransitionPush, kCATransitionMoveIn, kCATransitionReveal, kCATransitionFade }
//    if(playKindSelectView.hidden)
//    {
//        transition.subtype = kCATransitionFromBottom;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
//        [playKindSelectView.layer addAnimation:transition forKey:nil];
//        playKindSelectView.hidden = NO;
//    }
//    else
//    {
//        transition.subtype = kCATransitionFromTop;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
//        [playKindSelectView.layer addAnimation:transition forKey:nil];
        playKindSelectView.hidden = !playKindSelectView.hidden;
//    }
}
/*  */
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
    [self playButtonAction:sender];
    UIButton * button = (UIButton *)sender;
    switch (button.tag -TagMessageDetail160) {
        case 0:
        {
            PlayIntroduceViewController *introduce =[[PlayIntroduceViewController alloc]init];
            introduce.introduceLotNo = kLotNoGD115;
            introduce.delegate = self;
            introduce.view.frame = CGRectMake(463, 0, 467, 735);
            [self.view addSubview:introduce.view];
            messageView = introduce.view;
        }
            break;
        case 1:
        {
            BuyLotteryNumberViewController * buyLottery =[[BuyLotteryNumberViewController alloc]init];
            buyLottery.numLotNo = kLotNoGD115;
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
#pragma mark ================= pickBall delegate

- (void)pickPlayKindSelectLine:(int)line row:(int)row title:(NSString *)title
{
    playKindSelectView.hidden = YES;
    [narViewBtn setTitle:[NSString stringWithFormat:@"%@  ▼",title] forState:btnNormal];
    
    for (UIView *selectView in ballAreaView.subviews) {
        for (UIView *view in selectView.subviews) {
            if ([view isKindOfClass:[PickBallView class]]) {
                PickBallView *pickView = (PickBallView*)view;
                DLog(@"pcikview tag %d",pickView.tag);
                [pickView clearBallState];
            }
        }
       
        [selectView removeFromSuperview];
    }

    switch (line)
    {
        case 0: // 自选
        {
            switch (row) {
                case 0: // 任选二
                {
                    if (! normalSelectTwoView)
                    {
                        normalSelectTwoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 560, 50)];
                        messLabel.backgroundColor = [UIColor clearColor];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"至少选择2个号码投注,命中任意2位即中奖！\n奖金:6元";
                        messLabel.numberOfLines = 0;
                        [normalSelectTwoView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * pickBall =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.size.height, BallViewWidth, 150)];
                        [pickBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:2 selectMaxNum:11 ballType:Ball_Red];
                        pickBall.tag = TagNormalSelectView100+1;
                        [pickBall ballVIewTitle:@"球区："];
                        pickBall.delegate = self;
                        [normalSelectTwoView addSubview:pickBall];
                        [pickBall release];
                       
                        
                    }
                     playTypeString = @"1";
                    [ballAreaView addSubview:normalSelectTwoView];
                }
                    break;
                case 1: // 任选三
                {
                    if (! normalSelectThreeView)
                    {
                        normalSelectThreeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 560, 50)];
                        messLabel.backgroundColor = [UIColor clearColor];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"至少选择3个号码投注,命中任意3位即中奖！\n奖金:19元";
                        messLabel.numberOfLines = 0;
                        [normalSelectThreeView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * pickBall =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.size.height, BallViewWidth, 150)];
                        [pickBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:3 selectMaxNum:11 ballType:Ball_Red];
                        pickBall.tag = TagNormalSelectView100+2;
                        [pickBall ballVIewTitle:@"球区："];
                        pickBall.delegate = self;
                        [normalSelectThreeView addSubview:pickBall];
                        [pickBall release];
                        
                    }
                    [ballAreaView addSubview:normalSelectThreeView];
                    playTypeString = @"2";
                }
                    break;
                case 2: // 任选四
                {
                    if (! normalSelectFourView) {
                        normalSelectFourView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 560, 50)];
                        messLabel.backgroundColor = [UIColor clearColor];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"至少选择4个号码投注,命中任意4位即中奖！\n奖金:78元";
                        messLabel.numberOfLines = 0;
                        [normalSelectFourView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * pickBall =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.size.height, BallViewWidth, 150)];
                        [pickBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:4 selectMaxNum:11 ballType:Ball_Red];
                        pickBall.tag = TagNormalSelectView100+3;
                        [pickBall ballVIewTitle:@"球区："];
                        pickBall.delegate = self;
                        [normalSelectFourView addSubview:pickBall];
                        [pickBall release];
                                           }
                    [ballAreaView addSubview:normalSelectFourView];
                    playTypeString = @"3";

                }
                    break;
                case 3: // 任选五
                {
                    [ballAreaView addSubview:optionSelectFiveView];
                    playTypeString = @"4";
                }
                    break;
                case 4: // 任选六
                {
                    if (! normalSelectSixView)
                    {
                        normalSelectSixView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 560, 70)];
                        messLabel.backgroundColor = [UIColor clearColor];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"至少选择6个号码投注,选号中任意5位与开奖号码一致即中奖！\n奖金:90元";
                        messLabel.numberOfLines = 0;
                        [normalSelectSixView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * pickBall =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.size.height, BallViewWidth, 150)];
                        [pickBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:6 selectMaxNum:11 ballType:Ball_Red];
                        pickBall.tag = TagNormalSelectView100+5;
                        [pickBall ballVIewTitle:@"球区："];
                        pickBall.delegate = self;
                        [normalSelectSixView addSubview:pickBall];
                        [pickBall release];

                    }
                    [ballAreaView addSubview:normalSelectSixView];
                    playTypeString = @"5";
                }
                    break;
                case 5: // 任选七
                {
                    if (! normalSelectSevenView)
                    {
                        normalSelectSevenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 560, 70)];
                        messLabel.backgroundColor = [UIColor clearColor];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"至少选择7个号码投注,选号中任意5位与开奖号码一致即中奖！\n奖金:26元";
                        messLabel.numberOfLines = 0;
                        [normalSelectSevenView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * pickBall =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.size.height, BallViewWidth, 150)];
                        [pickBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:7 selectMaxNum:11 ballType:Ball_Red];
                        pickBall.tag = TagNormalSelectView100+6;
                        [pickBall ballVIewTitle:@"球区："];
                        pickBall.delegate = self;
                        [normalSelectSevenView addSubview:pickBall];
                        [pickBall release];

                    }
                    [ballAreaView addSubview:normalSelectSevenView];
                    playTypeString  = @"6";
                }
                    break;
                case 6: // 任选八
                {
                    if (! normalSelectEightView)
                    {
                        normalSelectEightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 560, 70)];
                        messLabel.backgroundColor = [UIColor clearColor];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"选择8个号码投注,选号中任意5位与开奖号码一致即中奖！\n奖金:9元";
                        messLabel.numberOfLines = 0;
                        [normalSelectEightView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * pickBall =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.size.height, BallViewWidth, 150)];
                        [pickBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:8 selectMaxNum:8 ballType:Ball_Red];
                        pickBall.tag = TagNormalSelectView100+7;
                        [pickBall ballSumViewTitle:@"球区：（选择8个）"];
                        pickBall.delegate = self;
                        [normalSelectEightView addSubview:pickBall];
                        [pickBall release];
                    }
                    [ballAreaView addSubview:normalSelectEightView];
                    playTypeString = @"7";
                }
                    break;
                case 7: // 前一
                {
                    if (! normalFrontOneView)
                    {
                        normalFrontOneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 560, 70)];
                        messLabel.backgroundColor = [UIColor clearColor];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"至少选择1个号码投注,命中开奖在号码第1位即中奖！\n奖金:13元";
                        messLabel.numberOfLines = 0;
                        [normalFrontOneView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * pickBall =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.size.height, BallViewWidth, 150)];
                        [pickBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:1 selectMaxNum:11 ballType:Ball_Red];
                        pickBall.tag = TagNormalSelectView100+8;
                        [pickBall ballVIewTitle:@"球区："];
                        pickBall.delegate = self;
                        [normalFrontOneView addSubview:pickBall];
                        [pickBall release];

                    }
                    [ballAreaView addSubview:normalFrontOneView];
                    playTypeString = @"8";
                }
                    break;
                case 8: // 前二直选
                {
                    if (! normalFrontTwoSelectView)
                    {
                        normalFrontTwoSelectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 560, 70)];
                        messLabel.backgroundColor = [UIColor clearColor];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"每位个选1个或多个号码投注,按位置全部命中即中奖！\n奖金:130元";
                        messLabel.numberOfLines = 0;
                        [normalFrontTwoSelectView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * pickBall =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.size.height, BallViewWidth, 150)];
                        [pickBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:1 selectMaxNum:11 ballType:Ball_Red];
                        pickBall.tag = TagNormalFrontTwoSelectView150+1;
                        [pickBall ballVIewTitle:@"万位:"];
                        pickBall.delegate = self;
                        [normalFrontTwoSelectView addSubview:pickBall];
                        [pickBall release];
                        
                        PickBallView * thodsPickBall = [[PickBallView alloc]initWithFrame:CGRectMake(0, pickBall.frame.origin.y+pickBall.frame.size.height, BallViewWidth, 150)];
                        [thodsPickBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:1 selectMaxNum:11 ballType:Ball_Red];
                        thodsPickBall.tag = TagNormalFrontTwoSelectView150+2;
                        thodsPickBall.delegate = self;
                        [thodsPickBall ballVIewTitle:@"千位:"];
                        [normalFrontTwoSelectView addSubview:thodsPickBall];
                        [thodsPickBall release];

                    }
                    [ballAreaView addSubview:normalFrontTwoSelectView];
                    playTypeString = @"9";
                }
                    break;
                case 9: // 前二组选
                {
                    if (! normalFrontTwoGroupView)
                    {
                        normalFrontTwoGroupView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 560, 70)];
                        messLabel.backgroundColor = [UIColor clearColor];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"至少选择2个号码投注,投注号码与开奖号码前两位一致,位置不限即中奖！\n奖金:65元";
                        messLabel.numberOfLines = 0;
                        [normalFrontTwoGroupView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * pickBall =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.size.height, BallViewWidth, 150)];
                        [pickBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:2 selectMaxNum:11 ballType:Ball_Red];
                        pickBall.tag = TagNormalSelectView100+9;
                        [pickBall ballVIewTitle:@"球区："];
                        pickBall.delegate = self;
                        [normalFrontTwoGroupView addSubview:pickBall];
                        [pickBall release];

                    }
                    [ballAreaView addSubview:normalFrontTwoGroupView];
                    playTypeString = @"10";
                }
                    break;
                case 10: // 前三直选
                {
                    if (! normalFrontThreeSelectView)
                    {
                        normalFrontThreeSelectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        
                        UILabel * messLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 560, 70)];
                        messLabel.backgroundColor = [UIColor clearColor];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"每位各选1个或多个号码投注,按位置全部命中即中奖！\n奖金:1170元";
                        messLabel.numberOfLines = 0;
                        [normalFrontThreeSelectView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * pickBall =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.size.height, BallViewWidth, 120)];
                        [pickBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:1 selectMaxNum:11 ballType:Ball_Red];
                        pickBall.tag = TagNormalFrontThreeSelectView200+1;
                        [pickBall ballVIewTitle:@"万位："];
                        pickBall.delegate = self;
                        [normalFrontThreeSelectView addSubview:pickBall];
                        [pickBall release];
                        
                        PickBallView *thodsPickBall =[[PickBallView alloc]initWithFrame:CGRectMake(0, pickBall.frame.origin.y+pickBall.frame.size.height, BallViewWidth, 120)];
                        thodsPickBall.delegate = self;
                        thodsPickBall.tag = TagNormalFrontThreeSelectView200+2;
                        [thodsPickBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:1 selectMaxNum:11 ballType:Ball_Red];
                        [thodsPickBall ballVIewTitle:@"千位:"];
                        [normalFrontThreeSelectView addSubview:thodsPickBall];
                        [thodsPickBall release];
                        
                        PickBallView * hundredPickBall = [[PickBallView alloc]initWithFrame:CGRectMake(0, thodsPickBall.frame.origin.y+thodsPickBall.frame.size.height, BallViewWidth, 120)];
                        [hundredPickBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:1 selectMaxNum:11 ballType:Ball_Red];
                        hundredPickBall.tag = TagNormalFrontThreeSelectView200+3;
                        [hundredPickBall ballVIewTitle:@"百位:"];
                        hundredPickBall.delegate = self;
                        [normalFrontThreeSelectView addSubview:hundredPickBall];
                        [hundredPickBall release];

                    }
                    [ballAreaView addSubview:normalFrontThreeSelectView];
                    playTypeString = @"11";
                }
                    break;
                case 11:  // 前三组选
                {
                    if (! normalFrontThreeGroupView)
                    {
                        normalFrontThreeGroupView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 560, 70)];
                        messLabel.backgroundColor = [UIColor clearColor];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"至少选择3个号码投注,投注号码与开奖号码前三位一致，位置不限即中奖！\n奖金:195元";
                        messLabel.numberOfLines = 0;
                        [normalFrontThreeGroupView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * pickBall =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.size.height, BallViewWidth, 150)];
                        [pickBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:3 selectMaxNum:11 ballType:Ball_Red];
                        pickBall.tag = TagNormalSelectView100+10;
                        [pickBall ballVIewTitle:@"球区："];
                        pickBall.delegate = self;
                        [normalFrontThreeGroupView addSubview:pickBall];
                        [pickBall release];

                    }
                    [ballAreaView addSubview:normalFrontThreeGroupView];
                    playTypeString = @"12";
                }
                    break;
                default:
                    break;
            }
        }
            break;
         case 1: // 胆拖
        {
            switch (row) {

                case 0: // 任选二
                {
                    if (! dragSelectTwoView)
                    {
                        dragSelectTwoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 560, 70)];
                        messLabel.backgroundColor = [UIColor clearColor];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"至少选择1个胆码和2个拖码投注,胆码加拖码≥3个,投注号码与开奖号码前两位一致,位置不限即中奖！\n奖金:6元";
                        messLabel.numberOfLines = 0;
                        [dragSelectTwoView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * pickBall =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.size.height, BallViewWidth, 150)];
                        [pickBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:1 selectMaxNum:1 ballType:Ball_Red];
                        pickBall.tag = TagDragSelectTwoView300+1;
                        [pickBall ballSumViewTitle:@"胆码 (只能选1个球)"];
                        pickBall.delegate = self;
                        [dragSelectTwoView addSubview:pickBall];
                        [pickBall release];
                        
                        PickBallView *dragBall = [[PickBallView alloc]initWithFrame:CGRectMake(0, pickBall.frame.origin.y+pickBall.frame.size.height, BallViewWidth, 150)];
                        [dragBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:2 selectMaxNum:10 ballType:Ball_Red];
                        dragBall.tag = TagDragSelectTwoView300+2;
                        [dragBall ballSumViewTitle:@"拖码（选2-10个球）"];
                        dragBall.delegate = self;
                        [dragSelectTwoView addSubview:dragBall];
                        [dragBall release];
                        
                    }
                    [ballAreaView addSubview:dragSelectTwoView];
                    playTypeString = @"13";
                }
                    break;
                case 1: // 任选三
                {
                    if (! dragSelectThreeView)
                    {
                        dragSelectThreeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 560, 70)];
                        messLabel.backgroundColor = [UIColor clearColor];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"胆码可选1-2个,拖码至少选项2个,胆码加拖码大于等于4个,命中开奖号码的任意3位（含全部胆码）即中奖！\n奖金:19元";
                        messLabel.numberOfLines = 0;
                        [dragSelectThreeView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * pickBall =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.size.height, BallViewWidth, 150)];
                        [pickBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:1 selectMaxNum:2 ballType:Ball_Red];
                        pickBall.tag = TagDragSelectTwoView300 +3;
                        [pickBall ballSumViewTitle:@"胆码 (选1-2个球，胆码加拖码个数大于3)"];
                        pickBall.delegate = self;
                        [dragSelectThreeView addSubview:pickBall];
                        [pickBall release];
                        
                        PickBallView *dragBall = [[PickBallView alloc]initWithFrame:CGRectMake(0, pickBall.frame.origin.y+pickBall.frame.size.height, BallViewWidth, 150)];
                        [dragBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:2 selectMaxNum:10 ballType:Ball_Red];
                        dragBall.tag = TagDragSelectTwoView300+4;
                        [dragBall ballSumViewTitle:@"拖码（选2-10个球）"];
                        dragBall.delegate = self;
                        [dragSelectThreeView addSubview:dragBall];
                        [dragBall release];
                        
                    }
                    [ballAreaView addSubview:dragSelectThreeView];
                    playTypeString = @"14";
                }
                    break;
                case 2: // 任选四
                {
                    if (! dragSelectFourView)
                    {
                        dragSelectFourView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 560, 70)];
                        messLabel.backgroundColor = [UIColor clearColor];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"胆码可选1-3个,拖码至少选择2个,胆码加拖码≥5个,命中开奖号码的任意5位（含全部胆码）即中奖！\n奖金:78元";
                        messLabel.numberOfLines = 0;
                        [dragSelectFourView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * pickBall =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.size.height, BallViewWidth, 150)];
                        [pickBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:1 selectMaxNum:3 ballType:Ball_Red];
                        pickBall.tag = TagDragSelectTwoView300+5;
                        [pickBall ballSumViewTitle:@"胆码 (选1-3个球，胆码加拖码个数大于4)"];
                        pickBall.delegate = self;
                        [dragSelectFourView addSubview:pickBall];
                        [pickBall release];
                        
                        PickBallView *dragBall = [[PickBallView alloc]initWithFrame:CGRectMake(0, pickBall.frame.origin.y+pickBall.frame.size.height, BallViewWidth, 150)];
                        [dragBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:2 selectMaxNum:10 ballType:Ball_Red];
                        dragBall.tag = TagDragSelectTwoView300+6;
                        [dragBall ballSumViewTitle:@"拖码（选2-10个球）"];
                        dragBall.delegate = self;
                        [dragSelectFourView addSubview:dragBall];
                        [dragBall release];
                        
                    }
                    [ballAreaView addSubview:dragSelectFourView];
                    playTypeString = @"15";

                }
                    break;
                case 3: // 任选五
                {
                    if (! dragSelectFiveView)
                    {
                        dragSelectFiveView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 560, 70)];
                        messLabel.backgroundColor = [UIColor clearColor];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"胆码可选1-4个,拖码至少选择2个,胆码加拖码≥6个,全部命中开奖号码（含全部胆码）即中奖！\n奖金:540元";
                        messLabel.numberOfLines = 0;
                        [dragSelectFiveView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * pickBall =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.size.height, BallViewWidth, 150)];
                        [pickBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:1 selectMaxNum:4 ballType:Ball_Red];
                        pickBall.tag = TagDragSelectTwoView300+7;
                        [pickBall ballSumViewTitle:@"胆码 (选1-4个球，胆码加拖码个数大于5)"];
                        pickBall.delegate = self;
                        [dragSelectFiveView addSubview:pickBall];
                        [pickBall release];
                        
                        PickBallView *dragBall = [[PickBallView alloc]initWithFrame:CGRectMake(0, pickBall.frame.origin.y+pickBall.frame.size.height, BallViewWidth, 150)];
                        [dragBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:2 selectMaxNum:10 ballType:Ball_Red];
                        dragBall.tag = TagDragSelectTwoView300+8;
                        [dragBall ballSumViewTitle:@"拖码（选2-10个球）"];
                        dragBall.delegate = self;
                        [dragSelectFiveView addSubview:dragBall];
                        [dragBall release];
                        
                    }
                    [ballAreaView addSubview:dragSelectFiveView];
                    playTypeString = @"16";
                    

                }
                    break;
                case 4: // 任选六
                {
                    if (! dragSelectSixView)
                    {
                        dragSelectSixView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 560, 70)];
                        messLabel.backgroundColor = [UIColor clearColor];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"胆码可选1-5个,拖码至少选择2个,胆码加拖码≥7个,选号中任意5位与开奖号码一致（含全部胆码）即中奖！\n奖金:90元";
                        messLabel.numberOfLines = 0;
                        [dragSelectSixView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * pickBall =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.size.height, BallViewWidth, 150)];
                        [pickBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:1 selectMaxNum:5 ballType:Ball_Red];
                        pickBall.tag = TagDragSelectSixView350+1;
                        [pickBall ballSumViewTitle:@"胆码 (选1-5个球，胆码加拖码个数大于6)"];
                        pickBall.delegate = self;
                        [dragSelectSixView addSubview:pickBall];
                        [pickBall release];
                        
                        PickBallView *dragBall = [[PickBallView alloc]initWithFrame:CGRectMake(0, pickBall.frame.origin.y+pickBall.frame.size.height, BallViewWidth, 150)];
                        [dragBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:2 selectMaxNum:10 ballType:Ball_Red];
                        dragBall.tag = TagDragSelectSixView350+2;
                        [dragBall ballSumViewTitle:@"拖码（选2-10个球）"];
                        dragBall.delegate = self;
                        [dragSelectSixView addSubview:dragBall];
                        [dragBall release];
                        
                    }
                    [ballAreaView addSubview:dragSelectSixView];
                    playTypeString = @"17";
                }
                    break;
                case 5: // 任选七
                {
                    if (! dragSelectSevenView)
                    {
                        dragSelectSevenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 560, 70)];
                        messLabel.backgroundColor = [UIColor clearColor];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"胆码可选1-6个,拖码至少选择2个,胆码加拖码≥8个,选号中任意5位与开奖号码一致（含全部胆码）即中奖！\n奖金:26元";
                        messLabel.numberOfLines = 0;
                        [dragSelectSevenView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * pickBall =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.size.height, BallViewWidth, 150)];
                        [pickBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:1 selectMaxNum:6 ballType:Ball_Red];
                        pickBall.tag = TagDragSelectSixView350+3;
                        [pickBall ballSumViewTitle:@"胆码 (选1-6个球，胆码加拖码个数大于7)"];
                        pickBall.delegate = self;
                        [dragSelectSevenView addSubview:pickBall];
                        [pickBall release];
                        
                        PickBallView *dragBall = [[PickBallView alloc]initWithFrame:CGRectMake(0, pickBall.frame.origin.y+pickBall.frame.size.height, BallViewWidth, 150)];
                        [dragBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:2 selectMaxNum:10 ballType:Ball_Red];
                        dragBall.tag = TagDragSelectSixView350+4;
                        [dragBall ballSumViewTitle:@"拖码（选2-10个球）"];
                        dragBall.delegate = self;
                        [dragSelectSevenView addSubview:dragBall];
                        [dragBall release];
                        
                    }
                    [ballAreaView addSubview:dragSelectSevenView];
                    playTypeString = @"18";

                }
                    break;
                case 6: // 前二组选
                {
                    if (! dragFrontTwoGroupView)
                    {
                        dragFrontTwoGroupView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 560, 70)];
                        messLabel.backgroundColor = [UIColor clearColor];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"至少选择1个胆码和1个拖码投注,胆码加拖码≥3个,投注号码与开奖号码前两位一致,位置不限即中奖！\n奖金:65元";
                        messLabel.numberOfLines = 0;
                        [dragFrontTwoGroupView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * pickBall =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.size.height, BallViewWidth, 150)];
                        [pickBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:1 selectMaxNum:1 ballType:Ball_Red];
                        pickBall.tag = TagDragSelectSixView350+5;
                        [pickBall ballSumViewTitle:@"胆码 (只能选1个球)"];
                        pickBall.delegate = self;
                        [dragFrontTwoGroupView addSubview:pickBall];
                        [pickBall release];
                        
                        PickBallView *dragBall = [[PickBallView alloc]initWithFrame:CGRectMake(0, pickBall.frame.origin.y+pickBall.frame.size.height, BallViewWidth, 150)];
                        [dragBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:2 selectMaxNum:10 ballType:Ball_Red];
                        dragBall.tag = TagDragSelectSixView350+6;
                        [dragBall ballSumViewTitle:@"拖码（选2-10个球）"];
                        dragBall.delegate = self;
                        [dragFrontTwoGroupView addSubview:dragBall];
                        [dragBall release];
                        
                    }
                    [ballAreaView addSubview:dragFrontTwoGroupView];
                    playTypeString = @"19";

                }
                    break;
                case 7: // 前三组选
                {
                    if (! dragFrontThreeGroupView)
                    {
                        dragFrontThreeGroupView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 450)];
                        UILabel * messLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 560, 70)];
                        messLabel.backgroundColor = [UIColor clearColor];
                        messLabel.textColor = [UIColor redColor];
                        messLabel.text = @"胆码可选1-2个,拖码至少选择2个,胆码加拖码≥4个,投注号码与开奖号码前三位一致,位置不限（含全部胆码）即中奖！\n奖金:195元";
                        messLabel.numberOfLines = 0;
                        [dragFrontThreeGroupView addSubview:messLabel];
                        [messLabel release];
                        
                        PickBallView * pickBall =[[PickBallView alloc]initWithFrame:CGRectMake(0, messLabel.frame.size.height, BallViewWidth, 150)];
                        [pickBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:1 selectMaxNum:2 ballType:Ball_Red];
                        pickBall.tag = TagDragSelectSixView350+7;
                        [pickBall ballSumViewTitle:@"胆码 (选1-2个球,胆码加拖码个数大于3)"];
                        pickBall.delegate = self;
                        [dragFrontThreeGroupView addSubview:pickBall];
                        [pickBall release];
                        
                        PickBallView *dragBall = [[PickBallView alloc]initWithFrame:CGRectMake(0, pickBall.frame.origin.y+pickBall.frame.size.height, BallViewWidth, 150)];
                        [dragBall ballViewCreateStartValue:1 ballCount:11 perLine:12 leastNum:1 selectMaxNum:10 ballType:Ball_Red];
                        dragBall.tag = TagDragSelectSixView350+8;
                        [dragBall ballSumViewTitle:@"拖码（选2-10个球）"];
                        dragBall.delegate = self;
                        [dragFrontThreeGroupView addSubview:dragBall];
                        [dragBall release];
                        
                    }
                    [ballAreaView addSubview:dragFrontThreeGroupView];
                    playTypeString = @"20";
                    
                }
                    break;
                default:
                    break;
            }
//            [dragFirstArray removeAllObjects];
//            [dragSecondArray removeAllObjects];
        }
            break;
        default:
            break;
    }
    [self pickResultLabelRefresh:0];//刷新注数
}
- (void)ballViewResultArray:(NSMutableArray *)array selectView:(PickBallView *)ballView
{
    if (array.count==0) {
        return;
    }
    itemDic = nil;
    int indexView = ballView.tag /50;
    int indexArea = ballView.tag - indexView*50;
    switch (indexView) {
        case 2: 
        {
            switch (indexArea) {
                case 1: // 自选 任选二
                {
                    optionBallArray = [array retain];
                    NSArray * noteAry = @[@"0",@"1",@"3",@"6",@"10",@"15",@"21",@"28",@"36",@"45",@"55"];
                    [self resultNormalSelectViewNumber:2 noteArray:noteAry];
                }
                    break;
                case 2: // 自选 任选三
                {
                     optionBallArray = [array retain];
                    NSArray * noteAry =@[@"0",@"0",@"1",@"4",@"10",@"20",@"35",@"56",@"84",@"120",@"165"];
                    [self resultNormalSelectViewNumber:3 noteArray:noteAry];

                }
                    break;
                case 3: // 自选 任选四
                {
                    optionBallArray = [array retain];
                    NSArray * noteAry =@[@"0",@"0",@"0",@"1",@"5",@"15",@"35",@"70",@"126",@"210",@"330"];
                    [self resultNormalSelectViewNumber:4 noteArray:noteAry];
                }
                    break;
                case 4: // 自选 任选五
                {
                    optionBallArray = [array retain];
                    NSArray * noteAry =@[@"0",@"0",@"0",@"0",@"1",@"6",@"21",@"56",@"126",@"252",@"462"];
                    [self resultNormalSelectViewNumber:5 noteArray:noteAry];
                }
                    break;
                case 5: // 自选 任选六
                {
                    optionBallArray = [array retain];
                    NSArray * noteAry =@[@"0",@"0",@"0",@"0",@"0",@"1",@"7",@"28",@"84",@"210",@"462"];
                    [self resultNormalSelectViewNumber:6 noteArray:noteAry];
                }
                    break;
                case 6: // 自选 任选七
                {
                    optionBallArray = [array retain];
                    NSArray * noteAry =@[@"0",@"0",@"0",@"0",@"0",@"0",@"1",@"8",@"36",@"120",@"330"];
                    [self resultNormalSelectViewNumber:7 noteArray:noteAry];
                    
                }
                    break;
                case 7: // 自选 任选八
                {
                    optionBallArray = [array retain];
                    NSArray * noteAry =@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"1",@"0",@"0",@"0"];
                    [self resultNormalSelectViewNumber:8 noteArray:noteAry];
                }
                    break;
                case 8: // 自选  前一直选
                {
                    optionBallArray = [array retain];
                    NSArray * noteAry =@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11"];
                    [self resultNormalSelectViewNumber:1 noteArray:noteAry];
                }
                    break;
                case 9: // 前二组选
                {
                    optionBallArray = [array retain];
                    NSArray * noteAry =@[@"0",@"1",@"3",@"6",@"10",@"15",@"21",@"28",@"36",@"45",@"55"];
                    [self resultNormalGroupViewNumber:2 noteArray:noteAry];
                }
                    break;
                case 10: // 前三 组选
                {
                    optionBallArray = [array retain];
                    NSArray * noteAry =@[@"0",@"0",@"1",@"4",@"10",@"20",@"35",@"56",@"84",@"120",@"165"];
                    [self resultNormalGroupViewNumber:3 noteArray:noteAry];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 3: // 前二自选
        {
            if (indexArea == 1) {
                dragFirstArray = [array retain];
            }
            if (indexArea == 2) {
                dragSecondArray = [array retain];
            }
            [self resultNormalFrontTwoSelectView];
        }
            break;
        case 4: // 前三自选
        {
           
            if (indexArea == 1) {
                dragFirstArray = [array retain];
            }
            if (indexArea == 2) {
                dragSecondArray = [array retain];
            }
            if (indexArea == 3) {
                optionBallArray = [array retain];
            }
            [self resultNormalFrontThreeSelectView:optionBallArray];
        }
            break;
        case 6: //胆拖
        case 7:
        {
            switch (indexArea) {
                case 1:
                case 3:
                case 5:
                case 7://胆
                {
//                    dragFirstArray = [array retain];
//                    PickBallView *tuoPickView = (PickBallView *)[ballAreaView viewWithTag:50*indexView+indexArea+1];
//                      [tuoPickView ballViewDifferentNumber:[self numberArrayTuomaDanmaDifferentDanmaArray:dragFirstArray tuomaArray:dragSecondArray]];
                    NSLog(@"%d", (50*indexView+indexArea+1));
                    PickBallView *tuoPickView = (PickBallView *)[ballAreaView viewWithTag:50*indexView+indexArea+1];
                    PickBallView *danPickView = (PickBallView *)[ballAreaView viewWithTag:50*indexView+indexArea];
                    if ([tuoPickView stateForIndex:ballView.currentPickIndex]) {
                        [tuoPickView resetStateForIndex:ballView.currentPickIndex];
                    }
                    dragFirstArray = [danPickView.ballStateArray retain];
                    dragSecondArray = [tuoPickView.ballStateArray retain];
                    
                }
                    break;
                case 2:
                case 4:
                case 6:
                case 8:
                {
//                    dragSecondArray = [array retain];
//                    PickBallView *danPickView = (PickBallView *)[ballAreaView viewWithTag:50*indexView+indexArea-1];
//                      [danPickView ballViewDifferentNumber:[self numberArrayTuomaDanmaDifferentDanmaArray:dragFirstArray tuomaArray:dragSecondArray]];
                    PickBallView *tuoPickView = (PickBallView *)[ballAreaView viewWithTag:50*indexView+indexArea];
                    PickBallView *danPickView = (PickBallView *)[ballAreaView viewWithTag:50*indexView+indexArea-1];
                    if ([danPickView stateForIndex:ballView.currentPickIndex]) {
                        [danPickView resetStateForIndex:ballView.currentPickIndex];
                    }
                    dragFirstArray = [danPickView.ballStateArray retain];
                    dragSecondArray = [tuoPickView.ballStateArray retain];
                }
                    break;
                default:
                    break;
            }
            [self drayResultSelectView];

        }
            break;
        default:
            break;
    }
    
}
/* 前 组选 */
- (void)resultNormalGroupViewNumber:(int)num noteArray:(NSArray *)noteAry
{
    NSArray * numAry =[self convertArrayWithStateArray:optionBallArray];
    if (numAry.count ==0) {
        [self pickResultLabelRefresh:0];
        return;
    }
    int noteCount = 0;
    noteCount = [[noteAry objectAtIndex:numAry.count-1] intValue];
    [self pickResultLabelRefresh:noteCount];
    
    if (noteCount == 0) {
        return;
    }
    NSString * redString =[numAry componentsJoinedByString:@","];
    NSString * codeString = @"";
    if (numAry.count ==num) {
        codeString = [codeString stringByAppendingFormat:@"S|Z%d|%@",num,[numAry componentsJoinedByString:@""]];
    }else{
        codeString = [NSString stringWithFormat:@"M|Z%d|%@",num,[numAry componentsJoinedByString:@""]];
    }
    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
              redString,@"red",
              [NSNumber numberWithInt: noteCount],@"count",
              codeString,@"codeString",
              nil];

}
/* 任选 */
- (void)resultNormalSelectViewNumber:(int)num noteArray:(NSArray *)noteAry
{
    NSArray * numAry =[self convertArrayWithStateArray:optionBallArray];
    if (numAry.count ==0) {
        [self pickResultLabelRefresh:0];
        return;
    }
    DLog(@"numAry %@",numAry);
    int noteCount = 0;
    noteCount = [[noteAry objectAtIndex:numAry.count-1] intValue];
    [self pickResultLabelRefresh:noteCount];
    
    if (noteCount == 0) {
        return;
    }
    NSString * redString =[numAry componentsJoinedByString:@","];
    NSString * codeString = @"";
    if (numAry.count ==num && num != 1) {
        codeString = [codeString stringByAppendingFormat:@"S|R%d|%@",num,[numAry componentsJoinedByString:@""]];
    }else{
        codeString = [NSString stringWithFormat:@"M|R%d|%@",num,[numAry componentsJoinedByString:@""]];
    }
    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
              redString,@"red",
              [NSNumber numberWithInt: noteCount],@"count",
              codeString,@"codeString",
              nil];

}
/*  前二直选 */
- (void)resultNormalFrontTwoSelectView
{
    NSArray * milAry = [self convertArrayWithStateArray:dragFirstArray];
    NSArray * thodAry = [self convertArrayWithStateArray:dragSecondArray];
    if (milAry.count ==0 || thodAry.count == 0) {
        [self pickResultLabelRefresh:0];

        return;
    }
    int noteCount = 0;
     noteCount = numZhuZhiWithDic(@{kWangWeiKey:milAry, kQianWeiKey:thodAry});
    [self pickResultLabelRefresh:noteCount];
    if (noteCount == 0) {
        return;
    }
    NSString * redString  = [NSString stringWithFormat:@"%@|%@",[milAry componentsJoinedByString:@","],[thodAry componentsJoinedByString:@","]];
    NSString * codeString;
    if (noteCount > 1 || (noteCount == 1 && ([milAry count] > 1 || [thodAry count] > 1))) {
       codeString = [NSString stringWithFormat:@"P|Q2|%@-%@",[milAry componentsJoinedByString:@""],[thodAry componentsJoinedByString:@""]];
    }
    else
        codeString = [NSString stringWithFormat:@"S|Q2|%@%@",[milAry componentsJoinedByString:@""],[thodAry componentsJoinedByString:@""]];
    
    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
              redString,@"red",
              [NSNumber numberWithInt: noteCount],@"count",
              codeString,@"codeString",
              nil];

}
/* 前三 自选 */
- (void)resultNormalFrontThreeSelectView:(NSMutableArray*)hundredArray
{
    NSArray * milAry = [self convertArrayWithStateArray:dragFirstArray];
    NSArray * thodAry = [self convertArrayWithStateArray:dragSecondArray];
    NSArray * hundAry =[self convertArrayWithStateArray:hundredArray];
    if (milAry.count ==0 || thodAry.count ==0 ||hundAry.count ==0) {
        [self pickResultLabelRefresh:0];

        return;
    }
    int noteCount = 0; //betcode:P|Q3|0102-030405-020304

    noteCount = numZhuZhiWithDic(@{kWangWeiKey:milAry, kQianWeiKey:thodAry, kBaiWeiKey:hundAry});
    [self pickResultLabelRefresh:noteCount];
    if (noteCount == 0) {
        return;
    }
    NSString * redString  = [NSString stringWithFormat:@"%@|%@|%@",[milAry componentsJoinedByString:@","],[thodAry componentsJoinedByString:@","],[hundAry componentsJoinedByString:@","]];
    NSString * codeString;
    if (noteCount > 1 || (noteCount == 1 && ([milAry count] > 1 || [thodAry count] > 1 || [hundAry count] > 1))) {
        codeString = [NSString stringWithFormat:@"P|Q3|%@-%@-%@",[milAry componentsJoinedByString:@""],[thodAry componentsJoinedByString:@""],[hundAry componentsJoinedByString:@""]];
    }
    else
        codeString = [NSString stringWithFormat:@"S|Q3|%@%@%@",[milAry componentsJoinedByString:@""],[thodAry componentsJoinedByString:@""],[hundAry componentsJoinedByString:@""]];
    
    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
              redString,@"red",
              [NSNumber numberWithInt: noteCount],@"count",
              codeString,@"codeString",
              nil];
}
/* 胆拖 任选二*/
- (void)drayResultSelectView
{
    NSArray * firstAry = [self convertArrayWithStateArray:dragFirstArray];
    NSArray * secondAry =[self convertArrayWithStateArray:dragSecondArray];
    if (firstAry.count==0||secondAry.count==0) {
        [self pickResultLabelRefresh:0];

        return;
    }
    int  noteCount = 0 ;
    int playType = [playTypeString intValue];
    NSString *codeType=@"";
    int baseBallCount = 2;
    switch (playType) {
        case 13: //任选二
            codeType = @"R2";
            baseBallCount = 2;
            break;
        case 14: // 任选3
            codeType = @"R3";
            baseBallCount = 3;
            break;
        case 15: //任选4
            codeType = @"R4";
            baseBallCount = 4;
            break;
        case 16: //任选5
            codeType = @"R5";
            baseBallCount = 5;
            break;
        case 17: // 任选6
            codeType = @"R6";
            baseBallCount = 6;
            break;
        case 18: // 任选7
            codeType = @"R7";
            baseBallCount = 7;
            break;
        case 19: //前二组选
            codeType = @"Z2";
            baseBallCount = 2;
            break;
        case 20: // 前三 组选
            codeType = @"Z3";
            baseBallCount = 3;
            break;
        default:
            break;
    }
    
    if (firstAry.count + secondAry.count >baseBallCount && firstAry.count>=1 && secondAry.count>=2) {
        noteCount = RYCChoose(baseBallCount - firstAry.count, secondAry.count);
    }
    [self pickResultLabelRefresh:noteCount];
    if (noteCount ==0) {
        return;
    }
    NSString * redString =[NSString stringWithFormat:@"%@#%@",[firstAry componentsJoinedByString:@","],[secondAry componentsJoinedByString:@","]];
    NSString * codeString = [NSString stringWithFormat:@"D|%@|%@-%@",codeType,[firstAry componentsJoinedByString:@""],[secondAry componentsJoinedByString:@""]];
    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
              redString,@"red",
              [NSNumber numberWithInt: noteCount],@"count",
              codeString,@"codeString",
              nil];
    
    
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

- (void)loginViewSuccessLogin
{
    
}

#pragma mark ------------- resultSelect
- (void)pickResultLabelRefresh:(int)count
{
    [selectResultView resultLabelRefreshCount:count];
}
- (void)pickSelectResultRefreshAction:(id)sender
{
    [self pickResultLabelRefresh:0];
    int playType = [playTypeString intValue];
    switch (playType) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        {
            PickBallView * pickBall         = (PickBallView *)[ballAreaView viewWithTag:
                                                             TagNormalSelectView100+playType];
            [pickBall clearBallState];
        }
            break;
        case 9:
        {
            PickBallView * pickBall         = (PickBallView *)[ballAreaView viewWithTag:
                                                             TagNormalFrontTwoSelectView150+1];
            [pickBall clearBallState];
            PickBallView * thodsPickBall    = (PickBallView *)[ballAreaView viewWithTag:
                                                             TagNormalFrontTwoSelectView150+2];
            [thodsPickBall clearBallState];
        }
            break;
        case 10:
        {
            PickBallView * pickBall         = (PickBallView *)[ballAreaView viewWithTag:
                                                             TagNormalSelectView100+9];
            [pickBall clearBallState];
            
        }
            break;
        case 11: //前三直选
        {
            PickBallView * pickBall         = (PickBallView *)[ballAreaView viewWithTag:
                                                       TagNormalFrontThreeSelectView200+1];
            [pickBall clearBallState];
            
            PickBallView * thodsPickBall    = (PickBallView *)[ballAreaView viewWithTag:
                                                            TagNormalFrontThreeSelectView200+2];
            [thodsPickBall clearBallState];
            PickBallView * hundredPickBall  = (PickBallView *)[ballAreaView viewWithTag:
                                                              TagNormalFrontThreeSelectView200+3];
            [hundredPickBall clearBallState];
        }
            break;
        case 12: //前三 组选
        {
            PickBallView * pickBall         = (PickBallView *)[ballAreaView viewWithTag:
                                                               TagNormalSelectView100+10];
            [pickBall clearBallState];
            
        }
            break;
        case 13: //胆拖 任选二
        {
            PickBallView * pickBall         = (PickBallView *)[ballAreaView viewWithTag:
                                                              TagDragSelectTwoView300+1];
            [pickBall clearBallState];
            PickBallView * thodPickBall     = (PickBallView *)[ballAreaView viewWithTag:
                                                               TagDragSelectTwoView300+2];
            [thodPickBall clearBallState];
        }
            break;
        case 14: // 胆拖 任选三
        {
            PickBallView * pickBall         = (PickBallView *)[ballAreaView viewWithTag:
                                                               TagDragSelectTwoView300+3];
            [pickBall clearBallState];
            PickBallView * thodPickBall     = (PickBallView *)[ballAreaView viewWithTag:
                                                               TagDragSelectTwoView300+4];
            [thodPickBall clearBallState];

        }
            break;
        case 15: // 胆拖 任选四
        {
            PickBallView * pickBall         = (PickBallView *)[ballAreaView viewWithTag:
                                                               TagDragSelectTwoView300+5];
            [pickBall clearBallState];
            PickBallView * thodPickBall     = (PickBallView *)[ballAreaView viewWithTag:
                                                               TagDragSelectTwoView300+6];
            [thodPickBall clearBallState];
        }
            break;
        case 16: // 胆拖 任选五
        {
            PickBallView * pickBall         = (PickBallView *)[ballAreaView viewWithTag:
                                                               TagDragSelectTwoView300+7];
            [pickBall clearBallState];
            PickBallView * thodPickBall     = (PickBallView *)[ballAreaView viewWithTag:
                                                               TagDragSelectTwoView300+8];
            [thodPickBall clearBallState];

        }
            break;
        case 17:  // 胆拖 任选六
        {
            PickBallView * pickBall         = (PickBallView *)[ballAreaView viewWithTag:
                                                               TagDragSelectSixView350+1];
            [pickBall clearBallState];
            PickBallView * thodPickBall     = (PickBallView *)[ballAreaView viewWithTag:
                                                               TagDragSelectSixView350+2];
            [thodPickBall clearBallState];
        }
            break;
        case 18: // 胆拖 任选七
        {
            PickBallView * pickBall         = (PickBallView *)[ballAreaView viewWithTag:
                                                               TagDragSelectSixView350+3];
            [pickBall clearBallState];
            PickBallView * thodPickBall     = (PickBallView *)[ballAreaView viewWithTag:
                                                               TagDragSelectSixView350+4];
            [thodPickBall clearBallState];
        }
            break;
        case 19: // 胆拖 前二组选
        {
            PickBallView * pickBall         = (PickBallView *)[ballAreaView viewWithTag:
                                                               TagDragSelectSixView350+5];
            [pickBall clearBallState];
            PickBallView * thodPickBall     = (PickBallView *)[ballAreaView viewWithTag:
                                                               TagDragSelectSixView350+6];
            [thodPickBall clearBallState];
        }
            break;
        case 20: // 胆拖 前三组选
        {
            PickBallView * pickBall         = (PickBallView *)[ballAreaView viewWithTag:
                                                               TagDragSelectSixView350+7];
            [pickBall clearBallState];
            PickBallView * thodPickBall     = (PickBallView *)[ballAreaView viewWithTag:
                                                               TagDragSelectSixView350+8];
            [thodPickBall clearBallState];
        }
            break;
        default:
            break;
    }
    
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
    if ([KISDictionaryHaveKey(itemDic, @"count") floatValue] > 10000) {
        [self showAlertWithMessage:@"单笔投注不能超过10000注!"];
        return;
    }
    [basketView pickTableViewArrayAddItem:itemDic];
    [self pickSelectResultRefreshAction:sender];
    itemDic = nil;
}
@end
