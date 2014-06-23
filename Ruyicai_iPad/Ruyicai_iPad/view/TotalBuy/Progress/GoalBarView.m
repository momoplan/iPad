//
//  GoalBarView.m
//  RuYiCai
//
//  Created by huangxin on 13-9-22.
//
//

#import "GoalBarView.h"

@implementation GoalBarView

@synthesize percentLabel = m_percentLabel;


- (void) dealloc
{
    [m_percentLabel release];
    
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //frame   CGRectMake(15, 22, 50, 50)
        self.backgroundColor = [UIColor clearColor];
        bgImage = [UIImage imageNamed:@"circle.png"];
        
        m_percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (frame.size.height-20)/2+10, frame.size.width, 20)];
        m_percentLabel.font = [UIFont systemFontOfSize:15];
        
        [m_percentLabel setTextAlignment:NSTextAlignmentCenter];
        [m_percentLabel setBackgroundColor:[UIColor clearColor]];
        m_percentLabel.adjustsFontSizeToFitWidth = YES;
        m_percentLabel.text = @"99%";
        [self addSubview:m_percentLabel];
        
        UILabel *titLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, (frame.size.height-20)/2-10, frame.size.width, 20)];
        titLabel.backgroundColor =[UIColor clearColor];
        titLabel.textAlignment = NSTextAlignmentCenter;
        titLabel.text = @"进度";
        titLabel.font = m_percentLabel.font;
        [self addSubview:titLabel];
        [titLabel release];

        
        bgImageLayer = [CALayer layer];
        bgImageLayer.contentsScale = [UIScreen mainScreen].scale;
        bgImageLayer.contents = (id) bgImage.CGImage;
        bgImageLayer.frame = CGRectMake(0, 0, 66, 66);
        
        percentLayer = [ProgressLayer layer];
        percentLayer.contentsScale = [UIScreen mainScreen].scale;
        percentLayer.percent = 0;
        percentLayer.layerCenter = CGPointMake(33 , 33);
        percentLayer.innerRadius = 33 - 8;
        percentLayer.outerRadius = 33;
        percentLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        percentLayer.masksToBounds = NO;
        [percentLayer setNeedsDisplay];
        
        [self.layer addSublayer:bgImageLayer];
        [self.layer addSublayer:percentLayer];
        [bgImageLayer removeAnimationForKey:@"frame"];
        
    }
    return self;
}


- (void)setPercent:(int)percent
{
    CGFloat floatPercent = percent / 100.0;
    floatPercent = MIN(1, MAX(0, floatPercent));
    m_percentLabel.text = [NSString stringWithFormat:@"%d%%",percent];
    if (percent < 50) {
        m_percentLabel.textColor = [UIColor colorWithRed:0.0 green:200.0/255.0 blue:0.0 alpha:1.0];
        percentLayer.color = [UIColor colorWithRed:0.0 green:200.0/255.0 blue:0.0 alpha:1.0];
    }else{
        m_percentLabel.textColor = [UIColor colorWithRed:200.0/255.0 green:0.0 blue:0.0 alpha:1.0];
        percentLayer.color = [UIColor colorWithRed:200.0/255.0 green:0.0 blue:0.0 alpha:1.0];
    }
    percentLayer.percent = floatPercent;
    [self setNeedsLayout];
    [percentLayer setNeedsDisplay];
}

@end
