//
//  PickNumPlayKindSelectView.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-21.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "PickNumPlayKindSelectView.h"

@interface PickNumPlayKindSelectView ()
{
    NSArray * arrayTitle;
    NSArray * arrayKind;
}
@end

@implementation PickNumPlayKindSelectView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
#define btnCustom UIButtonTypeCustom
#define btnNormal UIControlStateNormal
#define btnTouch UIControlEventTouchUpInside
#define TagButtonKind 1000
- (id)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleAry kindArray:(NSArray *)kindAry
{
    self = [super initWithFrame:frame];
    if (self) {
        arrayKind = [[NSArray alloc]initWithArray:kindAry];
        arrayTitle = [[NSArray alloc]initWithArray:titleAry];
        
        [self playKindSelectViewFrame:frame titleArray:titleAry kind:kindAry];
    }
    return self;
}
- (void)dealloc
{
    self.delegate = nil;
    [arrayTitle release];
    [arrayKind release];
    
    [super dealloc];

}
- (void)playKindSelectViewFrame:(CGRect)frame titleArray:(NSArray *)titltArray kind:(NSArray *)kindAry
{
    UIImageView * bgImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    bgImageView.image = RYCImageNamed(@"playSelectBg.png");
    [self addSubview:bgImageView];
    [bgImageView release];
    int kind ;
    if ([[kindAry objectAtIndex:0] count]>3) {
       kind = [[kindAry objectAtIndex:0] count]/3 -1;
    }else{
        kind=0;
    }
    for (int i=0; i<titltArray.count; i++) {
        UILabel * titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 50+(50*i)+(50*kind*i), 70, 40)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:19];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = [titltArray objectAtIndex:i];
        [self addSubview:titleLabel];
        [titleLabel release];
        NSArray * array = [kindAry objectAtIndex:i];
        for (int j=0; j<array.count; j++) {
            UIButton * button =[UIButton buttonWithType:btnCustom];
            int line = j/3;
            int row = j%3;
            button.frame = CGRectMake(100+(105*row), titleLabel.frame.origin.y+(50*line), 95, 40);
            [button setTitle:[array objectAtIndex:j] forState:btnNormal];
            [button setBackgroundImage:RYCImageNamed(@"playBtnNro.png") forState:btnNormal];
            [button setTitleColor:RGBCOLOR(51, 51, 51) forState:btnNormal];
            [button setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateHighlighted];
            [button setBackgroundImage:RYCImageNamed(@"playSelectClick.png") forState:UIControlStateHighlighted];
            button.tag = TagButtonKind + 100*i +j;
            [button addTarget:self action:@selector(playKindSelectButtonAction:)forControlEvents:btnTouch];
            [self addSubview:button];
        }
    }
}
- (void)playKindSelectButtonAction:(id)sender
{
    UIButton * button = (UIButton *)sender;
    int line = (button.tag - TagButtonKind)/100;
    int row = (button.tag - TagButtonKind)%100;
    NSArray * array = [arrayKind objectAtIndex:line];
    NSString *btnStr =[NSString stringWithFormat:@"%@-%@",[arrayTitle objectAtIndex:line],[array objectAtIndex:row]];
    DLog(@"btnStr %@",btnStr);
    [self.delegate pickPlayKindSelectLine:line row:row title:btnStr];
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
