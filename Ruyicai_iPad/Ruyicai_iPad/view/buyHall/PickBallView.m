//
//  PickBallView.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-20.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "PickBallView.h"

@interface PickBallView ()
{
    int ballStartValue;//开始球号
    int ballAllCount;//总共球数
    int perLine;//每行显示球数
    int ballLeastNum;//至少选球数
    int ballMaxNum;//最多选球数
    int ballSelectNum;// 当前所选球数
    Ball_Type ballType;//球类型
    int selectBallNum;//选中的球数
    UIView * messView;//提示信息
}
@end

@implementation PickBallView
@synthesize delegate;
@synthesize ballStateArray;
@synthesize currentPickIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code】
        self.backgroundColor = [UIColor whiteColor];
        UIView  *topBg  =[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 46)];
        topBg.backgroundColor  = [UIColor colorWithPatternImage:RYCImageNamed(@"repeatx.png")];
        [self addSubview:topBg];
        [topBg release];
        
        ballStartValue = 0;
        ballAllCount = 0;
        perLine = 0 ;
        ballLeastNum = 0;
        ballMaxNum = 0;
        self.ballStateArray = [[NSMutableArray alloc]init];
        selectBallNum = 0;

    }
    return self;
}
- (void)dealloc
{
    self.delegate = nil;
    [self.ballStateArray release],self.ballStateArray = nil;
    [messView release],messView = nil;
    
    [super dealloc];
}
#define KBallRectValue 42
#define kBallSpacingValue 5
#define TagBallBase 1000
#pragma mark ============= ballView
- (void)ballViewCreateStartValue:(int)startValue ballCount:(int)ballCount perLine:(int)line leastNum:(int)leastNum selectMaxNum:(int)maxNum ballType:(Ball_Type)type
{
    ballStartValue = startValue;
    ballAllCount = ballCount;
    perLine = line;
    ballLeastNum = leastNum;
    ballMaxNum = maxNum;
    ballType = type;
    selectBallNum = 0;
    messView =[[UIView alloc]init];
    
    for (int i=0; i<ballAllCount; i++) {
        float lineIndex = i/perLine;
        UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20+(KBallRectValue + kBallSpacingValue)*(i % perLine), 50+kBallSpacingValue +lineIndex*(KBallRectValue+kBallSpacingValue), KBallRectValue, KBallRectValue);
        [button setBackgroundImage:RYCImageNamed(@"ball_gray.png") forState:UIControlStateNormal];
		[button setTitle:[NSString stringWithFormat:@"%d", (i + ballStartValue)] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[button addTarget:self action:@selector(pressedBallButtonAction:) forControlEvents:UIControlEventTouchUpInside];
		button.tag = TagBallBase + i;
        [self addSubview:button];
        
        [self.ballStateArray addObject:@"0"];
    }
}
/*  至少还有选 */
- (void)ballVIewTitle:(NSString *)string
{
    UILabel *titleLabel         = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 500, 20)];
    titleLabel.backgroundColor  = [UIColor clearColor];
    
    titleLabel.text             = [NSString stringWithFormat: @"%@（至少选择%d个）",string,ballLeastNum]  ;
    [self addSubview:titleLabel];
    [titleLabel release];

}
/* 只显示球区 */
- (void)ballSumViewTitle:(NSString *)title{
    
    UILabel *titleLabel         = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 500, 20)];
    titleLabel.backgroundColor  = [UIColor clearColor];
    titleLabel.text             = [NSString stringWithFormat: @"%@",title];
    [self addSubview:titleLabel];
    [titleLabel release];

}
/* 机选号码 */
- (void)ballViewAutoSelectWithStart:(int)startNum maxNum:(int)maxNum perLine:(int)perL
{
    ballSelectNum = startNum;
    ballMaxNum = maxNum;
    autoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    autoButton.frame = CGRectMake(420, 5, 60, 35);
    [autoButton setTitle:[NSString stringWithFormat:@"%d个",startNum] forState:btnNormal];
    [autoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [autoButton setBackgroundImage:[UIImage imageNamed: @"random_num_normal.png"] forState:UIControlStateNormal];
    [autoButton setBackgroundImage: [UIImage imageNamed: @"random_num_click.png"] forState:UIControlStateHighlighted];
    [autoButton addTarget:self action:@selector(autoSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:autoButton];
    
    UIButton*  jixuan_button = [[UIButton alloc] initWithFrame:CGRectMake(480, 5, 100, 35)];
    [jixuan_button setTitle:@"机选号码" forState:UIControlStateNormal];
    [jixuan_button setBackgroundColor:[UIColor clearColor]];
    [jixuan_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [jixuan_button setBackgroundImage:[UIImage imageNamed:@"random_button_normal.png"] forState:UIControlStateNormal];
    [jixuan_button setBackgroundImage:[UIImage imageNamed:@"random_button_click.png"] forState:UIControlStateHighlighted];
    [jixuan_button addTarget:self action:@selector(jiXuanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:jixuan_button];
    [jixuan_button release];

    int lineNum = 1;
    if (maxNum - startNum >0) {
        lineNum = (maxNum-startNum)/perL + ((maxNum-startNum) % perL == 0 ? 0 : 1);
    }
    autoListView = [[UIView alloc] initWithFrame:CGRectMake(10, 45, 580, 300)];
    [autoListView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView*  bg_image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, autoListView.frame.size.width, 50*lineNum + 5)];
    bg_image.image = [UIImage imageNamed:@"randomnum_bg.png"];
    [autoListView addSubview:bg_image];
    [bg_image release];
    [self addSubview:autoListView];
#define TagNumButton 200
    for (int i=0; i<=maxNum-startNum; i++) {
        UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10+(KBallRectValue + kBallSpacingValue)*(i % perL), 10+(KBallRectValue+kBallSpacingValue)*(i/perL), KBallRectValue, KBallRectValue);
        [button setBackgroundImage:RYCImageNamed(@"num_bg.png") forState:btnNormal];
        [button setTitle:[NSString stringWithFormat:@"%d",startNum+i] forState:btnNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
		[button addTarget:self action:@selector(pressedNumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
		button.tag = TagNumButton + i;
		[autoListView addSubview:button];
    }
    autoListView.hidden = YES;
    
}

#pragma mark ==================== methods

- (void)autoSelectButtonAction:(id)sender
{
    autoListView.hidden = autoListView.hidden ? NO : YES;
}
- (void)jiXuanButtonAction:(id)sender
{
    autoListView.hidden = YES;
    self.ballStateArray = [self randomBallWithMax:ballAllCount selectNum:ballSelectNum];
    selectBallNum = ballSelectNum;
    [self refreshBallState];
    
    [self.delegate ballViewResultArray:self.ballStateArray selectView:self];
}
- (void)pressedNumButtonAction:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    autoListView.hidden = YES;
    ballSelectNum = btn.tag - TagNumButton + ballLeastNum;
    [autoButton setTitle:[NSString stringWithFormat:@"%d个",ballSelectNum] forState:btnNormal];
    self.ballStateArray = [self randomBallWithMax:ballAllCount selectNum:ballSelectNum];
    selectBallNum = ballSelectNum;
    [self refreshBallState];
    
    [self.delegate ballViewResultArray:self.ballStateArray selectView:self];

}
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

- (void)pressedBallButtonAction:(id)sender
{
    UIButton * button = (UIButton *)sender;
    for (int i=0; i<self.ballStateArray.count; i++) {
        self.currentPickIndex = button.tag - TagBallBase;
        if (button.tag == TagBallBase+i) {
            if ([[self.ballStateArray objectAtIndex:i]isEqualToString:@"1"]) {
                [self.ballStateArray replaceObjectAtIndex:i withObject:@"0"];
                selectBallNum --;
                [button setBackgroundImage:[UIImage imageNamed:@"ball_gray.png"] forState:UIControlStateNormal];//灰球
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//字体颜色
                
                [self.delegate ballViewResultArray:self.ballStateArray selectView:self];
            }else
            {
                if (selectBallNum < ballMaxNum) {
                    [self.ballStateArray replaceObjectAtIndex:i withObject:@"1"];
                    selectBallNum ++;
                    
                    if (ballType == Ball_Red) {
                        [button setBackgroundImage:[UIImage imageNamed:@"ball_red.png"] forState:UIControlStateNormal];//换成红色图片
                    }else{
                        [button setBackgroundImage:[UIImage imageNamed:@"ball_blue.png"] forState:UIControlStateNormal];
                    }
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    
                    [self.delegate ballViewResultArray:self.ballStateArray selectView:self];
                }
            }
        }
    }
    
    
    [messView removeFromSuperview];
    [messView release];
    messView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 125, 20)];
    messView.layer.cornerRadius = 5.0;
    [messView setBackgroundColor:[UIColor darkGrayColor]];
    [self addSubview:messView];
    UILabel *mLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,3,125,15)];
    [mLabel setBackgroundColor:[UIColor clearColor]];
    [mLabel setTextColor:[UIColor whiteColor]];
    mLabel.textAlignment = NSTextAlignmentCenter;
    mLabel.font = [UIFont systemFontOfSize:12];
    if (ballMaxNum - selectBallNum == 0)
    {
        mLabel.text = [NSString stringWithFormat:@"该区不能再选了"];
    }
    else if (ballLeastNum - selectBallNum >= 0)
    {
        mLabel.text = [NSString stringWithFormat:@"至少还要选 %d 个球",ballLeastNum - selectBallNum];
    }
    else
    {
        mLabel.text = [NSString stringWithFormat:@"最多还可以选 %d 个球",ballMaxNum - selectBallNum];
    }
    [messView addSubview:mLabel];
    [mLabel release];
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideView) object:nil];//取消该方法的调用
    [self performSelector:@selector(hideView) withObject:nil afterDelay:3.0f];
    
