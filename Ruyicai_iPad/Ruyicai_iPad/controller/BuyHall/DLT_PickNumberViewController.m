//
//  DLT_PickNumberViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-14.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "DLT_PickNumberViewController.h"
#import "SetChaseStageTableView.h"

@interface DLT_PickNumberViewController ()

@end

@implementation DLT_PickNumberViewController
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
#pragma  mark ---------- controller

- (void)viewWillDisappear:(BOOL)animated
{
    if([m_timer isValid])
	{
		[m_timer invalidate];
		m_timer = nil;
	}
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self DLTPickNumViewTitle];//标题view
    [self DLTPickNumHeadView];//顶部view
    [self DLTPickViewOptionalView];//自选
    
    selectResultView =[[PickNumSelectResultView alloc]initWithFrame:CGRectMake(0, 612, BallViewWidth, 107)];
    selectResultView.delegate = self;
    [self.view addSubview:selectResultView];
    
    [self DLTPickNumberBasketView];//号码篮 view
    [self requestQueryLot];
    [self sendRequestLotteryInfoWithLotNo:kLotNoDLT];
}
- (void)dealloc{
    self.delegate = nil;
    [numberDataArray release],numberDataArray = nil;

    [DLTBallView release];
    [DLTOptionalView release];
    [DLTDragView release];
    
    [playSelectView release];
    [selectResultView release];
    [numBasketView release];
    
    [beforeAreaView release];
    [behindAreaView release];
    [beforeD release];
    [beforeG release];
    [behindDView release];
    [behindGView release];
    
    [optionalBeforeArray release];
    [optionalBehindArray release];
    [dragBeforeDanmaArray release];
    [dragBeforeTuomaArray release];
    [dragBehindDanmaArray release];
    [dragBehindTuomaArray release];
    [itemDic release];
    [messDetailView release];
    [super dealloc];


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ----------- view create
/* 标题栏 */
- (void)DLTPickNumViewTitle
{
    [super tabBarBackgroundImageViewWith:self.view];
    
    narViewBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    narViewBtn.frame = CGRectMake(335, 15, 238, 40);
    [narViewBtn setTitle:@"大乐透 - 自选  ▼" forState:UIControlStateNormal];
    narViewBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [narViewBtn setBackgroundImage:RYCImageNamed(@"top_qiehuan.png") forState:btnNormal];
    [narViewBtn setTitleColor:[UIColor whiteColor] forState:btnNormal];
    [narViewBtn addTarget:self action:@selector(DLTNarViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:narViewBtn];
    viewShowType = @"1";
    
    UIButton * DLTPlayBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    DLTPlayBtn.frame = CGRectMake(self.view.frame.size.height-200, 10, 50, 50);
    [DLTPlayBtn setImage:RYCImageNamed(@"pickNum_right.png") forState:UIControlStateNormal];
    [DLTPlayBtn addTarget:self action:@selector(DLTPlayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:DLTPlayBtn];
    
}
/* 顶部 */
- (void)DLTPickNumHeadView
{
    // 头部视图
    UIView * headView =[[UIView alloc]initWithFrame:CGRectMake(0, 69, 908, 77)];
    headView.backgroundColor = RGBCOLOR(244, 244, 244);
    [self.view addSubview:headView];
    [headView release];
    
    UIImageView * kindImg               = [[UIImageView alloc]initWithFrame:CGRectMake(80, 10, 60, 60)];
    kindImg.image = RYCImageNamed(@"dlt");
    [headView addSubview:kindImg];
    
    //返回按钮
    UIButton * DLTBackBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    DLTBackBtn.frame = CGRectMake(0, 1, 76, 76);
    [DLTBackBtn setImage:RYCImageNamed(@"backBtn-nor.png") forState:btnNormal];
    [DLTBackBtn setImage:RYCImageNamed(@"backBtn-click.png") forState:btnSelect];    [DLTBackBtn addTarget:self action:@selector(DLTPickViewBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:DLTBackBtn];
#define TagBeforeIssuerLabel102 102
#define TagbePrizeLabel103 103
#define TagBeBlueLabel303 303
    // 上期开奖
    UILabel * beforeIssueLaebl =[[UILabel alloc]initWithFrame:CGRectMake(250, 10, 200, 30)];
    beforeIssueLaebl.backgroundColor = [UIColor clearColor];
    beforeIssueLaebl.tag = TagBeforeIssuerLabel102;
    [headView addSubview:beforeIssueLaebl];
    [beforeIssueLaebl release];

    UILabel * bePrizeLabel =[[UILabel alloc]initWithFrame:CGRectMake(beforeIssueLaebl.frame.origin.x+beforeIssueLaebl.frame.size.width+20, beforeIssueLaebl.frame.origin.y, 120, 30)];
    bePrizeLabel.tag = TagbePrizeLabel103;
    bePrizeLabel.backgroundColor = [UIColor clearColor];
    bePrizeLabel.textColor = [UIColor redColor];
    [headView addSubview:bePrizeLabel];
    [bePrizeLabel release];
    
    UILabel * blueLabel = [[UILabel alloc]initWithFrame:CGRectMake(bePrizeLabel.frame.size.width+bePrizeLabel.frame.origin.x, bePrizeLabel.frame.origin.y, 45, bePrizeLabel.frame.size.height)];
    blueLabel.textColor = [UIColor blueColor];
    blueLabel.backgroundColor = [UIColor clearColor];
    blueLabel.tag = TagBeBlueLabel303;
    [headView addSubview:blueLabel];
    [blueLabel release];
    
    
#define TagThisIssLabel104 104
    //这期倒计时
    UILabel * thisIssueLabel =[[UILabel alloc]initWithFrame:CGRectMake(beforeIssueLaebl.frame.origin.x, 40, beforeIssueLaebl.frame.size.width, 30)];
    thisIssueLabel.tag = TagThisIssLabel104;
    thisIssueLabel.backgroundColor = [UIColor clearColor];
    [headView addSubview:thisIssueLabel];
    [thisIssueLabel release];
#define TagThisEndLabel105 105
    UILabel * thisEndLabel =[[UILabel alloc]initWithFrame:CGRectMake(thisIssueLabel.frame.origin.x + thisIssueLabel.frame.size.width +20, thisIssueLabel.frame.origin.y, 200, 30)];
    thisEndLabel.tag = TagThisEndLabel105;
    thisEndLabel.backgroundColor = [UIColor clearColor];
    thisEndLabel.textColor = [UIColor redColor];
    [headView addSubview:thisEndLabel];
    [thisEndLabel  release];
}
/* 自选 */
- (void)DLTPickViewOptionalView
{
    DLTBallView = [[UIView alloc]initWithFrame:CGRectMake(0, 146,BallViewWidth, 472)];
    DLTBallView.backgroundColor = RGBCOLOR(255, 255, 255);
    [self.view addSubview:DLTBallView];
    
    //自选
    DLTOptionalView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,BallViewWidth, 450)];
    DLTOptionalView.backgroundColor = [UIColor clearColor];
    
    beforeAreaView =[[PickBallView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 200)];
    [beforeAreaView ballViewCreateStartValue:1 ballCount:35 perLine:12 leastNum:5 selectMaxNum:18 ballType:Ball_Red];
    [beforeAreaView ballVIewTitle:@"前区:"];
    [beforeAreaView ballViewAutoSelectWithStart:5 maxNum:18 perLine:12];
    beforeAreaView.delegate = self;
    [DLTOptionalView addSubview:beforeAreaView];
    
    behindAreaView = [[PickBallView alloc]initWithFrame:CGRectMake(0, 200, BallViewWidth, 200)];
    
    [behindAreaView ballViewCreateStartValue:1 ballCount:12 perLine:12 leastNum:2 selectMaxNum:12 ballType:Ball_Blue];
    [behindAreaView ballVIewTitle:@"后区"];
    [behindAreaView ballViewAutoSelectWithStart:2 maxNum:12 perLine:12];
    behindAreaView.delegate = self;
    [DLTOptionalView addSubview:behindAreaView];
    
    [DLTBallView addSubview:DLTOptionalView];

    
    // 胆拖
    if (!DLTDragView) {
        DLTDragView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 470)];
        DLTDragView.contentSize = CGSizeMake(BallViewWidth, 600);
        DLTDragView.backgroundColor = RGBCOLOR(255, 255, 255);
        
        beforeD =[[PickBallView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 200)];
        [beforeD ballViewCreateStartValue:1 ballCount:35 perLine:12 leastNum:1 selectMaxNum:4 ballType:Ball_Red];
        [beforeD ballSumViewTitle:@"前区胆码: (请选择0~4个)"];
//        [beforeD ballViewAutoSelectWithStart:1 maxNum:4 perLine:12];
        beforeD.delegate = self;
        [DLTDragView addSubview:beforeD];
        
        beforeG = [[PickBallView alloc]initWithFrame:CGRectMake(0, 200, BallViewWidth, 200)];
        [beforeG ballViewCreateStartValue:1 ballCount:35 perLine:12 leastNum:1 selectMaxNum:22 ballType:Ball_Red];
        [beforeG ballSumViewTitle:@"前区拖码: (请选择1~22个)"];
//        [beforeG ballViewAutoSelectWithStart:1 maxNum:22 perLine:12];
        beforeG.delegate = self;
        [DLTDragView addSubview:beforeG];
        
        behindDView =[[PickBallView alloc]initWithFrame:CGRectMake(0, beforeG.frame.size.height+beforeG.frame.origin.y, BallViewWidth, 100)];
        [behindDView ballViewCreateStartValue:1 ballCount:12 perLine:12 leastNum:1 selectMaxNum:1 ballType:Ball_Blue];
        [behindDView ballSumViewTitle:@"后区胆码: (请选择0~1个）"];
//        [behindDView ballViewAutoSelectWithStart:1 maxNum:1 perLine:12];
        behindDView.delegate = self;
        [DLTDragView addSubview:behindDView];
        
        behindGView =[[PickBallView alloc]initWithFrame:CGRectMake(0, behindDView.frame.origin.y +behindDView.frame.size.height, BallViewWidth, 100)];
        [behindGView ballViewCreateStartValue:1 ballCount:12 perLine:12 leastNum:1 selectMaxNum:12 ballType:Ball_Blue];
        [behindGView ballSumViewTitle:@"后区拖码: (请选择1~12个)"];
//        [behindGView ballViewAutoSelectWithStart:1 maxNum:12 perLine:12];
        behindGView.delegate = self;
        [DLTDragView addSubview:behindGView];
    }

    
}

