//
//  ChaseDetailCellModel.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-11-8.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 追号查询详情 model

#import <Foundation/Foundation.h>

@interface ChaseDetailCellModel : NSObject
@property (nonatomic,retain) NSString * batchCode; //	期号
@property (nonatomic,retain) NSString * lotMulti;//	倍数
@property (nonatomic,retain) NSString * amount;//	金额
@property (nonatomic,retain) NSString * winCode;//	中奖号码
@property (nonatomic,retain) NSString * state;//	订单状态
@property (nonatomic,retain) NSString * stateMemo;//	状态描述
@property (nonatomic,retain) NSString * prizeAmt;// 中奖金额
@property (nonatomic,retain) NSString * desc;//	收益率信息
@end
