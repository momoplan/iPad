//
//  TicketKindViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-6-28.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "TicketKindViewController.h"

//彩票 投注信息
#import "RuYiCaiLotDetail.h"

#define TAG_SSQ_KIND 100
#define TagPickBallView150 150
#define TagHeadBlueLabel201 201

@interface TicketKindViewController ()
{
    UIButton *narBarViewButton; //中间导航按钮
    
    UIView *titleSelectView; //玩法选择view
    
    UIView * moreMessageView; //上面信息view
    
}
@end

@implementation TicketKindViewController
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

- (void)dealloc{
    [beforeIssueLaebl release];
    [bePrizeLabel release];
    [numberLabel release];
    [thisEndLabel release];
    
    [issueString release];
    
    [ballViewBg release];
    [BallDirectView release];
    [BallDragView release];
    
    [pickBaesketView release];
    [selectResult release];

    [redDanArray release];
    [redTuoArray release];
    [bluePickArray release];
    [itemDic release];
    
     [titleSelectView release];
    [moreMessageView release];
    
    [batchEndTime release]; batchEndTime = nil;
   
    [super dealloc];

    
    





}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
    /// 导航设置
    [self createNarbarView];
    //设置上边信息view
    [self headMessageView];
    [self setBallView];
    //设置 选择结果区
    [self setSelectBallResultView];
    
    pickBaesketView =[[PickNumBasketView alloc]initWithFrame:CGRectMake(600, 145, 308, 574)];
    pickBaesketView.delegate = self;
    NSArray * itemArray =@[@"投注",@"追号",@"合买",@"赠送",];
    [pickBaesketView pickNumberBasketViewItem:itemArray];
    [self.view addSubview:pickBaesketView];
    
    [self ssqrequestQueryLot];
    [self sendRequestLotteryInfo];
