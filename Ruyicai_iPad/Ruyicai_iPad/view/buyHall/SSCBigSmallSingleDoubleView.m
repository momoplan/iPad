//
//  SSCBigSmallSingleDoubleView.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-26.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "SSCBigSmallSingleDoubleView.h"

@implementation SSCBigSmallSingleDoubleView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UILabel *messLabel =[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 530, 70)];
        messLabel.backgroundColor =[UIColor clearColor];
        messLabel.textColor = [UIColor redColor];
        messLabel.text = @"每位各选1个号码投注,所选号码与开奖的个位十位号码性质位置相符即中奖！\n奖金：4元";
        messLabel.numberOfLines = 0;
        [self addSubview:messLabel];
        [messLabel release];
        
        decStateArray = [[NSMutableArray alloc]init];
        indStateArray = [[NSMutableArray alloc]init];
        
        [self setDecadeAreaView];
        [self setUnitAreaView];
    }
    return self;
}
- (void)dealloc
{
    self.delegate = nil;
    [decStateArray release];
    [indStateArray release];
    
    [super dealloc];

}
#define TAG_DECADE_BUTTON10 10
/* 十位 */
- (void)setDecadeAreaView
{
    UILabel * titLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 70, 200, 20)];
    titLabel.backgroundColor = [UIColor clearColor];
    titLabel.text = @"十位区（选择1个）";
    [self addSubview:titLabel];
    [titLabel release];
    decSelectNum = 0;
    NSArray * array= @[@"大",@"小",@"单",@"双"];
    for (int i=0; i<array.count; i++) {
        UIButton  * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(50+(50*i), 100, 40, 40);
        [button setBackgroundImage:RYCImageNamed(@"ball_gray.png") forState:btnNormal];
        [button setTitle:[array objectAtIndex:i] forState:btnNormal];
        [button setTitleColor:[UIColor blackColor] forState:btnNormal];
        button.tag = TAG_DECADE_BUTTON10 + i;
        [button addTarget:self action:@selector(decadeButtonAction:) forControlEvents:btnTouch];
        [self addSubview:button];
        [decStateArray addObject:@"0"];
    }
}
/* 个位 */
#define TAG_UNIT_BUTTON20 20
- (void)setUnitAreaView
{
    UILabel * titLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 170, 200, 20)];
    titLabel.backgroundColor = [UIColor clearColor];
    titLabel.text = @"个位区（选择1个）";
    [self addSubview:titLabel];
    [titLabel release];
    indSelectNum = 0;
    NSArray * array= @[@"大",@"小",@"单",@"双"];
    for (int i=0; i<array.count; i++) {
        UIButton  * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(50+(50*i), 200, 40, 40);
        [button setBackgroundImage:RYCImageNamed(@"ball_gray.png") forState:btnNormal];
        [button setTitle:[array objectAtIndex:i] forState:btnNormal];
        [button setTitleColor:[UIColor blackColor] forState:btnNormal];
        button.tag = TAG_UNIT_BUTTON20 + i;
        [button addTarget:self action:@selector(unitButtonAction:) forControlEvents:btnTouch];
        [self addSubview:button];
        [indStateArray addObject:@"0"];
    }

}
#pragma mark =============  methods
- (void)decadeButtonAction:(id)sender
{
    UIButton * button = (UIButton *)sender;
    int ballMaxSelect =1;
    DLog(@"button.tag %d",button.tag);
    
  
    int index =button.tag - TAG_DECADE_BUTTON10;
    
     if ([[decStateArray objectAtIndex:index]isEqualToString:@"0"]) {
         if (decSelectNum<ballMaxSelect) {
             [decStateArray replaceObjectAtIndex:index withObject:@"1"];
             [button setBackgroundImage:RYCImageNamed(@"ball_red.png") forState:btnNormal];
             [button setTitleColor:[UIColor whiteColor] forState:btnNormal];
             decSelectNum++;
         }
        
     }else
     {
         [decStateArray replaceObjectAtIndex:index withObject:@"0"];
         [button setBackgroundImage:RYCImageNamed(@"ball_gray.png") forState:btnNormal];
         [button setTitleColor:[UIColor blackColor] forState:btnNormal];
         decSelectNum--;
         if (decSelectNum<0) {
             decSelectNum=0;
         }

     }
     [decMessView removeFromSuperview];
    [decMessView release];
    decMessView =[[UIView alloc]initWithFrame:CGRectMake(250, 70, 150, 20)];
    decMessView.layer.cornerRadius = 5.0;
    decMessView.backgroundColor = [UIColor grayColor];
    [self addSubview:decMessView];
    UILabel * label =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    if (ballMaxSelect - decSelectNum ==0) {
        label.text = [NSString stringWithFormat:@"该区不能再选了"];
    }else if (ballMaxSelect - decSelectNum>0)
    {
        label.text = [NSString stringWithFormat:@"至少还要选 %d 个球",ballMaxSelect - decSelectNum];

    }
    [decMessView addSubview:label];
    [label release];
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(decHideView) object:nil];//取消该方法的调用
    [self performSelector:@selector(decHideView) withObject:nil afterDelay:3.0f];
    [self.delegate bigSmallSingDoubleViewSelectResultDecArray:decStateArray indArray:indStateArray];
}
- (void)unitButtonAction:(id)sender
{
    UIButton * button = (UIButton *)sender;
    int ballMaxSelect =1;
    DLog(@"button.tag %d",button.tag);
    
    
    int index =button.tag - TAG_UNIT_BUTTON20;
    
    if ([[indStateArray objectAtIndex:index]isEqualToString:@"0"]) {
        if (indSelectNum<ballMaxSelect) {
            [indStateArray replaceObjectAtIndex:index withObject:@"1"];
            [button setBackgroundImage:RYCImageNamed(@"ball_red.png") forState:btnNormal];
            [button setTitleColor:[UIColor whiteColor] forState:btnNormal];
            indSelectNum++;
        }
        
    }else
    {
        [indStateArray replaceObjectAtIndex:index withObject:@"0"];
        [button setBackgroundImage:RYCImageNamed(@"ball_gray.png") forState:btnNormal];
        [button setTitleColor:[UIColor blackColor] forState:btnNormal];
        indSelectNum--;
        if (indSelectNum<0) {
            indSelectNum=0;
        }
        
    }
    [indMessView removeFromSuperview];
    [indMessView release];
    indMessView =[[UIView alloc]initWithFrame:CGRectMake(250, 170, 150, 20)];
    indMessView.backgroundColor = [UIColor grayColor];
    indMessView.layer.cornerRadius = 5.0;
    [self addSubview:indMessView];
    UILabel * label =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    if (ballMaxSelect - indSelectNum ==0) {
        label.text = [NSString stringWithFormat:@"该区不能再选了"];
    }else if (ballMaxSelect - indSelectNum>0)
    {
        label.text = [NSString stringWithFormat:@"至少还要选 %d 个球",ballMaxSelect - decSelectNum];
        
    }
    [indMessView addSubview:label];
    [label release];
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(indHideView) object:nil];//取消该方法的调用
    [self performSelector:@selector(indHideView) withObject:nil afterDelay:3.0f];
    [self.delegate bigSmallSingDoubleViewSelectResultDecArray:decStateArray indArray:indStateArray];

}
- (void)decHideView
{
	decMessView.hidden = YES;
}
- (void)indHideView
{
    indMessView.hidden =YES;
}

- (void)clearAllSelectState{
    for ( int i=0; i<decStateArray.count; i++) {
        [decStateArray replaceObjectAtIndex:i withObject:@"0"];
        UIButton *button =(UIButton *)[self viewWithTag:TAG_DECADE_BUTTON10+i];
        [button setBackgroundImage:RYCImageNamed(@"ball_gray.png") forState:btnNormal];
        [button setTitleColor:[UIColor blackColor] forState:btnNormal];
    }
    decSelectNum =0;
    
    for ( int i=0; i<indStateArray.count; i++) {
        [indStateArray replaceObjectAtIndex:i withObject:@"0"];
        UIButton *button =(UIButton *)[self viewWithTag:TAG_UNIT_BUTTON20+i];
        [button setBackgroundImage:RYCImageNamed(@"ball_gray.png") forState:btnNormal];
        [button setTitleColor:[UIColor blackColor] forState:btnNormal];
    }
    indSelectNum= 0;
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
