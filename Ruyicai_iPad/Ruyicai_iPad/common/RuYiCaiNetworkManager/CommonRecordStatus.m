//
//  CommonRecordStatus.m 
//  RuYiCai
// 
//  Created by ruyicai on 12-6-1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//
/*
 记录常用 的状态值
 
 */

#import "CommonRecordStatus.h"
#import "SBJsonParser.h"
#import "RYCCommon.h"
#import "RuYiCaiLotDetail.h"
#import "RYCImageNamed.h"
@interface CommonRecordStatus (internal)

@end

@implementation CommonRecordStatus

@synthesize remmberQuitStatus = m_remmberQuitStatus;
@synthesize isGetCashOK = m_isGetCashOK;
@synthesize startImageId = m_startImageId;
@synthesize startImage = m_startImage;
@synthesize useStartImage = m_useStartImage;

@synthesize netMissDate = m_netMissDate;
  
@synthesize deviceToken = m_deviceToken;
@synthesize chargeWarnStr = m_chargeWarnStr;

@synthesize topActionDic = m_topActionDic;
@synthesize sampleNetStr = m_sampleNetStr;

@synthesize resultWarn = m_resultWarn;

@synthesize QueryBetlotNO = m_QueryBetlotNO;

@synthesize loginWay = m_loginWay;

@synthesize lotteryInfor = m_lotteryInfor;
@synthesize inProgressActivityCount = m_inProgressActivityCount;

@synthesize changeWay = m_changeWay;

@synthesize stopSaleLotDiction = m_stopSaleLotDiction;

static CommonRecordStatus *s_commonRecordStatusManager = NULL;

