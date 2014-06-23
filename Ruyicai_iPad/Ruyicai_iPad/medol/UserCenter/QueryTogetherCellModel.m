//
//  QueryTogetherCellModel.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-6.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "QueryTogetherCellModel.h"

@implementation QueryTogetherCellModel

@synthesize  caseLotId;//合买编号
@synthesize  starter;//发起人
@synthesize  lotNo;//彩种编号
@synthesize  lotName;//彩种名称
@synthesize  buyAmt;//参与人认购金额

@synthesize  prizeAmt;//参与人中奖金额
@synthesize  displayState;//合买状态 1认购中，2满员，3成功，4撤单，5流单，6已中奖
@synthesize  buyTime;//认购时间
@synthesize  prizeState;//兑奖标识
//
//- (void)dealloc
//{
//    [super dealloc];
//    [caseLotId release],caseLotId = nil;
//    [starter release],starter = nil;
//    [lotNo release],lotNo = nil;
//    [lotName release],lotName = nil;
//    [buyAmt release],buyAmt = nil;
//    
//    [prizeAmt release],prizeAmt = nil;
//    [displayState release],displayState = nil;
//    [buyTime release],buyTime = nil;
//    [prizeState release],prizeState = nil;
//}
@end
