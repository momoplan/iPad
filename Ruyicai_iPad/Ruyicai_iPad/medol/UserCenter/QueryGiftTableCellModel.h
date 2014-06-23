//
//  QueryGiftTableCellModel.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-6.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryGiftTableCellModel : NSObject

@property (nonatomic,retain) NSString * gifted;//是否为赠出的
@property (nonatomic,retain) NSString * giftMobileId;//谁赠送的

@property (nonatomic,retain) NSString * orderId;//订单编号
@property (nonatomic,retain) NSString * toMobileId;//被赠送人
@property (nonatomic,retain) NSString * orderTime;//赠送时间
@property (nonatomic,retain) NSString * amount;//赠送金额
@property (nonatomic,retain) NSString * batchCode;//期号

@property (nonatomic,retain) NSString * lotMulti;//倍数
@property (nonatomic,retain) NSString * betNum;//注数
@property (nonatomic,retain) NSString * betCode;//解析后的注码
@property (nonatomic,retain) NSString * lotNo;//彩种编号
@property (nonatomic,retain) NSString * lotName;//彩种名称

@property (nonatomic,retain) NSString * stateMemo;//状态描述
@property (nonatomic,retain) NSString * prizeState;//兑奖标识	0未开奖，3未中奖，4中大奖，5中小奖
@property (nonatomic,retain) NSString * winCode;//开奖号码
@end
