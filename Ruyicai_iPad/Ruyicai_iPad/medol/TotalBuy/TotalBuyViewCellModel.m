//
//  TotalBuyViewCellModel.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-9.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "TotalBuyViewCellModel.h"

@implementation TotalBuyViewCellModel

@synthesize  caseLotId;//	方案编号
@synthesize  lotNo;//	彩种编号
@synthesize  lotName;//	彩种名称
@synthesize  batchCode;//	期号
@synthesize  starter;//	发起人

@synthesize  starterUserNo;//	发起人用户编号
@synthesize  totalAmt;//	方案总金额
@synthesize  safeAmt;//	保底金额
@synthesize  buyAmt;//	认购金额
@synthesize   progress;//	认购进度

@synthesize  safeRate;//	保底进度
@synthesize  displayIcon;//	显示的图标（专家战绩）
@synthesize  isTop;//	是否置顶	true是，false否


@synthesize  goldStar;//	金星
@synthesize  graygoldStar;//	金星(灰)
@synthesize  diamond;//	钻石
@synthesize  graydiamond;//	钻石(灰)
@synthesize  cup;//	奖杯
@synthesize  graycup;//	奖杯(灰)
@synthesize  crown;//	皇冠
@synthesize  graycrown;//	皇冠(灰)
//
//- (void)dealloc
//{
//    [caseLotId release],caseLotId = nil;
//    [lotNo release],lotNo = nil;
//    [lotName release],lotName = nil;
//    [batchCode release],batchCode = nil;
//    [starter release],starter = nil;
//    
//    [starterUserNo release],starterUserNo = nil;
//    [totalAmt release],totalAmt = nil;
//    [safeAmt release],safeAmt = nil;
//    [buyAmt release],buyAmt = nil;
//    [progress release],progress = nil;
//    
//    [safeRate release],safeRate = nil;
//    [displayIcon release],displayIcon = nil;
//    [isTop release],isTop = nil;
//    
//    [goldStar release],goldStar = nil;
//    [graygoldStar release],graygoldStar = nil;
//    [diamond release],diamond = nil;
//    [graydiamond release],graydiamond = nil;
//    [cup release],cup = nil;
//    [graycup release],graycup = nil;
//    [crown release],crown = nil;
//    [graycrown release],graycrown = nil;
//    [super dealloc];
//
//}
@end
