//
//  MoreActivityTableViewCell.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-9-3.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "MoreActivityTableViewCell.h"

@implementation MoreActivityTableViewCell
@synthesize tModel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        titleLabel                  = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 330, 20)];
        titleLabel.font             = [UIFont boldSystemFontOfSize:18];
        titleLabel.textAlignment    = NSTextAlignmentCenter;
        [self.contentView addSubview:titleLabel];
        
        introduceLabel              = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, 30, titleLabel.frame.size.width, 60)];
        introduceLabel.numberOfLines= 0;
        introduceLabel.font         = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:introduceLabel];
        
        timeLabel                   = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, introduceLabel.frame.size.height + introduceLabel.frame.origin.y, introduceLabel.frame.size.width ,30)];
        timeLabel.font              = [UIFont systemFontOfSize:15];
        timeLabel.textColor         = [UIColor redColor];
        [self.contentView addSubview:timeLabel];
    }
    return self;
}
- (void)dealloc
{
    [tModel release],tModel = nil;
    [titleLabel release];
    [introduceLabel release];
    [timeLabel release];

    [super dealloc];

}
- (void)activityTitleCellRefresh
{
    titleLabel.text = tModel.title;
    introduceLabel.text = [NSString stringWithFormat:@"活动结束:%@",tModel.introduce];
    if ([tModel.isEnd isEqualToString:@"1"]) {
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.text = [NSString stringWithFormat:@"活动时间:%@(已结束)",tModel.activityTime];
    }else{
        timeLabel.textColor = [UIColor redColor];

        timeLabel.text = [NSString stringWithFormat:@"活动时间:%@(进行中)",tModel.activityTime];

    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