//    self.view.backgroundColor = RGBCOLOR(255, 255, 255);

}
#pragma mark ---------- RYCNetManager delegate
- (void)ssqrequestQueryLot
{
    NSMutableDictionary *mDict =[[[NSMutableDictionary alloc]init]autorelease];
    [mDict setObject:kLotNoSSQ forKey:@"lotno"];
	[mDict setObject:@"highFrequency" forKey:@"type"];
    [mDict setObject:@"QueryLot" forKey:@"command"];
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkRequestTypeLeftTime showProgress:NO];

}
- (void)sendRequestLotteryInfo
{
    NSMutableDictionary* mDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [mDict setObject:@"QueryLot" forKey:@"command"];
    [mDict setObject:@"winInfoList" forKey:@"type"];
    [mDict setObject:@"1" forKey:@"maxresult"];
    [mDict setObject:@"1" forKey:@"pageindex"];
    [mDict setObject:kLotNoSSQ forKey:@"lotno"];
    //    ASINetworkRequestTypeGetLotteryInfo
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkRequestTypeGetLotteryInfo showProgress:NO];
}
- (void)netSuccessWithResult:(NSDictionary*)dataDic tag:(NSInteger)requestTag
{
    switch (requestTag) {
        case ASINetworkRequestTypeLeftTime:
            [self getBatchCodeOfLot:dataDic];
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
- (void)getBeforeIssueMessageInfo:(NSDictionary *)messInfo
{
    NSArray * resultAry = KISDictionaryHaveKey(messInfo, @"result");
    NSDictionary * dic = [resultAry objectAtIndex:0];
    NSString * oldBatchCode = KISDictionaryHaveKey(dic, @"batchCode");
    beforeIssueLaebl.text = [NSString stringWithFormat:@"第%@期开奖号码:", oldBatchCode];
    
    NSString * winCodeStr = KISDictionaryHaveKey(dic, @"winCode");
    NSArray * ballAry = [super lotteryCellBallDoubleNumberString:winCodeStr];
    NSMutableString  * beRedString = [[NSMutableString alloc]init];
    for (int i=0; i<ballAry.count; i++) {
        [beRedString appendFormat:@"%@,",[ballAry objectAtIndex:i]];
    }
    bePrizeLabel.text = [beRedString substringToIndex:18];
   
    UILabel *blueLabel = (UILabel *)[self.view viewWithTag:TagHeadBlueLabel201];
    blueLabel.text = [beRedString substringWithRange:NSMakeRange(18, 2)];
    [beRedString release];
}
- (void)getBatchCodeOfLot:(NSDictionary *)parserDict
{
//    DLog(@"parserDict %@",parserDict);
    if (![KISDictionaryHaveKey(parserDict, @"lotNo") isEqualToString:kLotNoSSQ]) {
        issueString = @"";
        return;
    }
    self.batchEndTime = [parserDict objectForKey:@"time_remaining"];//剩余秒数
    issueString = [[NSString alloc]initWithString:KISDictionaryHaveKey(parserDict, @"batchcode")];
    
    numberLabel.text = [NSString stringWithFormat:@"离%@期截止还剩：",issueString] ;
   
    [pickBaesketView getThisLotNoString:kLotNoSSQ andThisBatchString:issueString];
    pickBaesketView.lotNo = kLotNoSSQ;
    pickBaesketView.thisBatchCode = issueString;
    
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
		m_timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(refreshLeftTime)
												 userInfo:nil repeats:YES];
	}
}
- (void)refreshLeftTime
{
    if (0 == self.batchEndTime.length)
    {
        return;
    }
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
        [mDict setObject:kLotNoSSQ forKey:@"lotno"];
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

#pragma mark ------------- self Create view
/// 导航设置
- (void)createNarbarView
{
    //导航 按钮
    
    
    [super tabBarBackgroundImageViewWith:self.view];
    
    narBarViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    narBarViewButton.frame = CGRectMake(335, 15, 238, 40);
    [narBarViewButton setTitle:@"双色球-自选 ▼" forState:UIControlStateNormal];
    narBarViewButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [narBarViewButton setBackgroundImage:RYCImageNamed(@"top_qiehuan.png") forState:btnNormal];
    [narBarViewButton setTitleColor:[UIColor whiteColor] forState:btnNormal];
    [narBarViewButton addTarget:self action:@selector(SSQnarViewTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:narBarViewButton];
    
    
    UIButton *playButton =[UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake(self.view.frame.size.width-200, 10, 50, 50);
    [playButton setImage:RYCImageNamed(@"pickNum_right.png") forState:btnNormal];
    [playButton addTarget:self action:@selector(SSQnarBarButtonEvent:) forControlEvents:btnTouch];
    [self.view addSubview:playButton];

}
//消除当前视图
- (void)backToSuperView
{
    [self.delegate  disMissTicketKindViewController:self];    
}

- (void)headMessageView
{
    UIView * headView =[[UIView alloc]initWithFrame:CGRectMake(0, 68, 908, 77)];
    headView.backgroundColor = RGBCOLOR(244, 244, 244);
    [self.view addSubview:headView];
    [headView release];
    
    UIImageView * kindImg               = [[UIImageView alloc]initWithFrame:CGRectMake(80, 10, 60, 60)];
    kindImg.image = RYCImageNamed(@"ssq");
    [headView addSubview:kindImg];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 76, 76);
    [backBtn setBackgroundImage:RYCImageNamed(@"backBtn-nor.png") forState:btnNormal];
    [backBtn setImage:RYCImageNamed(@"backBtn-click.png") forState:btnSelect];
    [backBtn addTarget:self action:@selector(backToSuperView) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:backBtn];
    
    beforeIssueLaebl =[[UILabel alloc]initWithFrame:CGRectMake(250, 10, 200, 30)];
    beforeIssueLaebl.backgroundColor = [UIColor clearColor];
    [headView addSubview:beforeIssueLaebl];
    
    bePrizeLabel =[[UILabel alloc]initWithFrame:CGRectMake(beforeIssueLaebl.frame.origin.x+beforeIssueLaebl.frame.size.width, beforeIssueLaebl.frame.origin.y, 145, 30)];
    bePrizeLabel.backgroundColor = [UIColor clearColor];
    bePrizeLabel.textColor = [UIColor redColor];
    [headView addSubview:bePrizeLabel];
    
    UILabel * blueLabel = [[UILabel alloc]initWithFrame:CGRectMake(bePrizeLabel.frame.size.width+bePrizeLabel.frame.origin.x, bePrizeLabel.frame.origin.y, 20, bePrizeLabel.frame.size.height)];
    blueLabel.textColor = [UIColor blueColor];
    blueLabel.backgroundColor = [UIColor clearColor];
    blueLabel.tag = TagHeadBlueLabel201;
    [headView addSubview:blueLabel];
    [blueLabel release];
    
    
    numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 40, 200, 30)];
    numberLabel.text = @"离截止还剩：";
    numberLabel.backgroundColor =[UIColor clearColor];
    [headView addSubview:numberLabel];
    
    thisEndLabel =[[UILabel alloc]initWithFrame:CGRectMake(numberLabel.frame.size.width+numberLabel.frame.origin.x, numberLabel.frame.origin.y, 200, 30)];
    thisEndLabel.backgroundColor =[UIColor clearColor];
    thisEndLabel.textColor = [UIColor redColor];
    [headView addSubview:thisEndLabel];
    
}
- (void)setBallView
{
    ballViewBg =[[UIView alloc]initWithFrame:CGRectMake(0, 145, 600, 474)];
    ballViewBg.backgroundColor =RGBCOLOR(255, 255, 255);
    [self.view addSubview:ballViewBg];
    [ballViewBg release];

    /* 自选 */
    BallDirectView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 600, 450)];
    BallDirectView.backgroundColor =[UIColor whiteColor];
    [ballViewBg addSubview:BallDirectView];
    playTypeString = @"1";
    
    PickBallView * redBallView =[[PickBallView alloc]initWithFrame:CGRectMake(0, 0, 600, 200)];
    [redBallView ballViewCreateStartValue:1 ballCount:33 perLine:12 leastNum:6 selectMaxNum:16 ballType:Ball_Red];
    [redBallView ballViewAutoSelectWithStart:6 maxNum:16 perLine:12];
    redBallView.delegate = self;
    redBallView.tag = TagPickBallView150 +1;
    [redBallView ballVIewTitle:@"红球区"];
    [BallDirectView addSubview:redBallView];
    [redBallView release];
    
    PickBallView *blueBallView = [[PickBallView alloc]initWithFrame:CGRectMake(0, 200, BallViewWidth, 200)];
    [blueBallView ballViewCreateStartValue:1 ballCount:16 perLine:12 leastNum:1 selectMaxNum:16 ballType:Ball_Blue];
    
    [blueBallView ballViewAutoSelectWithStart:1 maxNum:16 perLine:12];
    blueBallView.delegate = self;
    blueBallView.tag = TagPickBallView150+2;
    [blueBallView ballVIewTitle:@"蓝球区"];
    [BallDirectView addSubview:blueBallView];
    [blueBallView release];
    
    if (! BallDragView) {
        BallDragView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 600, 450)];
        BallDragView.contentSize = CGSizeMake(BallViewWidth, 580);
