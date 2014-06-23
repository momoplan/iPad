//
//  RYView.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-6-27.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "RYView.h"

@implementation RYView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

- (void)initView
{
    
}
/* 彩球状态数组 转化 数字形式 */
- (NSArray *)convertArrayWithStateArray:(NSArray *)stateArray
{
    NSMutableArray *newArray =[[NSMutableArray alloc]init];
    for (int i=0; i<stateArray.count; i++) {
        if ([[stateArray objectAtIndex:i]isEqualToString:@"1"]) {
            [newArray addObject:[NSNumber numberWithInt:i+1]];
        }
    }
    return [newArray autorelease];
}
- (NSMutableArray*)randomBallWithMax:(int)maxNum selectNum:(int)select_ran
{
    NSMutableArray *randomArray=[[NSMutableArray alloc]init];
    for (int i =0; i<maxNum; i++) {
        [randomArray addObject:@"0"];
    }
    int m_randomNum = 0;
    int max_random = maxNum;
    int select_random = select_ran;
    
    while (m_randomNum < select_random) {
        int randomNum = (arc4random() % max_random);
        
        if (![[randomArray objectAtIndex:randomNum]isEqualToString:@"1"]) {
            [randomArray replaceObjectAtIndex:randomNum withObject:@"1"];
            m_randomNum += 1;
        }
    }
    return [randomArray autorelease];
}
/* 提示信息 */
-(void)showAlertWithMessage:(NSString *)message
{
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [alert release];
}
- (void)dealloc{
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