- (id)init
{
    self = [super init];
    if (self) 
    {
        //初始化 状态值
        m_remmberQuitStatus = NO;
        m_isGetCashOK = NO;
        m_useStartImage = NO;//默认使用本地开机图片
        
        m_startImageId = @"";
        m_netMissDate = @"";
        m_chargeWarnStr = @"";
        m_sampleNetStr = @"";
        m_deviceToken = @"";
        m_resultWarn = @"";
        m_loginWay = kNormalLogin;
        
        m_lotteryInfor = @"";
        
        m_inProgressActivityCount = @"0";
        
        m_changeWay = 0;
        
        m_stopSaleLotDiction = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

+ (CommonRecordStatus *)commonRecordStatusManager
{
    @synchronized(self) 
    {
		if (s_commonRecordStatusManager == nil) 
		{
			s_commonRecordStatusManager = [[self alloc] init];
		}
	}
	return s_commonRecordStatusManager;
}

+ (id)allocWithZone:(NSZone *)zone 
{
	@synchronized(self) 
	{
		if (s_commonRecordStatusManager == nil) 
		{
			s_commonRecordStatusManager = [super allocWithZone:zone];
			return s_commonRecordStatusManager;   
		}
	}	
	return nil;   
}

- (id)copyWithZone:(NSZone *)zone 
{
	return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark lotTitle  lotNo  name 转换
- (NSString*)lotNameWithLotNo:(NSString*)lotNo
{
    if ([lotNo isEqualToString:kLotNoSSQ])
         return @"双色球";
    else if ([lotNo isEqualToString:kLotNoFC3D])
         return @"福彩3D";
    else if ([lotNo isEqualToString:kLotNoDLT])
         return @"大乐透";
    else if ([lotNo isEqualToString:kLotNoQLC])
         return @"七乐彩";
    else if ([lotNo isEqualToString:kLotNoPLS])
         return @"排列三";
    else if ([lotNo isEqualToString:kLotNoQXC])
         return @"七星彩";
    else if ([lotNo isEqualToString:kLotNoSSC])
         return @"时时彩";
    else if ([lotNo isEqualToString:kLotNo115])
         return @"江西11选5";
    else
         return @"";
}


- (NSString*)lotTitleWithLotNo:(NSString*)lotNo
{
    if ([lotNo isEqualToString:kLotNoSSQ])
        return kLotTitleSSQ;
    else if ([lotNo isEqualToString:kLotNoFC3D])
        return kLotTitleFC3D;
    else if ([lotNo isEqualToString:kLotNoDLT])
        return kLotTitleDLT;
    else if ([lotNo isEqualToString:kLotNoQLC])
        return kLotTitleQLC;
    else if ([lotNo isEqualToString:kLotNoSSC])
        return kLotTitleSSC;
    else if ([lotNo isEqualToString:kLotNo115])
        return kLotTitle11X5;
    else if ([lotNo isEqualToString:kLotNoGD115])
        return kLotTitleGD115;
    else
        return @"";
}


- (NSString*)lotNameWithLotTitle:(NSString*)lotTitle
{
    if ([lotTitle isEqualToString:kLotTitleSSQ])
        return @"双色球";
    else if ([lotTitle isEqualToString:kLotTitleFC3D])
        return @"福彩3D";
    else if ([lotTitle isEqualToString:kLotTitleDLT])
        return @"大乐透";
    else if ([lotTitle isEqualToString:kLotTitleQLC])
        return @"七乐彩";
    else if ([lotTitle isEqualToString:kLotTitle11X5])
        return @"11选5";
    else if ([lotTitle isEqualToString:kLotTitleSSC])
        return @"时时彩";
    else if ([lotTitle isEqualToString:kLotTitleGD115])
        return @"广东11选5";
    return @"";
}

- (NSString*)lotNoWithLotTitle:(NSString*)lotTitle
{
    if ([lotTitle isEqualToString:kLotTitleSSQ])
        return kLotNoSSQ;
    else if ([lotTitle isEqualToString:kLotTitleFC3D])
        return kLotNoFC3D;
    else if ([lotTitle isEqualToString:kLotTitleDLT])
        return kLotNoDLT;
    else if ([lotTitle isEqualToString:kLotTitleQLC])
        return kLotNoQLC;
    else if ([lotTitle isEqualToString:kLotTitleSSC])
        return kLotNoSSC;
    else if ([lotTitle isEqualToString:kLotTitle11X5])
        return kLotNo115;
    else if ([lotTitle isEqualToString:kLotTitleGD115])
        return kLotNoGD115;
    else
        return @"";
}

+ (BOOL)lotNoISJC:(NSString*)lotNo
{
    if ([lotNo isEqualToString:kLotNoBJDC] ||
        [lotNo isEqualToString:kLotNoBJDC_RQSPF] ||
        [lotNo isEqualToString:kLotNoBJDC_JQS] ||
        [lotNo isEqualToString: kLotNoBJDC_HalfAndAll] ||
        [lotNo isEqualToString: kLotNoBJDC_SXDS] ||
        [lotNo isEqualToString:kLotNoBJDC_Score] ||
        
        [lotNo isEqualToString:kLotNoJCLQ] ||
        [lotNo isEqualToString:kLotNoJCLQ_SF] ||
        [lotNo isEqualToString:kLotNoJCLQ_RF] ||
        [lotNo isEqualToString:kLotNoJCLQ_SFC] ||
        [lotNo isEqualToString:kLotNoJCLQ_DXF] ||
        
        [lotNo isEqualToString:kLotNoJCZQ] ||
        [lotNo isEqualToString:kLotNoJCZQ_RQ] ||
        [lotNo isEqualToString:kLotNoJCZQ_SPF] ||
        [lotNo isEqualToString:kLotNoJCZQ_ZJQ] ||
        [lotNo isEqualToString:kLotNoJCZQ_SCORE] ||
        [lotNo isEqualToString:kLotNoJCZQ_HALF] ||
        [lotNo isEqualToString:kLotNoJCLQ_CONFUSION] ||
        [lotNo isEqualToString:kLotNoJCZQ_CONFUSION]
        )
        return YES;
    else
        return NO;
}
#pragma mark 清楚投注数据
- (void)clearBetData
{
    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor removeAllObjects];
    [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor removeAllObjects];
    
    [RuYiCaiLotDetail sharedObject].batchCode = @"";
    [RuYiCaiLotDetail sharedObject].batchEndTime = @"";
    [RuYiCaiLotDetail sharedObject].batchNum = @"";
    [RuYiCaiLotDetail sharedObject].betCode = @"";
    [RuYiCaiLotDetail sharedObject].disBetCode = @"";
    [RuYiCaiLotDetail sharedObject].lotNo = @"";
    [RuYiCaiLotDetail sharedObject].lotMulti = @"";
    [RuYiCaiLotDetail sharedObject].amount = @"";
    [RuYiCaiLotDetail sharedObject].betType = @"";
    [RuYiCaiLotDetail sharedObject].sellWay = @"";
    [RuYiCaiLotDetail sharedObject].toMobileCode = @"";
    [RuYiCaiLotDetail sharedObject].advice = @"";
    [RuYiCaiLotDetail sharedObject].zhuShuNum = @"";
    [RuYiCaiLotDetail sharedObject].prizeend = @"";
    [RuYiCaiLotDetail sharedObject].oneAmount = @"";
    [RuYiCaiLotDetail sharedObject].moreZuBetCode = @"";
    [RuYiCaiLotDetail sharedObject].moreZuAmount = @"";
    [RuYiCaiLotDetail sharedObject].subscribeInfo = @"";
    [RuYiCaiLotDetail sharedObject].giftContentStr = @"";
}

#pragma mark 选球页面右上角的view
- (UIImageView*)creatFourButtonView
{
    UIImageView* imgBg = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 145, 160)]  autorelease];
    imgBg.image = RYCImageNamed(@"jcchooselist_4.png");
    [imgBg setBackgroundColor:[UIColor clearColor]];
    return imgBg;
}
- (UIImageView*)creatThreeButtonView
{
    UIImageView* imgBg = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 145, 120)]  autorelease];
    imgBg.image = RYCImageNamed(@"jcchooselist_3.png");
    [imgBg setBackgroundColor:[UIColor clearColor]];
    return imgBg;
}