//        [ballViewBg addSubview:BallDragView];
        
        PickBallView * redDanView =[[PickBallView alloc]initWithFrame:CGRectMake(0, 0, BallViewWidth, 200)];
        [redDanView ballViewCreateStartValue:1 ballCount:33 perLine:12 leastNum:1 selectMaxNum:5 ballType:Ball_Red];
//        [redDanView ballViewAutoSelectWithStart:1 maxNum:5 perLine:12];
        redDanView.tag = TagPickBallView150 +3;
        [redDanView ballVIewTitle:@"胆码区"];
        redDanView.delegate = self;
        [BallDragView addSubview:redDanView];
        [redDanView release];
        
        PickBallView *redTuoView =[[PickBallView alloc]initWithFrame:CGRectMake(0, 200, BallViewWidth, 200)];
        [redTuoView ballViewCreateStartValue:1 ballCount:33 perLine:12 leastNum:2 selectMaxNum:18 ballType:Ball_Red];
//        [redTuoView ballViewAutoSelectWithStart:2 maxNum:18 perLine:12];
        redTuoView.tag = TagPickBallView150+4;
        [redTuoView ballVIewTitle:@"拖码区"];
        redTuoView.delegate = self;
        [BallDragView addSubview:redTuoView];
        [redTuoView release];
        
        PickBallView *bluePickView =[[PickBallView alloc]initWithFrame:CGRectMake(0, 400, BallViewWidth, 150)];
        [bluePickView ballViewCreateStartValue:1 ballCount:16 perLine:12 leastNum:1 selectMaxNum:16 ballType:Ball_Blue];
