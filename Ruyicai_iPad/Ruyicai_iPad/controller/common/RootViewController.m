//
//  RootViewController.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-6-27.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.

 
}
- (void)tabBarBackgroundImageViewWith:(UIView *)view
{
    UIImageView *narImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabBar_bg.png"]];
    narImage.frame = CGRectMake(-5, 0, 913, 70);
    [view addSubview:narImage];
    [narImage release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ---------------- view 
- (void)transitionView:(UIView*)view
{
    CATransition *transition = [CATransition animation];
    transition.duration = .5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;//{ kCATransitionPush, kCATransitionMoveIn, kCATransitionReveal, kCATransitionFade }
    transition.subtype = kCATransitionFromRight;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
    [view.layer addAnimation:transition forKey:nil];
}

#pragma mark --------------------- randomBall 
/*  不重复的随机数 */
- (NSMutableArray*)randomBallWithMax:(int)maxNum selectNum:(int)select_ran
{
    NSMutableArray *randomArray=[[NSMutableArray alloc]init];
    for (int i =0; i<maxNum; i++) {
        [randomArray addObject:@"0"];
    }
    int m_randomNum = 0;
    int max_random = maxNum;
    int select_random = select_ran;
    
    while (m_randomNum < select_random) {
        int randomNum = (arc4random() % max_random);
        
        if (![[randomArray objectAtIndex:randomNum]isEqualToString:@"1"]) {
            [randomArray replaceObjectAtIndex:randomNum withObject:@"1"];
            m_randomNum += 1;
        }
    }
    return [randomArray autorelease];
}
/* 彩球选出 数字 */
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

#pragma mark --------------------  拖码 胆码的数字不重复
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
#pragma mark ------------------ alertView
/* 提示信息 */
-(void)showAlertWithMessage:(NSString *)message
{
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [alert release];
}
#pragma mark ------------------ success
/*  是否成功登陆 */
- (BOOL)isSuccessLogin
{
    return [UserLoginData sharedManager].hasLogin ? YES :NO;
}
#pragma mark -------------------- 计算字符串长度
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
#pragma mark ------------- buttonCreate
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
#pragma mark ------------ viewControllerDisappear
- (void)rootViewControllerDisappear:(UIViewController *)viewController
{
    [UIView animateWithDuration:0.5 animations:^(void){
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
#pragma mark ------------ 开奖号码数组整理
- (NSMutableArray *)lotteryCellBallDoubleNumberString:(NSString *)lotString
{
    NSMutableArray * strArray =[[NSMutableArray alloc]init];
    for (int i=0; i<lotString.length/2; i++) {
        NSString * string= [lotString substringWithRange:NSMakeRange(2*i, 2)];
        [strArray addObject:string];
    }
    return [strArray autorelease];
}
- (NSMutableArray *)lotteryCellBallSingleNumberString:(NSString *)lotString
{
    NSMutableArray * strArray =[[NSMutableArray alloc]init];
    for (int i=0; i<lotString.length; i++) {
        NSString * string= [lotString substringWithRange:NSMakeRange(1*i, 1)];
        [strArray addObject:string];
    }
    return [strArray autorelease];
}
// 大乐透 中奖号码解析
- (NSMutableArray *)lotteryBallDLTNumberString:(NSString *)lotString
{
    if (lotString) {
        NSMutableArray * lotteryArray =[[NSMutableArray alloc]initWithCapacity:0];
        if (lotString.length == 20) {
            for (int i = 0; i < 7; i++)
            {
                NSMutableString *lotteryMutable = [NSMutableString stringWithString:lotString];
                
                //删掉空格符
                NSRange rangge = [lotteryMutable rangeOfString:@" "];
                while (rangge.length > 0) {
                    [lotteryMutable deleteCharactersInRange:rangge];
                    rangge = [lotteryMutable rangeOfString:@" "];
                }
                //删掉“＋”
                rangge = [lotteryMutable rangeOfString:@"+"];
                while (rangge.length > 0) {
                    [lotteryMutable deleteCharactersInRange:rangge];
                    rangge = [lotteryMutable rangeOfString:@"+"];
                }
                NSString *subString = [lotteryMutable substringWithRange:NSMakeRange(2*i, 2)];
                [lotteryArray addObject:subString];
            }
        }
        return [lotteryArray autorelease];
    }
    return nil;
}
#pragma mark -------------- 前一期开奖号码
- (void)sendRequestLotteryInfoWithLotNo:(NSString *)lotNoStr
{
    NSMutableDictionary* mDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [mDict setObject:@"QueryLot" forKey:@"command"];
    [mDict setObject:@"winInfoList" forKey:@"type"];
    [mDict setObject:@"1" forKey:@"maxresult"];
    [mDict setObject:@"1" forKey:@"pageindex"];
    [mDict setObject:lotNoStr forKey:@"lotno"];
    //    ASINetworkRequestTypeGetLotteryInfo
    
    [RYCNetworkManager sharedManager].netDelegate = self;
    [[RYCNetworkManager sharedManager] netRequestStartWith:mDict withRequestType:ASINetworkRequestTypeGetLotteryInfo showProgress:NO];
}
#pragma mark ----------------- 横屏显示
//  横屏显示
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight);
}

- (BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
@end
