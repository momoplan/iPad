//
//  MyMessageTableViewCell.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-30.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "MyMessageTableViewCell.h"

@implementation MyMessageTableViewCell
@synthesize replyStateString;
@synthesize model;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 240, 20)];
        [self.contentView addSubview:timeLabel];
        
        questionLabel =[[UILabel alloc]initWithFrame:CGRectZero];
        questionLabel.textColor = [UIColor redColor];
        questionLabel.numberOfLines = 0;
        questionLabel.font = [UIFont systemFontOfSize:18.0];
        [self.contentView addSubview:questionLabel];
        
        replyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        replyLabel.textColor = [UIColor blackColor];
        replyLabel.text = @"客服回复：";
        [self.contentView addSubview:replyLabel];
        
        replyContentLabel =[[UILabel alloc]initWithFrame:CGRectZero];
        replyContentLabel.textColor = [UIColor redColor];
        replyContentLabel.numberOfLines = 0;
        replyContentLabel.font = [UIFont systemFontOfSize:18.0];
        [self.contentView addSubview:replyContentLabel];
    }
    return self;
}
- (void)dealloc
{
    [timeLabel release];
    [questionLabel release];
    
    [super dealloc];

}
- (void)messageTableCellRefresh
{
    questionLabel.frame = CGRectMake(20, 35, 500, model.contentHig);
    replyLabel.frame = CGRectMake(20, 37 + model.contentHig, 200, 20);
    replyContentLabel.frame = CGRectMake(20, 35 + model.contentHig + 30, 500, model.replyHig);
    
    timeLabel.text =[NSString stringWithFormat: @"我于 %@ 的留言:",model.createTime];
    questionLabel.text = model.content;
    if ([model.reply length] > 0) {
        replyLabel.hidden = NO;
        replyContentLabel.text = model.reply;
    }
    else
        replyLabel.hidden = YES;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
