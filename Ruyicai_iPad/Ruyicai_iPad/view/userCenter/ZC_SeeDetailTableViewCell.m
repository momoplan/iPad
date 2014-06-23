//
//  ZC_SeeDetailTableViewCell.m
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 13-1-16.
//
//

#import "ZC_SeeDetailTableViewCell.h"
#import "RCLabel.h"

@interface ZC_SeeDetailTableViewCell ()

@end

@implementation ZC_SeeDetailTableViewCell

@synthesize contentStr = m_contentStr;
@synthesize play = m_play;

//{"display":"true","visibility":"","result":[{"lotName":"足球胜负彩","play":"单式","result":[
//{"teamId":"1","homeTeam":"埃尔夫","guestTeam":"霍森斯","betContent":"1"},{"teamId":"2","homeTeam":"","guestTeam":"","betContent":"1"}

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
    [@"对阵" drawAtPoint:CGPointMake(130, 35) withFont:[UIFont systemFontOfSize:14]];
    [@"您的选项" drawAtPoint:CGPointMake(233, 35) withFont:[UIFont systemFontOfSize:14]];
    [self drawLine:context TOPLEFTPOINT:CGPointMake(70, 30) BOTTOMRIGHTPOINT:CGPointMake(70, 60)];
    [self drawLine:context TOPLEFTPOINT:CGPointMake(220, 30) BOTTOMRIGHTPOINT:CGPointMake(220, 60)];
    
    NSInteger heightIndex = 60;
    NSInteger cellheight = zcCellHeight;
    for (int i = 0; i < [self.contentStr count]; i++) {
        NSInteger currentCellHeight = cellheight;
        NSString* bianhao = KISNullValue(self.contentStr, i, @"teamId");
        
        NSString* homeTeam = KISNullValue(self.contentStr, i,@"homeTeam");
        NSString* guestTeam = KISNullValue(self.contentStr, i,@"guestTeam");
        NSString* duiZhen = @"VS";
        
                    
        NSString* betContent = KISNullValue(self.contentStr, i,@"betContent");
        NSString* isDanMa = [KISNullValue(self.contentStr, i, @"isDanMa") isEqualToString:@"true"] ? @"(胆)" : @"";
        
        CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0); //黑

        [bianhao drawInRect:CGRectMake(0, heightIndex + 20, 70, cellheight) withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];

        [homeTeam drawInRect:CGRectMake(70, heightIndex + 5, 150, 20) withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];

        [duiZhen drawInRect:CGRectMake(70, heightIndex + 22, 150, 20) withFont:[UIFont systemFontOfSize:12] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];

        [guestTeam drawInRect:CGRectMake(70, heightIndex + 35, 150, 20) withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        
        RCLabel *tempLabel = [[RCLabel alloc] initWithFrame:CGRectMake(225,heightIndex + 20,50,cellheight - 10)];
        betContent = [betContent stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:betContent];
        tempLabel.componentsAndPlainText = componentsDS;
        [self addSubview:tempLabel];
        
        CGContextSetRGBFillColor(context, 1.0, 128.0/255.0, 0, 1.0); //蛋黄

        [isDanMa drawInRect:CGRectMake(275, heightIndex + cellheight - 20, 25, cellheight) withFont:[UIFont systemFontOfSize:12] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        
        //画线
        //肃
        [self drawLine:context TOPLEFTPOINT:CGPointMake(0, heightIndex) BOTTOMRIGHTPOINT:CGPointMake(0, heightIndex + currentCellHeight)];
        [self drawLine:context TOPLEFTPOINT:CGPointMake(70, heightIndex) BOTTOMRIGHTPOINT:CGPointMake(70, heightIndex + currentCellHeight)];
        [self drawLine:context TOPLEFTPOINT:CGPointMake(220, heightIndex) BOTTOMRIGHTPOINT:CGPointMake(220, heightIndex + currentCellHeight)];
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
    CGContextSelectFont(_context, "Helvetica", 12, kCGEncodingMacRoman);
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
    CGContextSetLineWidth(_context, 2.0);
    CGContextSetRGBFillColor(_context, 248.0/255.0, 248.0/255.0, 246.0/255.0, 1);
    CGContextFillRect(_context, rect);
    CGContextStrokePath(_context);
    
    CGContextAddRect(_context,rect);
    CGContextSetLineWidth(_context, 0.5);
    CGContextSetRGBStrokeColor(_context, 221.0/255.0, 221.0/255.0, 221.0/255.0, 1);
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
