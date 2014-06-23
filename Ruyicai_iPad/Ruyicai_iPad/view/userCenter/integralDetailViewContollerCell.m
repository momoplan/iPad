//
//  integralDetailViewContollerCell.m
//  Ruyicai_iPad
//
//  Created by baozi on 13-7-24.
//  Copyright (c) 2013年 baozi. All rights reserved.
//

#import "integralDetailViewContollerCell.h"

@implementation integralDetailViewContollerCell
@synthesize model;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        messLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 120, 25)];
        [self.contentView addSubview:messLabel];

        
        addLabel =[[UILabel alloc]initWithFrame:CGRectMake(150, 10, 100, 25)];
        
        [self.contentView addSubview:addLabel];
        
        timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(400, 10, 200, 25)];
        timeLabel.textColor =[UIColor grayColor];
        [self.contentView addSubview:timeLabel];
    }
    return self;
}
- (void)dealloc
{

    [model release],model = nil;
    [messLabel release];
    [timeLabel release];
    [addLabel release];

    [super dealloc];


}
- (void)integralContentViewCell
{
    messLabel.text = model.scoreSource;

    timeLabel.text = model.createTime;
    if ([model.blsign isEqualToString:@"-1"]) {
        [addLabel setTextColor:[UIColor colorWithRed:32.0/255.0 green:124.0/255.0 blue:35.0/255.0 alpha:1.0]];
        addLabel.text =[NSString stringWithFormat:@"－%@",model.score];
    }else
    {
        addLabel.text =[NSString stringWithFormat:@"＋%@",model.score];
        [addLabel setTextColor:[UIColor colorWithRed:196.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
