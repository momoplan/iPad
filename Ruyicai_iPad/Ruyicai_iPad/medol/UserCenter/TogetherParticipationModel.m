//
//  TogetherParticipationModel.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-7.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "TogetherParticipationModel.h"

@implementation TogetherParticipationModel

@synthesize  nickName;//昵称
@synthesize  buyAmt;//	认购金额
@synthesize  buyTime;//	认购时间
@synthesize  cancelCaselotbuy;//	是否可以撤资	true可以，false不可以
@synthesize  state;//	参与状态	1:正常；0:撤资

//- (void)dealloc
//{
//    [super dealloc];
//    [nickName release],nickName = nil;
////    [buyAmt release],buyAmt = nil;
//    [buyTime release],buyTime = nil;
//    [cancelCaselotbuy release],cancelCaselotbuy = nil;
//    [state release],state = nil;
//}

@end
