//
//  QueryTogetherDocumentaryModel.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-6.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "QueryTogetherDocumentaryModel.h"

@implementation QueryTogetherDocumentaryModel

@synthesize  tradeId;//定制编号
@synthesize  starter;//发起人名称
@synthesize  starterUserNo;//	发起人用户编号
@synthesize  displayIcon;//	战绩
@synthesize  lotNo;//	彩种

@synthesize  lotName;//	彩种名称
@synthesize  times;//	跟单次数
@synthesize  joinAmt;//	跟单金额
@synthesize  safeAmt;//	止损金额
@synthesize  maxAmt;//	百分比跟单最大金额

@synthesize  percent;//	跟单百分比
@synthesize  joinType;//	跟单类型	0:金额跟单;1:百分比跟单
@synthesize  forceJoin;//	是否强制跟单	0:不强制跟单;1:强制跟单
@synthesize  createTime;//	定制时间
@synthesize  state;//	状态	0:取消;1:有效@


@synthesize  goldStar;//	金星
@synthesize  graygoldStar;//	金星(灰)
@synthesize  diamond;//	钻石
@synthesize  graydiamond;//	钻石(灰)
@synthesize  cup;//	奖杯
@synthesize  graycup;//	奖杯(灰)
@synthesize  crown;//	皇冠
@synthesize  graycrown;//	皇冠(灰)
//- (void)dealloc
//{
//    [super dealloc];
//    [tradeId release],tradeId = nil;
//    [starter release],starter = nil;
//    [starterUserNo release],starterUserNo = nil;
//    [displayIcon release],displayIcon = nil;
//    [lotNo release],lotNo = nil;
//    
//    [lotName release],lotName = nil;
//    [times release],times = nil;
//    [joinAmt release],joinAmt = nil;
//    [safeAmt release],safeAmt = nil;
//    [maxAmt release],maxAmt = nil;
//    
//    [percent release],percent = nil;
//    [joinType release],joinType = nil;
//    [forceJoin release],forceJoin = nil;
//    [createTime release],createTime = nil;
//    [state release],state = nil;
//    
//    [goldStar release],goldStar = nil;
//    [graygoldStar release],graygoldStar = nil;
//    [diamond release],diamond = nil;
//    [graydiamond release],graydiamond = nil;
//    [cup release],cup = nil;
//    [graycup release],graycup = nil;
//    [crown release],crown = nil;
//    [graycrown release],graycrown = nil;
//}

@end
