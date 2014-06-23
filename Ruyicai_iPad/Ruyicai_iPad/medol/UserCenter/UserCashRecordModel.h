//
//  UserCashRecordModel.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-11-6.
//  Copyright (c) 2013年 baozi. All rights reserved.
//  提现  记录model

#import <Foundation/Foundation.h>

@interface UserCashRecordModel : NSObject
@property (nonatomic,retain) NSString * cashdetailid;	//提现记录id
@property (nonatomic,retain) NSString * amount;         //提现金额
@property (nonatomic,retain) NSString * cashTime;       //提现时间
@property (nonatomic,retain) NSString * rejectReason;	//驳回原因
@property (nonatomic,retain) NSString * stateMemo;      //提现状态描述
@property (nonatomic,retain) NSString * state;          //提现状态	1:待审核；103:已审核；104:驳回；105:成功；106:取消
@end
