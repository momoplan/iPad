//
//  QueryBetCellModel.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-2.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 投注查询 

#import <Foundation/Foundation.h>

@interface QueryBetCellModel : NSObject

@property (nonatomic,retain) NSString * lotNo;//彩种编号
@property (nonatomic,retain) NSString * orderId;//订单编号
@property (nonatomic,retain) NSString * lotName;//彩种名称
@property (nonatomic,retain) NSString * lotMulti;//倍数
@property (nonatomic,retain) NSString * betNum;//注数

@property (nonatomic,retain) NSString * batchCode;//期号
@property (nonatomic,retain) NSString * amount;//投注金额
@property (nonatomic,retain) NSString * aneAmount;//单注金额
@property (nonatomic,retain) NSString * play;//玩法
@property (nonatomic,retain) NSString * betCode;//解析后的注码

@property (nonatomic,retain) NSString * orderTime;//投注时间
@property (nonatomic,retain) NSString * prizeAmt;//中奖金额
//兑奖标识 0未开奖，3未中奖，4中大奖，5中小奖
@property (nonatomic,retain) NSString * prizeState;
@property (nonatomic,retain) NSString * winCode;//开奖号码
@property (nonatomic,retain) NSString * stateMemo;//状态描述

@property (nonatomic,retain) NSString * isRepeatBuy; //是否可再买一次
@end
