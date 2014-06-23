//
//  GoalBarView.h
//  RuYiCai
//
//  Created by huangxin on 13-9-22.
//
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>
#import "ProgressLayer.h"

@interface GoalBarView : UIView
{
    UIImage * bgImage;//背景图片
    ProgressLayer *percentLayer;
    CALayer *bgImageLayer;
    
    UILabel *m_percentLabel;
}
@property (nonatomic, retain) UILabel *percentLabel;

- (void)setPercent:(int)percent;

@end
