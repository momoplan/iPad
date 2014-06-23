//
//  QueryGiftTableCellModel.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-6.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "QueryGiftTableCellModel.h"

@implementation QueryGiftTableCellModel

@synthesize gifted;
@synthesize giftMobileId;

@synthesize  orderId;//订单编号
@synthesize  toMobileId;//被赠送人
@synthesize  orderTime;//赠送时间
@synthesize  amount;//赠送金额
@synthesize  batchCode;//期号

@synthesize  lotMulti;//倍数
@synthesize  betNum;//注数
@synthesize  betCode;//解析后的注码
@synthesize  lotNo;//彩种编号
@synthesize  lotName;//彩种名称

@synthesize  stateMemo;//状态描述
@synthesize  prizeState;//兑奖标识	0未开奖，3未中奖，4中大奖，5中小奖
@synthesize  winCode;//开奖号码

@end
