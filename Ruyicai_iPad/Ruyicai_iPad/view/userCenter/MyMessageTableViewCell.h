//
//  MyMessageTableViewCell.h
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-30.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMessageViewCellModel.h"
@interface MyMessageTableViewCell : UITableViewCell
{
    UILabel * timeLabel;//时间
    UILabel *questionLabel;//反馈问题
    
    UILabel* replyLabel;//回复
    UILabel* replyContentLabel;//回复内容
}
@property (nonatomic,retain) MyMessageViewCellModel * model;
@property (nonatomic,retain) NSString * replyStateString;

- (void)messageTableCellRefresh;
@end
