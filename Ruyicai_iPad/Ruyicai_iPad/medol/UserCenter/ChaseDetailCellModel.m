//
//  ChaseDetailCellModel.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-11-8.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  合买详情 model

#import "ChaseDetailCellModel.h"

#define Release(object) [object release],object = nil
@implementation ChaseDetailCellModel
 
@synthesize batchCode; //	期号
@synthesize lotMulti;//	倍数
@synthesize amount;//	金额
@synthesize winCode;//	中奖号码
@synthesize state;//	订单状态
@synthesize stateMemo;//	状态描述
@synthesize desc;//	收益率信息
@synthesize prizeAmt;
//- (void)dealloc
//{
//    [super dealloc];
//    [batchCode release],batchCode = nil;
//    Release(lotMulti);
//    Release(amount);
//    Release(winCode);
//    Release(state);
//    Release(stateMemo);
//    Release(prizeAmt);
//    Release(desc);
//}
@end
