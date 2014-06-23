//
//  MoreActivityTitleModel.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-9-4.
//  Copyright (c) 2013年 baozi. All rights reserved.
// 更多 活动中心 标题 model 

#import <Foundation/Foundation.h>

@interface MoreActivityTitleModel : NSObject

@property (nonatomic,retain) NSString * activityId; // 活动编号
@property (nonatomic,retain) NSString * title; // 活动标题
@property (nonatomic,retain) NSString * introduce; // 活动介绍
@property (nonatomic,retain) NSString * activityTime; // 活动时间
@property (nonatomic,retain) NSString * isEnd; // 活动是否结束

@end
