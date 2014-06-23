//
//  LotteryBallCommonView.m
//  Ruyicai_iPad
//
//  Created by huangxin on 13-7-18.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "LotteryBallCommonView.h"
#import "RYCImageNamed.h"


@implementation LotteryBallCommonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = NO;
        
    }
    return self;
}

- (void) drawBallWithLotteryCode:(NSString*) lotteryCode lotteryTitle:(NSString*)lotTitle scope:(float)scope
{
    
    NSArray *lotteryNoArray = [self getLotteryNoArrayWithString:lotteryCode lotteryTitle:lotTitle];
    if ([lotteryNoArray count] <= 0) {
        return;
    }
    int gap = 10 * scope;
    BallBlock ballBlock = [self getBallCount:lotTitle];
    BOOL isInt = [self isChangedCodeIntWithCodeString:lotTitle];
    
    //红球
    for (int i = 0; i < ballBlock.redBallCount; i++)
    {
        UIButton *redBallButton = [[UIButton alloc] init];
        redBallButton.frame = CGRectMake((50*i + gap*i) * scope, 0, 50 * scope, 50 * scope);
        redBallButton.titleLabel.font = [UIFont boldSystemFontOfSize:20 * scope];
        [redBallButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [redBallButton setBackgroundImage:RYCImageNamed(@"ball_red.png") forState:UIControlStateNormal];
        [redBallButton setBackgroundImage:RYCImageNamed(@"ball_red.png") forState:UIControlStateHighlighted];

        NSString *title = [lotteryNoArray objectAtIndex:i];
        if (isInt) {
            title = [NSString stringWithFormat:@"%d",[title intValue]];
        }
        [redBallButton setTitle:title forState:UIControlStateNormal];
        [self addSubview:redBallButton];
        [redBallButton release];
    }
    
    //蓝球
    for (int j = 0; j < ballBlock.blueBallCount; j++) {
        UIButton *blueBallButton = [[UIButton alloc] init];
        blueBallButton.frame = CGRectMake((50 + gap)*(ballBlock.redBallCount + j) * scope, 0, 50 * scope, 50 * scope);
        blueBallButton.titleLabel.font = [UIFont boldSystemFontOfSize:20 * scope];
        [blueBallButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        NSString *title = [lotteryNoArray objectAtIndex:ballBlock.redBallCount + j];
        if (isInt) {
            title = [NSString stringWithFormat:@"%d",[title intValue]];
        }
        [blueBallButton setTitle:title forState:UIControlStateNormal];
        [blueBallButton setBackgroundImage:RYCImageNamed(@"ball_blue.png") forState:UIControlStateNormal];
        [blueBallButton setBackgroundImage:RYCImageNamed(@"ball_blue.png") forState:UIControlStateHighlighted];

        [self addSubview:blueBallButton];
    }
}


//获得中奖号码
- (NSArray*) getLotteryNoArrayWithString:(NSString*)lottery lotteryTitle:(NSString*)lotTitle
{
    if (lottery == nil||[lottery isEqualToString:@""]) {
        
        return nil;
    }
    else
    {
        NSMutableArray *lotteryArray = [NSMutableArray arrayWithCapacity:1];
        BallBlock ballBlock = [self getBallCount:lotTitle];
        int ballCount = ballBlock.redBallCount + ballBlock.blueBallCount;
        if ([lotTitle isEqualToString:kLotTitleSSQ])
        {
            if (lottery.length == 14) {
                for (int i = 0; i < ballCount; i++){
                    NSString *subString = [lottery substringWithRange:NSMakeRange(2*i, 2)];
                    [lotteryArray addObject:subString];
                }
            }
            else
                return nil;
        }
        else if([lotTitle isEqualToString:kLotTitleQLC])
        {
            if (lottery.length == 16) {
                for (int i = 0; i < ballCount; i++){
                    NSString *subString = [lottery substringWithRange:NSMakeRange(2*i, 2)];
                    [lotteryArray addObject:subString];
                }
            }
            else
                return nil;
        }
        else if ([lotTitle isEqualToString:kLotTitleFC3D])
        {
            if (lottery.length == 6) {
                for (int i = 0; i < ballCount; i++){
                    NSString *subString = [lottery substringWithRange:NSMakeRange(2*i, 2)];
                    [lotteryArray addObject:subString];
                }
            }
            else
                return nil;
        }
        else if ([lotTitle isEqualToString:kLotTitleDLT])
        {
            if (lottery.length == 20) {
                for (int i = 0; i < ballCount; i++)
                {
                    NSMutableString *lotteryMutable = [NSMutableString stringWithString:lottery];
                    
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
            else
            {
                return nil;
            }
        }
        else if ([lotTitle isEqualToString:kLotTitle11X5])
        {
            if (lottery.length == 10) {
                for (int i = 0; i < ballCount; i++){
                    NSString *subString = [lottery substringWithRange:NSMakeRange(2*i, 2)];
                    [lotteryArray addObject:subString];
                }
            }
            else
                return nil;
        }
        else if ([lotTitle isEqualToString:kLotTitleSSC])
        {
            if (lottery.length == 5) {
                for (int i = 0; i < ballCount; i++){
                    NSString *subString = [lottery substringWithRange:NSMakeRange(1*i, 1)];
                    [lotteryArray addObject:subString];
                }
            }
            else
                return nil;
        }
        else if ([lotTitle isEqualToString:kLotTitleGD115])
        {
            if (lottery.length == 10) {
                for (int i = 0; i < ballCount; i++){
                    NSString *subString = [lottery substringWithRange:NSMakeRange(2*i, 2)];
                    [lotteryArray addObject:subString];
                }
            }
            else
                return nil;
        }

        return [NSArray arrayWithArray:lotteryArray];
    }
}

//获得彩种红蓝球的个数
- (BallBlock) getBallCount:(NSString*) lotTitle
{
    BallBlock ballBlock;
    
    if ([lotTitle isEqualToString:kLotTitleSSQ])
    {
        ballBlock.redBallCount = 6;
        ballBlock.blueBallCount = 1;
    }
    else if ([lotTitle isEqualToString:kLotTitleQLC])
    {
        ballBlock.redBallCount = 7;
        ballBlock.blueBallCount = 1;
    }
    else if ([lotTitle isEqualToString:kLotTitleFC3D])
    {
        ballBlock.redBallCount = 3;
        ballBlock.blueBallCount = 0;
    }
    else if ([lotTitle isEqualToString:kLotTitleDLT])
    {
        ballBlock.redBallCount = 5;
        ballBlock.blueBallCount = 2;
    }
    else if ([lotTitle isEqualToString:kLotTitle11X5])
    {
        ballBlock.redBallCount = 5;
        ballBlock.blueBallCount = 0;
    }
    else if ([lotTitle isEqualToString:kLotTitleSSC])
    {
        ballBlock.redBallCount = 5;
        ballBlock.blueBallCount = 0;
    }
    else if([lotTitle isEqualToString:kLotTitleGD115])
    {
        ballBlock.redBallCount = 5;
        ballBlock.blueBallCount = 0;
    }else
    {
        ballBlock.redBallCount = 0;
        ballBlock.blueBallCount = 0;
    }
    return ballBlock;
}

//判断是否要取int
- (BOOL) isChangedCodeIntWithCodeString:(NSString *)lotTitle
{
    if ([lotTitle isEqualToString: kLotTitleFC3D] || [lotTitle isEqualToString:  kLotTitleSSC]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end