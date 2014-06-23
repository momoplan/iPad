//
//  AccountDetailCellModel.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-1.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountDetailCellModel : NSObject

@property (nonatomic,retain) NSString * amt;//变动金额
@property (nonatomic,retain) NSString * blsign;//进出账标识 -1出账，1进账
//交易类型  1投注，2银行卡充值，3平台卡充值，5提现，6派奖，10点卡充值
@property (nonatomic,retain) NSString * transactionType;
@property (nonatomic,retain) NSString * memo;//描述
@property (nonatomic,retain) NSString * platTime;//变动时间
@end
