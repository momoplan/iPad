//
//  QueryTogetherDetailModel.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-7.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 合买详情 

#import <Foundation/Foundation.h>

@interface QueryTogetherDetailModel : NSObject

@property (nonatomic,retain) NSString * caseLotId;//	方案编号
@property (nonatomic,retain) NSString * starter;//	发起人
@property (nonatomic,retain) NSString * lotNo;//	彩种编号
@property (nonatomic,retain) NSString * lotName;//	彩种名称
@property (nonatomic,retain) NSString * lotMulti;//	倍数

@property (nonatomic,retain) NSString * batchCode;//	期号
@property (nonatomic,retain) NSString * display;//	注码是否保密
@property (nonatomic,retain) NSString * visibility;//	可见状态	0:对所有人立即公开;1:保密;2:对所有人截止后公开;3:对跟单者立即公开;4:对跟单者截止后公开
@property (nonatomic,retain) NSString * totalAmt;//	方案总额
@property (nonatomic,retain) NSString * safeAmt;//	保底金额

@property (nonatomic,retain) NSString * hasBuyAmt;//	已认购金额
@property (nonatomic,retain) NSString * remainderAmt;//	剩余认购金额
@property (nonatomic,retain) NSString * minAmt;//	最低认购金额
@property (nonatomic,retain) NSString * buyAmtByStarter;//	发起人认购金额
@property (nonatomic,retain) NSString * commisionRatio;//	提成比例

@property (nonatomic,retain) NSString * participantCount;//	参与人数
@property (nonatomic,retain) NSString * buyProgress;//	认购进度
@property (nonatomic,retain) NSString * safeProgress;//	保底进度
@property (nonatomic,retain) NSString * displayIcon;//	专家战绩
@property (nonatomic,retain) NSString * description;//	方案描述

@property (nonatomic,retain) NSString * displayState;//	合买状态	1:认购中;2:满员;3:成功;4:撤单;5:流单;6:已中奖
@property (nonatomic,retain) NSString * winCode;//	中奖号码
@property (nonatomic,retain) NSString * endTime;//	截止时间
@property (nonatomic,retain) NSString * cancelCaselot;//是否可以撤单 true是false否
@property (nonatomic,retain) NSString *  canAutoJoin;//	是否可以定制跟单 true是false否
@property (nonatomic,retain) NSString * url; //合买详情地址	微博分享用
@property (nonatomic,retain) NSString * betCodeHtml;//	方案内容(html)	除竞彩、足彩的其他彩种使用
@property (nonatomic,retain) NSString * betCodeJson;//	方案内容(Json)	竞彩、足彩使用


@property (nonatomic,retain) NSString * goldStar;//	金星
@property (nonatomic,retain) NSString * graygoldStar;//	金星(灰)
@property (nonatomic,retain) NSString * diamond;//	钻石
@property (nonatomic,retain) NSString * graydiamond;//	钻石(灰)
@property (nonatomic,retain) NSString * cup;//	奖杯
@property (nonatomic,retain) NSString * graycup;//	奖杯(灰)
@property (nonatomic,retain) NSString * crown;//	皇冠
@property (nonatomic,retain) NSString * graycrown;//	皇冠(灰)
@end
