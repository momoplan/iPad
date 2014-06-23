//
//  CustomFormView.h
//  Ruyicai_iPad
//
//  Created by huangxin on 13-7-24.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FORMCELLTAG 300

@interface CustomFormView : UIView
{
    float            m_lineWidth;//线条的粗细
    UIColor          *m_lineColor;//线条的颜色
    
    float            m_titleFontSize;//标题字体大小
    float            m_contentFontSize;//内容字体大小
    UIColor          *m_titleWordColor;//标题字的颜色
    UIColor          *m_contentWordColor;//内容字的颜色
    UIColor          *m_titleBgColor;//标题背景色
    UIColor          *m_contentBgColor;//内容背景色
    
    int              m_row;//行数
    int              m_vertical;//列数
    NSArray         *m_rowHeithArray;//各行高数组
    NSArray         *m_vWidthArray;//列宽数组
}
@property (nonatomic,assign) UIColor *lineColor;
@property (nonatomic,assign) float lineWidth;
@property (nonatomic,assign) int row;
@property (nonatomic,assign) int vertical;
@property (nonatomic,retain) NSArray* rowHeithArray;
@property (nonatomic,retain) NSArray* vWidthArray;

@property (nonatomic,assign) float titleFontSize;
@property (nonatomic,assign) float contentFontSize;

@property (nonatomic,assign) UIColor* titleWordColor;
@property (nonatomic,assign) UIColor* contentWordColor;
@property (nonatomic,assign) UIColor* titleBgColor;
@property (nonatomic,assign) UIColor* contentBgColor;

//获取表单元格的Rect
- (CGRect) getFormRectWithRow:(int)row Vertical:(int) vertical;

//绘制单元格
- (void) drawCell;

//查找单元格上的Label
- (UILabel*) getCellLabelWithTag:(int) tag;

//给单元格添加内容
- (void) setFormCellContentWithArray:(NSMutableArray*) contentArray;

@end
