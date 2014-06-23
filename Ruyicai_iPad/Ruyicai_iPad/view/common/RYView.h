//
//  RYView.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-6-27.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYCImageNamed.h"
#define btnCustom UIButtonTypeCustom
#define btnNormal UIControlStateNormal
#define btnTouch UIControlEventTouchUpInside
#define btnSelect UIControlStateSelected

#define ErrorCode(Dic)  [KISDictionaryHaveKey(Dic, @"error_code") isEqualToString:@"0000"]
#define RecordCodeNull(Dic) [KISDictionaryHaveKey(Dic, @"error_code") isEqualToString:@"0047"]

@interface RYView : UIView
<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,RYCNetworkManagerDelegate>

- (void)initView;
- (NSMutableArray*)randomBallWithMax:(int)maxNum selectNum:(int)select_ran;

/* 彩球状态数组 转化 数字形式 */
- (NSArray *)convertArrayWithStateArray:(NSArray *)stateArray;
///警告框
-(void)showAlertWithMessage:(NSString *)message;
@end
