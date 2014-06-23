//
//  RootViewController.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-6-27.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYCImageNamed.h"
#import "PullUpRefreshView.h"
#define btnCustom UIButtonTypeCustom
#define btnNormal UIControlStateNormal
#define btnTouch UIControlEventTouchUpInside

#define ErrorCode(Dic)  [KISDictionaryHaveKey(Dic, @"error_code") isEqualToString:@"0000"]
#define RecordCodeNull(Dic) [KISDictionaryHaveKey(Dic, @"error_code") isEqualToString:@"0047"]


#define BallViewWidth 600
@interface RootViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,RYCNetworkManagerDelegate>
{
    
    
}
/*
 产生随机数 数组
 maxNum 最大数 select_ran 随机数个数
 
 */
- (NSMutableArray *)randomBallWithMax:(int)maxNum selectNum:(int)select_ran;

///警告框
-(void)showAlertWithMessage:(NSString *)message;
/* 是否成功登陆 */
- (BOOL)isSuccessLogin;

/* 彩球选出 数字 */
- (NSArray *)convertArrayWithStateArray:(NSArray *)stateArray;

-(NSUInteger) unicodeLengthOfString: (NSString *) text;
-(NSUInteger) asciiLengthOfString: (NSString *) text;

- (void)tabBarBackgroundImageViewWith:(UIView *)view; // tabbar背景图片
- (void)transitionView:(UIView*)view;

#pragma mark ----- button 
- (UIButton*)creatIntroButton:(CGRect)rect;
- (UIButton*)creatHistoryButton:(CGRect)rect;

#pragma mark ------------ viewController
- (void)rootViewControllerDisappear:(UIViewController *)viewController;

#pragma mark ------------ 开奖号码数组整理
- (NSMutableArray *)lotteryCellBallDoubleNumberString:(NSString *)lotString;
- (NSMutableArray *)lotteryCellBallSingleNumberString:(NSString *)lotString;
// 大乐透 中奖号码解析
- (NSMutableArray *)lotteryBallDLTNumberString:(NSString *)lotString;
#pragma mark -------------- 前一期开奖号码
- (void)sendRequestLotteryInfoWithLotNo:(NSString *)lotNoStr;
#pragma mark --------------------  拖码 胆码的数字不重复
/* 判断 拖码 胆码的数字不重复*/
- (NSMutableArray *)numberArrayTuomaDanmaDifferentDanmaArray:(NSMutableArray *)damArray tuomaArray:(NSMutableArray *)tuoArray;
@end
