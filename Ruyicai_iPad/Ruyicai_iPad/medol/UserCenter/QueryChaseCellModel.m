//
//  QueryChaseCellModel.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-5.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "QueryChaseCellModel.h"

@implementation QueryChaseCellModel
@synthesize  tradeId;//交易编号
@synthesize  lotNo;//彩种编号
@synthesize  lotName;//彩种名称
@synthesize  lotMulti;//倍数
@synthesize  betNum;//注数

@synthesize  bet_code;//原始注码	“再追一次”时使用
@synthesize  betCode;//解析后的注码
@synthesize  batchNum;//追号期数
@synthesize  lastNum;//已追期数
@synthesize  beginBatch;//开始期号

@synthesize  lastBatch;//上次投注的期号
@synthesize  amount;//追号总金额
@synthesize  remainderAmount;//剩余追号总金额
@synthesize  oneAmount;//单注金额	用于判断是否是大乐透追加
@synthesize  state;//状态

@synthesize  orderTime;//定制时间
@synthesize  prizeEnd;//中奖后是否停止追号	1是，0否
@synthesize  isRepeatBuy;//是否允许再追一次	true是，f

@end
