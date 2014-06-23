//
//  QueryTogetherDocumentaryModel.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-6.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 跟单 列表

#import <Foundation/Foundation.h>

@interface QueryTogetherDocumentaryModel : NSObject

@property (nonatomic,retain) NSString * tradeId;//定制编号
@property (nonatomic,retain) NSString * starter;//发起人名称
@property (nonatomic,retain) NSString * starterUserNo;//	发起人用户编号
@property (nonatomic,retain) NSString * displayIcon;//	战绩
@property (nonatomic,retain) NSString * lotNo;//	彩种

@property (nonatomic,retain) NSString * lotName;//	彩种名称
@property (nonatomic,retain) NSString * times;//	跟单次数
@property (nonatomic,retain) NSString * joinAmt;//	跟单金额
@property (nonatomic,retain) NSString * safeAmt;//	止损金额
@property (nonatomic,retain) NSString * maxAmt;//	百分比跟单最大金额

@property (nonatomic,retain) NSString * percent;//	跟单百分比
@property (nonatomic,retain) NSString * joinType;//	跟单类型	0:金额跟单;1:百分比跟单
@property (nonatomic,retain) NSString * forceJoin;//	是否强制跟单	0:不强制跟单;1:强制跟单
@property (nonatomic,retain) NSString * createTime;//	定制时间
@property (nonatomic,retain) NSString * state;//	状态	0:取消;1:有效


@property (nonatomic,retain) NSString * goldStar;//	金星
@property (nonatomic,retain) NSString * graygoldStar;//	金星(灰)
@property (nonatomic,retain) NSString * diamond;//	钻石
@property (nonatomic,retain) NSString * graydiamond;//	钻石(灰)
@property (nonatomic,retain) NSString * cup;//	奖杯
@property (nonatomic,retain) NSString * graycup;//	奖杯(灰)
@property (nonatomic,retain) NSString * crown;//	皇冠
@property (nonatomic,retain) NSString * graycrown;//	皇冠(灰)
@end