//    [self refreshBallState];
}
- (void)hideView
{
	messView.hidden = YES;
}
- (void)refreshBallState
{
//    DLog(@"self.ballStateArray%@",self.ballStateArray);
    for (int i=0; i<self.ballStateArray.count; i++) {
        UIButton * btn =(UIButton *)[self viewWithTag:TagBallBase+i];
        if ([[self.ballStateArray objectAtIndex:i]isEqualToString:@"1"]) {
            if (ballType == Ball_Red) {
                  [btn setBackgroundImage:[UIImage imageNamed:@"ball_red.png"] forState:UIControlStateNormal];//换成红色图片
            }else{
                [btn setBackgroundImage:[UIImage imageNamed:@"ball_blue.png"] forState:UIControlStateNormal];
            }
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        }else{
            [btn setBackgroundImage:[UIImage imageNamed:@"ball_gray.png"] forState:UIControlStateNormal];//灰球
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//字体颜色
        }
    }
//    [self.delegate ballViewResultArray:self.ballStateArray selectView:self];
}
- (void)clearBallState
{
//    [self.ballStateArray removeAllObjects];
    for (int i=0; i<self.ballStateArray.count; i++) {
        [self.ballStateArray replaceObjectAtIndex:i withObject:@"0"];
    }
    selectBallNum =0;
    [self refreshBallState];
}
/* 防止选择相同的号码 */
- (void)ballViewDifferentNumber:(NSMutableArray *)numArray
{

    if (numArray.count == 0) {
        return;
    }
    DLog(@"self.ballStateArray %@  ",numArray);

    int same = 0;
    for (int i=0; i<numArray.count; i++) {
        int index = [[numArray objectAtIndex:i] intValue];
        if ([[self.ballStateArray objectAtIndex:index-1]isEqualToString:@"0"]) {
            [self.ballStateArray replaceObjectAtIndex:index-1 withObject:@"1"];
        }else{
            [self.ballStateArray replaceObjectAtIndex:index-1 withObject:@"0"];
        }
        selectBallNum --;
        same ++;
    }
    
    if (same !=0) {
        [self refreshBallState];
    }
}

- (BOOL)stateForIndex:(int)index
{
    if ([[self.ballStateArray objectAtIndex:index] isEqualToString:@"1"])
        return YES;
    else
        return NO;
}

- (void)resetStateForIndex:(int)index
{
    selectBallNum--;
    [self.ballStateArray replaceObjectAtIndex:index withObject:@"0"];
    UIButton *tmp = (UIButton *)[self viewWithTag:(TagBallBase + index)];
    [tmp setBackgroundImage:RYCImageNamed(@"ball_gray.png") forState:UIControlStateNormal];
	[tmp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
/*
 福彩3D 组三 单式
 */
- (void)differentBallGroupNumberArray:(NSArray *)numArray
{
    if (numArray.count == 0) {
        return;
    }
    int same =0;
    for (int i=0; i<numArray.count; i++) {
        int index =[[numArray objectAtIndex:i] intValue];
        if ([[self.ballStateArray objectAtIndex:index]isEqualToString:@"1"]) {
            [self.ballStateArray replaceObjectAtIndex:index withObject:@"0"];

        }else{
            [self.ballStateArray replaceObjectAtIndex:index withObject:@"1"];
        }
        selectBallNum --;
        same ++;
    }
    if (same >0) {
        [self refreshBallState];  
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
