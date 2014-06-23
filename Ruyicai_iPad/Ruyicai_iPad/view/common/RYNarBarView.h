//
//  RYNarBarView.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-6-27.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "RYView.h"

@protocol RYNarBarViewDelegate <NSObject>

@optional
//右边按钮 代理方法
- (void)narBarButtonEvent:(id)sender;

// 中间按钮 代理方法
- (void)narViewTitleButton:(id)sender;

@end

@interface RYNarBarView : RYView
{
    UIButton * item;
}

@property (nonatomic,retain) NSString * navTitle; //导航标题
@property (nonatomic,assign) id<RYNarBarViewDelegate>delegate;

/*
 初始化 narbarView
 传人两个参数 frame 为尺寸 title 为现实文字
*/
- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title;

/*
 初始化narbarView 中间显示 按钮
  frame 尺寸 btnTitle 为按钮标题
 */

- (id)initWithFrame:(CGRect)frame withButton:(NSString *)btnTitle;

/*
 //设置barItem 按钮
 参数  itemTitle 现实文字
 */
- (void)setBarButtonItemWithTitle:(NSString *)itemTitle;
@end