//        [bluePickView ballViewAutoSelectWithStart:1 maxNum:16 perLine:12];
        bluePickView.tag = TagPickBallView150 + 5;
        [bluePickView ballSumViewTitle:@"蓝球区"];
        bluePickView.delegate = self;
        [BallDragView addSubview:bluePickView];
        [bluePickView release];
        
    }

}
- (void)setSelectBallResultView
{
    selectResult =[[PickNumSelectResultView alloc]initWithFrame:CGRectMake(0, 612, BallViewWidth, 107)];
    selectResult.delegate = self;
    [self.view addSubview:selectResult];
}
//中间按钮
- (void)SSQnarViewTitleButton:(id)sender
{
    if (!titleSelectView) {
        titleSelectView = [[UIView alloc]initWithFrame: CGRectMake(self.view.frame.size.width/2-107, 60, 214, 140)];
        UIImageView * bgView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, titleSelectView.frame.size.width, titleSelectView.frame.size.height)];
        bgView.image = RYCImageNamed(@"playSelect_bg.png");
        [titleSelectView  addSubview:bgView];
        [bgView release];
        
        UIButton *firstButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        firstButton.frame = CGRectMake((214 - 150)/2, 30, 150, 41);
        [firstButton setTitle:@"双色球－自选"forState:UIControlStateNormal];
        firstButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [firstButton setBackgroundImage:RYCImageNamed(@"playBtnNro.png") forState:btnNormal];
        [firstButton setBackgroundImage:RYCImageNamed(@"playSelectClick") forState:UIControlStateSelected];
        [firstButton setTitleColor:RGBCOLOR(0, 0, 0) forState:btnNormal];
            [firstButton setTitleColor:RGBCOLOR(255, 255, 255) forState:btnSelect];
        firstButton.selected = YES;
        firstButton.tag = TAG_SSQ_KIND +1;
        [firstButton addTarget:self action:@selector(selectTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        [titleSelectView addSubview:firstButton];
        
        UIButton *secondButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        secondButton.frame = CGRectMake((214 - 150)/2, 80, 150, 41);
        [secondButton setBackgroundImage:RYCImageNamed(@"playBtnNro.png") forState:btnNormal];
        [secondButton setBackgroundImage:RYCImageNamed(@"playSelectClick") forState:UIControlStateSelected];
        [secondButton setTitleColor:RGBCOLOR(0, 0, 0) forState:btnNormal];
            [secondButton setTitleColor:RGBCOLOR(255, 255, 255) forState:btnSelect];
            secondButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        secondButton.tag = TAG_SSQ_KIND + 2;
        [secondButton setTitle:@"双色球 - 胆拖" forState:UIControlStateNormal];
        [secondButton addTarget:self action:@selector(selectTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        [titleSelectView addSubview:secondButton];
        [self.view addSubview:titleSelectView];
        titleSelectView.hidden = YES;
    }
    titleSelectView.hidden = !titleSelectView.hidden ;
//    CATransition *transition = [CATransition animation];
//    transition.duration = .5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    if(titleSelectView.hidden)
//    {
//        transition.subtype = kCATransitionFromBottom;
//        [titleSelectView.layer addAnimation:transition forKey:nil];
//        titleSelectView.hidden = NO;
//    }
//    else
//    {
//        transition.subtype = kCATransitionFromTop;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
//        [titleSelectView.layer addAnimation:transition forKey:nil];
//        titleSelectView.hidden = YES;
//    }
//
    
    
}
//玩法选择
- (void)selectTitleButton:(id)sender
{
    UIButton * selectBtn = (UIButton *)sender;
    UIButton *firBtn = (UIButton *)[titleSelectView viewWithTag:TAG_SSQ_KIND+1];
    UIButton *secBtn = (UIButton *)[titleSelectView viewWithTag:TAG_SSQ_KIND+2];
    if (selectBtn.tag - TAG_SSQ_KIND == 1) {// 双色球自选
        firBtn.selected = YES;
        secBtn.selected = NO;
        [narBarViewButton setTitle:@"双色球 - 自选  ▼" forState:UIControlStateNormal];
        [BallDragView removeFromSuperview];
        [ballViewBg addSubview: BallDirectView];
        playTypeString = @"1";
        
        [self ballViewSelectDirect];
    }else
    {
        firBtn.selected = NO;
        secBtn.selected = YES;
        [narBarViewButton setTitle:@"双色球 - 胆拖  ▼" forState:UIControlStateNormal];
        [BallDirectView removeFromSuperview];
        [ballViewBg addSubview:BallDragView];
        playTypeString = @"2";
        
        [self ballViewSelectDarg];
    }
    titleSelectView.hidden = YES;
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
#pragma mark ============== pickViewDelegate
- (void)ballViewResultArray:(NSMutableArray *)array selectView:(PickBallView *)ballView
{
    itemDic = nil;
    int indexBall =ballView.tag -TagPickBallView150;
    if (indexBall<3) { //自选
        PickBallView *redPickView = (PickBallView *)[ballViewBg viewWithTag:TagPickBallView150+1];
        PickBallView *bluePickView = (PickBallView *)[ballViewBg viewWithTag:TagPickBallView150+2];
        redDanArray = [redPickView.ballStateArray retain];
        bluePickArray = [bluePickView.ballStateArray retain];
//        if (indexBall ==1) {
//            redDanArray = [array retain];
//        }else{
//            bluePickArray = [array retain];
//        }
        [self ballViewSelectDirect];
    }else
    {
        PickBallView *redDanPickView = (PickBallView *)[ballViewBg viewWithTag:TagPickBallView150+3];
        PickBallView *redTuoPickView = (PickBallView *)[ballViewBg viewWithTag:TagPickBallView150+4];
        if (indexBall ==3) {//胆码
            redDanArray = [array retain];
//             [redTuoPickView ballViewDifferentNumber:[self numberArrayTuomaDanmaDifferentDanmaArray:redDanArray tuomaArray:redTuoArray]];
            if ([redTuoPickView stateForIndex:ballView.currentPickIndex]) {
                [redTuoPickView resetStateForIndex:ballView.currentPickIndex];
            }
            redDanArray = [redDanPickView.ballStateArray retain];
            redTuoArray = [redTuoPickView.ballStateArray retain];
        }else if (indexBall == 4){//拖码
            redTuoArray = [array retain];
//             [redDanPickView ballViewDifferentNumber:[self numberArrayTuomaDanmaDifferentDanmaArray:redDanArray tuomaArray:redTuoArray]];

            if ([redDanPickView stateForIndex:ballView.currentPickIndex]) {
                [redDanPickView resetStateForIndex:ballView.currentPickIndex];
            }
            redDanArray = [redDanPickView.ballStateArray retain];
            redTuoArray = [redTuoPickView.ballStateArray retain];
        }else{
            bluePickArray = [array retain];
        }
        
        [self ballViewSelectDarg];
    }
   
}
// 自选 彩球 注数
- (void)ballViewSelectDirect
{
    NSArray *redAry =[self convertArrayWithStateArray:redDanArray];
    NSArray * blueAry =[self convertArrayWithStateArray:bluePickArray];
//    if (redAry.count ==0 ||blueAry.count==0) {
//        return;
//        
//    }
    int noteCount = 0;
    if (redAry.count >=6 && blueAry.count >=1 ) {
        //注数 = zuhe(6,用户选中红球数量) * zuhe(1,用户选中蓝球数量)
        noteCount = RYCChoose(6, redAry.count) * RYCChoose(1, blueAry.count);
    }else{
        noteCount = 0;
    }
    [self pickResultLabelRefresh:noteCount];
    if (noteCount == 0) {
        return;
    }
    NSString *codeString = @"";
    int nRedCount = redAry.count;
    int nBlueCount = blueAry.count;
    if (nRedCount > 6 && nBlueCount > 1)  //复式
        codeString = [codeString stringByAppendingString:@"3001*"];
    else if (nRedCount > 6)  //红复式，篮球等于1
        codeString = [codeString stringByAppendingString:@"1001*"];
    else if (nBlueCount > 1)  //蓝复式
        codeString = [codeString stringByAppendingString:@"2001*"];
    else  //单式
        codeString = [codeString stringByAppendingString:@"0001"];
    // betcode:0001020912151825~16^ "3001*06091213232829~0314^";
    codeString =[codeString stringByAppendingFormat:@"%@~%@^",[redAry componentsJoinedByString:@""],[blueAry componentsJoinedByString:@""]];
 
    NSString *redString =[NSString stringWithFormat:@"%@",[redAry componentsJoinedByString:@","]];
    NSString *blueString = [NSString stringWithFormat:@"%@",[blueAry componentsJoinedByString:@","]];
    
    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
              redString,@"red",
              blueString,@"blue",
              [NSNumber numberWithInt: noteCount],@"count",
              codeString,@"codeString",
              nil];
    
}
// 胆拖
- (void)ballViewSelectDarg
{
    NSArray *rDanAry =[self convertArrayWithStateArray:redDanArray];
    NSArray *rTuoAry = [self convertArrayWithStateArray:redTuoArray];
    NSArray *bPickAry =[self convertArrayWithStateArray:bluePickArray];
    
//    if (rDanAry.count == 0||rTuoAry.count==0 ||bPickAry.count ==0) {
//        return;
//        
//    }
    int noteCount =0;
    
    //注数 = ((6 - 胆码红球数量), 托码数量) * 蓝球数量
    if (rDanAry.count >= 1 && rTuoAry.count >= 2)
    {
        noteCount = RYCChoose((6 - rDanAry.count), rTuoAry.count) * bPickAry.count;
    }else{
        noteCount = 0;
    }
    if (rDanAry.count + rTuoAry.count <7) {
        noteCount =0;
    }
    [self pickResultLabelRefresh:noteCount];
    if (noteCount == 0) {
        return;
    }
    // moreBetCode = "50011833*0717202731~0112^";
    NSString * codeString =@"";
    if (bPickAry.count ==1) {
        codeString =[codeString stringByAppendingFormat:@"4001"];
    }else
    {
        codeString =[codeString stringByAppendingFormat:@"5001"];
    }
    
    codeString =[codeString stringByAppendingFormat:@"%@*%@~%@^",[rDanAry componentsJoinedByString:@""],[rTuoAry componentsJoinedByString:@""],[bPickAry componentsJoinedByString:@""]];
    NSString * redString =[NSString stringWithFormat:@"%@#%@",[rDanAry componentsJoinedByString:@","],[rTuoAry componentsJoinedByString:@","]];
    NSString * blueString = [NSString stringWithFormat:@"%@",[bPickAry componentsJoinedByString:@","]];
    
    itemDic =[[NSDictionary alloc] initWithObjectsAndKeys:
              redString,@"red",
              blueString,@"blue",
              [NSNumber numberWithInt: noteCount],@"count",
              codeString,@"codeString",
              nil];
}
#pragma mark =================== resultSelect
- (void)pickResultLabelRefresh:(int)count
{
    [selectResult resultLabelRefreshCount:count];
}
- (void)pickSelectResultRefreshAction:(id)sender
{
    int pickView =[playTypeString intValue];
    switch (pickView) {
        case 1:
        {
            PickBallView *redPickView = (PickBallView *)[ballViewBg viewWithTag:TagPickBallView150+1];
            [redPickView clearBallState];
            PickBallView * bluePickView = (PickBallView *)[ballViewBg viewWithTag:TagPickBallView150+2];
            [bluePickView clearBallState];
        }
            break;
        case 2:
        {
            PickBallView *redDanPickView = (PickBallView *)[ballViewBg viewWithTag:TagPickBallView150+3];
            [redDanPickView clearBallState];
            PickBallView *redTuoPickView = (PickBallView *)[ballViewBg viewWithTag:TagPickBallView150+4];
            [redTuoPickView clearBallState];
            PickBallView * bluePickView = (PickBallView *)[ballViewBg viewWithTag:TagPickBallView150+5];
            [bluePickView clearBallState];
        }
            break;
        default:
            break;
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
    [pickBaesketView pickTableViewArrayAddItem:itemDic];
    [self pickSelectResultRefreshAction:sender];
    itemDic = nil;
}






- (NSArray *)convertArrayWithStateArray:(NSArray *)stateArray
{
    NSMutableArray *newArray =[[NSMutableArray alloc]init];
       for (int i=0; i<stateArray.count; i++) {
        if ([[stateArray objectAtIndex:i]isEqualToString:@"1"]) {
            [newArray addObject:[NSString stringWithFormat:@"%02d",i+1]];
        }
    }
    return [newArray autorelease];
}

#pragma mark -------------- narBarView delegate
// 右边按钮
#define TAG_NARBAR_BUTTON 550
- (void)SSQnarBarButtonEvent:(id)sender
{
    if (!moreMessageView) {
        moreMessageView = [[UIView alloc]init];
        moreMessageView.frame = CGRectMake(670, 70, 223, 119);
        moreMessageView.backgroundColor = [UIColor clearColor];
        
        UIImageView* imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, moreMessageView.frame.size.width, moreMessageView.frame.size.height)];
        imgBg.image = RYCImageNamed(@"jcchooselist_2.png");
        [imgBg setBackgroundColor:[UIColor clearColor]];
        [moreMessageView addSubview:imgBg];
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
            introButton.tag = TAG_NARBAR_BUTTON + i;
            [introButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            introButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            [introButton addTarget:self action:@selector(moreMessageViewButton:) forControlEvents:UIControlEventTouchUpInside];
            [moreMessageView addSubview:introButton];
            
        }
        [narArray release];
        [self.view addSubview:moreMessageView];
        moreMessageView.hidden = YES;
    }

    moreMessageView.hidden = !moreMessageView.hidden;
    
//    CATransition *transition = [CATransition animation];
//    transition.duration = .5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    if(moreMessageView.hidden)
//    {
//        transition.subtype = kCATransitionFromBottom;
//        [moreMessageView.layer addAnimation:transition forKey:nil];
//        moreMessageView.hidden = NO;
//    }
//    else
//    {
//        transition.subtype = kCATransitionFromTop;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
//        [moreMessageView.layer addAnimation:transition forKey:nil];
//        moreMessageView.hidden = YES;
//    }
    
}
//玩法介绍
- (void)moreMessageViewButton:(id)sender
{
    UIView * messageView =nil;
    UIButton * button = (UIButton *)sender;
    moreMessageView.hidden = YES;

    if (button.tag == TAG_NARBAR_BUTTON+1) {
        BuyLotteryNumberViewController * buyLottery =[[BuyLotteryNumberViewController alloc]init];
        buyLottery.numLotNo = kLotNoSSQ;
        buyLottery.delegate = self;
        buyLottery.view.frame = CGRectMake(463, 0, 467, 735);
        [self.view addSubview:buyLottery.view];
        messageView = buyLottery.view;
    }else{
        PlayIntroduceViewController *introduce =[[PlayIntroduceViewController alloc]init];
        introduce.introduceLotNo = kLotNoSSQ;
        introduce.delegate = self;
        introduce.view.frame = CGRectMake(463, 0, 467, 735);
        [self.view addSubview:introduce.view];
        messageView = introduce.view;
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
//  玩法选择view 切换
- (void)hiddenOrShowtitleSelectView
{
    titleSelectView.hidden = titleSelectView.hidden ? NO:YES;
    
//    [UIView beginAnimations:@"showtitle" context:nil];
//    //设定动画持续时间
//    [UIView setAnimationDuration:.5];
//    [UIView  setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    //动画的内容
//    if (!titleSelectView.hidden) {
//       titleSelectView.frame = CGRectMake(self.view.frame.size.width/2-100, 60, 214, 140);
//    }else{
//        titleSelectView.frame = CGRectMake(self.view.frame.size.width/2-100, -100, 214, 140);
//    }
//    //动画结束
//    [UIView commitAnimations];
    
    
    if (titleSelectView.hidden) {
        [UIView animateWithDuration:0.5 animations:^(void){
            CGPoint point = titleSelectView.center;
            point.y -= 300;
            titleSelectView.center = point;
        }completion:^(BOOL isFinish){
            if (isFinish) {
                [titleSelectView removeFromSuperview];
            }
        }];
    }else{
        titleSelectView.frame = CGRectMake(self.view.frame.size.width/2-100, 60, 214, 140);
        [self.view addSubview:titleSelectView];
        CATransition *transition = [CATransition animation];
        transition.duration = .5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;//{ kCATransitionPush, kCATransitionMoveIn, kCATransitionReveal, kCATransitionFade }
        transition.subtype = kCATransitionFromBottom;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
        [titleSelectView.layer addAnimation:transition forKey:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
