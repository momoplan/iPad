//
//  QueryTogetherDetailModel.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-7.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 合买 详情 

#import "QueryTogetherDetailModel.h"

@implementation QueryTogetherDetailModel

@synthesize  caseLotId;//	方案编号
@synthesize  starter;//	发起人
@synthesize  lotNo;//	彩种编号
@synthesize  lotName;//	彩种名称
@synthesize  lotMulti;//	倍数

@synthesize  batchCode;//	期号
@synthesize  display;//	注码是否保密
@synthesize  visibility;//	可见状态	0:对所有人立即公开;1:保密;2:对所有人截止后公开;3:对跟单者立即公开;4:对跟单者截止后公开
@synthesize  totalAmt;//	方案总额
@synthesize  safeAmt;//	保底金额

@synthesize  hasBuyAmt;//	已认购金额
@synthesize  remainderAmt;//	剩余认购金额
@synthesize  minAmt;//	最低认购金额
@synthesize  buyAmtByStarter;//	发起人认购金额
@synthesize  commisionRatio;//	提成比例

@synthesize  participantCount;//	参与人数
@synthesize  buyProgress;//	认购进度
@synthesize  safeProgress;//	保底进度
@synthesize  displayIcon;//	专家战绩
@synthesize  description;//	方案描述

@synthesize  displayState;//	合买状态	1:认购中;2:满员;3:成功;4:撤单;5:流单;6:已中奖
@synthesize  winCode;//	中奖号码
@synthesize  endTime;//	截止时间
@synthesize  cancelCaselot;//是否可以撤单 true是false否
@synthesize  canAutoJoin;//	是否可以定制跟单 true是false否
@synthesize url;

@synthesize betCodeHtml;
@synthesize betCodeJson;

@synthesize  goldStar;//	金星
@synthesize  graygoldStar;//	金星(灰)
@synthesize  diamond;//	钻石
@synthesize  graydiamond;//	钻石(灰)
@synthesize  cup;//	奖杯
@synthesize  graycup;//	奖杯(灰)
@synthesize  crown;//	皇冠
@synthesize  graycrown;//	皇冠(灰)

@end
