//
//  TogetherParticipationModel.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-7.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 合买参与人 数据格式

#import <Foundation/Foundation.h>

@interface TogetherParticipationModel : NSObject

@property (nonatomic,retain) NSString * nickName;//昵称 
@property (nonatomic,retain) NSString * buyAmt;//	认购金额
@property (nonatomic,retain) NSString * buyTime;//	认购时间
@property (nonatomic,retain) NSString * cancelCaselotbuy;//	是否可以撤资	true可以，false不可以
@property (nonatomic,retain) NSString * state;//	参与状态	1:正常；0:撤资
@end
