//
//  CustomFormView.m
//  Ruyicai_iPad
//
//  Created by huangxin on 13-7-24.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "CustomFormView.h"

@implementation CustomFormView
@synthesize lineWidth = m_lineWidth;
@synthesize row = m_row;
@synthesize vertical = m_vertical;
@synthesize rowHeithArray = m_rowHeithArray;
@synthesize vWidthArray = m_vWidthArray;
@synthesize lineColor = m_lineColor;
@synthesize titleFontSize = m_titleFontSize;
@synthesize contentFontSize = m_contentFontSize;
@synthesize titleWordColor = m_titleWordColor;
@synthesize contentWordColor = m_contentWordColor;
@synthesize titleBgColor = m_titleBgColor;
@synthesize contentBgColor = m_contentBgColor;

- (void) dealloc
{
    [m_rowHeithArray release];
    [m_vWidthArray release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.lineWidth = 1.0;
        self.lineColor = [UIColor blackColor];
        self.titleFontSize = 16.0;
        self.contentFontSize = 16.0;
        self.titleWordColor = [UIColor blackColor];
        self.contentWordColor = [UIColor blackColor];
        self.titleBgColor = [UIColor whiteColor];
        self.contentBgColor = [UIColor whiteColor];
        
        self.backgroundColor = [UIColor whiteColor];
        self.row = 0;
        self.vertical = 0;
        
        m_rowHeithArray = [[NSArray alloc] init];
        m_vWidthArray = [[NSArray alloc] init];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    
    //先画行
    for (int i = 0; i <= self.row; i++) {
        
        CGContextMoveToPoint(context, 0 ,[self calculateRowStartPointWithRow:i]);
        CGContextAddLineToPoint(context,
                                [self calculateRowStartPointWithVertical:self.vertical],
                                [self calculateRowStartPointWithRow:i]);
        CGContextStrokePath(context);
    }
    
    //再画列
    for (int j = 0; j <= self.vertical; j++) {
        CGContextMoveToPoint(context, [self calculateRowStartPointWithVertical:j], 0);
        CGContextAddLineToPoint(context, [self calculateRowStartPointWithVertical:j],
                                [self calculateRowStartPointWithRow:self.row]);
        CGContextStrokePath(context);
    }
}

//计算某一行的起点
- (float) calculateRowStartPointWithRow:(int) row
{
    float start = 0.0;
    for (int i = 0; i <= self.row; i++) {
        if (i > row) {
            break;
        }
        else if(i == 0)
        {
           start = 0.0;
        }
        else
            start += [[m_rowHeithArray objectAtIndex:i - 1] floatValue];
    }
    return start;
}

//计算每一列的起点
- (float) calculateRowStartPointWithVertical:(int) vertical
{
    float start = 0.0;
    for (int i = 0; i <= self.vertical; i++) {
        if (i > vertical) {
            break;
        }
        else if(i == 0)
        {
            start = 0.0;
        }
        else
            start += [[m_vWidthArray objectAtIndex:i - 1] floatValue];
    }
    return start;
}

//获取表单元格的Rect
- (CGRect) getFormRectWithRow:(int)row Vertical:(int) vertical
{
    CGRect formRect = CGRectZero;
    
    float originX = 0.0;
    float originY = 0.0;
    float width = 0.0;
    float height = 0.0;
    
    for (int i = 1; i <= row; i++)
    {
        if (i == 1) {
            originY = 0.0;
        }
        else{
            originY += [[m_rowHeithArray objectAtIndex:i - 2] floatValue];
        }
        height = [[m_rowHeithArray objectAtIndex:i - 1] floatValue];
    }
    
    for (int j = 1; j <= vertical; j++) {
        if (j == 1) {
            originX = 0.0;
        }
        else {
            originX += [[m_vWidthArray objectAtIndex:j - 2] floatValue];
        }
        width = [[m_vWidthArray objectAtIndex:j - 1] floatValue];
    }
    
    formRect = CGRectMake(originX, originY, width, height);
    
    return formRect;
}

//绘制单元格
- (void) drawCell
{
    for (int i = 1; i <= self.row; i++) {
        for (int j = 1; j <= self.vertical; j++) {
            UILabel *label = [[UILabel alloc] init];
            CGRect rect = [self getFormRectWithRow:i Vertical:j];
            label.frame = CGRectMake(rect.origin.x + self.lineWidth,
                                     rect.origin.y + self.lineWidth,
                                     rect.size.width - self.lineWidth,
                                     rect.size.height - self.lineWidth);
            if (i == 1){
                label.font = [UIFont systemFontOfSize:self.titleFontSize];
                label.textColor = self.titleWordColor;
                label.backgroundColor = self.titleBgColor;
            }
            else {
                label.font = [UIFont systemFontOfSize:self.contentFontSize];
                label.textColor = self.contentWordColor;
                label.backgroundColor = self.contentBgColor;
            }
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = FORMCELLTAG + j + i * self.vertical;
            [self addSubview:label];
            [label release];
        }
    }
}

//查找单元格上的Label
- (UILabel*) getCellLabelWithTag:(int) tag
{
    id mySubView = [self viewWithTag:tag];
    if ([mySubView isKindOfClass:[UILabel class]]) {
        return mySubView;
    }
    else{
        return nil;
    }
}


//给单元格添加内容
- (void) setFormCellContentWithArray:(NSMutableArray*) contentArray
{
    int cellNum = self.row * self.vertical;
    if (cellNum <= [contentArray count])
    {
        for (int i = 1; i <= self.row; i++)
        {
            for (int j = 1; j <= self.vertical; j++)
            {
                int index = (j + (i -1) * self.vertical) - 1;
                int labelTag = FORMCELLTAG + j + i * self.vertical;
                UILabel *label = (UILabel*)[self getCellLabelWithTag:labelTag];
                label.text = [contentArray objectAtIndex:index];
            }
        }
    }
}

@end
