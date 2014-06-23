//
//  PickNumSelectResultView.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-22.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "PickNumSelectResultView.h"

@implementation PickNumSelectResultView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView * topBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 34)];
        topBg.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"bottomrepeat.png")];
        [self addSubview:topBg];
        [topBg release];
        
        UIView * downBg = [[UIView alloc]initWithFrame:CGRectMake(0, 34, frame.size.width, 73)];
        downBg.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"result_down_bg.png")];
        [self addSubview:downBg];
        [downBg release];
        
        int grade = 0;
        int payMent = 0;
        resultLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 20)];
        resultLabel.backgroundColor = [UIColor clearColor];
        resultLabel.text = [NSString stringWithFormat:@"当前已选择了 %d 注 共%d 元",grade,payMent];
        [self addSubview:resultLabel];
        
        UIButton * afreshButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [afreshButton setTitle:@"重选" forState:UIControlStateNormal];
        [afreshButton setBackgroundImage:RYCImageNamed(@"result_ref-normal.png") forState:btnNormal];
        [afreshButton  setBackgroundImage:RYCImageNamed(@"result_ref-click.png") forState:UIControlStateHighlighted];
        afreshButton.frame = CGRectMake(100, 45, 126, 46);
        [afreshButton addTarget:self action:@selector(selectAfreshButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:afreshButton];
        
        UIButton * addToBaskBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        addToBaskBtn.frame = CGRectMake(280, 45, 144, 46);
        [addToBaskBtn setBackgroundImage:RYCImageNamed(@"buyNormal.png") forState:btnNormal];
        [addToBaskBtn setBackgroundImage:RYCImageNamed(@"buyClick.png") forState:UIControlStateHighlighted];
        [addToBaskBtn setTitle:@"添加到号码篮" forState:UIControlStateNormal];
        addToBaskBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [addToBaskBtn setTitleColor:[UIColor whiteColor] forState:btnNormal];
        [addToBaskBtn addTarget:self action:@selector(selectAddToBaskButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addToBaskBtn];

    }
    return self;
}
- (void)dealloc
{
    self.delegate = nil;
    [resultLabel release];
    [super dealloc];

}
- (void)resultLabelRefreshCount:(int)noteCount
{
    resultLabel.text = [NSString stringWithFormat:@"当前已选择了 %d 注 共%d 元",noteCount,noteCount*2];

}
/* 刷新*/
- (void)selectAfreshButtonAction:(id)sender
{
    [self.delegate pickSelectResultRefreshAction:sender];
}
/* 添加到号码篮*/
- (void)selectAddToBaskButtonAction:(id)sender
{
    [self.delegate pickselectResultAddToBaskAction:sender];
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
