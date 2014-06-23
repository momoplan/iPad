//
//  ProgressLayer.m
//  RuYiCai
//
//  Created by huangxin on 13-9-22.
//
//

#import "ProgressLayer.h"
#define toRadians(x) ((x)*M_PI / 180.0)
#define toDegrees(x) ((x)*180.0 / M_PI)

@implementation ProgressLayer
@synthesize percent, color;
@synthesize layerCenter,innerRadius,outerRadius;

-(void)drawInContext:(CGContextRef)ctx {
    
    CGPoint center = layerCenter;
    
    CGFloat delta = toRadians(360 * percent);
    
    if (color) {
        CGContextSetFillColorWithColor(ctx, color.CGColor);
    } else {
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:99/256.0 green:183/256.0 blue:70/256.0 alpha:.5].CGColor);
    }
    
    CGContextSetLineWidth(ctx, 1);
    
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    CGContextSetAllowsAntialiasing(ctx, YES);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddRelativeArc(path, NULL, center.x, center.y, innerRadius, -(M_PI / 2), delta);
    CGPathAddRelativeArc(path, NULL, center.x, center.y, outerRadius, delta - (M_PI / 2), -delta);
    CGPathAddLineToPoint(path, NULL, center.x, center.y-innerRadius);
    
    CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    
    CFRelease(path);
    
}

@end
