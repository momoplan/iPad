//
//  QueryTogetherCellModel.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-6.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 合买 列表

#import <Foundation/Foundation.h>

@interface QueryTogetherCellModel : NSObject

@property (nonatomic,retain) NSString * caseLotId;//合买编号
@property (nonatomic,retain) NSString * starter;//发起人
@property (nonatomic,retain) NSString * lotNo;//彩种编号
@property (nonatomic,retain) NSString * lotName;//彩种名称
@property (nonatomic,retain) NSString * buyAmt;//参与人认购金额

@property (nonatomic,retain) NSString * prizeAmt;//参与人中奖金额
@property (nonatomic,retain) NSString * displayState;//合买状态 1认购中，2满员，3成功，4撤单，5流单，6已中奖
@property (nonatomic,retain) NSString * buyTime;//认购时间
@property (nonatomic,retain) NSString * prizeState;//兑奖标识
@end
