//
//  MyMessageViewCellModel.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-8-9.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyMessageViewCellModel : NSObject

@property (nonatomic,retain) NSString * content;//	反馈内容
@property (nonatomic,retain) NSString * reply;//	回复内容
@property (nonatomic,retain) NSString * createTime;//	反馈时间
@property (nonatomic,retain) NSString * readState;//	已读状态	0:未读;1:已读

@property (nonatomic,assign) float contentHig;//内容高度
@property (nonatomic,assign) float replyHig;//回复高度

@end
