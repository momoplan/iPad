//
//  ProgressLayer.h
//  RuYiCai
//
//  Created by huangxin on 13-9-22.
//
//

#import <QuartzCore/QuartzCore.h>

@interface ProgressLayer : CALayer
@property (nonatomic) CGFloat percent;
@property (nonatomic, retain) UIColor *color;
@property (nonatomic, assign) CGPoint layerCenter;
@property (nonatomic, assign) float    innerRadius;
@property (nonatomic, assign) float    outerRadius;
@end