- (UIButton*)creatIntroButton:(CGRect)rect
{
    UIButton* introButton = [[[UIButton alloc] initWithFrame:rect]  autorelease];
    UIImageView *intro_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 20, 20)];
    intro_icon.image = RYCImageNamed(@"introduce_play.png");
    [introButton addSubview:intro_icon];
    [intro_icon release];
    introButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    [introButton setBackgroundImage:RYCImageNamed(@"caidanbutton_bg_click.png") forState:UIControlStateHighlighted];
    [introButton setTitle:@"玩法介绍" forState:UIControlStateNormal];
    [introButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    introButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
//    [introButton addTarget:self action:@selector(playIntroButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return introButton;
 
}
- (UIButton*)creatHistoryButton:(CGRect)rect
{
    UIButton* historyButton  = [[[UIButton alloc] initWithFrame:rect] autorelease];
    UIImageView *history_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 20, 20)];
    history_icon.image = RYCImageNamed(@"history_lottery.png");
    [historyButton addSubview:history_icon];
    [history_icon release];
    
    historyButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    [historyButton setBackgroundImage:RYCImageNamed(@"caidanbutton_bg_click.png") forState:UIControlStateHighlighted];
    [historyButton setTitle:@"历史开奖" forState:UIControlStateNormal];
    [historyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    historyButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
//    [historyButton addTarget:self action:@selector(historyLotteryClick:) forControlEvents:UIControlEventTouchUpInside];
    return historyButton; 
}

