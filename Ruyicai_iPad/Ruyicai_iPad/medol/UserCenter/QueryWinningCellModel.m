//
//  QueryWinningCellModel.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-2.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 中奖查询 cell 数据 model

#import "QueryWinningCellModel.h"

@implementation QueryWinningCellModel

@synthesize orderId;
@synthesize lotMulti;

@synthesize lotName;
@synthesize lotNo;
@synthesize batchCode;
@synthesize betCode;
@synthesize betNum;

@synthesize amount;
@synthesize winAmount;
@synthesize winCode;
@synthesize sellTime;
@synthesize cashTime;

- (void)dealloc
{
    [orderId release],orderId = nil;
    [lotMulti release],lotMulti = nil;
    
    [lotName release],lotName = nil;
    [lotNo release],lotNo = nil;
    [batchCode release],batchCode = nil;
    [betCode release],betCode = nil;
    [betNum release],betNum = nil;
    
    [amount release],amount = nil;
    [winAmount release],winAmount = nil;
    [winCode release],winCode = nil;
    [sellTime release],sellTime = nil;
    [cashTime release],cashTime = nil;
    [super dealloc];

}
@end
