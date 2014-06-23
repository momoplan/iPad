//
//  ZC_LCB_SeeDetailTableViewCell.m
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 13-1-21.
//
//

#import "ZC_LCB_SeeDetailTableViewCell.h"
#import "ZC_SeeDetailTableViewCell.h"
#import "RCLabel.h"

@interface ZC_LCB_SeeDetailTableViewCell ()

@end

@implementation ZC_LCB_SeeDetailTableViewCell
@synthesize contentStr = m_contentStr;
@synthesize isZC_JQC;
@synthesize play = m_play;

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawRectangle:context RECT:CGRectMake(0, 30, 300, 30)];
    NSString* wanfa = @"玩法：";
    if ([self.contentStr count] > 0) {
        wanfa = [wanfa stringByAppendingFormat:@"%@",self.play];
    }
    
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0); //黑
    [wanfa drawAtPoint:CGPointMake(10, 5) withFont:[UIFont systemFontOfSize:14]];
    //70 100 50 80
    [@"场次" drawAtPoint:CGPointMake(20, 35) withFont:[UIFont systemFontOfSize:14]];
    [@"对阵" drawAtPoint:CGPointMake(103, 35) withFont:[UIFont systemFontOfSize:14]];
    if(isZC_JQC)
    {
        [@"主队" drawAtPoint:CGPointMake(180, 35) withFont:[UIFont systemFontOfSize:14]];
        [@"客队" drawAtPoint:CGPointMake(250, 35) withFont:[UIFont systemFontOfSize:14]];
    }
    else
    {
        [@"半场" drawAtPoint:CGPointMake(180, 35) withFont:[UIFont systemFontOfSize:14]];
        [@"全场" drawAtPoint:CGPointMake(250, 35) withFont:[UIFont systemFontOfSize:14]];
    }
    [self drawLine:context TOPLEFTPOINT:CGPointMake(70, 30) BOTTOMRIGHTPOINT:CGPointMake(70, 60)];
    [self drawLine:context TOPLEFTPOINT:CGPointMake(162, 30) BOTTOMRIGHTPOINT:CGPointMake(162, 60)];
    [self drawLine:context TOPLEFTPOINT:CGPointMake(232, 30) BOTTOMRIGHTPOINT:CGPointMake(232, 60)];

    NSInteger heightIndex = 60;
    NSInteger cellheight = zcCellHeight;
    for (int i = 0; i < [self.contentStr count]; i++) {
        NSInteger currentCellHeight = cellheight;
        NSString* bianhao = KISNullValue(self.contentStr, i, @"teamId");
        
        NSString* homeTeam = KISNullValue(self.contentStr, i,@"homeTeam");
        NSString* guestTeam = KISNullValue(self.contentStr, i,@"guestTeam");
        NSString* duiZhen = @"VS";
        
        NSString* betContentHalf;//半场、主队
        NSString* betContentAll;//全场、客队

        if (isZC_JQC)
        {
            betContentHalf = KISNullValue(self.contentStr, i,@"betContentHome");//主队
            betContentAll = KISNullValue(self.contentStr, i,@"betContentGuest");//客队
        }
        else
        {
            betContentHalf = KISNullValue(self.contentStr, i,@"betContentHalf");//半场
            betContentAll = KISNullValue(self.contentStr, i,@"betContentAll");//全场
        }

        CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0); //黑
        
        [bianhao drawInRect:CGRectMake(0, heightIndex + 20, 70, cellheight) withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        
        [homeTeam drawInRect:CGRectMake(70, heightIndex + 5, 92, 20) withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        
        [duiZhen drawInRect:CGRectMake(70, heightIndex + 22, 92, 20) withFont:[UIFont systemFontOfSize:12] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];

        [guestTeam drawInRect:CGRectMake(70, heightIndex + 35, 92, 20) withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        
        RCLabel *tempLabel_half = [[RCLabel alloc] initWithFrame:CGRectMake(167,heightIndex + 20,60,cellheight - 10)];
        betContentHalf = [betContentHalf stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        RTLabelComponentsStructure *componentsDS_half = [RCLabel extractTextStyle:betContentHalf];
        tempLabel_half.componentsAndPlainText = componentsDS_half;
        [self addSubview:tempLabel_half];

        RCLabel *tempLabel_all = [[RCLabel alloc] initWithFrame:CGRectMake(237,heightIndex + 20,60,cellheight - 10)];
        betContentAll = [betContentAll stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        RTLabelComponentsStructure *componentsDS_all = [RCLabel extractTextStyle:betContentAll];
        tempLabel_all.componentsAndPlainText = componentsDS_all;
        [self addSubview:tempLabel_all];
        //画线
        //肃
        [self drawLine:context TOPLEFTPOINT:CGPointMake(0, heightIndex) BOTTOMRIGHTPOINT:CGPointMake(0, heightIndex + currentCellHeight)];
        [self drawLine:context TOPLEFTPOINT:CGPointMake(70, heightIndex) BOTTOMRIGHTPOINT:CGPointMake(70, heightIndex + currentCellHeight)];
        [self drawLine:context TOPLEFTPOINT:CGPointMake(162, heightIndex) BOTTOMRIGHTPOINT:CGPointMake(162, heightIndex + currentCellHeight)];
        [self drawLine:context TOPLEFTPOINT:CGPointMake(232, heightIndex) BOTTOMRIGHTPOINT:CGPointMake(232, heightIndex + currentCellHeight)];
        [self drawLine:context TOPLEFTPOINT:CGPointMake(300, heightIndex) BOTTOMRIGHTPOINT:CGPointMake(300, heightIndex + currentCellHeight)];

        //横
        [self drawLine:context TOPLEFTPOINT:CGPointMake(0, heightIndex + currentCellHeight) BOTTOMRIGHTPOINT:CGPointMake(300, heightIndex + currentCellHeight)];
        heightIndex += currentCellHeight;
        
    }
    
}

- (void)drawText:(CGContextRef)_context RECT:(CGRect)rect  TEXT:(NSString*)text
{
    //    // 设置旋转字体
    //    CGAffineTransform myTextTransform = CGAffineTransformMakeRotation(radians(270));
    //    CGContextSetTextMatrix(_context, myTextTransform);
    
    // 设置字体：为16pt Helvetica
    CGContextSelectFont(_context, "Helvetica", 12.0, kCGEncodingMacRoman);
    //设置文字绘制模式
    // 3种绘制模式：kCGTextFill 填充, kCGTextStroke 描边, kCGTextFillStroke 既填充又描边
    CGContextSetTextDrawingMode(_context, kCGTextStroke); // set drawing mode
    // 设置文本颜色字符为黑色
    CGContextSetRGBFillColor(_context, 0.0, 0.0, 0.0, 1.0); //黑
    //从文本空间到用户控件的转换矩阵 删除的话数字是倒放的
    CGContextSetTextMatrix(_context, CGAffineTransformMakeScale(1.0, -1.0));
    
    CGContextShowTextAtPoint(_context, rect.origin.x, rect.origin.y, [text UTF8String],
                             text.length);
}

- (void)drawRectangle:(CGContextRef)_context RECT:(CGRect)rect
{
    CGContextSetLineWidth(_context, 0.2);
    CGContextSetRGBFillColor(_context, 248.0/255.0, 248.0/255.0, 246.0/255.0, 1);
    CGContextFillRect(_context, rect);
    CGContextStrokePath(_context);//填充
    
    CGContextSetLineWidth(_context, 0.5);
    CGContextSetRGBStrokeColor(_context, 221.0/255.0, 221.0/255.0, 221.0/255.0, 1);
    CGContextAddRect(_context,rect);//边框
    CGContextStrokePath(_context);
}

- (void)drawLine:(CGContextRef)_context  TOPLEFTPOINT:(CGPoint)topLeftPoint BOTTOMRIGHTPOINT:(CGPoint)bottomRightPoint
{
    CGContextSetRGBStrokeColor(_context, 120.0/255.0, 120.0/255.0, 120.0/255.0, 1); //笔色
    CGContextSetLineWidth(_context, 0.2);

    CGContextMoveToPoint(_context, topLeftPoint.x, topLeftPoint.y);
    CGContextAddLineToPoint(_context, bottomRightPoint.x, bottomRightPoint.y);
    
    CGContextStrokePath(_context);
}

@end