- (UIButton*)creatQuerybetLotButton:(CGRect)rect
{
    UIButton* QuerybetLotButton  = [[[UIButton alloc] initWithFrame:rect]  autorelease];
    UIImageView *QuerybetLot_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 20, 20)];
    QuerybetLot_icon.image = RYCImageNamed(@"querybetlot_ico.png");
    [QuerybetLotButton addSubview:QuerybetLot_icon];
    [QuerybetLot_icon release];
    QuerybetLotButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    [QuerybetLotButton setBackgroundImage:RYCImageNamed(@"caidanbutton_bg_click.png") forState:UIControlStateHighlighted];
    [QuerybetLotButton setTitle:@"投注查询" forState:UIControlStateNormal];
    [QuerybetLotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    QuerybetLotButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
//    [QuerybetLotButton addTarget:self action:@selector(queryBetLotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return QuerybetLotButton;
}

- (UIButton*)creatLuckButton:(CGRect)rect
{
    UIButton* QuerybetLotButton  = [[[UIButton alloc] initWithFrame:rect]  autorelease];
    UIImageView *QuerybetLot_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 20, 20)];
    QuerybetLot_icon.image = RYCImageNamed(@"luckbuttonico.png");
    [QuerybetLotButton addSubview:QuerybetLot_icon];
    [QuerybetLot_icon release];
    QuerybetLotButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    [QuerybetLotButton setBackgroundImage:RYCImageNamed(@"caidanbutton_bg_click.png") forState:UIControlStateHighlighted];
    [QuerybetLotButton setTitle:@"幸运选号" forState:UIControlStateNormal];
    [QuerybetLotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    QuerybetLotButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
 
    return QuerybetLotButton;
}

- (UIButton*)creatAnalogNumButton:(CGRect)rect//模拟选号
{
    UIButton* AnalogNumButton  = [[[UIButton alloc] initWithFrame:rect]  autorelease];
    UIImageView *AnalogNum_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 20, 20)];
    AnalogNum_icon.image = RYCImageNamed(@"analog_num_ico.png");
    [AnalogNumButton addSubview:AnalogNum_icon];
    [AnalogNum_icon release];
    AnalogNumButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    [AnalogNumButton setBackgroundImage:RYCImageNamed(@"caidanbutton_bg_click.png") forState:UIControlStateHighlighted];
    [AnalogNumButton setTitle:@"模拟选号" forState:UIControlStateNormal];
    [AnalogNumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    AnalogNumButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    return AnalogNumButton;
}

- (UIButton*)creatPresentSituButton:(CGRect)rect//开奖走势
{
    UIButton* PresentSituButton  = [[[UIButton alloc] initWithFrame:rect]  autorelease];
    UIImageView *PresentSitu_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 20, 20)];
    PresentSitu_icon.image = RYCImageNamed(@"present_situation_ico.png");
    [PresentSituButton addSubview:PresentSitu_icon];
    [PresentSitu_icon release];
    PresentSituButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    [PresentSituButton setBackgroundImage:RYCImageNamed(@"caidanbutton_bg_click.png") forState:UIControlStateHighlighted];
    [PresentSituButton setTitle:@"开奖走势" forState:UIControlStateNormal];
    [PresentSituButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    PresentSituButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    return PresentSituButton;
}

#pragma mark 计算字符串长度
-(NSUInteger) unicodeLengthOfString: (NSString *) text
{
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++)
    {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    NSUInteger unicodeLength = asciiLength / 2;
    if(asciiLength % 2)
    {
        unicodeLength++;
    }
    return unicodeLength;
}

-(NSUInteger) asciiLengthOfString: (NSString *) text
{
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++)
    {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    return asciiLength;
}

#pragma mark 控制输入框输入长度
- (NSString*)textMaxLengthWithString:(NSString*)oldString andLength:(NSInteger)maxLength
{
    if(oldString.length >= maxLength)
    {
        oldString = [oldString substringWithRange:NSMakeRange(0, oldString.length - 1)];
    }
    return oldString;
}

#pragma mark 剪裁图片
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end