#define TagMessageDetail150 150
/* 号码篮 */
- (void)DLTPickNumberBasketView
{
    //号码篮 整体视图
    numBasketView =[[PickNumBasketView alloc]initWithFrame:CGRectMake(600, 147, 308, 574)];
    NSArray * itemArray =@[@"投注",@"追号",@"合买",@"赠送",];
    numBasketView.delegate = self;
    [numBasketView pickNumberBasketViewItem:itemArray];
    [self.view addSubview:numBasketView];
}
#pragma  mark ----------- view  methods
/* 自选 机选 */
#define TAG_PALT_BUTTON200 200
- (void)DLTNarViewButtonAction:(id)sender
{
    if (! playSelectView) {
        
        playSelectView = [[UIView alloc]initWithFrame: CGRectMake(self.view.frame.size.width/2-107, 60, 214, 140)];
        
        UIImageView * bgView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, playSelectView.frame.size.width, playSelectView.frame.size.height)];
        bgView.image = RYCImageNamed(@"playSelect_bg.png");
        [playSelectView  addSubview:bgView];
        [bgView release];
        
        UIButton *firstButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        firstButton.frame = CGRectMake((214 - 150)/2, 30, 150, 41);
        [firstButton setTitle:@"大乐透 - 自选"forState:UIControlStateNormal];
        firstButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [firstButton setBackgroundImage:RYCImageNamed(@"playBtnNro.png") forState:btnNormal];
        [firstButton setBackgroundImage:RYCImageNamed(@"playSelectClick") forState:UIControlStateSelected];
        [firstButton setTitleColor:RGBCOLOR(0, 0, 0) forState:btnNormal];
        [firstButton setTitleColor:RGBCOLOR(255, 255, 255) forState:btnSelect];
        firstButton.selected = YES;
        firstButton.tag = TAG_PALT_BUTTON200 +1;
        [firstButton addTarget:self action:@selector(playSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [playSelectView addSubview:firstButton];
        
        UIButton *secondButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        secondButton.frame = CGRectMake((214 - 150)/2, 80, 150, 41);
        [secondButton setBackgroundImage:RYCImageNamed(@"playBtnNro.png") forState:btnNormal];
        [secondButton setBackgroundImage:RYCImageNamed(@"playSelectClick") forState:UIControlStateSelected];
        [secondButton setTitleColor:RGBCOLOR(0, 0, 0) forState:btnNormal];
        [secondButton setTitleColor:RGBCOLOR(255, 255, 255) forState:btnSelect];
        secondButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        secondButton.tag = TAG_PALT_BUTTON200 + 2;
        [secondButton setTitle:@"大乐透 - 胆拖" forState:UIControlStateNormal];
        [secondButton addTarget:self action:@selector(playSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [playSelectView addSubview:secondButton];
        
        [self.view addSubview:playSelectView];
        playSelectView.hidden = YES;

    }
    playSelectView.hidden = !playSelectView.hidden ;
//    
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
- (void)DLTPlayButtonAction:(id)sender
{
    
    if (!messDetailView) {
        messDetailView = [[UIView alloc]init];
        messDetailView.frame= CGRectMake(670, 70, 223, 119);
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
            introButton.tag = TagMessageDetail150 + i;
            [introButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            introButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            [introButton addTarget:self action:@selector(playIntroButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [messDetailView addSubview:introButton];
            
        }
        [narArray release];
        [self.view addSubview:messDetailView];
        messDetailView.hidden = YES;
    }
    messDetailView.hidden = !messDetailView.hidden;
    
    
//        CATransition *transition = [CATransition animation];
//        transition.duration = .5;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionPush;//{ kCATransitionPush, kCATransitionMoveIn, kCATransitionReveal, kCATransitionFade }
//        if(messDetailView.hidden)
//        {
//            transition.subtype = kCATransitionFromBottom;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
//            [messDetailView.layer addAnimation:transition forKey:nil];
//            messDetailView.hidden = NO;
//        }
//        else
//        {
//            transition.subtype = kCATransitionFromTop;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
//            [messDetailView.layer addAnimation:transition forKey:nil];
//            messDetailView.hidden = YES;
//        }

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
            introduce.introduceLotNo = kLotNoDLT;
            introduce.delegate = self;
            introduce.view.frame = CGRectMake(463, 0, 467, 735);
            [self.view addSubview:introduce.view];
            messageView = introduce.view;
        }
            break;
        case 1:
        {
            BuyLotteryNumberViewController * buyLottery =[[BuyLotteryNumberViewController alloc]init];
            buyLottery.numLotNo = kLotNoDLT;
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
/* 返回*/
- (void)DLTPickViewBackButtonAction:(id)sender
{
    [self.delegate DLT_PickNumberViewDisappear:self];
}
- (void)playSelectButtonAction:(id)sender
{
    UIButton * button = (UIButton *)sender;
    int index = button.tag - TAG_PALT_BUTTON200;
    UIButton * firBtn = (UIButton *)[playSelectView viewWithTag:TAG_PALT_BUTTON200+1];
    UIButton * sceBtn = (UIButton *)[playSelectView viewWithTag:TAG_PALT_BUTTON200+2];
    if (index == 2) {
        firBtn.selected = NO;
        sceBtn.selected = YES;
        [narViewBtn setTitle:@"大乐透 - 胆拖  ▼" forState:btnNormal];
        [DLTOptionalView removeFromSuperview];
        [DLTBallView addSubview: DLTDragView];
        viewShowType = @"2";
        
    }else{
        firBtn.selected = YES;
        sceBtn.selected = NO;
        [narViewBtn setTitle:@"大乐透 - 自选  ▼" forState:btnNormal];
        [DLTDragView removeFromSuperview];
        [DLTBallView addSubview:DLTOptionalView];
        viewShowType = @"1";
    }
    playSelectView.hidden = YES;
    [self resultSelectRefreshDrag];//刷新注数
}
#pragma mark =================== notification 
- (void)requestQueryLot
{
    NSMutableDictionary * mDic =[[[NSMutableDictionary alloc]init]autorelease];
    [mDic setObject:@"QueryLot" forKey:@"command"];
    [mDic setObject:@"highFrequency" forKey:@"type"];
    [mDic setObject:kLotNoDLT forKey:@"lotno"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDic withRequestType:ASINetworkRequestTypeLeftTime showProgress:NO];
}

- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkRequestTypeLeftTime:
        {
            [self DLTIssueAndTimeDataRequest:dataDic];

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
    UILabel *issuelabel = (UILabel *)[self.view viewWithTag:TagBeforeIssuerLabel102];
    issuelabel.text = [NSString stringWithFormat:@"第%@期开奖号码:", oldBatchCode];
    
    NSString * winCodeStr = KISDictionaryHaveKey(dic, @"winCode");
    NSArray * ballAry = [super lotteryBallDLTNumberString:winCodeStr];
    NSMutableString  * beRedString = [[NSMutableString alloc]init];
    for (int i=0; i<ballAry.count; i++) {
        [beRedString appendFormat:@"%@,",[ballAry objectAtIndex:i]];
    }
    UILabel * prizeLabel = (UILabel *)[self.view viewWithTag:TagbePrizeLabel103];
    prizeLabel.text = [beRedString substringToIndex:15];
    
    UILabel * blueLabel = (UILabel *)[self.view viewWithTag:TagBeBlueLabel303];
    blueLabel.text = [beRedString substringWithRange:NSMakeRange(15, 5)];
    [beRedString release];
}
- (void)DLTIssueAndTimeDataRequest:(NSDictionary *)mDic
{
    if (![KISDictionaryHaveKey(mDic, @"lotNo") isEqualToString:kLotNoDLT]) {
        issueString = @"";
        return;
    }
    self.batchEndTime = KISDictionaryHaveKey(mDic, @"time_remaining");
    
    issueString = [[NSString alloc]initWithString:KISDictionaryHaveKey(mDic, @"batchcode")];
    UILabel * thisIssLabel = (UILabel *)[self.view viewWithTag:TagThisIssLabel104];
    thisIssLabel.text = [NSString stringWithFormat:@"离%@期截止还剩：",issueString];
    
    [numBasketView getThisLotNoString:kLotNoDLT andThisBatchString:issueString];

    numBasketView.lotNo = kLotNoDLT;
    
    UILabel *thisEndLabel = (UILabel *)[self.view viewWithTag:TagThisEndLabel105];
    
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
    UILabel *thisEndLabel = (UILabel *)[self.view viewWithTag:TagThisEndLabel105];
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
        [mDict setObject:kLotNoDLT forKey:@"lotno"];
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
#pragma mark -------------- resultSelect
/* 胆拖 注数 */
- (void)resultSelectRefreshDrag
{
    NSMutableArray *beforeArray = nil;
    NSMutableArray *behindArray = nil;
    NSString * redString = nil;
    NSString * blueString = nil;
    NSString * codeString = nil;
    int m_numZhu = 0;
    
    if ([viewShowType isEqualToString:@"1"]) {
        NSArray *arrayf = [self convertArrayWithStateArray:optionalBeforeArray];
        beforeArray = [[NSMutableArray alloc]initWithArray:arrayf];
        NSArray *arrayh = [self convertArrayWithStateArray:optionalBehindArray];
        behindArray = [[NSMutableArray alloc]initWithArray:arrayh];
        if (arrayf.count ==0 ||arrayh.count == 0) {
            return;
        }
        redString = [arrayf componentsJoinedByString:@","];
        blueString = [arrayh componentsJoinedByString:@","];
        codeString = [NSString stringWithFormat:@"%@-%@",[arrayf componentsJoinedByString:@" "],[arrayh componentsJoinedByString:@" "]];
        if (beforeArray.count >=5 && behindArray.count >=2 )
        {
            m_numZhu = RYCChoose(5, beforeArray.count) * RYCChoose(2, behindArray.count);
        }
        [beforeArray release];
        [behindArray release];
        
    }else{
        NSArray * beforeDAry = [self convertArrayWithStateArray:dragBeforeDanmaArray];
        NSArray * beforeGAry = [self convertArrayWithStateArray:dragBeforeTuomaArray];
        
        NSArray * behindD = [self convertArrayWithStateArray:dragBehindDanmaArray];
        NSArray * behindG = [self convertArrayWithStateArray:dragBehindTuomaArray];
        
        int nRedDanBalls = [beforeDAry count];
        int nRedTuoBalls = [beforeGAry count];
        int nBlueDanBalls = [behindD count];
        int nBuleTuoBalls = [behindG count];
//        if (nRedDanBalls==0 || nRedTuoBalls ==0 ||nBlueDanBalls == 0 || nBuleTuoBalls ==0) {
//            return;
//        }
        //注数 = ((5 - 胆码红球数量), 托码数量) * 蓝球数量
        if ((nRedDanBalls + nBlueDanBalls != 0) && (nRedTuoBalls + nBuleTuoBalls != 0))
        {
            m_numZhu = RYCChoose((5-nRedDanBalls), nRedTuoBalls) * RYCChoose((2-nBlueDanBalls), nBuleTuoBalls);
        }
        else
        {
            m_numZhu = 0;
        }
        
        if (nRedDanBalls + nRedTuoBalls < 6 ||
            nBlueDanBalls +nBuleTuoBalls < 2 ||
            nRedDanBalls < 1)
        {
            m_numZhu = 0;
        }

        NSString * dstring = [beforeDAry componentsJoinedByString:@","];
        NSString * gstring = [beforeGAry componentsJoinedByString:@","];
        redString =[NSString stringWithFormat:@"%@#%@",dstring,gstring];
        
        NSString *dStr = [behindD componentsJoinedByString:@","];
        NSString *gStr = [behindG componentsJoinedByString:@","];
        blueString = [NSString stringWithFormat:@"%@#%@",dStr,gStr];
        
        if (nBlueDanBalls == 0) {
            codeString = [NSString stringWithFormat:@"%@$%@-%@",[beforeDAry componentsJoinedByString:@" "],[beforeGAry componentsJoinedByString:@" "],[behindG componentsJoinedByString:@" "]];
        }
        else if(nBuleTuoBalls == 1)//后区 胆一个 拖一个
        {
            codeString = [NSString stringWithFormat:@"%@$%@-%@ %@",[beforeDAry componentsJoinedByString:@" "],[beforeGAry componentsJoinedByString:@" "],[behindD componentsJoinedByString:@" "],[behindG componentsJoinedByString:@" "]];
        }
        else
        {
            codeString = [NSString stringWithFormat:@"%@$%@-%@$%@",[beforeDAry componentsJoinedByString:@" "],[beforeGAry componentsJoinedByString:@" "],[behindD componentsJoinedByString:@" "],[behindG componentsJoinedByString:@" "]];
        }

    }
    [self pickResultLabelRefresh:m_numZhu];
    if (m_numZhu == 0) {
        return;
    }
    if (m_numZhu >0) {
        itemDic  =[[NSDictionary alloc] initWithObjectsAndKeys:
                   [redString stringByAppendingFormat:@"|%@", blueString],@"red",
                   [NSNumber numberWithInt: m_numZhu],@"count",
                   codeString,@"codeString",
                   nil];
    }
}
#pragma mark ------------ ball delegate
- (void)ballViewResultArray:(NSMutableArray *)array selectView:(PickBallView *)ballView
{
    itemDic = nil;
    if ([viewShowType isEqualToString:@"1"])
    {
        if ([ballView isEqual:beforeAreaView]) {
            optionalBeforeArray = [array retain];
        }
        if (ballView == behindAreaView) {
            optionalBehindArray = [array retain];
        }
    }else
    {
        if (ballView == beforeD) { // 前区胆码
//            dragBeforeDanmaArray = [array retain];
//            
//            [beforeG ballViewDifferentNumber:[self numberArrayTuomaDanmaDifferentDanmaArray:dragBeforeDanmaArray tuomaArray:dragBeforeTuomaArray]];
            if ([beforeG stateForIndex:ballView.currentPickIndex]) {
                [beforeG resetStateForIndex:ballView.currentPickIndex];
            }
            dragBeforeDanmaArray = [beforeD.ballStateArray retain];
            dragBeforeTuomaArray = [beforeG.ballStateArray retain];
        }
        if (ballView == beforeG) { // 前区拖码
//            dragBeforeTuomaArray = [array retain];
//            
//            [beforeD ballViewDifferentNumber:[self numberArrayTuomaDanmaDifferentDanmaArray:dragBeforeDanmaArray tuomaArray:dragBeforeTuomaArray]];
            if ([beforeD stateForIndex:ballView.currentPickIndex]) {
                [beforeD resetStateForIndex:ballView.currentPickIndex];
            }
            dragBeforeDanmaArray = [beforeD.ballStateArray retain];
            dragBeforeTuomaArray = [beforeG.ballStateArray retain];
        }
        
        if (ballView == behindDView) { //后区胆码
            
//            dragBehindDanmaArray = [array retain];
//            [behindGView ballViewDifferentNumber:[self numberArrayTuomaDanmaDifferentDanmaArray:dragBehindDanmaArray tuomaArray:dragBehindTuomaArray]];
            if ([behindGView stateForIndex:ballView.currentPickIndex]) {
                [behindGView resetStateForIndex:ballView.currentPickIndex];
            }
            dragBehindDanmaArray = [behindDView.ballStateArray retain];
            dragBehindTuomaArray = [behindGView.ballStateArray retain];
        }
        
        if (ballView == behindGView) { //后区拖码
            if ([behindDView stateForIndex:ballView.currentPickIndex]) {
                [behindDView resetStateForIndex:ballView.currentPickIndex];
            }
            dragBehindDanmaArray = [behindDView.ballStateArray retain];
            dragBehindTuomaArray = [behindGView.ballStateArray retain];
//            dragBehindTuomaArray = [array retain];
//            [behindDView  ballViewDifferentNumber:[self numberArrayTuomaDanmaDifferentDanmaArray:dragBehindDanmaArray tuomaArray:dragBehindTuomaArray]];
        }

    }
       [self resultSelectRefreshDrag];
}
#pragma mark ---------- selectResult
- (void)pickResultLabelRefresh:(int)count
{
    [selectResultView resultLabelRefreshCount:count];
}
- (void)pickSelectResultRefreshAction:(id)sender
{
    if ([viewShowType isEqualToString:@"1"])
    {
        [beforeAreaView clearBallState];
        [behindAreaView clearBallState];
    }else
    {
        
        [beforeD clearBallState];
        [beforeG clearBallState];
        [behindDView clearBallState];
        [behindGView clearBallState];
    }
    [self pickResultLabelRefresh:0];
}

- (void)pickselectResultAddToBaskAction:(id)sender
{
    if (itemDic ==nil ||[[itemDic objectForKey:@"count"] intValue]==0) {
        [self showAlertWithMessage:@"请至少选择一注进行添加!"];
        return;
    }
    if ([KISDictionaryHaveKey(itemDic, @"count") floatValue] > 10000) {
        [self showAlertWithMessage:@"单笔投注不能超过10000注!"];
        return;
    }
    [numBasketView pickTableViewArrayAddItem:itemDic];
    [self pickSelectResultRefreshAction:sender];
    itemDic = nil;
}
/* 判断 拖码 胆码的数字不重复*/
- (NSMutableArray *)numberArrayTuomaDanmaDifferentDanmaArray:(NSMutableArray *)damArray tuomaArray:(NSMutableArray *)tuoArray
{
    NSMutableArray * numAry = [[NSMutableArray alloc]init];
    NSArray * dArray =[self convertArrayWithStateArray:damArray];
    NSArray * tArray = [self convertArrayWithStateArray:tuoArray];
    DLog(@" dArray %@ tArray%@",dArray,tArray);
    if (dArray.count ==0 || tArray.count == 0) {
        return nil;
    }
    for (int i=0; i<dArray.count; i++) {
        for (int j=0; j<tArray.count; j++) {
            if ([[dArray objectAtIndex:i] isEqual:[tArray objectAtIndex:j]]) {
                [numAry addObject:[dArray objectAtIndex:i]];
            }
        }
    }
    return [numAry autorelease];
}
@end
