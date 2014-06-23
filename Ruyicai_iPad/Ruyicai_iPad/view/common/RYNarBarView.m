//
//  RYNarBarView.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-6-27.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "RYNarBarView.h"

@implementation RYNarBarView
@synthesize navTitle;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        navTitle = [title retain];//传入的title 赋值给属性navTitle
        [self initView];//自定义view
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame withButton:(NSString *)btnTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        navTitle = [btnTitle retain];//传入的title 赋值给属性navTitle
        [self initViewWithButton];//自定义view
    }
    return self;
}

#pragma mark ------------- init
- (void)initViewWithButton
{
    self.backgroundColor = RGBCOLOR(20, 15, 15);//设置背景颜色
    
    if (navTitle) {
        UIButton * titleBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        titleBtn.frame = CGRectMake(self.frame.size.width/2-75, 10, 150, 50);
        titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:25];
        titleBtn.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [titleBtn setTitle:navTitle forState:UIControlStateNormal];
        [titleBtn addTarget:self action:@selector(titleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:titleBtn];
    }
}

//自定义view 中间显示文字
- (void)initView{
//    CGRect rect = self.frame;
    self.backgroundColor = RGBCOLOR(20, 15, 15);//设置背景颜色

    //创建 标题
    if (navTitle) { //判断
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(400, 10, 150, 30)]; // 设置显示label 尺寸
        titleLabel.backgroundColor = [UIColor clearColor];// 背景设置为透明
        titleLabel.textColor = [UIColor whiteColor]; //字体颜色 黑色
        titleLabel.text = navTitle; //label 显示信息赋值
        titleLabel.font = [UIFont boldSystemFontOfSize:30]; //字体大小 黑体 30
        titleLabel.textAlignment = NSTextAlignmentCenter; // 文字居中显示
        [self addSubview:titleLabel]; // 加载到视图上
        [titleLabel release]; //释放
    }
    
}
//设置 barItem
- (void)setBarButtonItemWithTitle:(NSString *)itemTitle
{
    if (itemTitle.length > 0) { // 判断不为空
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOK:) name:@"loginOK" object:nil];
        item =[UIButton buttonWithType:UIButtonTypeRoundedRect]; //初始化按钮
        item.frame = CGRectMake(800, 10, 100, 40); // 设置尺寸
        [item setTitle:itemTitle forState:UIControlStateNormal]; // 设置那就标题
        [item addTarget:self action:@selector(itemButtonEvent:) forControlEvents:UIControlEventTouchUpInside]; // 绑定事件
        [self addSubview:item]; // 加到视图上
        
    }
}

#pragma mark ---------------- event methods

//按钮 事件
- (void)itemButtonEvent:(id)sender
{
    [self.delegate narBarButtonEvent:sender]; //代理调用
}


- (void)titleButtonClicked:(id)sender
{
    
    [self.delegate narViewTitleButton:sender];
}

-(void)loginOK:(NSNotification*)notification
{
    [item setTitle:@"注销" forState:UIControlStateNormal];
}
- (void)dealloc{
    [navTitle release];
    [super dealloc];

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
